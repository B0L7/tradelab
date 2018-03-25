#ifndef FRAMEWORK_LAYER_ORDER_MQH
#define FRAMEWORK_LAYER_ORDER_MQH

#include "order.mqh"
#include "order_count.mqh"
#include "order_operation.mqh"
#include "order_symbol.mqh"
#include "layer_order_setting.mqh"
#include "layer_order_data.mqh"

list<layer_order_data *> *order_layer_orders;
list<order_symbol *> *order_layer_symbols;

#ifdef FOR_OPTIMIZATION
#define LAYER_ORDER_CHECK_SYMBOL(sym) true
#define LAYER_ORDER_CHECK_MAGIC(mag) true
#else
#define LAYER_ORDER_CHECK_SYMBOL(sym) (kernel_order::symbol() == sym)
#define LAYER_ORDER_CHECK_MAGIC(mag) (kernel_order::magic_number() == mag)
#endif

#define LAYER_ORDER_CHECK_TYPE(order_type, order_stop_type) (kernel_order::type() == order_type || kernel_order::type() == order_stop_type)

class layer_order {
public:
	static void init() {
		order_layer_orders = new list<layer_order_data *> ( 2 );
		order_layer_orders.add ( new layer_order_data() );
		order_layer_orders.add ( new layer_order_data() );
		gc::push ( gc_dispose_type_on_end_deinit, order_layer_orders );
	}

	static order_symbol *get_order_layer_symbol_current_symbol() {
		TOOL_CACHED ( order_symbol *,
		_order_layer_symbol_current_symbol, {
			_order_layer_symbol_current_symbol = order_symbol::create ( Symbol() );
			gc::push ( gc_dispose_type_on_end_deinit, _order_layer_symbol_current_symbol );
		} );
	}

	static void push_settings ( layer_order_setting *settings_ptr ) {
		get_by_setting ( settings_ptr ).set ( settings_ptr );

		if ( settings_ptr.max_trade_pairs != 0
				|| settings_ptr.currency_block != 0 ) {
			ACTION_ON_NONVALUE_OR_DEFAULT ( order_layer_symbols, order_layer_symbols = new list<order_symbol *>() );
		}
	}

	static void refresh_all() {
		get_order_layer_symbol_current_symbol().reset_direction();
		ACTION_ON_VALUE_OR_DEFAULT ( order_layer_symbols, order_layer_symbols.clear() );
		LIST_FOREACH ( order_layer_orders, layer_order_data *, item, item.reset() );

		int magic_number = order_layer_orders.items[0].settings.magic_number;
		int ordersCount = kernel_order::count();

		for ( int i = 0; i < ordersCount; i++ ) {
			if ( !kernel_order::select_by_index ( i ) ) {
				continue;
			}

			if ( !LAYER_ORDER_CHECK_SYMBOL ( CURRENT_SYMBOL ) ) {
				if ( GC_CHECK_PTR ( order_layer_symbols ) ) {
					string symbol = kernel_order::symbol();
					LIST_FIRST_OR_DEFAULT ( order_layer_symbols, found_symbol, order_symbol *, item, item.full == symbol );

					if ( !GC_CHECK_PTR ( found_symbol ) ) {
						found_symbol = order_symbol::create ( symbol );
						order_layer_symbols.add ( found_symbol );
					}

					found_symbol.set_contains_direction ( order::is_buy_direction ( kernel_order::type() ) );
				}

				continue;
			}

			if ( !LAYER_ORDER_CHECK_MAGIC ( magic_number ) ) {
				continue;
			}

			LIST_FOREACH ( order_layer_orders, layer_order_data *, item, {
				if ( !LAYER_ORDER_CHECK_TYPE ( item.settings.order_type, item.settings.order_stop_type ) ) {
					continue;
				}

				order *for_add = factory_order::get();
				refresh_order ( for_add );

				if ( !GC_CHECK_PTR ( item.min_order )
						|| ( !item.is_buy_direction && for_add.open_price < item.min_order.open_price )
						|| ( item.is_buy_direction && for_add.open_price > item.min_order.open_price ) ) {
					item.min_order = for_add;
				}

				if ( !GC_CHECK_PTR ( item.max_order )
						|| ( !item.is_buy_direction && for_add.open_price > item.max_order.open_price )
						|| ( item.is_buy_direction && for_add.open_price < item.max_order.open_price ) ) {
					item.max_order = for_add;
				}

				item.orders.add ( for_add );
				item.count.inc_by_type ( for_add.order_type );

				ACTION_ON_VALUE_OR_DEFAULT ( order_layer_symbols, get_order_layer_symbol_current_symbol().set_contains_direction ( item.is_buy_direction ) );
				break;
			} );
		}
	}

