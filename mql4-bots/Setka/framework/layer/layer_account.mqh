#ifndef FRAMEWORK_LAYER_ACCOUNT_MQH
#define FRAMEWORK_LAYER_ACCOUNT_MQH

class layer_account {
public:
	static string currency() {
		TOOL_CACHED ( string,
					  _currency,
					  _currency = kernel_account::currency() );
	}

	static bool is_trade_allowed() {
		TOOL_CACHED_TICK ( bool,
						   _is_trade_allowed,
						   _is_trade_allowed = kernel_account::is_trade_allowed() );
	}

	static bool is_testing() {
		TOOL_CACHED ( bool,
					  _is_testing,
					  _is_testing = kernel_account::is_testing() );
	}

	static bool is_optimization() {
		TOOL_CACHED ( bool,
					  _is_optimization,
					  _is_optimization = kernel_account::is_optimization() );
	}

	static int digits() {
		TOOL_CACHED ( int,
					  _digits,
					  _digits = kernel_account::digits() );
	}

	static int bit_multiplier() {
		TOOL_CACHED ( int,
					  _bit_multiplier,
					  _bit_multiplier = layer_account::digits() == 3 || layer_account::digits() == 5  ? 10 : 1 );
	}

	static double profit_clear_currency() {
		TOOL_CACHED_TICK ( double,
		_profit_currency, {
			_profit_currency = 0.0;

			list<layer_order_data *> *directions = layer_order::get_all();
			LIST_FOREACH ( directions, layer_order_data *, item, {
				_profit_currency += item.profit_clear_currency();
			} );
		} );
	}

	static double profit_clear_percent() {
		TOOL_CACHED_TICK ( double,
		_profit_percent, {
			_profit_percent = profit_clear_currency() / ( kernel_account::balance() / 100.0 ) ;
		} );
	}

	static double drawdown_currency() {
		return profit_clear_currency() * -1;
	}

	static double drawdown_percent() {
		return profit_clear_percent() * -1;
	}
};

#endif