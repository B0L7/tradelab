#ifndef FRAMEWORK_TOOL_ORDER_MQH
#define FRAMEWORK_TOOL_ORDER_MQH

class tool_order {
public:
	static double get_distance ( enum_order_operation_type order_type,
								 double start,
								 double end ) {
		return order::is_buy_direction ( order_type ) ?
			   end - start :
			   start - end;
	}

	static bool is_price_before_line ( enum_order_operation_type order_type,
									   double price,
									   double line ) {
		return order::is_buy_direction ( order_type ) ?
			   price < line :
			   line < price;
	}

	static double deduct_points_from_current_price ( enum_order_operation_type order_type,
			double points ) {
		return deduct_points ( order_type,
							   layer_market::price_close ( order_type ),
							   points );
	}

	static double deduct_points ( enum_order_operation_type order_type,
								  double price,
								  double points ) {
		return order::is_buy_direction ( order_type ) ?
			   price - points :
			   price + points;
	}

	static double add_points_to_current_price ( enum_order_operation_type order_type,
			double points ) {
		return add_point ( order_type,
						   layer_market::price_close ( order_type ),
						   points );
	}

	static double add_point ( enum_order_operation_type order_type,
							  double price,
							  double points ) {
		return order::is_buy_direction ( order_type ) ?
			   price + points :
			   price - points;
	}
};

#endif