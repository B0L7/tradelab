#ifndef FRAMEWORK_ORDER_LAYER_SYMBOL_MQH
#define FRAMEWORK_ORDER_LAYER_SYMBOL_MQH

class order_symbol : public disposable_obj {
public:
	string full;
	bool contains_buy;
	bool contains_sell;

	TOOL_CACHED_INSTANCE ( string, base, _base = kernel_symbol::currency_base ( full ) )
	TOOL_CACHED_INSTANCE ( string, profit, _profit = kernel_symbol::currency_profit ( full ) )

	bool check_base ( bool need_buy_direction, order_symbol *check_symbol ) {
		return ( need_buy_direction
				 && ( ( contains_buy
						&& ext_string_equals ( check_symbol.base(), base(), false ) )
					  || ( contains_sell
						   &&  ext_string_equals ( check_symbol.base(), profit(), false ) ) ) )
			   || ( !need_buy_direction
					&& ( ( contains_sell
						   && ext_string_equals ( check_symbol.base(), base(), false ) )
						 || ( contains_buy
							  && ext_string_equals ( check_symbol.base(), profit(), false ) ) ) );
	}

	bool check_profit ( bool need_buy_direction, order_symbol *check_symbol ) {
		return ( need_buy_direction
				 && ( ( contains_buy
						&& ext_string_equals ( check_symbol.profit(), profit(), false ) )
					  || ( contains_sell
						   && ext_string_equals ( check_symbol.profit(), base(), false ) ) ) )
			   || ( !need_buy_direction
					&& ( ( contains_sell
						   && ext_string_equals ( check_symbol.profit(), profit(), false ) )
						 || ( contains_buy
							  && ext_string_equals ( check_symbol.profit(), base(), false ) ) ) );
	}

	void set_contains_direction ( bool is_buy_direction ) {
		if ( is_buy_direction ) {
			contains_buy = true;
		} else {
			contains_sell = true;
		}
	}

	void reset_direction() {
		contains_buy = false;
		contains_sell = false;
	}

	static order_symbol *create ( string symbol ) {
		order_symbol *result = new order_symbol();
		result.full = symbol;
		return result;
	}
};

#endif