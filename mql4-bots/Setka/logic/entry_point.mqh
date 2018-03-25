#ifndef SETKA_MQH
#define SETKA_MQH

#include "enum/enum.mqh"
#include "defines.mqh"
#include "logic_handler.mqh"
#include "api.mqh"

#property version VER

logic_handler *short_hd;
logic_handler *long_hd;
timer_t *life_timer;
bool _init_failed = false;

#ifndef FOR_OPTIMIZATION

#include "test/test.mqh"

void show_market_info()
{
	log_info ( StringFormat ( SRC_SETKA_MODE_LOW, dtos ( kernel_market::price_day_min (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_HIGH, dtos ( kernel_market::price_day_max (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_TIME, TimeToString ( kernel_market::tick_last_time (  ), TIME_DATE | TIME_MINUTES | TIME_SECONDS ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_BID, dtos ( layer_market::price_buy (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_ASK, dtos ( layer_market::price_sell (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_POINT, dtos ( layer_market::point (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_DIGITS, itos ( kernel_market::digits (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_SPREAD, itos ( layer_market::spread (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_STOPLEVEL, dtos ( layer_market::stop_level (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_LOTSIZE, dtos ( layer_market::lot_size ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_TICKVALUE, dtos ( layer_market::tick_value ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_TICKSIZE, dtos ( layer_market::tick_size ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_SWAPLONG, dtos ( kernel_market::swap_long ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_SWAPSHORT, dtos ( kernel_market::swap_short ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_STARTING, TimeToString ( kernel_market::starting ( ), TIME_DATE | TIME_MINUTES | TIME_SECONDS ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_EXPIRATION, TimeToString ( kernel_market::expiration ( ), TIME_DATE | TIME_MINUTES | TIME_SECONDS ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_TRADEALLOWED, kernel_market::trade_allowed ( ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MINLOT, dtos ( layer_market::lot_min ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_LOTSTEP, dtos ( layer_market::lot_step ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MAXLOT, dtos ( kernel_market::lot_max ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_SWAPTYPE, EnumToString ( kernel_market::swap_type ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_PROFITCALCMODE, EnumToString ( kernel_market::profit_calc_type ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MARGINCALCMODE, EnumToString ( kernel_market::margin_calc_type ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MARGININIT, dtos ( kernel_market::margin_init ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MARGINMAINTENANCE, dtos ( kernel_market::margin_maintenance ( ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MARGINHEDGED, dtos ( kernel_market::margin_hedged (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_MARGINREQUIRED, dtos ( layer_market::margin_required (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_MODE_FREEZELEVEL, dtos ( kernel_market::freeze_level (  ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_TERMINAL_VERSION_MSG, itos ( TerminalInfoInteger ( TERMINAL_BUILD ) ) ) );
	log_info ( StringFormat ( SRC_SETKA_VERSION_MSG, VER, BUILD, TimeToString ( __DATETIME__, TIME_DATE | TIME_MINUTES | TIME_SECONDS ) ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_COMPANY, kernel_account::company() ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_CURRENCY, layer_account::currency() ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_LEVERAGE, itos ( layer::account_leverage() ) ) );
	log_info ( ext_string::get_sha256 ( itos ( kernel_account::number() ) ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_SERVER, kernel_account::server() ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_STOPOUT, itos ( kernel_account::stopout_level() ) ) );
	log_info ( StringFormat ( SRC_SETKA_ACCOUNT_STOPOUT_MODE, itos ( kernel_account::stopout_mode() ) ) );
}

int OnInit()
{
	_init_failed = false;

	tool_cache::update_instance_state();

	if ( layer_account::is_optimization() ) {
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	gc::init();

	if ( !layer_account::is_testing() ) {
		life_timer = timer_t::create ( 60 );
		gc::push ( gc_dispose_type_on_end_deinit, life_timer );

		update_time_on_chart();
	}

	show_market_info();

	double lot_step = layer_market::lot_step ();
	int lot_exp = get_lot_exp_by_minlot ( lot_step );
	log_info (  StringFormat ( SRC_SETKA_COUNT_SYMBOL_FOR_AVG, ( int ) lot_exp ) );

	if ( lot_exp == -1 ) {
		log_error ( StringFormat ( SRC_SETKA_NOT_GOOD_LOTSTEP, lot_step ) );
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	if ( !defines_validate() ) {
		log_error ( SRC_SETKA_VALID_NOT_GOOD );
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	if ( !test::all() ) {
		log_error ( SRC_SETKA_TEST_NOT_GOOD );
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	log_info ( SRC_SETKA_TEST_GOOD );

	setting_t *short_settings = defines_create ( false, lot_exp );
	gc::push ( gc_dispose_type_on_end_deinit, short_settings );
	setting_t *long_settings = defines_create ( true, lot_exp );
	gc::push ( gc_dispose_type_on_end_deinit, long_settings );

	layer_order::init();
	short_hd = new logic_handler ( false, short_settings );
	long_hd = new logic_handler ( true, long_settings );

	int max_order_count = short_settings.max_open_orders + long_settings.max_open_orders;
	factory_order::init ( max_order_count );
	factory_order_operation::init ( max_order_count );

	if ( !layer_account::is_testing() ) {
		api::set_short_handler ( short_hd );
		api::set_long_handler ( long_hd );
		api::set_times ( GlobalParamsUpdateTiming );
		api::init();
	}

	defines_init_scheduler();

	log_info ( SRC_SETKA_INIT_COMPLETED );

	return INIT_SUCCEEDED;
}

#else

int OnInit()
{
	_init_failed = false;

	tool_cache::update_instance_state();

	if ( !layer_account::is_optimization()
			&& !layer_account::is_testing() ) {
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	gc::init();

	double lot_step = layer_market::lot_step ();
	int lot_exp = get_lot_exp_by_minlot ( lot_step );

	log_info (  StringFormat ( SRC_SETKA_COUNT_SYMBOL_FOR_AVG, ( int ) lot_exp ) );

	if ( lot_exp == -1 ) {
		log_error ( StringFormat ( SRC_SETKA_NOT_GOOD_LOTSTEP, lot_step ) );
		_init_failed = true;
		return INIT_SUCCEEDED;
	}

	if ( !defines_validate() ) {
		log_error ( SRC_SETKA_VALID_NOT_GOOD );
		_init_failed = true;
		return INIT_PARAMETERS_INCORRECT;
	}

	setting_t *short_settings = defines_create ( false, lot_exp );
	gc::push ( gc_dispose_type_on_end_deinit, short_settings );
	setting_t *long_settings = defines_create ( true, lot_exp );
	gc::push ( gc_dispose_type_on_end_deinit, long_settings );

	layer_order::init();
	short_hd = new logic_handler ( false, short_settings );
	long_hd = new logic_handler ( true, long_settings );

	int max_order_count = short_settings.max_open_orders + long_settings.max_open_orders;
	factory_order::init ( max_order_count );
	factory_order_operation::init ( max_order_count );

	defines_init_scheduler();

	return INIT_SUCCEEDED;
}

#endif

void OnDeinit ( const int reason )
{
	string reason_str = error_deinit_reason ( reason );

	if ( reason_str != NULL ) {
		log_info ( StringFormat ( SRC_SETKA_DEINIT_REASON, reason_str ) );
	}

	if ( short_hd != NULL ) {
		delete short_hd;
	}

	if ( short_hd != NULL ) {
		delete long_hd;
	}

	api::deinit();
	gc::deinit();
}

double get_recovery_factor()
{
	double dd = TesterStatistics ( STAT_EQUITY_DD );
	return dd != 0.0 ? ( TesterStatistics ( STAT_PROFIT ) / dd ) : 0;
}

double OnTester( )
{
	return get_recovery_factor();
}

void OnTick()
{
	if ( _init_failed ) {
		return;
	}

	pre_tick_handler();
	tick_handler();
	post_tick_handler();
}

void pre_tick_handler()
{
	layer_error::reset();
	tool_cache::update_tick_state();
	factory_order::reset();
	factory_order_operation::reset();

	if ( short_hd.is_strong_sleep() && long_hd.is_strong_sleep() ) {
		return;
	}

	layer_order::refresh_all();
}

void tick_handler()
{
	if ( short_hd.is_strong_sleep() && long_hd.is_strong_sleep() ) {
		return;
	}

	if ( !layer_account::is_trade_allowed() ) {
		log_info ( SRC_SETKA_TRADE_NOT_ALLOWED  );
		return;
	}

	enum_trade_mode_type trade_mode = layer_symbol::trade_mode ( CURRENT_SYMBOL );

	if ( trade_mode != trade_mode_type_full ) {
		switch ( trade_mode ) {
			case trade_mode_type_disabled:
				log_info ( SRC_SETKA_SYMBOL_TRADE_MODE_DISABLED );
				return;

			case trade_mode_type_long_only:
				log_info ( SRC_SETKA_SYMBOL_TRADE_MODE_LONGONLY );
				break;

			case trade_mode_type_short_only:
				log_info ( SRC_SETKA_SYMBOL_TRADE_MODE_SHORTONLY );
				break;

			case trade_mode_type_close_only:
				log_info ( SRC_SETKA_SYMBOL_TRADE_MODE_CLOSEONLY );
				break;
		}
	}

	double account_balance = kernel_account::balance();

	if ( account_balance == 0.00 ) {
		log_info ( SRC_SETKA_NO_MONEY  );
		return;
	}

	double account_drawdown_percent = ( 1 - ( kernel_account::equity() / account_balance ) ) * 100;

	short_hd.drawdown_changed_handler ( account_drawdown_percent );
	long_hd.drawdown_changed_handler ( account_drawdown_percent );
	short_hd.mark_block_work_by_stop_trade ( false );
	long_hd.mark_block_work_by_stop_trade ( false );

	bool is_close_by_profit_percent = is_close_orders_profit_in_percent ( layer_account::profit_clear_percent() );
	bool is_close_by_profit_currency = is_close_orders_profit_in_money ( layer_account::profit_clear_currency() );
	bool is_close_by_drawdown_percent = is_close_orders_drawdown_in_percent ( layer_account::drawdown_percent() );
	bool is_close_by_drawdown_currency = is_close_orders_drawdown_in_money ( layer_account::drawdown_currency() );

	bool is_close_by_profit = is_close_by_profit_currency
							  || is_close_by_profit_percent;
	bool is_close_by_drawdown = is_close_by_drawdown_currency
								|| is_close_by_drawdown_percent;
	bool is_need_close = is_close_by_profit
						 || is_close_by_drawdown;
	bool is_close_by_percent = is_close_by_profit_percent
							   || is_close_by_drawdown_percent;

	if (  !short_hd.is_close_module_activated()
			&& !long_hd.is_close_module_activated()
			&& short_hd.is_can_close()
			&& long_hd.is_can_close()
			&& is_need_close ) {

		if ( is_close_by_drawdown ) {
			log_alert ( StringFormat ( SRC_SETKA_DRAWDOWN_CLOSE_ALL_BY_DRAWDOWN_MSG,
									   is_close_by_percent ?
									   DoubleToString ( layer_account::drawdown_percent(), 2 ) + "%" :
									   DoubleToString ( layer_account::drawdown_currency(), 2 ),
									   is_close_by_percent ?
									   DoubleToString ( CloseAllOrders_ByDrawdownPercent, 2 ) + "%" :
									   DoubleToString ( CloseAllOrders_ByDrawdownMoney, 2 ) ) );
		} else {
			log_alert ( StringFormat ( SRC_SETKA_DRAWDOWN_CLOSE_ALL_BY_PROFIT_MSG,
									   is_close_by_percent ?
									   DoubleToString ( layer_account::profit_clear_percent(), 2 ) + "%" :
									   DoubleToString ( layer_account::profit_clear_currency(), 2 ),
									   is_close_by_percent ?
									   DoubleToString ( CloseAllOrders_ByProfitPercent, 2 ) + "%" :
									   DoubleToString ( CloseAllOrders_ByProfitMoney, 2 ) ) );
		}

		short_hd.mark_close_all_orders ( 0, true, is_close_by_drawdown );
		long_hd.mark_close_all_orders ( 0, true, is_close_by_drawdown  );

		if ( short_hd._is_block_work ) {
			log_alert ( SRC_SETKA_DRAWDOWN_CLOSE_ALL_STOP_TRADE_MSG );
		}
	} else if ( is_stop_trade_drawdown_in_percent ( layer_account::drawdown_percent() )
				|| is_stop_trade_drawdown_in_money ( layer_account::drawdown_currency() ) ) {
		log_info (  StringFormat ( SRC_SETKA_DRAWDOWN_MSG,
								   DoubleToString ( layer_account::drawdown_percent(), 0 ) + "%" ) );

		if ( short_hd.get_profit() > long_hd.get_profit() ) {
			long_hd.mark_block_work_by_stop_trade ( true );
		} else {
			short_hd.mark_block_work_by_stop_trade ( true );
		}
	}

	short_hd.tick_handler();

	if ( layer_market::is_closed() ) {
		return;
	}

	long_hd.tick_handler();
}

void post_tick_handler()
{
	if ( layer_market::is_closed() ) {
		log_info ( SRC_SETKA_MARKET_CLOSE_ERROR );
		short_hd.reset_states();
		long_hd.reset_states();
	}

	api::process();
	gc::dispose();

	if ( life_timer != NULL && life_timer.is_elapsed() ) {
		life_timer.reset();
		update_time_on_chart();
	}
}

void update_time_on_chart()
{
	Comment ( StringFormat ( SRC_SETKA_VERSION_MSG, VER, BUILD, TimeToString ( __DATETIME__, TIME_DATE | TIME_MINUTES ), TimeToString ( layer::time_current(), TIME_DATE | TIME_MINUTES ) ) );
}

bool is_close_orders_drawdown_in_percent ( double drawdown_percent )
{
	return CloseAllOrders_ByDrawdownPercent > 0
		   && drawdown_percent >= CloseAllOrders_ByDrawdownPercent;
}

bool is_close_orders_drawdown_in_money ( double drawdown_currency )
{
	return CloseAllOrders_ByDrawdownMoney > 0
		   && drawdown_currency >= CloseAllOrders_ByDrawdownMoney;
}

bool is_close_orders_profit_in_percent ( double profit_percent )
{
	return CloseAllOrders_ByProfitPercent > 0
		   && profit_percent >= CloseAllOrders_ByProfitPercent;
}

bool is_close_orders_profit_in_money ( double profit_currency )
{
	return CloseAllOrders_ByProfitMoney > 0
		   && profit_currency >= CloseAllOrders_ByProfitMoney;
}

bool _stop_trade_by_drawdown_in_percent_enabled = false;
bool is_stop_trade_drawdown_in_percent ( double drawdown_percent )
{
	if ( StopTrade_ByDrawdownPercent == 0 ) {
		return false;
	}

	if ( _stop_trade_by_drawdown_in_percent_enabled ) {
		if ( drawdown_percent >= StopTrade_ByDrawdownPercent_Off ) {
			return true;
		}

		log_alert ( StringFormat ( SRC_SETKA_STOP_DRAWDOWN_OFF,
								   DoubleToString ( drawdown_percent, 2 ) + "%",
								   DoubleToString ( StopTrade_ByDrawdownPercent_Off, 2 ) + "%" ) );
		_stop_trade_by_drawdown_in_percent_enabled = false;
		return false;
	}

	bool result = drawdown_percent >= StopTrade_ByDrawdownPercent;

	if ( result
			&& StopTrade_ByDrawdownPercent_Off != 0 ) {
		log_alert ( StringFormat ( SRC_SETKA_STOP_DRAWDOWN_ON,
								   DoubleToString ( drawdown_percent, 2 ) + "%",
								   DoubleToString ( StopTrade_ByDrawdownPercent_Off, 2 ) + "%" ) );
		_stop_trade_by_drawdown_in_percent_enabled = true;
	}

	return result;
}

bool _stop_trade_by_drawdown_in_money_enabled = false;
bool is_stop_trade_drawdown_in_money ( double drawdown_currency )
{
	if ( StopTrade_ByDrawdownMoney == 0 ) {
		return false;
	}

	if ( _stop_trade_by_drawdown_in_money_enabled ) {
		if ( drawdown_currency >= StopTrade_ByDrawdownMoney_Off ) {
			return true;
		}

		log_alert ( StringFormat ( SRC_SETKA_STOP_DRAWDOWN_OFF,
								   DoubleToString ( drawdown_currency, 2 ),
								   DoubleToString ( StopTrade_ByDrawdownMoney_Off, 2 ) ) );
		_stop_trade_by_drawdown_in_money_enabled = false;
		return false;
	}

	bool result = drawdown_currency >= StopTrade_ByDrawdownMoney;

	if ( result
			&& StopTrade_ByDrawdownMoney_Off != 0 ) {
		log_alert ( StringFormat ( SRC_SETKA_STOP_DRAWDOWN_ON,
								   DoubleToString ( drawdown_currency, 2 ),
								   DoubleToString ( StopTrade_ByDrawdownMoney_Off, 2 ) ) );
		_stop_trade_by_drawdown_in_money_enabled = true;
	}

	return result;
}

int get_lot_exp_by_minlot ( double minlot )
{
	int result = -1;

	if ( minlot >= 1.0 ) {
		return result;
	}

	do {
		result++;
	} while ( ( minlot *= 10 ) <= 1.0 );

	return result;
}

#endif