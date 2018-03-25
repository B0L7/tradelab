#ifndef FRAMEWORK_LAYER_ORDER_SETTING_MQH
#define FRAMEWORK_LAYER_ORDER_SETTING_MQH

class layer_order_setting : public disposable_obj {
public:
	int magic_number;
	enum_order_operation_type order_type;
	enum_order_operation_type order_stop_type;
	bool is_buy_direction;
	int max_orders;
	int max_trade_pairs;
	int currency_block;

	static layer_order_setting *create ( int max_orders,
										 int magic_number,
										 enum_order_operation_type order_type,
										 enum_order_operation_type order_stop_type,
										 int max_trade_pairs,
										 int currency_block ) {
		layer_order_setting *result = new layer_order_setting();
		result.magic_number = magic_number;
		result.order_type = order_type;
		result.order_stop_type = order_stop_type;
		result.is_buy_direction = order::is_buy_direction ( order_type );
		result.max_orders = max_orders;
		result.max_trade_pairs = max_trade_pairs;
		result.currency_block = currency_block;
		return result;
	}
};

#endif