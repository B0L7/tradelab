#ifndef LOGICS_TEST_MQH
#define LOGICS_TEST_MQH

#include "test_entry_point.mqh"
#include "test_grid_step_calc.mqh"
#include "test_handler_base.mqh"
#include "test_lot_calc.mqh"

class test {
public:
	static bool all() {
		/*
		    test_handler_base *hb_test = new test_handler_base();

		    if ( !hb_test.test_all() ) {
			return false;
		    }


		    delete hb_test;
		    test_entry_point *s_test = new test_entry_point();

		    if ( !s_test.test_all() ) {
			return false;
		    }

		    delete s_test;
		*/

		if ( !test_lot_calc::test_all() ) {
			return false;
		}

		if ( !test_grid_step_calc::test_all() ) {
			return false;
		}

		return true;
	}
};

#endif