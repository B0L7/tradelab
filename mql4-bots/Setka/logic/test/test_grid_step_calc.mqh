#ifndef TEST_GRID_STEP_CALC_MQH
#define TEST_GRID_STEP_CALC_MQH

class test_grid_step_calc {
public:
	static bool test_all() {
		return test_grid_stop();
	}

private:
	static bool test_grid_stop() {
		int for_check[] = {
			0, //1
			19, //2
			19, //3
			19, //4
			22, //5
			25, //6
			29, //7
			33, //8
			38, //9
			43, //10
			48, //11
			48  //12
		};

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;
		test_settings.testing_balance = 1000;

		test_settings.grid_step = 19;

		test_settings.grid_level = 5;
		test_settings.grid_value = 3;

		test_settings.grid_level2 = 7;
		test_settings.grid_level2_add_pips = 4;

		test_settings.grid_level3 = 9;
		test_settings.grid_level3_add_pips = 5;

		test_settings.grid_stop = 11;

		int count = ArraySize ( for_check );

		for ( int i = 1; i < count; i++ ) {
			int check = for_check[ i ];
			int result = calc_grid_step::get ( test_settings, i + 1 );

			if ( check != result ) {
				delete test_settings;
				return false;
			}
		}

		delete test_settings;
		return true;
	}
};

#endif