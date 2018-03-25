#ifndef FRAMEWORK_ORDER_MQH
#define FRAMEWORK_ORDER_MQH

class order : public disposable_obj {
public:
	string symbol;
	long magic_number;
	enum_order_operation_type order_type;
	int ticket;
	double lot;
	double open_price;
	double stop_loss;
	double take_profit;
	double commission;
	double swap;
	datetime open_time;
	datetime close_time;
	int lvl;

	void reset() {
		symbol = EXT_STRING_EMPTY;
		magic_number = 0;
		order_type = order_operation_none;
		ticket = 0;
		lot = 0.0000;
		open_price = 0.0000;
		stop_loss = 0.0000;
		take_profit = 0.0000;
		commission = 0.0000;
		swap = 0.0000;
		lvl = 0;
	}

	static bool is_buy_direction ( enum_order_operation_type order_type ) {
		return order_type == order_operation_buy
			   || order_type == order_operation_buy_limit
			   || order_type == order_operation_buy_stop;
	}

	static bool is_order ( enum_order_operation_type order_type ) {
		return order_type == order_operation_buy
			   || order_type == order_operation_sell;
	}

	static bool is_order_stop ( enum_order_operation_type order_type ) {
		return order_type == order_operation_buy_stop
			   || order_type == order_operation_sell_stop;
	}

	static bool is_order_limit ( enum_order_operation_type order_type ) {
		return order_type == order_operation_buy_limit
			   || order_type == order_operatione_sell_limit;
	}

	static double get_profit_in_currency ( enum_order_operation_type order_type,
										   double open_price,
										   double lot,
										   double at_price ) {
		return tool_order::get_distance ( order_type,
										  open_price,
										  at_price )
			   * layer_market::price_for_point_per_lot ()
			   * lot;
	}

	static double get_profit_in_currency ( enum_order_operation_type order_type,
										   double open_price,
										   double lot ) {
		return get_profit_in_currency ( order_type,
										open_price,
										lot,
										layer_market::price_close ( order_type ) );
	}

	static color get_order_color ( enum_order_operation_type type ) {
		return order::is_buy_direction ( type ) ? Blue : Red;
	}

	bool is_buy_direction () {
		return is_buy_direction ( order_type );
	}

	bool is_order() {
		return is_order ( order_type );
	}

	bool is_order_stop () {
		return is_order_stop ( order_type );
	}

	double get_price() {
		return layer_market::price_close ( order_type );
	}

	double get_profit_in_currency () {
		return get_profit_in_currency ( get_price() );
	}

	double get_profit_clear_currency () {
		return get_profit_in_currency ( get_price() ) + commission + swap;
	}

	double get_profit_in_currency ( double at_price ) {
		return get_profit_in_currency ( order_type,
										open_price,
										lot,
										at_price );
	}

	bool is_before_line ( double line ) {
		return tool_order::is_price_before_line ( order_type,
				open_price,
				line );
	}

	double get_distance_from_open_price ( double price ) {
		return tool_order::get_distance ( order_type,
										  open_price,
										  price );
	}
};

#endif