#ifndef FRAMEWORK_TOOL_CANDLE_MQH
#define FRAMEWORK_TOOL_CANDLE_MQH

enum candle_type {
	candle_type_bull,
	candle_type_bear,
	candle_type_zero
};

class tool_candle {
public:
	static candle_type get_candle_type ( double open_price, double close_price ) {
		if ( open_price < close_price ) {
			return candle_type_bull;
		} else if ( open_price > close_price ) {
			return candle_type_bear;
		}

		return candle_type_zero;
	}

	static candle_type get_candle_type ( string symbol, ENUM_TIMEFRAMES time_frame, int shift ) {
		return get_candle_type ( kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_open, shift ),
								 kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_close, shift ) );
	}

	static double get_candle_size ( double first, double second ) {
		return MathAbs ( first - second );
	}

	static double get_candle_size ( string symbol, ENUM_TIMEFRAMES time_frame, int shift ) {
		return get_candle_size ( kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_high, shift ),
								 kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_low, shift ) );
	}

	static int get_candle_size_p ( double first, double second ) {
		return layer_market::to_pips ( get_candle_size ( first, second ) );
	}

	static int get_candle_size_by_high_low_p ( string symbol, ENUM_TIMEFRAMES time_frame, int shift ) {
		return get_candle_size_p ( kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_high, shift ),
								   kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_low, shift ) );
	}

	static int get_candle_size_by_open_close_p ( string symbol, ENUM_TIMEFRAMES time_frame, int shift ) {
		return get_candle_size_p ( kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_open, shift ),
								   kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_close, shift ) );
	}

	static int get_merged_candle_size_by_high_low_p ( string symbol, ENUM_TIMEFRAMES time_frame, int first_shift, int end_shift ) {
		double low = kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_low, end_shift );
		double high = kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_high, end_shift );

		for ( int i = end_shift + 1; i <= first_shift; i++ ) {
			double low_check = kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_low, i );
			double high_check = kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_high, i );

			if ( low > low_check ) {
				low = low_check;
			}

			if ( high < high_check ) {
				high = high_check;
			}
		}

		return get_candle_size_p ( high, low );
	}

	static int get_merged_candle_size_by_open_close_p ( string symbol, ENUM_TIMEFRAMES time_frame, int first_shift, int end_shift ) {
		return get_candle_size_p ( kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_open, first_shift ),
								   kernel_quotes::get_candle_value ( symbol, time_frame, candle_value_close, end_shift ) );
	}

	static datetime get_time ( string symbol, ENUM_TIMEFRAMES time_frame, int shift ) {
		return iTime ( symbol, time_frame, shift );
	}
};

#endif