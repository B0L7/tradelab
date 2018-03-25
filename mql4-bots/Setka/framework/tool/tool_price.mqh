#ifndef FRAMEWORK_TOOL_PRICE_MQH
#define FRAMEWORK_TOOL_PRICE_MQH

class tool_price {
public:
	static double get_sign ( double value ) {
		return value >= 0.000000 ? 1 : -1;
	}

	static double add_by_direction ( double start_direction, double value, double end_direction ) {
		return start_direction + ( get_sign ( end_direction - start_direction ) * value );
	}

	static double add_by_order_type_direction ( enum_order_operation_type order_type, double base, double value ) {
		return order::is_buy_direction ( order_type ) ?
			   base - value :
			   base + value;
	}

	static double deduct_by_order_type_direction ( enum_order_operation_type order_type, double base, double value ) {
		return order::is_buy_direction ( order_type ) ?
			   base + value :
			   base - value;
	}

	static double distance_by_type ( enum_order_operation_type order_type, double start, double end ) {
		return order::is_buy_direction ( order_type ) ?
			   start - end :
			   end - start;
	}
};

#endif