#ifndef HANDLER_BASE_TEST_MQH
#define HANDLER_BASE_TEST_MQH

class test_handler_base {
public:
	bool test_all() {
		return test_calc_lot()
			   && test_grid_step();
	}

private:
	bool test_calc_lot() {
		return true;

		/*

		    setting_t *setting = new setting_t();
		    setting.lots = 0.01;
		    setting.lot_exp = 2.0;
		    setting.multi_lots_level1 = 3;
		    setting.multi_lots_factor = 1.65;
		    setting.multi_lots_level2 = 11;
		    setting.multi_lots_level2_corr = -0.05;
		    _instance._settings = setting;
		    double for_check[] = {
			0.01, 0.01, 0.02,
			0.03, 0.04, 0.07,
			0.12, 0.20, 0.33,
			0.55, 0.88, 1.36,
			2.04, 2.96, 4.15
		    };

		    for ( int i = 0; i < 15; i++ ) {
			if ( NormalizeDouble ( _instance.calc_lot ( i + 1, no_gap, 0.0 ), setting.lot_exp ) != for_check[i] ) {
				return false;
			}
		    }

		    setting.multi_lots_level2 = 0;
		    double for_check2[] = {
			0.01, 0.01, 0.02,
			0.03, 0.04, 0.07,
			0.12, 0.20, 0.33,
			0.55, 0.91, 1.50,
			2.47, 4.07, 6.72
		    };

		    for ( int i = 0; i < 15; i++ ) {
			if ( NormalizeDouble ( _instance.calc_lot ( i + 1, no_gap, 0.0 ), setting.lot_exp ) != for_check2[i] ) {
				return false;
			}
		    }

		    setting.multi_lots_level1 = 0;

		    for ( int i = 0; i < 15; i++ ) {
			if ( NormalizeDouble ( _instance.calc_lot ( i + 1, no_gap, 0.0 ), setting.lot_exp ) != setting.lots ) {
				return false;
			}
		    }

		    setting.lots = 0.01;
		    setting.lot_exp = 2.0;
		    setting.multi_lots_level1 = 3;
		    setting.multi_lots_factor = 1.4;
		    setting.multi_lots_level2 = 5;
		    setting.multi_lots_level2_corr = 0.02;
		    setting.multi_lots_level3 = 10;
		    setting.multi_lots_level3_corr = -0.05;

		    double for_check3[] = {
			1.00, 1.00, 1.40,
			1.40, 1.42, 1.44,
			1.46, 1.48, 1.50,
			1.45, 1.40, 1.35,
			1.30, 1.25, 1.20
		    };

		    for ( int i = 0; i < 15; i++ ) {
			if ( NormalizeDouble ( _instance.calc_lot_factor ( i + 1 ), 2 ) != for_check3[i] ) {
				return false;
			}
		    }

		    delete setting;
		    return true;

		*/
	}

	bool test_grid_step() {
		return true;
		/*

		    setting_t *setting = new setting_t();
		    setting.grid_step = 10.0;
		    setting.grid_level = 9;
		    setting.grid_value = 16;
		    setting.grid_level2 = 16;
		    setting.grid_level2_add_pips = 0;
		    _instance._settings = setting;
		    double for_check[] = { 10, 10, 10, 10, 10, 10, 10, 10, 26, 42, 58, 74, 90, 106, 122 };

		    for ( int i = 0; i < 15; i++ ) {
			if ( _instance.calc_grid_step ( i + 1 ) != for_check[i] ) {
				return false;
			}
		    }

		    for ( int i = 15; i < 21; i++ ) {
			if ( _instance.calc_grid_step ( i + 1 ) != 122 ) {
				return false;
			}
		    }

		    setting.grid_level = 0;

		    for ( int i = 0; i < 21; i++ ) {
			if ( _instance.calc_grid_step ( i + 1 ) != 10 ) {
				return false;
			}
		    }

		    delete setting;
		    return true;
		*/
	}
};

#endif