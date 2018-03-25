#ifndef FRAMEWORK_LAYER_ORDER_DATA_MQH
#define FRAMEWORK_LAYER_ORDER_DATA_MQH

class layer_order_data : public disposable_obj {
public:
	layer_order_setting *settings;
	bool is_buy_direction;
	list<order *> *orders;
	order *min_order;
	order *max_order;
	bool is_sorted;
	order_count_t *count;

	~layer_order_data() {
		GC_DISPOSE_IF ( settings );
		GC_DISPOSE_IF ( orders );
		GC_DISPOSE_IF ( min_order );
		GC_DISPOSE_IF ( max_order );
		GC_DISPOSE_IF ( count );
	}

	void set ( layer_order_setting *in_settings ) {
		settings = in_settings;
		is_buy_direction = order::is_buy_direction ( in_settings.order_type );
		orders = new list<order *> ( in_settings.max_orders );
		min_order = NULL;
		max_order = NULL;
		is_sorted = false;
		count = new order_count_t();
	}

	void reset() {
		min_order = NULL;
		max_order = NULL;
		is_sorted = false;

		orders.clear_without_dispoce();
		count.clear();
	}

	TOOL_CACHED_INSTANCE_TICK ( double,
	profit_clear_currency, {
		_profit_clear_currency = 0.0;
		LIST_FOREACH ( orders, order *, item,

					   if ( item.is_order() )
					   _profit_clear_currency += item.get_profit_clear_currency()
					 );
	} );

	double drawdown_currency() {
		return profit_clear_currency() * -1;
	}
};

#endif