	// Вызывает после удаление ордеров надо бы как то это обыграть
	static void refresh ( layer_order_setting *settings_ptr ) {
		layer_order_data *pair = get_by_setting ( settings_ptr );

		pair.orders.clear_without_dispoce();
		pair.count.clear();

		int ordersCount = kernel_order::count();

		for ( int i = 0; i < ordersCount; i++ ) {
			if (  !kernel_order::select_by_index ( i )
					|| !LAYER_ORDER_CHECK_SYMBOL ( CURRENT_SYMBOL )
					|| !LAYER_ORDER_CHECK_MAGIC ( pair.settings.magic_number )
					|| !LAYER_ORDER_CHECK_TYPE ( pair.settings.order_type, pair.settings.order_stop_type ) ) {
				continue;
			}


			order *for_add = factory_order::get();
			refresh_order ( for_add );
			pair.orders.add ( for_add );
			pair.count.inc_by_type ( for_add.order_type );
		}
	}

	static void push ( layer_order_setting *settings_ptr, int ticket ) {
		if ( !kernel_order::select_by_ticket ( ticket ) ) {
			return;
		}

		layer_order_data *collection = get_by_setting ( settings_ptr );

		order *for_add = factory_order::get();
		refresh_order ( for_add );
		for_add.lvl = collection.orders.count + 1;

		collection.orders.add ( for_add );
		collection.max_order = for_add;
	}

	static void refresh ( layer_order_setting *settings_ptr, int ticket ) {
		if ( !kernel_order::select_by_ticket ( ticket )  ) {
			return;
		}

		list<order *> *orders = get ( settings_ptr );
		LIST_FIRST_OR_DEFAULT ( orders, result, order *, item, item.ticket == ticket );
		ACTION_ON_VALUE_OR_DEFAULT ( result, refresh_order ( result ) );
	}

	static list<order *> *get ( layer_order_setting *settings_ptr ) {
		layer_order_data *collection = get_by_setting ( settings_ptr );

		if ( !collection.is_sorted ) {
			collection.is_sorted = true;

			LIST_SORT_BUBBLE ( collection.orders,
							   open_price,
							   !collection.is_buy_direction );
			LIST_FOREACH2 ( collection.orders,
							order *,
							item,
							item.lvl = i_kdaskdgfgf + 1 );
		}

		return GET_VALUE_OR_DEFAULT ( collection, collection.orders );
	}

	static order_count_t *get_count ( layer_order_setting *settings_ptr ) {
		layer_order_data *collection = get_by_setting ( settings_ptr );
		return GET_VALUE_OR_DEFAULT ( collection, collection.count );
	}

	static order *get_min ( layer_order_setting *settings_ptr ) {
		layer_order_data *collection = get_by_setting ( settings_ptr );
		return GET_VALUE_OR_DEFAULT ( collection, collection.min_order );
	}

	static order *get_max ( layer_order_setting *settings_ptr ) {
		layer_order_data *collection = get_by_setting ( settings_ptr );
		return GET_VALUE_OR_DEFAULT ( collection, collection.max_order );
	}

	static int get_pair_count() {
		return GET_VALUE_OR_MANUAL ( order_layer_symbols, order_layer_symbols.count, 0 );
	}

