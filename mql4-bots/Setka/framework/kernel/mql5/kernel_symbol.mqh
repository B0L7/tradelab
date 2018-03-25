#ifndef FRAMEWORK_KERNEL_SYMBOL_MQH
#define FRAMEWORK_KERNEL_SYMBOL_MQH

class kernel_symbol {
public:
	static enum_trade_mode_type trade_mode ( string symbol ) {
		return ( enum_trade_mode_type ) SymbolInfoInteger ( symbol, SYMBOL_TRADE_MODE );
	}

	/*
	    static trade_mode_type trade_mode() {
		return trade_mode ( CURRENT_SYMBOL );
	    }
	*/

	static string currency_base ( string symbol ) {
		return SymbolInfoString ( symbol, SYMBOL_CURRENCY_BASE );
	}

	/*
	    static string currency_base ( ){
		return SymbolInfoString ( CURRENT_SYMBOL, SYMBOL_CURRENCY_BASE );
	    }
	*/

	static string currency_profit ( string symbol ) {
		return SymbolInfoString ( symbol, SYMBOL_CURRENCY_PROFIT );
	}

	/*
	    static string currency_profit ( ){
		return SymbolInfoString ( CURRENT_SYMBOL, SYMBOL_CURRENCY_PROFIT );
	    }
	*/
};

#endif