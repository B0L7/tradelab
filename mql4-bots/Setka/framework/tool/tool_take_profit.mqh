#ifndef FRAMEWORK_TOOL_TAKE_PROFIT_MQH
#define FRAMEWORK_TOOL_TAKE_PROFIT_MQH

class tool_take_profit {
public:
	static double get_avg_price_by_lot_factor ( list<order *> *orders,
			int skip_stop_order_count,
			bool with_virtual_order = false,
			double virtual_price = 0.0,
			double virtual_lot = 0.0 ) {
		double result = 0,
			   lots = 0;
		order *last_order = NULL;

		for ( int i = 0; i < orders.count; i++ ) {
			last_order = orders.items[i];

			if ( skip_stop_order_count != 0
					&& last_order.is_order_stop () ) {
				skip_stop_order_count -= 1;
				continue;
			}

			result += last_order.open_price * last_order.lot;
			lots += last_order.lot;
		}

		if ( with_virtual_order
				&& orders.count > 0 ) {
			result += virtual_price * virtual_lot;
			lots += virtual_lot;
		}

		return result / lots;
	}

	static double get_level_without_loss ( list<order *> *orders,
										   int skip_stop_order_count,
										   bool with_virtual_order = false,
										   double virtual_price = 0.0,
										   double virtual_lot = 0.0 ) {
		double lots = 0.0;
		double profit = 0.0;
		order *last_order = NULL;

		for ( int i = 0; i < orders.count; i++ ) {
			last_order = orders.items[i];

			if ( skip_stop_order_count != 0
					&& last_order.is_order_stop () ) {
				skip_stop_order_count -= 1;
				continue;
			}

			profit += last_order.get_profit_in_currency();
			lots += last_order.lot;

			if ( last_order.is_order () ) {
				profit += last_order.commission + last_order.swap;
			}
		}

		if ( with_virtual_order
				&& orders.count > 0 ) {
			profit += order::get_profit_in_currency ( last_order.order_type,
					  virtual_price,
					  virtual_lot );
			lots += virtual_lot;
		}

		if ( profit == 0.0 ) {
			return layer_market::price_close ( last_order.order_type );
		}

		double profit_pips = ( profit / lots ) / layer_market::tick_value ();
		double profit_points = layer_market::to_points ( profit_pips );
		return tool_order::deduct_points_from_current_price ( last_order.order_type, profit_points );
	}
};

#endif