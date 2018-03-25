#ifndef FRAMEWORK_TIME_MQH
#define FRAMEWORK_TIME_MQH

class time {
public:
	static int get_seconds_from_time_frame ( ENUM_TIMEFRAMES time_frame ) {
		return time_frame * 60;
	}
};


#endif