#ifndef FRAMEWORK_ENUM_ORDER_OPERATION_TYPE_MQH
#define FRAMEWORK_ENUM_ORDER_OPERATION_TYPE_MQH

enum enum_order_operation_type {
	order_operation_none = -255,
	order_operation_buy = 255,
	order_operation_sell = 254,
	order_operation_buy_stop = 253,
	order_operation_buy_limit = 252,
	order_operation_sell_stop = 251,
	order_operatione_sell_limit = 250
};

#endif