	static int get_base_count ( bool is_buy_direction ) {
		if ( !GC_CHECK_PTR ( order_layer_symbols ) ) {
			return 0;
		}

		order_symbol *check_symbol = get_order_layer_symbol_current_symbol();
		LIST_COUNT ( order_layer_symbols,
					 result,
					 order_symbol *,
					 item,
					 item.check_base ( is_buy_direction, check_symbol ) );
		return result;
	}

	static int get_profit_count ( bool is_buy_direction  ) {
		if ( !GC_CHECK_PTR ( order_layer_symbols ) ) {
			return 0;
		}

		order_symbol *check_symbol = get_order_layer_symbol_current_symbol();
		LIST_COUNT ( order_layer_symbols,
					 result,
					 order_symbol *,
					 item,
					 item.check_profit ( is_buy_direction,  check_symbol  ) );
		return result;
	}

	static order *get_history_last_order ( layer_order_setting *settings_ptr ) {
		layer_order_data *pair = get_by_setting ( settings_ptr );

		for ( int i = kernel_order::count_history() - 1; i >= 0; i-- ) {
			if ( !kernel_order::select_by_index_history ( i )
					|| !LAYER_ORDER_CHECK_SYMBOL ( CURRENT_SYMBOL )
					|| !LAYER_ORDER_CHECK_MAGIC ( pair.settings.magic_number )
					|| !LAYER_ORDER_CHECK_TYPE ( pair.settings.order_type, pair.settings.order_stop_type ) ) {
				continue;
			}

			order *result = factory_order::get();
			refresh_order ( result );
			return result;
		}

		return NULL;
	}

	static bool close_all ( int magic_number,
							enum_order_operation_type order_type,
							enum_order_operation_type order_stop_type,
							int slippage ) {
		bool result = false;
		color order_color = order::get_order_color ( order_type );

		for ( int i = 0; i < 3 && !result; i++ ) {
			result = close_by_market ( magic_number,
									   order_type,
									   order_stop_type,
									   slippage,
									   order_color );
		}

		return result;
	}

	static bool close_by_market ( int magic_number,
								  enum_order_operation_type order_type,
								  enum_order_operation_type order_stop_type,
								  int slippage,
								  color order_color ) {
		for ( int i = kernel_order::count() - 1; i >= 0; i-- ) {
			if ( !kernel_order::select_by_index ( i ) ) {
				return false;
			}

			if ( !LAYER_ORDER_CHECK_SYMBOL ( CURRENT_SYMBOL )
					|| !LAYER_ORDER_CHECK_MAGIC ( magic_number )
					|| !LAYER_ORDER_CHECK_TYPE ( order_type, order_stop_type ) ) {
				continue;
			}

			log_info_k ( StringFormat ( SRC_ORDER_TRY_CLOSE_ORDER, IntegerToString ( kernel_order::ticket() ) ) );

			bool is_close = order::is_order_stop ( kernel_order::type() ) ?
							kernel_order::delete_stop ( kernel_order::ticket(), order_color ) :
							kernel_order::close ( kernel_order::ticket(),
												  kernel_order::lots(),
												  layer_market::price_close ( kernel_order::type() ),
												  slippage,
												  order_color );

			if ( !is_close ) {
				log_info_k ( SRC_ORDER_FAIL_CLOSE_ORDER );
				return false;
			}
		}

		return true;
	}

	static list<layer_order_data *> *get_all() {
		return order_layer_orders;
	}

	static layer_order_data *get_by_setting ( layer_order_setting *settings_ptr ) {
		return order_layer_orders.items[settings_ptr.order_type == order_operation_buy ? 0 : 1];
	}

private:

	static void refresh_order ( order *value ) {
		value.symbol = kernel_order::symbol();
		value.magic_number = kernel_order::magic_number();
		value.order_type = kernel_order::type();
		value.ticket = kernel_order::ticket();
		value.lot = kernel_order::lots();
		value.open_price = kernel_order::open_price();
		value.stop_loss = kernel_order::stop_loss();
		value.take_profit = kernel_order::take_profit();
		value.commission = kernel_order::commission();
		value.swap = kernel_order::swap();
		value.open_time = kernel_order::open_time();
		value.close_time = kernel_order::close_time();
	}
};

#endif