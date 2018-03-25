#ifndef FRAMEWORK_LAYER_MQH
#define FRAMEWORK_LAYER_MQH

#include "layer_error.mqh"
#include "layer_symbol.mqh"
#include "layer_market.mqh"
#include "layer_account.mqh"
#include "layer_order/layer_order.mqh"

class layer {
public:
	static int account_leverage() {
		TOOL_CACHED_TICK ( int,
		_leverage, {
			double leverage_by_current_symbol = layer_market::tick_value ()
			* layer_market::price_buy()
			/ layer_market::margin_required ()
			/ layer_market::point();
			int casted_leverage = ( int ) MathFloor ( leverage_by_current_symbol );
			_leverage =  casted_leverage != 0 ? casted_leverage : kernel_account::leverage();
		} );
	}

	static datetime time_current() {
		TOOL_CACHED_TICK ( datetime,
						   _time_current,
						   _time_current = TimeCurrent() );
	}

	static double correct_price ( double value ) {
		return NormalizeDouble ( value, layer_account::digits() );
	}
};

#endif