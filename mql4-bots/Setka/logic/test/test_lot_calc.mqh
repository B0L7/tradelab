#ifndef LOT_CALC_TEST_MQH
#define LOT_CALC_TEST_MQH

class test_lot_calc {
public:
	static bool test_all() {
		return test_calc_lot_by_balance()
			   && test_calc_lot_by_last_order()
			   && test_calc_lot_by_min_order()
			   && test_mult_stop()
			   && test_max_lot();
	}

private:
	static bool test_calc_lot_by_balance() {
		double for_check[] = {
			1000, 3, 1000, 0.01, 0.010,
			1050, 3, 1000, 0.01, 0.010,
			1100, 3, 1000, 0.01, 0.011,
			1150, 3, 1000, 0.01, 0.011,
			1200, 3, 1000, 0.01, 0.012,
			1250, 3, 1000, 0.01, 0.012,
			1300, 3, 1000, 0.01, 0.013,
			1350, 3, 1000, 0.01, 0.013,
			1400, 3, 1000, 0.01, 0.014,
			1450, 3, 1000, 0.01, 0.014,
			1500, 3, 1000, 0.01, 0.015,
			1550, 3, 1000, 0.01, 0.015,
			1600, 3, 1000, 0.01, 0.016,
			1650, 3, 1000, 0.01, 0.016,
			1700, 3, 1000, 0.01, 0.017,
			1750, 3, 1000, 0.01, 0.017,
			1850, 3, 1000, 0.01, 0.018,
			1900, 3, 1000, 0.01, 0.019,
			1950, 3, 1000, 0.01, 0.019,
			2000, 3, 1000, 0.01, 0.020
		};

		int columns = 5;
		int rows = 20;
		int count = rows * columns;

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;

		bool result = true;

		for ( int i = 0; i < count; ) {
			test_settings.testing_balance = for_check[ i++ ];
			test_settings.lot_exp = ( int ) for_check[ i++ ];
			test_settings.currency_for_min_lot = ( int ) for_check[ i++ ];
			test_settings.lots = for_check[ i++ ];

			double check_lot = for_check[ i++ ];
			double result_lot = calc_lot::get ( test_settings,  NULL, 1, no_gap, 0.00000f );

			if ( check_lot != result_lot ) {
				result = false;
				break;
			}
		}

		delete test_settings;
		return result;
	}

	static bool test_calc_lot_by_last_order() {
		double for_check[] = {
			0.01f,
			0.02f,
			0.02f,
			0.04f,
			0.07f,
			0.14f,
			0.28f,
			0.59f,
			1.29f,
			2.97f
		};

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;
		test_settings.testing_balance = 1000;
		test_settings.mult_type = calc_lot_type_last_order;
		test_settings.lot_exp = 2;
		test_settings.currency_for_min_lot = 1000;
		test_settings.lots = 0.01f;
		test_settings.multi_lots_level1 = 2;
		test_settings.multi_lots_factor = 1.5f;
		test_settings.multi_lots_level2 = 3;
		test_settings.multi_lots_level2_corr = 0.1f;

		bool result = true;
		int count = ArraySize ( for_check );

		for ( int i = 0; i < count; i++ ) {
			double check_lot = NormalizeDouble ( for_check[ i ], test_settings.lot_exp );
			double result_lot = NormalizeDouble ( calc_lot::get ( test_settings,  NULL, i + 1, no_gap, 0.00000f ), test_settings.lot_exp );

			if ( check_lot != result_lot ) {
				result = false;
				break;
			}
		}

		delete test_settings;
		return result;
	}

	static bool test_calc_lot_by_min_order() {
		double for_check[] = {
			0.0100f,
			0.0150f,
			0.0160f,
			0.0170f,
			0.0180f,
			0.0190f,
			0.0200f,
			0.0210f,
			0.0220f,
			0.0230f
		};

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;
		test_settings.testing_balance = 1000;
		test_settings.mult_type = calc_lot_type_min_order;
		test_settings.lot_exp = 2;
		test_settings.currency_for_min_lot = 1000;
		test_settings.lots = 0.01f;
		test_settings.multi_lots_level1 = 2;
		test_settings.multi_lots_factor = 1.5f;
		test_settings.multi_lots_level2 = 3;
		test_settings.multi_lots_level2_corr = 0.1f;

		bool result = true;
		int count = ArraySize ( for_check );

		for ( int i = 0; i < count; i++ ) {
			double check_lot = NormalizeDouble ( for_check[ i ], test_settings.lot_exp );
			double result_lot = NormalizeDouble ( calc_lot::get ( test_settings,  NULL, i + 1, no_gap, 0.00000f ), test_settings.lot_exp );

			if ( check_lot != result_lot ) {
				result = false;
				break;
			}
		}

		delete test_settings;
		return result;
	}

	static bool test_mult_stop() {
		double for_check[] = {
			0.0100f,
			0.0150f,
			0.0240f,
			0.0408f,
			0.0694f,
			0.1179f,
			0.2005f,
			0.3408f,
			0.5793f,
			0.9848f
		};

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;
		test_settings.testing_balance = 1000;
		test_settings.mult_type = calc_lot_type_last_order;
		test_settings.lot_exp = 4;
		test_settings.currency_for_min_lot = 1000;
		test_settings.lots = 0.01f;
		test_settings.multi_lots_level1 = 2;
		test_settings.multi_lots_factor = 1.5f;
		test_settings.multi_lots_level2 = 3;
		test_settings.multi_lots_level2_corr = 0.1f;
		test_settings.mult_stop = 4;

		int count = ArraySize ( for_check );

		for ( int i = 0; i < count; i++ ) {
			double check_lot = NormalizeDouble ( for_check[ i ], test_settings.lot_exp );
			double result_lot = NormalizeDouble ( calc_lot::get ( test_settings,  NULL, i + 1, no_gap, 0.00000f ), test_settings.lot_exp );

			if ( check_lot != result_lot ) {
				delete test_settings;
				return false;
			}
		}

		delete test_settings;
		return true;
	}

	static bool test_max_lot() {
		double for_check[] = {
			0.0100f,
			0.0150f,
			0.0200f,
			0.0200f,
			0.0200f,
			0.0200f,
			0.0200f,
			0.0200f,
			0.0200f,
			0.0200f
		};

		setting_t *test_settings = new setting_t();
		test_settings.is_testing = true;
		test_settings.testing_balance = 1000;
		test_settings.mult_type = calc_lot_type_last_order;
		test_settings.lot_exp = 4;
		test_settings.currency_for_min_lot = 1000;
		test_settings.lots = 0.01f;
		test_settings.multi_lots_level1 = 2;
		test_settings.multi_lots_factor = 1.5f;
		test_settings.multi_lots_level2 = 3;
		test_settings.multi_lots_level2_corr = 0.1f;
		test_settings.mult_stop = 4;
		test_settings.max_lot = 2;

		int count = ArraySize ( for_check );

		for ( int i = 0; i < count; i++ ) {
			double check_lot = NormalizeDouble ( for_check[ i ], test_settings.lot_exp );
			double result_lot = NormalizeDouble ( calc_lot::get ( test_settings,  NULL, i + 1, no_gap, 0.00000f ), test_settings.lot_exp );

			if ( check_lot != result_lot ) {
				delete test_settings;
				return false;
			}
		}

		delete test_settings;
		return true;
	}
};

#endif