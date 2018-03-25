#ifndef LOGIC_HANDLER_MQH
#define LOGIC_HANDLER_MQH

#include "scheduler.mqh"
#include "calc/calc.mqh"

timer_t *handler_base_spread_block_trading_timer;
timer_t *handler_base_vol_block_trading_timer;

class logic_handler {
public:
	setting_t *_settings;
	layer_order_setting *_order_settings;
	color _order_color;
	string _msg_key;
	timer_t *_ct_timer;
	timer_t *_close_orders;
	timer_t *_strong_sleep_timer;
	order *_last_order;
	order_operation *_last_not_open_order_stop;
	bool _is_first_tick;
	bool _is_block_work;
	bool _is_block_work_by_stop_trade;
	int _last_order_stop_count;
	bool _drawdown_percent_block;

	double _last_tp;
	double _log_last_tp;

	logic_handler ( bool is_buy, setting_t *settings ) {
		_msg_key = StringFormat ( "[%s]", is_buy ? SRC_HANDLER_BASE_LONG : SRC_HANDLER_BASE_SHORT );
		_order_color = is_buy ? Green : Red;
		_settings = settings;
		_ct_timer = timer_t::create ( _settings.take_profit_control_timing );
		gc::push ( gc_dispose_type_on_end_deinit, _ct_timer );

		handler_base_spread_block_trading_timer = NULL;
		handler_base_vol_block_trading_timer = NULL;
		_strong_sleep_timer = NULL;
		_close_orders = NULL;
		_last_not_open_order_stop = NULL;
		_is_first_tick = true;
		_is_block_work = false;

		_order_settings = layer_order_setting::create ( _settings.max_open_orders,
						  _settings.magic_number,
						  is_buy ?
						  order_operation_buy :
						  order_operation_sell,
						  settings.gap_control != op_stop ?
						  order_operation_none :
						  is_buy ?
						  order_operation_buy_stop :
						  order_operation_sell_stop,
						  _settings.max_trade_pairs,
						  _settings.currency_block );
		gc::push ( gc_dispose_type_on_end_deinit, _order_settings );

		layer_order::push_settings ( _order_settings );
		reset_vars();
	}

	double get_profit() {
		return layer_order::get_by_setting ( _order_settings ).profit_clear_currency();
	}

	bool is_close_module_activated() {
		return GC_CHECK_PTR ( _close_orders );
	}

	~logic_handler() {
		GC_DISPOSE_IF ( handler_base_spread_block_trading_timer );
		GC_DISPOSE_IF ( handler_base_vol_block_trading_timer );
		GC_DISPOSE_IF ( _last_not_open_order_stop );
		GC_DISPOSE_IF ( _strong_sleep_timer );
	}

	void drawdown_changed_handler ( double drawdown_percent ) {
		log_set_msg_key ( _msg_key );

		if ( _drawdown_percent_block
				&& drawdown_percent <= _settings.no1Order_by_drawdown_percent_off ) {
			_drawdown_percent_block = false;

			log_info_k ( StringFormat ( SRC_HANDLER_BASE_DRAWDOWN_BLOCK_OFF, DoubleToString ( drawdown_percent, 0 ), _settings.no1Order_by_drawdown_percent_off ) );
		}
	}

