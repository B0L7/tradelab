#ifndef FRAMEWORK_LAYER_SYMBOL_MQH
#define FRAMEWORK_LAYER_SYMBOL_MQH

class layer_symbol {
public:
	static enum_trade_mode_type trade_mode ( string symbol ) {
		TOOL_CACHED_TICK_TESTING ( enum_trade_mode_type,
								   _trade_mode,
								   _trade_mode = kernel_symbol::trade_mode ( symbol ) );
	}
};

#endif