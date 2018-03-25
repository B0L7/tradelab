#ifndef FRAMEWORK_KERNEL_QUOTES_MQH
#define FRAMEWORK_KERNEL_QUOTES_MQH

class kernel_quotes {
public:
	static double get_candle_value ( string symbol,
									 ENUM_TIMEFRAMES time_frame,
									 enum_candle_value_type type,
									 int shift ) {
		switch ( type ) {
			case candle_value_low: {
				double result[];
				return CopyLow ( symbol, TFMigrate ( time_frame ), shift, 1, result ) > 0 ? result[0] : -1;
			}

			case candle_value_close: {
				double result[];
				return CopyClose ( symbol, TFMigrate ( time_frame ), shift, 1, result ) > 0 ? result[0] : -1;
			}

			case candle_value_open: {
				double result[];
				return CopyOpen ( symbol, TFMigrate ( time_frame ), shift, 1, result ) > 0 ? result[0] : -1;
			}

			case candle_value_high: {
				double result[];
				return CopyHigh ( symbol, TFMigrate ( time_frame ), shift, 1, result ) > 0 ? result[0] : -1;
			}

			default:
				return -1;
		}
	}

	static datetime get_candle_open_time ( string symbol,
										   ENUM_TIMEFRAMES time_frame,
										   int shift ) {
		long result[];
		return CopyTime ( symbol, TFMigrate ( time_frame ), shift, 1, result ) > 0 ? result[0] : -1;
	}

private:
	static ENUM_TIMEFRAMES TFMigrate ( int time_frame ) {
		switch ( time_frame ) {
			case 0:
				return ( PERIOD_CURRENT );

			case 1:
				return ( PERIOD_M1 );

			case 5:
				return ( PERIOD_M5 );

			case 15:
				return ( PERIOD_M15 );

			case 30:
				return ( PERIOD_M30 );

			case 60:
				return ( PERIOD_H1 );

			case 240:
				return ( PERIOD_H4 );

			case 1440:
				return ( PERIOD_D1 );

			case 10080:
				return ( PERIOD_W1 );

			case 43200:
				return ( PERIOD_MN1 );

			case 2:
				return ( PERIOD_M2 );

			case 3:
				return ( PERIOD_M3 );

			case 4:
				return ( PERIOD_M4 );

			case 6:
				return ( PERIOD_M6 );

			case 10:
				return ( PERIOD_M10 );

			case 12:
				return ( PERIOD_M12 );

			case 16385:
				return ( PERIOD_H1 );

			case 16386:
				return ( PERIOD_H2 );

			case 16387:
				return ( PERIOD_H3 );

			case 16388:
				return ( PERIOD_H4 );

			case 16390:
				return ( PERIOD_H6 );

			case 16392:
				return ( PERIOD_H8 );

			case 16396:
				return ( PERIOD_H12 );

			case 16408:
				return ( PERIOD_D1 );

			case 32769:
				return ( PERIOD_W1 );

			case 49153:
				return ( PERIOD_MN1 );

			default:
				return ( PERIOD_CURRENT );
		}
	}
};

#endif