	void tick_handler() {
		log_set_msg_key ( _msg_key );

		if ( _settings.close_all_orders ) {
			close_all_lvls ( );
			return;
		}

		if ( is_close_module_activated() ) {
			if ( !_close_orders.is_elapsed() ) {
				return;
			}

			log_info_k ( SRC_HANDLER_BASE_MODULE_CLOSE_START );

			if ( !close_all_lvls ( ) ) {
				log_info_k ( SRC_HANDLER_BASE_MODULE_CLOSE_ERROR );
				_close_orders.reset();
				return;
			}

			log_info_k ( SRC_HANDLER_BASE_MODULE_CLOSE_COMPLETE );
			gc::push ( gc_dispose_type_on_end_tick, _close_orders );
			return;
		}

		order_count_t *orders_count = layer_order::get_count ( _order_settings );

		if ( orders_count.all() == 0 ) {
			//Сбрасываем все переменные используемые в течение сущ. сетки
			reset_vars();
		} else {
			if ( orders_count.order() > 0 && _last_tp == 0.0f ) {
				_last_tp = calc_take_profit::get ( _settings, _order_settings, orders_count.all() );
			}

			_last_order = layer_order::get_max ( _order_settings );
		}

		double price_open = layer_market::price_open ( _order_settings.order_type );
		double step_in_point = layer_market::to_points ( calc_grid_step::get ( _settings, orders_count.all() + 1 ) );

		if ( is_need_close_orders ( orders_count ) ) {
			_close_orders = timer_t::create ( 0 );
			return;
		}

		if ( GC_CHECK_PTR ( _last_not_open_order_stop ) ) {
			if ( _last_not_open_order_stop.price == price_open
					|| !is_price_better ( _last_not_open_order_stop.price, price_open ) ) {
				log_info_k ( StringFormat ( SRC_HANDLER_BASE_STOP_ORDER_CLEAR,
											dtos ( price_open ),
											itos ( _last_not_open_order_stop.lvl ),
											dtos ( _last_not_open_order_stop.price ),
											dtos ( _last_not_open_order_stop.lot ),
											dtos ( _last_not_open_order_stop.step_p ) ) );
				gc::push ( gc_dispose_type_on_end_tick, _last_not_open_order_stop );
			} else {
				if ( order_operation_process ( orders_count, _last_not_open_order_stop ) ) {
					orders_count.inc_by_type ( _order_settings.order_stop_type );
					gc::push ( gc_dispose_type_on_end_tick, _last_not_open_order_stop );

					double take_profit = calc_take_profit::get ( _settings, _order_settings, orders_count.all() );
					set_tp ( take_profit, SRC_HANDLER_BASE_UPDATE_TP );
					_ct_timer.reset();
				} else {
					log_info_k ( layer_error::get_last_saved_string() );
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_NOT_COMPLETE_STOP_ORDER,
												 itos ( _last_not_open_order_stop.lvl ),
												 dtos ( _last_not_open_order_stop.price ),
												 dtos ( _last_not_open_order_stop.lot ),
												 dtos ( _last_not_open_order_stop.step_p ) ) );
				}

				return;
			}
		}

		if ( is_can_open_order ( orders_count,
								 !GC_CHECK_PTR ( _last_order ) ? -1.0 : _last_order.open_price,
								 price_open,
								 step_in_point ) ) {
			//set_last_candle();
			bool need_aligment = _settings.gap_control == op_stop
								 && orders_count.stop() > 0
								 && layer_order::get_max ( _order_settings ).is_order_stop();

			if ( open_lvl_handler ( _settings.gap_control,
									orders_count,
									!GC_CHECK_PTR ( _last_order ) ? -1.0 : _last_order.open_price,
									price_open,
									step_in_point ) ) {
				if ( need_aligment
						&& layer_order::get_max ( _order_settings ).is_order() ) {
					_last_order_stop_count = process_order_stop_aligment ( orders_count ) ? orders_count.stop() : 0;
				}

				double take_profit = calc_take_profit::get ( _settings, _order_settings, orders_count.all() );
				set_tp ( take_profit, SRC_HANDLER_BASE_UPDATE_TP );
				_ct_timer.reset();
			}
		} else if ( is_ct_elapsed ( orders_count ) ) {
			//set_last_candle();
			_ct_timer.reset();
			double take_profit = layer::correct_price ( calc_take_profit::get ( _settings, _order_settings, orders_count.all() ) );

			if ( !calc_take_profit:: is_lvl3 ( _settings, orders_count.all( ) ) ) {
				double profit_on_tp = 0.0;

				list<order *> *orders = layer_order::get ( _order_settings );
				LIST_FOREACH ( orders, order *, item, {
					if ( item.is_order() ) {
						profit_on_tp += item.commission + item.swap;
						profit_on_tp += item.get_profit_in_currency ( take_profit );
						continue;
					}

					if ( item.is_before_line ( take_profit ) ) {
						profit_on_tp += item.get_profit_in_currency ( take_profit );
					}
				} );

				if ( profit_on_tp < 0.00 ) {
					take_profit = calc_take_profit::get ( _settings,
														  _order_settings,
														  tp_level_without_loss,
														  _settings.take_profit_control_noloss_fixpips );
				}
			}

			set_tp ( take_profit, SRC_HANDLER_BASE_TIMER_UPDATE_TP );
		} else {
			//set_last_candle();

			if ( _settings.gap_control == op_stop
					&& orders_count.stop() > 0
					&& _last_order_stop_count != orders_count.stop()
					&& layer_order::get_max ( _order_settings ).is_order()
					&& layer_symbol::trade_mode ( CURRENT_SYMBOL ) == trade_mode_type_full
					&& process_order_stop_aligment ( orders_count ) ) {
				_last_order_stop_count = orders_count.stop();

				double take_profit = calc_take_profit::get ( _settings, _order_settings, orders_count.all() );
				set_tp ( take_profit, SRC_HANDLER_BASE_UPDATE_TP );
				_ct_timer.reset();
			}
		}
	}

	void mark_close_all_orders ( int time_to_start, bool timer_on_start, bool is_close_by_drawdown ) {
		if ( is_close_by_drawdown ) {
			_is_block_work = _settings.close_all_orders_by_drawdown_stop_trade;
		}

		_close_orders = timer_t::create ( time_to_start );

		if ( timer_on_start ) {
			_close_orders.set_zero();
		}
	}

	void mark_block_work_by_stop_trade ( bool block ) {
		_is_block_work_by_stop_trade = block;
	}

	bool close_all_lvls () {
		order_count_t *orders_count = layer_order::get_count ( _order_settings );

		int lvl = orders_count.all();

		if ( lvl == 0 ) {
			return true;
		}

		double step_p = layer_market::to_points ( calc_grid_step::get ( _settings, lvl ) );
		int slippage = calc_slippage ( lvl, step_p );

		if ( !layer_order::close_all ( _settings.magic_number, _order_settings.order_type, _order_settings.order_stop_type, slippage ) ) {
			int error = layer_error::get_last();

			if ( error == ERROR_MARKET_CLOSED ) {
				log_info_k ( SRC_SETKA_MARKET_CLOSE );
				return false;
			} else if ( error != ERROR_REQUOTE ) {
				log_info_k ( StringFormat ( SRC_HANDLER_BASE_ERROR_CLOSE_ORDERS, error_get_last ( error ) ) );
				return false;
			}
		}

		layer_order::refresh ( _order_settings );
		order_count_t *orders_count_before = layer_order::get_count ( _order_settings );
		return orders_count_before.all() == 0;
	}

	bool set_tp ( double tp, string msg ) {
		_last_tp = tp;
		list<order_operation *> *operations = calc_take_profit::get_set_tp_if ( _settings, _order_settings, tp );

		if ( !GC_CHECK_PTR ( operations ) ) {
			return true;
		}

		log_info_k ( StringFormat ( msg, dtos ( _log_last_tp ), dtos ( tp ) ) );

		gc::push ( gc_dispose_type_on_end_tick, operations );
		bool all_complete;

		for ( int i = 0; i < 3; i++ ) {
			all_complete = true;
			LIST_FOREACH_REVERSE ( operations,
								   order_operation *,
			item, {
				if ( item.is_completed ) {
					continue;
				}

				if ( !order_operation_process ( NULL, item ) ) {
					log_info_k ( layer_error::get_last_saved_string() );

					all_complete = false;
					continue;
				}

				item.is_completed = true;
			} );

			if ( all_complete ) {
				_log_last_tp = tp;
				operations.clear_without_dispoce();
				return true;
			}
		}

		operations.clear_without_dispoce();
		return false;
	}

	bool open_lvl_handler ( enum_gap_control_type control_type, order_count_t *orders_count, double last_price, double price, double step_in_point ) {
		if ( orders_count.all() + 1 == 1 ) {
			control_type = no_gap;
		}

		switch ( control_type ) {
			case no_gap: {
				orders_count.inc_by_type ( _order_settings.order_type );
				double lot = calc_lot::get ( _settings, _order_settings,  orders_count.all(), control_type, price );
				double normalized_lot = NormalizeDouble ( lot, _settings.lot_exp );

				if ( free_check ( orders_count, price, normalized_lot ) <= 0.0 ) {
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_NOT_GOOD_LOT, normalized_lot ) );
					orders_count.deinc_by_type ( _order_settings.order_type );
					return false;
				}

				if ( !open_lvl ( orders_count, control_type, price, normalized_lot, step_in_point ) ) {
					orders_count.deinc_by_type ( _order_settings.order_type );
					return false;
				}

				return true;
			}

			case inc_lot: {
				orders_count.inc_by_type ( _order_settings.order_type );
				double lot = calc_lot::get ( _settings, _order_settings,  orders_count.all(), control_type, price );
				double normalized_lot = NormalizeDouble ( lot, _settings.lot_exp );

				if ( free_check ( orders_count, price, normalized_lot ) <= 0.0 ) {
					log_info_k ( StringFormat ( SRC_HANDLER_BASE_NO_MONEY_ON_INC_LOT, NormalizeDouble ( lot, _settings.lot_exp ) ) );
					orders_count.deinc_by_type ( _order_settings.order_type );
					return open_lvl_handler ( no_gap, orders_count, 0.0, price, step_in_point );
				}

				if ( !open_lvl ( orders_count, control_type, price, normalized_lot, step_in_point ) ) {
					orders_count.deinc_by_type ( _order_settings.order_type );
					return false;
				}

				return true;
			}

			case op_stop: {
				if ( !calc_gap::is_gap ( _settings, _order_settings.order_type, last_price, price, step_in_point ) ) {
					return open_lvl_handler ( no_gap, orders_count, 0.0, price, step_in_point );
				}

				double stop_level = layer_market::min_distance_from_open_price_p ( CURRENT_SYMBOL, _settings.max_spread );
				double stop_level_offset = layer_market::to_points ( _settings.gap_min_pips_from_market );
				double adjusted_price = tool_price::deduct_by_order_type_direction ( _order_settings.order_type, price, stop_level + stop_level_offset );

				if ( !calc_gap::is_gap ( _settings, _order_settings.order_type, last_price, adjusted_price, step_in_point ) ) {
					return open_lvl_handler ( no_gap, orders_count, 0.0, price, step_in_point );
				}

				double gap_size = tool_order::get_distance ( _order_settings.order_type, price, last_price );
				log_alert_k ( StringFormat ( SRC_HANDLER_BASE_DETECT_GAP,
											 dtos ( last_price ),
											 dtos ( price ),
											 dtos ( gap_size ),
											 dtos ( step_in_point ),
											 DoubleToString ( ( gap_size / ( step_in_point / 100.00f ) ) - 100.00, 2 ),
											 dtos ( stop_level + stop_level_offset ) ) );

				list<order *> *opened_orders = layer_order::get ( _order_settings );
				LIST_LAST_INDEX_OF ( opened_orders, last_order_index, order *, item, item.is_order() );

				//Получаем кол-во ордеров и начальную цену относительно последнего открытого ордера
				if ( last_order_index != opened_orders.count - 1 ) {
					list<order *> *orders_before_gap = opened_orders.take ( last_order_index + 1 );
					gc::push ( gc_dispose_type_on_end_tick, orders_before_gap );

					orders_count = new order_count_t();
					LIST_FOREACH ( orders_before_gap, order *, item, orders_count.inc_by_type ( item.order_type ) );
					gc::push ( gc_dispose_type_on_end_tick, orders_count );

					orders_before_gap.clear_without_dispoce();

					order *item = opened_orders.items[last_order_index];
					last_price = item.open_price;
				}

				//Генерируем список ордеров, которые требуется открыть
				list<order_operation *> *list_order_open = generate_list_order_for_open ( orders_count.all() + 1,
						last_price,
						adjusted_price );
				gc::push ( gc_dispose_type_on_end_tick, list_order_open );

				//Накладываем уже открытые отложки на те которые требуется открыть
				if ( last_order_index != opened_orders.count - 1 ) {
					LIST_JOIN ( opened_orders,
								list_order_open,
								order *,
								left,
								order_operation *,
								right,
					left.lvl == right.lvl, {
						right.ticket = left.ticket;
						right.operation_type = order_operation_type_update;
					} );
				}

				LIST_FOREACH ( list_order_open,
							   order_operation *,
				item, {
					if ( item.ticket != 0 ) {
						log_info_k ( StringFormat ( SRC_HANDLER_BASE_SHOW_CALC_STOP_ORDER_WITH_TIKET, itos ( item.lvl ), itos ( item.ticket ), dtos ( item.price ), dtos ( item.lot ), dtos ( item.step_p ) ) );
					} else {
						log_info_k ( StringFormat ( SRC_HANDLER_BASE_SHOW_CALC_STOP_ORDER, itos ( item.lvl ), dtos ( item.price ), dtos ( item.lot ), dtos ( item.step_p ) ) );
					}
				} );

				LIST_FOREACH ( list_order_open, order_operation *, item, {
					if ( !order_operation_process ( orders_count, item ) ) {
						log_info_k ( layer_error::get_last_saved_string() );
						//TODO: Вообще нужно проверять последний ли это ордер
						_last_not_open_order_stop = item.clone();
						list_order_open.clear_without_dispoce();
						return false;
					}

					item.is_completed = true;
				} );

				list_order_open.clear_without_dispoce();
				return true;
			}

			default:
				return false;
		}
	}

	// Генерируем список ордеров, которые требуется открыть
	list<order_operation *> *generate_list_order_for_open ( int start_lvl, double start_price, double end_price ) {
		int end_lvl = _settings.max_open_orders;

		if ( _settings.gap_max_order_stop != 0
				&&  end_lvl - start_lvl + 1 > _settings.gap_max_order_stop ) {
			end_lvl = start_lvl + _settings.gap_max_order_stop - 1;
		}

		list<order_operation *> *result = new list<order_operation *>();
		double current_price = start_price;

		for ( int i = start_lvl; i <= end_lvl; i++ ) {
			double step_p = layer_market::to_points ( calc_grid_step::get ( _settings, i ) );

			// Нужно проверять по кол-ву без открытого ордера
			if ( !is_can_add_order ( i - 1, current_price, end_price, step_p, 100.0 ) ) {
				break;
			}

			current_price = tool_price::add_by_direction ( current_price, step_p, end_price );

			order_operation *for_add = factory_order_operation::get();
			for_add.is_completed = false;
			for_add.operation_type = order_operation_type_open;
			for_add.magic_number = _settings.magic_number;
			for_add.order_type = _order_settings.order_stop_type;
			for_add.lvl = i;
			for_add.lot = NormalizeDouble (  calc_lot::get ( _settings, _order_settings, i, no_gap, 0.0 ), _settings.lot_exp );
			for_add.price = current_price;
			for_add.step_p = step_p;
			for_add.comment = create_order_comment ( i );
			result.add ( for_add );
		}

		//Сдвигаем отложенные ордера к последней полученной цене, так как мы не смогли покрыть весь гэп.
		double shift_offset = tool_price::distance_by_type ( _order_settings.order_type,
							  result.last_or_default().price,
							  end_price );
		LIST_FOREACH ( result,
					   order_operation *,
					   item,
					   item.price = tool_price::add_by_order_type_direction ( _order_settings.order_type, item.price, shift_offset ) );
		return result;
	}

	bool process_order_stop_aligment ( order_count_t *orders_count ) {
		list<order_operation *> *need_aligment = generate_list_order_stop_for_aligment();

		if ( !GC_CHECK_PTR ( need_aligment ) ) {
			return true;
		}

		gc::push ( gc_dispose_type_on_end_tick, need_aligment );

		bool is_completed = true;
		LIST_FOREACH ( need_aligment, order_operation *, item, {
			if ( !order_operation_process ( orders_count, item ) ) {
				log_info_k ( layer_error::get_last_saved_string() );
				is_completed = false;
			}
		} );

		need_aligment.clear_without_dispoce();
		return is_completed;
	}

	list<order_operation *> *generate_list_order_stop_for_aligment() {
		list<order_operation *> *result = NULL;
		list<order *> *opened_orders = layer_order::get ( _order_settings );

		for ( int i = opened_orders.count - 1; i > 0; i-- ) {
			order *first = opened_orders.items[i];
			order *for_aligment = opened_orders.items[i - 1];

			if ( !first.is_order() || !for_aligment.is_order_stop() ) {
				continue;
			}

			double distance = tool_order::get_distance ( _order_settings.order_type, first.open_price, for_aligment.open_price );
			double step = layer_market::to_points ( calc_grid_step::get ( _settings, first.lvl ) );
			double shift_offset = layer::correct_price ( distance - step );

			if ( shift_offset == 0.00 ) {
				i--;
				continue;
			}

			for ( ; i > 0; i-- ) {
				for_aligment = opened_orders.items[i - 1];

				if ( for_aligment.is_order() ) {
					break;
				}

				order_operation *for_add = factory_order_operation::get();
				for_add.is_completed = false;
				for_add.ticket = for_aligment.ticket;
				for_add.operation_type = order_operation_type_set_sl_tp_price;
				for_add.take_profit = 0.0f;
				for_add.stop_loss = 0.0f;
				for_add.lvl = for_aligment.lvl;
				for_add.price = tool_price::add_by_order_type_direction ( for_aligment.order_type,
								for_aligment.open_price,
								shift_offset );

				if ( !GC_CHECK_PTR ( result ) ) {
					result = new list<order_operation *>();
					log_info_k ( SRC_HANDLER_BASE_ALIGMENT );
				}

				result.add ( for_add );

				log_info_k ( StringFormat ( SRC_HANDLER_BASE_SHOW_ALIGMENT_STOP_ORDER,
											itos ( for_add.lvl ),
											itos ( for_add.ticket ),
											dtos ( for_aligment.open_price ),
											dtos ( for_add.price ) ) );
			}
		}

		return result;
	}

	bool order_operation_process ( order_count_t *orders_count,
								   order_operation *order_oper ) {
		switch ( order_oper.operation_type ) {
			case order_operation_type_none:
				return true;

			case order_operation_type_set_tp: {
				if ( kernel_order::set_tp ( order_oper.magic_number,
											order_oper.ticket,
											order_oper.take_profit ) ) {
					//layer_order::refresh ( _order_settings, order_operation.ticket );
					order_oper.is_completed = true;
					return true;
				}

				return false;
			}

			case order_operation_type_set_sl_tp: {
				if ( kernel_order::set_sl_tp ( order_oper.ticket,
											   order_oper.stop_loss,
											   order_oper.take_profit ) ) {
					//layer_order::refresh ( _order_settings, order_operation.ticket );
					order_oper.is_completed = true;
					return true;
				}

				return false;
			}

			case order_operation_type_update: {
				if ( kernel_order::set_price ( order_oper.ticket,
											   order_oper.price,
											   _order_color ) ) {
					layer_order::refresh ( _order_settings, order_oper.ticket );
					order_oper.is_completed = true;
					return true;
				}

				return false;
			}

			case order_operation_type_set_sl_tp_price: {
				if ( kernel_order::set_sl_tp_price ( order_oper.ticket,
													 order_oper.stop_loss,
													 order_oper.take_profit,
													 order_oper.price ) ) {
					layer_order::refresh ( _order_settings, order_oper.ticket );
					order_oper.is_completed = true;
					return true;
				}

				return false;
			}

			case order_operation_type_open: {
				orders_count.inc_by_type ( _order_settings.order_stop_type );

				if ( free_check ( orders_count, order_oper.price, order_oper.lot ) <= 0.0 ) {
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_NOT_GOOD_STOP_LOT, order_oper.lot ) );
					return false;
				}

				string comment = create_order_comment ( order_oper.lvl );
				log_info_k (  StringFormat ( SRC_HANDLER_BASE_TRY_OPEN_STOP_LVL, IntegerToString ( order_oper.lvl, 0 ), dtos ( order_oper.step_p ), dtos ( order_oper.lot ), comment ) );

				int ticket = kernel_order::send_stop ( _settings.magic_number, order_oper.order_type, order_oper.price, order_oper.lot, comment, _order_color );

				if ( ticket != -1 ) {
					layer_order::push ( _order_settings, ticket );

					order_oper.is_completed = true;
					return true;
				}

				orders_count.deinc_by_type ( _order_settings.order_type );
				return false;
			}

			default:
				return false;
		}

		return false;
	}

	bool open_lvl ( order_count_t *orders_count, enum_gap_control_type control_type, double price, double lot, double step ) {
		string comment = create_order_comment ( orders_count.all() );
		log_info_k (  StringFormat ( SRC_HANDLER_BASE_TRY_OPEN_LVL, IntegerToString ( orders_count.all(), 0 ), DoubleToString ( step, kernel_account::digits() ), comment ) );

		for ( int i = 0; i < 5; i++ ) {
			int slippage = calc_slippage ( orders_count.all(), step );

			int ticket = kernel_order::send ( _settings.magic_number, _order_settings.order_type, price, lot, slippage, comment, _order_color );

			if ( ticket != -1 ) {
				layer_order::push ( _order_settings, ticket );
				return true;
			}

			int error = layer_error::get_last();

			if ( error == ERROR_MARKET_CLOSED ) {
				log_info_k (  SRC_SETKA_MARKET_CLOSE );
				break;
			} else if ( error != ERROR_REQUOTE ) {
				log_info_k (  StringFormat ( SRC_HANDLER_BASE_ERROR_OPEN_LVL, error_get_last ( error ) ) );
				break;
			}

			log_info_k ( SRC_HANDLER_BASE_FAIL_SLIPPAGE_OPEN_LVL );

			tool_cache::update_tick_state();
			double new_price =  layer_market::price_open ( _order_settings.order_type );
			double distance = tool_order::get_distance ( _order_settings.order_type, new_price, price );
			lot = calc_lot::get ( _settings, _order_settings, orders_count.all(), control_type, new_price );

			if ( orders_count.all() == 1 ) {
				if ( distance >= step ) {
					double spread_in_point = layer_market::to_points ( layer_market::spread () );
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_VERY_STRONG_MOTION, distance, step, spread_in_point ) );
					break;
				}

				if ( !is_can_open_first_order ( orders_count.all() ) ) {
					log_info_k ( SRC_HANDLER_BASE_OPENED_NEW_CANDLE_NO_SIGNAL );
					break;
				}

				if ( !is_price_better ( price, new_price ) ) {
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_BAD_PRICE, new_price, price ) );
					break;
				}
			} else {
				if ( distance >= step
						&& _settings.gap_control != no_gap ) {
					break;
				}

				// Так как мы уже прибали ордер, то может быть ошибка если открываем последний ордер
				if ( !is_can_add_order ( orders_count.all() - 1, price, new_price, step, 75 ) ) {
					log_info_k (  StringFormat ( SRC_HANDLER_BASE_PRICE_GOTO_START, dtos ( new_price ), dtos ( price ) ) );
					break;
				}
			}

			if ( !is_spred_valid()
					|| !is_vol_valid() ) {
				break;
			}

			price = new_price;
		}

		log_info_k ( SRC_HANDLER_BASE_FAIL_EXIT_OPEN_LVL );
		return false;
	}

	int calc_slippage ( int order_count, double step_in_point ) {
		double double_spread = layer_market::to_points ( layer_market::spread () ) * 2.0;
		double step = ( step_in_point / 100.0 ) * 25.0; // 25% îò òåêóùåãî øàãà ñåòêè
		double result = double_spread > step ? double_spread : step;
		return layer_market::to_pips ( result );
	}

	bool is_can_close() {
		enum_trade_mode_type trade_mode = layer_symbol::trade_mode ( CURRENT_SYMBOL );
		return trade_mode == trade_mode_type_full
			   || trade_mode == trade_mode_type_close_only;
	}

	bool is_need_close_orders ( order_count_t *orders_count ) {
		if ( !is_can_close() ) {
			return false;
		}

		if ( scheduler::is_close_all_orders ( _order_settings ) ) {
			return true;
		}

		if ( _settings.gap_control == op_stop
				&& orders_count.order() == 0
				&& orders_count.stop() > 0 ) {
			log_info_k (  StringFormat ( SRC_HANDLER_BASE_NOT_CLOSE_ORDER_STOP, itos ( orders_count.stop() ) ) );
			return true;
		}

		double price_close = layer_market::price_close ( _order_settings.order_type );

		if ( orders_count.all() > 0
				&& is_price_worse ( _last_tp, price_close ) ) {
			log_info_k (  StringFormat ( SRC_HANDLER_BASE_PRICE_REACED_TP, dtos ( price_close ), dtos ( _last_tp ) ) );
			return true;
		}

		return false;
	}

	bool is_can_open() {
		enum_trade_mode_type trade_mode = layer_symbol::trade_mode ( CURRENT_SYMBOL );

		return trade_mode == trade_mode_type_full
			   || ( trade_mode == trade_mode_type_long_only && _order_settings.is_buy_direction )
			   || ( trade_mode == trade_mode_type_short_only && !_order_settings.is_buy_direction );
	}

	bool is_can_open_order ( order_count_t *orders_count, double last_price, double price, double step ) {
		return _settings.open_positions
			   && !_is_block_work
			   && !_is_block_work_by_stop_trade
			   && is_can_open()
			   && ( is_can_open_first_order ( orders_count.all() )
					|| is_can_add_order ( orders_count, last_price, price, step, 100.0 ) )
			   && !scheduler::is_stop_trade_time()
			   && is_spred_valid()
			   && is_vol_valid();
	}

	bool is_can_open_first_order ( int lvl ) {
		return lvl == 0
			   && _settings.open_first_order
			   && !is_strong_sleep()
			   && scheduler::is_trade_time()
			   && scheduler::is_trade_time_for_first_order()
			   && can_open_first_order()
			   && !is_wait_stop_on_close()
			   && !is_drawdown_percent_block()
			   && !is_max_pair_block()
			   && !is_currency_block()
			   && is_leverage_valid()
			   && _settings.final_stop_trading > layer::time_current();
	}

	bool is_can_add_order ( order_count_t *orders_count, double last_price, double price, double grid_step, double percent_of_price ) {
		return is_can_add_order ( orders_count.all(), last_price, price, grid_step, percent_of_price );
	}

	bool is_can_add_order ( int orders_count, double last_price, double price, double grid_step, double percent_of_price ) {
		return orders_count > 0
			   && orders_count < _settings.max_open_orders
			   && ( percent_of_price == 100 ? grid_step : ( grid_step / 100 ) * percent_of_price ) <= tool_order::get_distance ( _order_settings.order_type, price, last_price )
			   && scheduler::is_trade_time()
			   && is_min_time_step_valid();
	}

	bool is_max_pair_block() {
		if ( _settings.max_trade_pairs == 0
				|| layer_order::get_pair_count() < _settings.max_trade_pairs ) {
			return false;
		}

		log_info_k2 ( _settings.max_trade_pairs_label,
					  StringFormat ( SRC_HANDLER_BASE_MAX_PAIR_BLOCK, _settings.max_trade_pairs ) );
		return true;
	}

	bool is_currency_block() {
		if ( _settings.currency_block == 0 ) {
			return false;
		}

		int base_count = layer_order::get_base_count ( _order_settings.is_buy_direction );
		int profit_count = layer_order::get_profit_count ( _order_settings.is_buy_direction );

		if ( base_count < _order_settings.currency_block
				&& profit_count < _order_settings.currency_block ) {
			return false;
		}

		log_info_k2 ( _settings.currency_block_label,
					  StringFormat ( _order_settings.is_buy_direction ?
									 SRC_HANDLER_BASE_CURRENCY_BLOCK_LONG :
									 SRC_HANDLER_BASE_CURRENCY_BLOCK_SHORT,
									 layer_order::get_order_layer_symbol_current_symbol().base(),
									 base_count,
									 layer_order::get_order_layer_symbol_current_symbol().profit(),
									 profit_count,
									 _settings.currency_block ) );
		return true;
	}

	bool is_drawdown_percent_block() {
		if ( _settings.no1Order_by_drawdown_percent == 0 ) {
			return false;
		}

		double drawdown_percent = ( 1 - ( kernel_account::equity() / kernel_account::balance() ) ) * 100;

		if ( drawdown_percent <= _settings.no1Order_by_drawdown_percent ) {
			return false;
		}

		if ( _settings.no1Order_by_drawdown_percent_off != 0 ) {
			_drawdown_percent_block = true;
		}

		log_info_k ( StringFormat ( SRC_HANDLER_BASE_DRAWDOWN_BLOCK, DoubleToString ( drawdown_percent, 0 ), _settings.no1Order_by_drawdown_percent ) );
		return true;
	}

	bool is_ct_elapsed ( order_count_t *counts ) {
		if ( _settings.take_profit_control_timing == 0
				|| counts.order() == 0 ) {
			return false;
		}

		if ( _is_first_tick ) {
			_is_first_tick = false;
			return true;
		}

		return _ct_timer.is_elapsed();
	}

	bool is_min_time_step_valid() {
		if ( _settings.min_time_step == 0 ) {
			return true;
		}

		order *last_order = layer_order::get_max ( _order_settings );
		int diff_in_seconds = ( int ) ( layer::time_current() - last_order.open_time );

		if ( _settings.min_time_step < diff_in_seconds ) {
			return true;
		}

		log_info_k ( StringFormat ( SRC_HANDLER_BASE_CANCEL_MIN_TIME_STEP, TimeToString ( last_order.open_time + _settings.min_time_step + 1, TIME_DATE | TIME_MINUTES | TIME_SECONDS ) ) );
		return false;
	}

	bool is_leverage_valid() {
		if ( _settings.min_leverage == 0 ) {
			return true;
		}

		int leverage = layer::account_leverage();

		if ( _settings.min_leverage <= leverage ) {
			return true;
		}

		log_info_k ( StringFormat ( SRC_HANDLER_BASE_CANCEL_LEVERAGE, itos ( leverage ), itos ( _settings.min_leverage ) ) );
		return false;
	}

	bool is_spred_valid() {
		if ( _settings.max_spread == 0 ) {
			return true;
		}

		if ( handler_base_spread_block_trading_timer != NULL ) {
			if ( !handler_base_spread_block_trading_timer.is_elapsed() ) {
				return false;
			}

			GC_DISPOSE_IF ( handler_base_spread_block_trading_timer );
		}

		int spread = layer_market::spread ();

		if ( spread <= _settings.max_spread ) {
			return true;
		}

		if ( _settings.max_spread_stop_drading_timing != 0 ) {
			handler_base_spread_block_trading_timer = timer_t::create ( _settings.max_spread_stop_drading_timing );
			log_info ( StringFormat ( SRC_HANDLER_BASE_SPREAD_NOT_GOOD, spread, _settings.max_spread, _settings.max_spread_stop_drading_timing, ttos ( handler_base_spread_block_trading_timer.ent_time() ) ) );
		}

		return false;
	}

	bool is_vol_valid() {
		if ( _settings.vol_candle_max_size == 0 ) {
			return true;
		}

		if ( handler_base_vol_block_trading_timer != NULL ) {
			if ( !handler_base_vol_block_trading_timer.is_elapsed() ) {
				return false;
			}

			GC_DISPOSE_IF ( handler_base_vol_block_trading_timer );
		}

		double candle_pips_size = tool_candle::get_candle_size_by_high_low_p ( CURRENT_SYMBOL, _settings.vol_candle_tf, 0 );

		if ( candle_pips_size <= _settings.vol_candle_max_size ) {
			return true;
		}

		if ( _settings.vol_stop_trade_timing != 0 ) {
			handler_base_vol_block_trading_timer = timer_t::create ( _settings.vol_stop_trade_timing );
			log_info ( StringFormat ( SRC_HANDLER_BASE_VOL_NOT_GOOD, candle_pips_size, _settings.vol_candle_max_size, _settings.vol_stop_trade_timing, ttos ( handler_base_vol_block_trading_timer.ent_time() ) ) );
		}

		return false;
	}

	bool is_wait_stop_on_close() {
		if ( _settings.pause_on_close_in_sec == 0 ) {
			return false;
		}

		order *last_order = layer_order::get_history_last_order ( _order_settings );

		if ( !GC_CHECK_PTR ( last_order ) ) {
			return false;
		}

		datetime last_close_time = last_order.close_time;
		int distance = time_get_distance_in_sec ( layer::time_current(), last_close_time );

		if ( _settings.pause_on_close_in_sec <= distance ) {
			return false;
		}

		int need_sleep = _settings.pause_on_close_in_sec - distance;
		log_info_k (  StringFormat ( SRC_HANDLER_BASE_TIMER_STOP_ON_CLOSE, need_sleep / 60 ) );
		_strong_sleep_timer = timer_t::create ( need_sleep );
		return true;
	}

	TOOL_CACHED_INSTANCE_TICK ( bool,
	is_strong_sleep, {
		if ( !_settings.open_positions )
			_is_strong_sleep = true;
		else if ( !GC_CHECK_PTR ( _strong_sleep_timer ) )
			_is_strong_sleep = false;
		else if ( !_strong_sleep_timer.is_elapsed() )
			_is_strong_sleep = true;
		else {
			gc::push ( gc_dispose_type_on_end_tick, _strong_sleep_timer );
			_strong_sleep_timer = NULL;
			_is_strong_sleep = false;
		}
	} )

	void skip_candles ( int count ) {
		int current_candle_time_open = ( int ) tool_candle::get_time ( CURRENT_SYMBOL, _settings.time_frame, 0 );
		int need_candle_time_open = current_candle_time_open + ( time::get_seconds_from_time_frame ( _settings.time_frame ) * count );
		_strong_sleep_timer = timer_t::create ( need_candle_time_open - ( int ) layer::time_current() );
	}

	bool can_open_first_order () {
		if ( _settings.candles_for_open_first_order == 0 ) {
			return true;
		}

		for ( int i = 0; i < _settings.candles_for_open_first_order; i++ ) {
			candle_type candle_t = tool_candle::get_candle_type ( CURRENT_SYMBOL,
								   _settings.time_frame,
								   i + 1 );

			if ( candle_t == candle_type_zero ) {
				if ( i + 1 == _settings.candles_for_open_first_order ) {
					return false;
				}

				continue;
			}

			bool signal = _order_settings.is_buy_direction ?
						  candle_t == candle_type_bull :
						  candle_t == candle_type_bear;

			if ( _settings.revers_signal_to_open_first_order ) {
				signal = !signal;
			}

			if ( !signal ) {
				skip_candles ( _settings.candles_for_open_first_order - i );
				return false;
			}
		}

		if ( _settings.candles_for_open_first_order_min_pips > 0
				|| _settings.candles_for_open_first_order_max_pips > 0 ) {
			int candle_pips_size = _settings.candles_for_open_first_order_open_close ?
								   tool_candle::get_merged_candle_size_by_open_close_p ( CURRENT_SYMBOL, _settings.time_frame, _settings.candles_for_open_first_order, 1 ) :
								   tool_candle::get_merged_candle_size_by_high_low_p ( CURRENT_SYMBOL, _settings.time_frame, _settings.candles_for_open_first_order, 1 );

			if ( _settings.candles_for_open_first_order_min_pips > 0
					&& candle_pips_size < _settings.candles_for_open_first_order_min_pips ) {
				log_info_k ( StringFormat ( SRC_HANDLER_BASE_CANCEL_CANDLE_SIZE_MIN, candle_pips_size, _settings.candles_for_open_first_order_min_pips ) );
				skip_candles ( 1 );
				return false;
			}

			if ( _settings.candles_for_open_first_order_max_pips > 0
					&& candle_pips_size > _settings.candles_for_open_first_order_max_pips ) {
				log_info_k ( StringFormat ( SRC_HANDLER_BASE_CANCEL_CANDLE_SIZE_MAX, candle_pips_size, _settings.candles_for_open_first_order_max_pips ) );
				skip_candles ( 1 );
				return false;
			}
		}

		return true;
	}

	double free_check ( order_count_t *order_count,
						double price,
						double lot ) {
		double free_margin_before_open = kernel_account::free_margin_check ( CURRENT_SYMBOL,
										 _order_settings.order_type,
										 lot );

		if ( order_count.stop() > 0 ) {
			double tp_with_new_order = calc_take_profit::get ( _settings, _order_settings, order_count.all(),
									   true,
									   price,
									   lot );
			double margin_stop_orders = tool_margin::calc_margin ( _order_settings, tp_with_new_order );
			free_margin_before_open -= margin_stop_orders;
		}

		log_info_k ( StringFormat ( SRC_HANDLER_BASE_FREE_MAGIN_CHECK_NEW_ORDER, itos ( order_count.all() ), dtos ( price ), dtos ( lot ), dtos ( free_margin_before_open ) ) );
		return free_margin_before_open;
	}

	string create_order_comment ( int lvl ) {
		int last_order_tiket = 0;

		if ( lvl > 1 ) {
			last_order_tiket = layer_order::get_min ( _order_settings ).ticket;
		}

		return !ext_string_equals ( _settings.add_comment, EXT_STRING_EMPTY, false ) ?
			   StringFormat ( "%s-%s<%s>%d-%s", _settings.add_comment, IntegerToString ( last_order_tiket, 8, '0' ), IntegerToString ( lvl, 2, '0' ), _settings.gap_control, VER ) :
			   StringFormat ( "%s<%s>%d-%s", IntegerToString ( last_order_tiket, 8, '0' ), IntegerToString ( lvl, 2, '0' ), _settings.gap_control, VER );
	}

	void reset_vars() {
		_last_tp = 0;
		_log_last_tp = 0;
		_drawdown_percent_block = false;
		_last_order = NULL;
		GC_DISPOSE_IF ( _last_not_open_order_stop );
	}

	bool is_price_better ( double last_price, double price ) {
		return _order_settings.is_buy_direction ?
			   price <= last_price :
			   price >= last_price;
	}

	bool is_price_worse ( double last_price, double price ) {
		return _order_settings.is_buy_direction ?
			   price >= last_price :
			   price <= last_price;
	}

	void reset_states() {
		if ( GC_CHECK_PTR ( _close_orders ) ) {
			log_info_k ( SRC_HANDLER_BASE_RESET_STATE_CLOSE_ORDER );
			gc::push ( gc_dispose_type_on_end_tick, _close_orders );
		}
	}

	// API
	bool can_update_params() {
		return !GC_CHECK_PTR ( _close_orders )
			   && !GC_CHECK_PTR ( _last_not_open_order_stop );
	}

	string get_global_prefix ( string base_prefix ) {
		string side_prefix = order::is_buy_direction ( _order_settings.order_type ) ? "Buy" : "Sell";
		return StringFormat ( "%s_%d_%s_%s", base_prefix, _settings.magic_number, CURRENT_SYMBOL, side_prefix  );
	}

	double get_order_position ( double last_price, int lvl ) {
		return tool_order::deduct_points ( _order_settings.order_type,
										   last_price,
										   layer_market::to_points ( calc_grid_step::get ( _settings, lvl ) ) );
	}
};

#endif
