#ifndef FRAMEWORK_LAYER_MARKET_MQH
#define FRAMEWORK_LAYER_MARKET_MQH

class layer_market {
public:
	static double lot_min() {
		TOOL_CACHED ( double,
					  _lot_min,
					  _lot_min = kernel_market::lot_min ( CURRENT_SYMBOL ) );
	}

	static double lot_max()  {
		TOOL_CACHED ( double,
					  _lot_max,
					  _lot_max = kernel_market::lot_max ( CURRENT_SYMBOL ) );
	}

	static double lot_size() {
		TOOL_CACHED ( double,
					  _lot_size,
					  _lot_size = kernel_market::lot_size ( CURRENT_SYMBOL ) );
	}

	static double lot_step() {
		TOOL_CACHED ( double,
					  _lot_step,
					  _lot_step = kernel_market::lot_step ( CURRENT_SYMBOL ) );
	}

	static double tick_value() {
		TOOL_CACHED ( double,
					  _tick_value,
					  _tick_value = kernel_market::tick_value ( CURRENT_SYMBOL ) );
	}

	static double tick_size() {
		TOOL_CACHED ( double,
					  _tick_size,
					  _tick_size = kernel_market::tick_size ( CURRENT_SYMBOL ) );
	}

	static double stop_level() {
		TOOL_CACHED ( double,
					  _stop_level,
					  _stop_level = kernel_market::stop_level ( CURRENT_SYMBOL ) );
	}

	static double margin_required() {
		TOOL_CACHED ( double,
					  _margin_required,
					  _margin_required = kernel_market::margin_required ( CURRENT_SYMBOL ) );
	}

	static double freeze_level ( ) {
		TOOL_CACHED ( double,
					  _freeze_level,
					  _freeze_level = kernel_market::freeze_level ( CURRENT_SYMBOL ) );
	}

	static int spread() {
		TOOL_CACHED_TICK ( int,
						   _spread,
						   _spread = kernel_market::spread ( CURRENT_SYMBOL ) );
	}

	static double point() {
		TOOL_CACHED ( double,
					  _point,
					  _point = kernel_market::point ( ) );
	}

	static double price_buy() {
		TOOL_CACHED_TICK ( double,
						   _price_buy,
						   _price_buy = kernel_market::price_buy ( CURRENT_SYMBOL ) );
	}

	static double price_sell() {
		TOOL_CACHED_TICK ( double,
						   _price_sell,
						   _price_sell = kernel_market::price_sell ( CURRENT_SYMBOL ) );
	}

	static double price_open ( enum_order_operation_type order_type ) {
		return order::is_buy_direction ( order_type ) ?
			   price_buy() :
			   price_sell();
	}

	static double price_close ( enum_order_operation_type order_type ) {
		return order::is_buy_direction ( order_type ) ?
			   price_sell() :
			   price_buy();
	}

	static double to_points ( double pips ) {
		return pips * layer_market::point();
	}

	static int to_pips ( double points ) {
		return ( int ) ( points / layer_market::point() );
	}

	static double price_for_point_per_lot () {
		return layer_market::tick_value ()
			   / layer_market::tick_size ();
	}

	static double min_distance_from_open_price_p ( string symbol, int max_spread ) {
		double result = layer_market::stop_level ();

		if ( result != 0.000000 ) {
			return layer_market::to_points ( result );
		}

		result = layer_market::freeze_level ();

		if ( result != 0.000000 ) {
			return layer_market::to_points ( result );
		}

		result = layer_market::spread () * 2;

		if ( result > max_spread ) {
			return layer_market::to_points ( result );
		}

		return layer_market::to_points ( max_spread );
	}

	static bool is_closed() {
		return layer_error::get_last_saved() == ERROR_MARKET_CLOSED;
	}
};

#endif