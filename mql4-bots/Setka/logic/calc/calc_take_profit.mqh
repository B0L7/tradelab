#ifndef TAKE_PROFIT_CALC_MQH
#define TAKE_PROFIT_CALC_MQH

class calc_take_profit {
private:
	static bool is_lvl1 ( setting_t *settings,
						  int order_count ) {
		return settings.take_proffit_level1 != 0
			   && order_count >= settings.take_proffit_level1;
	}

	static bool is_lvl2 ( setting_t *settings,
						  int order_count ) {
		return settings.take_proffit_level2 != 0
			   && order_count >= settings.take_proffit_level2;
	}

	static enum_take_profit_calc_type get_type ( setting_t *settings,
			int order_count ) {
		return is_lvl3 ( settings, order_count ) ?
			   tp_level_without_loss :
			   settings.tp_type;
	}

	static int get_pips ( setting_t *settings,
						  int order_count ) {
		int result = settings.take_proffit;

		if ( is_lvl3 ( settings, order_count ) ) {
			result = settings.take_proffit_level3_fix_pips;
		} else if ( is_lvl2 ( settings, order_count ) ) {
			int lvl1_count = settings.take_proffit_level2 - 1;
			int lvl2_count = order_count - lvl1_count;

			result = get_pips ( settings, lvl1_count );

			for ( int i = 0; i < lvl2_count; i++ ) {
				result += settings.take_proffit_level2_corr;
			}
		} else if ( is_lvl1 ( settings, order_count ) ) {
			int take_profit_factor = settings.take_proffit_level1_corr * ( order_count + 1 - settings.take_proffit_level1 );
			result = settings.take_proffit + take_profit_factor;
		}

		return result;
	}

public:
	static bool is_lvl3 ( setting_t *settings,
						  int order_count ) {
		return settings.take_proffit_level3 != 0
			   && order_count >= settings.take_proffit_level3;
	}

	static double get ( setting_t *settings,
						layer_order_setting *order_settings,
						enum_take_profit_calc_type type,
						int tp_pips,
						bool with_virtual_order = false,
						double virtual_price = 0.0,
						double virtual_lot = 0.0 ) {
		list<order *> *orders = layer_order::get ( order_settings );
		int stop_count = layer_order::get_count ( order_settings ).stop();

		double last_result = 0,
			   result = 0,
			   tp_in_points = tp_pips == 0 ? 0.0 : layer_market::to_points ( tp_pips );
		int last_stop_count_before_line = 0,
			stop_count_before_line = 0,
			skip_stop_order = stop_count;

		while ( true ) {
			last_result = result;

			switch ( type ) {
				case tp_avg:
					result = tool_take_profit::get_avg_price_by_lot_factor ( orders,
							 skip_stop_order,
							 with_virtual_order,
							 virtual_price,
							 virtual_lot );
					break;

				case tp_level_without_loss:
					result = tool_take_profit::get_level_without_loss ( orders,
							 skip_stop_order,
							 with_virtual_order,
							 virtual_price,
							 virtual_lot );
					break;

				default:
					return 0.0;
			}

			result = tool_order::add_point ( order_settings.order_type, result, tp_in_points );

			// Сразу же выходим, если не учитываются отложенные ордера
			// либо отложенных ордеров нету
			// либо все отложки учитываются в ТР
			if ( order_settings.order_stop_type == -1
					|| stop_count == 0
					|| skip_stop_order <= 0 ) {
				break;
			}

			last_stop_count_before_line = stop_count_before_line;

			LIST_COUNT ( orders, stop_count_before_line_by_result, order *, item, item.is_order_stop() && tool_order::is_price_before_line ( item.order_type, item.open_price, result ) );
			stop_count_before_line = stop_count_before_line_by_result;

			// Если кол-во отложенных ордеров попадающих в ТР не увеличилось,
			// то выходим из цикла и берем прошлый ТР
			if ( last_stop_count_before_line == stop_count_before_line ) {
				if ( skip_stop_order > 0 ) {
					// TODO: вывод происходит каждый раз при расчете ТР, нужно это перенести в блок, когда явно задается ТР
					// или придумать возможность отложенного вывода сообщения в лог
					//log_info_k ( StringFormat ( SRC_HANDLER_BASE_TP_SKIP_ORDER_STOP, skip_stop_order ) );
				}

				break;
			}

			skip_stop_order -= 1;
		}

		return result;
	}

	static double get ( setting_t *settings,
						layer_order_setting *order_settings,
						int order_count,
						bool with_virtual_order = false,
						double virtual_price = 0.0,
						double virtual_lot = 0.0 ) {
		double result = get ( settings,
							  order_settings,
							  get_type ( settings, order_count ),
							  get_pips ( settings, order_count ),
							  with_virtual_order,
							  virtual_price,
							  virtual_lot );
		return layer::correct_price ( result );
	}

#define ADD_IN_NULL(collection_item_type, collection, collection_capacity, for_add) \
	if(collection == NULL){ \
		collection = new list<collection_item_type>(collection_capacity); \
	} \
	collection.add(for_add);

	static list<order_operation *> *get_set_tp_if ( setting_t *settings,
			layer_order_setting *order_settings,
			double norm_tp ) {
		list<order_operation *> *result = NULL;

		bool min_distance_inited = false;
		double min_distance_from_open_price_p = 0.0;

		list<order *> *orders = layer_order::get ( order_settings );
		LIST_FOREACH ( orders, order *, item, {
			if ( item.take_profit == norm_tp ) {
				continue;
			}

			if ( item.is_order_stop() && !item.is_before_line ( norm_tp ) ) {
				if ( !min_distance_inited ) {
					min_distance_inited = true;
					min_distance_from_open_price_p = layer_market::min_distance_from_open_price_p ( CURRENT_SYMBOL,
							settings.max_spread );
					// TODO: временная мера layer_market?и с проблемами на EURJPY
					min_distance_from_open_price_p += layer_market::to_points ( layer_account::bit_multiplier() );
				}

				// Так как это отложка и она находиться за линией нужного нам ТР,
				// то требуется выставить минимальное значение ТР и SL
				double sl = item.is_buy_direction() ?
							item.open_price - min_distance_from_open_price_p :
							item.open_price + min_distance_from_open_price_p;
				sl = layer::correct_price ( sl );
				double tp = item.is_buy_direction() ?
							item.open_price + min_distance_from_open_price_p :
							item.open_price - min_distance_from_open_price_p ;
				tp = layer::correct_price ( tp );

				if ( tp == item.take_profit && sl == item.stop_loss ) {
					continue;
				}


				order_operation *for_add = factory_order_operation::get();
				for_add.is_completed = false;
				for_add.ticket = item.ticket;
				for_add.operation_type = order_operation_type_set_sl_tp;
				for_add.take_profit = tp;
				for_add.stop_loss = sl;
				ADD_IN_NULL ( order_operation *, result, order_settings.max_orders, for_add );
				continue;
			}

			order_operation *for_add = factory_order_operation::get();
			for_add.is_completed = false;
			for_add.ticket = item.ticket;
			for_add.operation_type = order_operation_type_set_tp;
			for_add.take_profit = norm_tp;
			ADD_IN_NULL ( order_operation *, result, order_settings.max_orders, for_add );
		} );

		return result;
	}
};

#endif