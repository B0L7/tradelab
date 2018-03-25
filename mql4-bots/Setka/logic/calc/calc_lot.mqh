#ifndef LOT_CALC_MQH
#define LOT_CALC_MQH

#include "../setting.mqh"

class calc_lot {
private:
	static bool is_lvl1 ( setting_t *settings, int order_count ) {
		return settings.multi_lots_level1 != 0
			   && order_count >= settings.multi_lots_level1;
	}

	static bool is_lvl2 ( setting_t *settings, int order_count ) {
		return settings.multi_lots_level2 != 0
			   && is_lvl1 ( settings, order_count )
			   && order_count >= settings.multi_lots_level2;
	}

	static bool is_lvl3 ( setting_t *settings, int order_count ) {
		return settings.multi_lots_level3 != 0
			   && is_lvl2 ( settings, order_count )
			   && order_count >= settings.multi_lots_level3;
	}

	static bool is_lvl4 ( setting_t *settings, int order_count ) {
		return settings.mult4 != 0
			   && is_lvl3 ( settings, order_count )
			   && order_count >= settings.mult4;
	}

	static double get_factor ( setting_t *settings,
							   int lvl ) {
		double result = 1.0;

		if ( settings.mult_stop != 0
				&& settings.mult_stop < lvl ) {
			lvl = settings.mult_stop;
		}

		if ( is_lvl4 ( settings, lvl ) ) {
			result = get_factor ( settings, lvl - ( lvl - settings.mult4 + 1 ) );

			int count = lvl + 1 - settings.mult4;

			for ( int i = 0; i < count; i++ ) {
				result += settings.mult4_add;
			}
		} else if ( is_lvl3 ( settings, lvl ) ) {
			result = get_factor ( settings, lvl - ( lvl - settings.multi_lots_level3 + 1 ) );

			int count = lvl + 1 - settings.multi_lots_level3;

			for ( int i = 0; i < count; i++ ) {
				result += settings.multi_lots_level3_corr;
			}
		} else if ( is_lvl2 ( settings, lvl ) ) {
			result = get_factor ( settings, lvl - ( lvl - settings.multi_lots_level2 + 1 ) );

			int count = lvl + 1 - settings.multi_lots_level2;

			for ( int i = 0; i < count; i++ ) {
				result += settings.multi_lots_level2_corr;
			}
		} else if ( is_lvl1 ( settings, lvl ) ) {
			result = settings.multi_lots_factor;
		}

		return result;
	}

	static double get_for_gap_control ( setting_t *settings,
										enum_order_operation_type order_type,
										int lvl,
										double last_lot,
										double last_price,
										double price ) {
		double step_p = layer_market::to_points ( calc_grid_step::get ( settings, lvl ) );
		double distance_p = tool_order::get_distance ( order_type, price, last_price );
		double lot_factor = get_factor ( settings, lvl );

		if ( !calc_gap::is_gap ( settings, order_type, order_type, distance_p, step_p ) ) {
			return last_lot * lot_factor;
		}

		// TODO: print on every calc lot
		//log_info_k ( _msg_key, StringFormat ( SRC_HANDLER_BASE_DETECT_GAP, dtos ( last_price ), dtos ( price ), dtos ( order::get_distance ( _order_type, price, last_price ) ) ) );
		double gap_factor = lot_factor * ( ( distance_p - step_p ) / step_p ) * settings.gap_lot_koef;
		double tripple_last_lot = last_lot * settings.gap_last_order_koef;
		double result = last_lot * ( lot_factor + gap_factor );
		return tripple_last_lot < result ? tripple_last_lot : result;
	}

	static double calc_lot_by_balance ( double min_lot,
										double balance_by_min_lot,
										double balance,
										int truncate_count,
										double market_lot_min ) {
		double coff = balance / balance_by_min_lot;
		double result = ext_string::truncate_real_part ( min_lot * coff, truncate_count );
		return result < market_lot_min ? market_lot_min : result;
	}

	static double get_base_lot ( setting_t *settings,
								 layer_order_setting *settings_ptr,
								 int lvl ) {
		if ( !settings.is_testing && lvl != 1 ) {
			return layer_order::get_min ( settings_ptr ).lot;
		}

		return settings.currency_for_min_lot == 0 ?
			   settings.lots :
			   calc_lot_by_balance ( settings.lots,
									 settings.currency_for_min_lot,
									 settings.is_testing ? settings.testing_balance : kernel_account::balance(),
									 settings.lot_exp,
									 settings.is_testing ? settings.testing_layer_market_lot_min : layer_market::lot_min() );
	}

	static double get_by_min_order ( setting_t *settings,
									 layer_order_setting *order_layer_settings_ptr,
									 int lvl,
									 enum_gap_control_type control_type,
									 double price,
									 double first_lot ) {
		double result = first_lot;

		switch ( control_type ) {
			case no_gap:
			case op_stop:
				result *= get_factor ( settings, lvl );
				break;

			case inc_lot:
				//result = get_for_gap_control ( settings, settings_ptr.order_type, count + 1, result, open_prices[count - 1], price );
				break;
		}

		return result;
	}

	static double get_by_last_order ( setting_t *settings,
									  layer_order_setting *settings_ptr,
									  int lvl,
									  enum_gap_control_type control_type,
									  double price,
									  double first_lot ) {
		double result = first_lot;

		switch ( control_type ) {
			case no_gap:
			case op_stop:
				for ( int i = 1; i < lvl; i++ ) {
					result *= get_factor ( settings, i + 1 );
				}

				break;

			case inc_lot: {
				int count = 0;
				double open_prices[];

				list<order *> *orders = layer_order::get ( settings_ptr );
				ArrayResize ( open_prices, orders.count );
				LIST_FOREACH ( orders, order *, item, {
					count += 1;
					open_prices[count - 1] = item.open_price;
				} );

				if ( count == 0 ) {
					break;
				}

				for ( int i = 1; i < count; i++ ) {
					result = get_for_gap_control ( settings, settings_ptr.order_type, i + 1, result, open_prices[i - 1], open_prices[i] );
				}

				result = get_for_gap_control ( settings, settings_ptr.order_type, count + 1, result, open_prices[count - 1], price );
				break;
			}
		}

		return result;
	}

public:
	static double get ( setting_t *settings,
						layer_order_setting *settings_ptr,
						int lvl,
						enum_gap_control_type control_type,
						double price ) {
		double base_lot = get_base_lot ( settings,
										 settings_ptr,
										 lvl );
		double result = base_lot;

		if ( lvl != 1 ) {
			result = settings.mult_type == calc_lot_type_last_order ?
					 get_by_last_order ( settings,
										 settings_ptr,
										 lvl,
										 control_type,
										 price,
										 result ) :
					 get_by_min_order ( settings,
										settings_ptr,
										lvl,
										control_type,
										price,
										result );
		}

		if ( settings.max_lot != 0.00 ) {
			double max_lot = settings.max_lot * base_lot;

			if ( max_lot < result ) {
				result = max_lot;
			}
		}

		return result;
	};
};

#endif