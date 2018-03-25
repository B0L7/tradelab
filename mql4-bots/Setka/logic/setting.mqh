#ifndef SETTING_MQH
#define SETTING_MQH

#include "enum/enum.mqh"
#include "scheduler.mqh"

class setting_t : public disposable_obj  {
public:
	bool is_testing;
	double testing_balance;
	double testing_layer_market_lot_min;

	int magic_number;
	int max_spread;

	bool close_all_orders;
	bool open_positions;
	bool open_first_order;
	int max_open_orders;

	int pause_on_close_in_sec;


	enum_position_signal position_signal;

	ENUM_TIMEFRAMES time_frame;
	int candles_for_open_first_order;
	bool candles_for_open_first_order_open_close;
	int candles_for_open_first_order_min_pips;
	int candles_for_open_first_order_max_pips;
	bool revers_signal_to_open_first_order;

	enum_take_profit_calc_type tp_type;
	int take_proffit;
	int take_proffit_level1;
	int take_proffit_level1_corr;
	int take_proffit_level2;
	int take_proffit_level2_corr;
	int take_proffit_level3;
	int take_proffit_level3_fix_pips;
	int take_profit_control_timing;
	int take_profit_control_noloss_fixpips;
	int max_spread_stop_drading_timing;

	int grid_step;
	int grid_level;
	int grid_value;
	int grid_level2;
	int grid_level2_add_pips;
	int grid_level3;
	int grid_level3_add_pips;
	int grid_stop;

	enum_calc_lot_type mult_type;
	int currency_for_min_lot;
	double lots;
	int lot_exp;
	int multi_lots_level1;
	double multi_lots_factor;
	int multi_lots_level2;
	double multi_lots_level2_corr;
	int multi_lots_level3;
	double multi_lots_level3_corr;
	int mult4;
	double mult4_add;

	int mult_stop;
	double max_lot;

	enum_gap_control_type gap_control;
	int gap_max_order_stop;
	int gap_min_pips_from_market;
	int gap_min_pips;
	int gap_min_percent;
	double gap_lot_koef;
	double gap_last_order_koef;

	ENUM_TIMEFRAMES vol_candle_tf;
	int vol_candle_max_size;
	int vol_stop_trade_timing;

	day_of_week_t trade_start_day;
	int trade_start_minute;
	day_of_week_t trade_end_day;
	int trade_stop_minute;

	datetime final_stop_trading;
	int max_trade_pairs;
	int currency_block;
	int no1Order_by_drawdown_percent;
	int no1Order_by_drawdown_percent_off;
	bool close_all_orders_by_drawdown_stop_trade;
	string add_comment;
	int min_leverage;
	int min_time_step;

	string currency_block_label;
	string max_trade_pairs_label;
};

#endif