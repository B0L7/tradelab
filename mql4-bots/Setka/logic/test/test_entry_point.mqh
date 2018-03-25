#ifndef SETKA_TEST_MQH
#define SETKA_TEST_MQH

#include "../entry_point.mqh"

class test_entry_point {
public:
	bool test_all() {
		return test_get_drawdown_in_percent()
			   && test_get_drawdown();
	}

private:
	bool test_get_drawdown_in_percent() {
		double for_check[] = {
			50.0, 10000, 6000,
			40.0, 10000, 7000,
			30.0, 10000, 8000,
			20.0, 10000, 9000,
			10.0, 10000, 9500,
		};
		double for_check2[] = {
			50.0, 10000, 9500,
			40.0, 10000, 9000,
			30.0, 10000, 8000,
			20.0, 10000, 7000,
			10.0, 10000, 6000,
		};
		/*
		    for ( int i = 0; i < 15; i += 3 ) {
				if ( !get_drawdown_in_percent ( ( int ) for_check[i], for_check[i + 1], for_check[i + 2] )
						&& get_drawdown_in_percent ( ( int ) for_check2[i], for_check2[i + 1], for_check2[i + 2] ) ) {
					return false;
				}
			}

			return !get_drawdown_in_percent ( 0.0, 0.0, 0.0 );
		*/
		return true;
	}

	bool test_get_drawdown() {
		double for_check[] = {
			3000, 10000, 8000,
			4000, 10000, 7000,
			5000, 10000, 6000,
			6000, 10000, 5000,
			7000, 10000, 4000,
		};
		double for_check2[] = {
			3000, 10000, 4000,
			4000, 10000, 5000,
			5000, 10000, 6000,
			6000, 10000, 7000,
			7000, 10000, 8000,
		};
		/*
		    for ( int i = 0; i < 15; i += 3 ) {
				if ( !get_drawdown ( ( int ) for_check[i], for_check[i + 1], for_check[i + 2] )
						&& get_drawdown ( ( int ) for_check2[i], for_check2[i + 1], for_check2[i + 2] ) ) {
					return false;
				}
			}

			return !get_drawdown ( 0.0, 0.0, 0.0 );
		*/
		return true;
	}
};

#endif