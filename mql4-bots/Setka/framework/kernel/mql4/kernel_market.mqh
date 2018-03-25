#ifndef FRAMEWORK_KERNEL_MARKET_MQH
#define FRAMEWORK_KERNEL_MARKET_MQH

class kernel_market {
public:
	static double price_buy ( string symbol ) {
		return MarketInfo ( symbol, MODE_ASK );
	}

	static double price_sell ( string symbol ) {
		return MarketInfo ( symbol, MODE_BID );
	}

	static double price_day_min ( string symbol ) {
		return MarketInfo ( symbol, MODE_LOW );
	}

	static double price_day_min ( ) {
		return price_day_min ( CURRENT_SYMBOL );
	}

	static double price_day_max ( string symbol ) {
		return MarketInfo ( symbol, MODE_HIGH );
	}

	static double price_day_max ( ) {
		return price_day_max ( CURRENT_SYMBOL );
	}

	static double tick_value ( string symbol ) {
		return MarketInfo ( symbol, MODE_TICKVALUE );
	}

	static double tick_value () {
		return tick_value ( CURRENT_SYMBOL );
	}

	static double tick_size ( string symbol ) {
		return MarketInfo ( symbol, MODE_TICKSIZE );
	}

	static double tick_size () {
		return tick_size ( CURRENT_SYMBOL );
	}

	static datetime tick_last_time ( string symbol ) {
		return ( datetime ) MarketInfo ( symbol, MODE_TIME );
	}

	static datetime tick_last_time () {
		return tick_last_time ( CURRENT_SYMBOL );
	}

	static double lot_min ( string symbol ) {
		return MarketInfo ( symbol, MODE_MINLOT );
	}

	static double lot_min () {
		return lot_min ( CURRENT_SYMBOL );
	}

	static double lot_size ( string symbol ) {
		return MarketInfo ( symbol, MODE_LOTSIZE );
	}

	static double lot_size () {
		return lot_size ( CURRENT_SYMBOL );
	}

	static double lot_step ( string symbol ) {
		return MarketInfo ( symbol, MODE_LOTSTEP );
	}

	static double lot_step () {
		return lot_step ( CURRENT_SYMBOL );
	}

	static double lot_max ( string symbol ) {
		return MarketInfo ( symbol, MODE_MAXLOT );
	}

	static double lot_max () {
		return lot_max ( CURRENT_SYMBOL );
	}

	static enum_swap_type swap_type ( string symbol ) {
		return ( enum_swap_type ) MarketInfo ( symbol, MODE_SWAPTYPE );
	}

	static enum_swap_type swap_type () {
		return swap_type ( CURRENT_SYMBOL );
	}

	static double swap_long ( string symbol ) {
		return MarketInfo ( symbol, MODE_SWAPLONG );
	}

	static double swap_long ( ) {
		return swap_long ( CURRENT_SYMBOL );
	}

	static double swap_short ( string symbol ) {
		return MarketInfo ( symbol, MODE_SWAPSHORT );
	}

	static double swap_short ( ) {
		return swap_short ( CURRENT_SYMBOL );
	}

	static enum_margin_calc_type margin_calc_type ( string symbol ) {
		return ( enum_margin_calc_type ) MarketInfo ( symbol, MODE_MARGINCALCMODE );
	}

	static enum_margin_calc_type margin_calc_type () {
		return margin_calc_type ( CURRENT_SYMBOL );
	}

	static double margin_required ( string symbol ) {
		return MarketInfo ( symbol, MODE_MARGINREQUIRED );
	}

	static double margin_required ( ) {
		return margin_required ( CURRENT_SYMBOL );
	}

	static double margin_hedged ( string symbol ) {
		return MarketInfo ( symbol, MODE_MARGINHEDGED );
	}

	static double margin_hedged (  ) {
		return margin_hedged ( CURRENT_SYMBOL );
	}

	static double margin_maintenance ( string symbol ) {
		return MarketInfo ( symbol, MODE_MARGINMAINTENANCE );
	}

	static double margin_maintenance () {
		return margin_maintenance ( CURRENT_SYMBOL );
	}

	static double margin_init ( string symbol ) {
		return MarketInfo ( symbol, MODE_MARGININIT );
	}

	static double margin_init () {
		return margin_init ( CURRENT_SYMBOL );
	}

	static double point ( string symbol ) {
		return MarketInfo ( symbol, MODE_POINT );
	}

	static double point () {
		return point ( CURRENT_SYMBOL );
	}

	static datetime starting ( string symbol ) {
		return ( datetime ) MarketInfo ( symbol, MODE_STARTING );
	}

	static datetime starting ( ) {
		return ( datetime ) starting ( CURRENT_SYMBOL );
	}

	static datetime expiration ( string symbol ) {
		return ( datetime ) MarketInfo ( symbol, MODE_EXPIRATION );
	}

	static datetime expiration () {
		return ( datetime ) expiration ( CURRENT_SYMBOL );
	}

	static bool trade_allowed ( string symbol ) {
		return MarketInfo ( symbol, MODE_TRADEALLOWED );
	}

	static bool trade_allowed () {
		return trade_allowed ( CURRENT_SYMBOL );
	}

	static double stop_level ( string symbol ) {
		return MarketInfo ( symbol, MODE_STOPLEVEL );
	}

	static double stop_level () {
		return stop_level ( CURRENT_SYMBOL );
	}

	static double freeze_level ( string symbol ) {
		return MarketInfo ( symbol, MODE_FREEZELEVEL );
	}

	static double freeze_level () {
		return freeze_level ( CURRENT_SYMBOL );
	}

	static int spread ( string symbol ) {
		return ( int ) MarketInfo ( symbol, MODE_SPREAD );
	}

	static int spread () {
		return spread ( CURRENT_SYMBOL );
	}

	static int digits ( string symbol ) {
		return ( int ) MarketInfo ( symbol, MODE_DIGITS );
	}

	static int digits () {
		return ( int ) digits ( CURRENT_SYMBOL );
	}

	static enum_profit_calc_type profit_calc_type ( string symbol ) {
		return ( enum_profit_calc_type ) MarketInfo ( symbol, MODE_PROFITCALCMODE );
	}

	static enum_profit_calc_type profit_calc_type () {
		return profit_calc_type ( CURRENT_SYMBOL );
	}
};

#endif