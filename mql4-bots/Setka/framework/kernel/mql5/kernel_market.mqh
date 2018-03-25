#ifndef FRAMEWORK_KERNEL_MARKET_MQH
#define FRAMEWORK_KERNEL_MARKET_MQH

class kernel_market {
public:
	static double price_buy ( string symbol ) {
		MqlTick last_tick;
		SymbolInfoTick ( symbol, last_tick );
		return last_tick.ask;
	}

	static double price_sell ( string symbol ) {
		MqlTick last_tick;
		SymbolInfoTick ( symbol, last_tick );
		return last_tick.bid;
	}

	static double price_day_min ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_LASTLOW );
	}

	static double price_day_min ( ) {
		return price_day_min ( CURRENT_SYMBOL );
	}

	static double price_day_max ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_LASTHIGH );
	}

	static double price_day_max ( ) {
		return price_day_max ( CURRENT_SYMBOL );
	}

	static double tick_value ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_TRADE_TICK_VALUE );
	}

	static double tick_value () {
		return tick_value ( CURRENT_SYMBOL );
	}

	static double tick_size ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_TRADE_TICK_SIZE );
	}

	static double tick_size () {
		return tick_size ( CURRENT_SYMBOL );
	}

	static datetime tick_last_time ( string symbol ) {
		return SymbolInfoInteger ( symbol, SYMBOL_TIME );
	}

	static datetime tick_last_time () {
		return tick_last_time ( CURRENT_SYMBOL );
	}

	static double lot_min ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_VOLUME_MIN );
	}

	static double lot_min () {
		return lot_min ( CURRENT_SYMBOL );
	}

	static double lot_size ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_TRADE_CONTRACT_SIZE );
	}

	static double lot_size () {
		return lot_size ( CURRENT_SYMBOL );
	}

	static double lot_step ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_VOLUME_STEP );
	}

	static double lot_step () {
		return lot_size ( CURRENT_SYMBOL );
	}

	static double lot_max ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_VOLUME_MAX );
	}

	static double lot_max () {
		return lot_max ( CURRENT_SYMBOL );
	}

	static enum_swap_type swap_type ( string symbol ) {
		return ( enum_swap_type ) SymbolInfoInteger ( symbol, SYMBOL_SWAP_MODE );
	}

	static enum_swap_type swap_type () {
		return swap_type ( CURRENT_SYMBOL );
	}

	static double swap_long ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_SWAP_LONG );
	}

	static double swap_long ( ) {
		return swap_long ( CURRENT_SYMBOL );
	}

	static double swap_short ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_SWAP_SHORT );
	}

	static double swap_short ( ) {
		return swap_short ( CURRENT_SYMBOL );
	}

	static enum_margin_calc_type margin_calc_type ( string symbol ) {
		return margin_calc_type_forex;
	}

	static enum_margin_calc_type margin_calc_type () {
		return margin_calc_type_forex;
	}

	static double margin_required ( string symbol ) {
		double result = -255;
		double request_result = OrderCalcMargin ( ORDER_TYPE_BUY,
								symbol,
								1.0,
								price_buy ( symbol ),
								result );

		if ( !request_result ) {
			Print ( StringFormat ( "%d", layer_error::get_last() ) );
		}

		return result;
	}

	static double margin_required ( ) {
		return 0.0;
	}

	static double margin_hedged ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_MARGIN_HEDGED );
	}

	static double margin_hedged (  ) {
		return SymbolInfoDouble ( CURRENT_SYMBOL, SYMBOL_MARGIN_HEDGED );
	}

	static double margin_maintenance ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_MARGIN_MAINTENANCE );
	}

	static double margin_maintenance () {
		return SymbolInfoDouble ( CURRENT_SYMBOL, SYMBOL_MARGIN_MAINTENANCE );
	}

	static double margin_init ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_MARGIN_INITIAL );
	}

	static double margin_init () {
		return SymbolInfoDouble ( CURRENT_SYMBOL, SYMBOL_MARGIN_INITIAL );
	}

	static double point ( string symbol ) {
		return SymbolInfoDouble ( symbol, SYMBOL_POINT );
	}

	static double point () {
		return point ( CURRENT_SYMBOL );
	}

	static datetime starting ( string symbol ) {
		return 0;
	}

	static datetime starting ( ) {
		return 0;
	}

	static datetime expiration ( string symbol ) {
		return 0;
	}

	static datetime expiration () {
		return 0;
	}

	static bool trade_allowed ( string symbol ) {
		return false;
	}

	static bool trade_allowed () {
		return false;
	}

	static double stop_level ( string symbol ) {
		return SymbolInfoInteger ( symbol, SYMBOL_TRADE_STOPS_LEVEL );
	}

	static double stop_level () {
		return stop_level ( CURRENT_SYMBOL );
	}

	static double freeze_level ( string symbol ) {
		return SymbolInfoInteger ( symbol, SYMBOL_TRADE_FREEZE_LEVEL );
	}

	static double freeze_level () {
		return freeze_level ( CURRENT_SYMBOL );
	}

	static int spread ( string symbol ) {
		return SymbolInfoInteger ( symbol, SYMBOL_SPREAD );
	}

	static int spread () {
		return spread ( CURRENT_SYMBOL );
	}

	static int digits ( string symbol ) {
		return SymbolInfoInteger ( symbol, SYMBOL_DIGITS );
	}

	static int digits () {
		return digits ( CURRENT_SYMBOL );
	}

	static enum_profit_calc_type profit_calc_type ( string symbol ) {
		return ( enum_profit_calc_type ) SymbolInfoInteger ( symbol, SYMBOL_TRADE_CALC_MODE );
	}

	static enum_profit_calc_type profit_calc_type () {
		return profit_calc_type ( CURRENT_SYMBOL );
	}
};

#endif