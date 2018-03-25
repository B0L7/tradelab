#ifndef FRAMEWORK_KERNEL_QUOTES_MQH
#define FRAMEWORK_KERNEL_QUOTES_MQH

class kernel_quotes {
public:
	static double get_candle_value ( string symbol,
									 ENUM_TIMEFRAMES time_frame,
									 enum_candle_value_type type,
									 int shift ) {
		switch ( type ) {
			case candle_value_low:
				return iLow ( symbol, time_frame, shift );

			case candle_value_close:
				return iClose ( symbol, time_frame, shift );

			case candle_value_open:
				return iOpen ( symbol, time_frame, shift );

			case candle_value_high:
				return iHigh ( symbol, time_frame, shift );

			default:
				return -1;
		}
	}

	static datetime get_candle_open_time ( string symbol,
										   ENUM_TIMEFRAMES time_frame,
										   int shift ) {
		return iTime ( symbol, time_frame, shift );
	}
};

#endif