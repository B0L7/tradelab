#ifndef GAP_CALC_MQH
#define GAP_CALC_MQH

#include "../setting.mqh"

class calc_gap {
public:
	static bool is_gap ( setting_t *settings,
						 double distance,
						 double step_p ) {
		return settings.gap_min_pips != 0 ?
			   distance - step_p >= layer_market::to_points ( settings.gap_min_pips ) :
			   distance - step_p >= ( ( step_p / 100.0f ) * settings.gap_min_percent );
	}

	static bool is_gap ( setting_t *settings,
						 enum_order_operation_type order_type,
						 double last_price,
						 double price,
						 double step_p ) {
		return is_gap ( settings, tool_order::get_distance ( order_type, price, last_price ), step_p );
	}
};

#endif