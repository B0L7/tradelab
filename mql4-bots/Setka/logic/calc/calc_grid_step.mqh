#ifndef GRID_STEP_CALC_MQH
#define GRID_STEP_CALC_MQH

#include "../setting.mqh"

class calc_grid_step {
private:
	static bool is_lvl1 ( setting_t *settings, int order_count ) {
		return settings.grid_level != 0
			   && order_count >= settings.grid_level;
	}

	static bool is_lvl2 ( setting_t *settings, int order_count ) {
		return settings.grid_level2 != 0
			   && is_lvl1 ( settings, order_count )
			   && order_count >= settings.grid_level2;
	}

	static bool is_lvl3 ( setting_t *settings, int order_count ) {
		return settings.grid_level3 != 0
			   && is_lvl2 ( settings, order_count )
			   && order_count >= settings.grid_level3;
	}

public:
	static int get ( setting_t *settings, int lvl ) {
		int result = settings.grid_step;

		if ( settings.grid_stop != 0 && settings.grid_stop < lvl ) {
			lvl = settings.grid_stop;
		}

		// Очень важен порядок проверки условий он сокращается кол-во условий
		if ( is_lvl3 ( settings, lvl ) ) {
			result = get ( settings, lvl - ( lvl - settings.grid_level3 + 1 )  );

			int count =  lvl + 1 - settings.grid_level3;

			for ( int i = 0; i < count; i++ ) {
				result += settings.grid_level3_add_pips;
			}
		} else if ( is_lvl2 ( settings, lvl ) ) {
			result = get ( settings, lvl - ( lvl - settings.grid_level2 + 1 )  );

			int count =  lvl + 1 - settings.grid_level2;

			for ( int i = 0; i < count; i++ ) {
				result += settings.grid_level2_add_pips;
			}
		} else if ( is_lvl1 ( settings, lvl ) ) {
			result = settings.grid_step + ( settings.grid_value * ( lvl + 1 - settings.grid_level ) );
		}

		return result;
	}
};

#endif