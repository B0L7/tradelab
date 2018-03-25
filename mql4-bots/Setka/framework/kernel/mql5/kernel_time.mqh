#ifndef FRAMEWORK_KERNEL_TIME_MQH
#define FRAMEWORK_KERNEL_TIME_MQH

class kernel_time {
public:
	static int get_hour ( datetime value ) {
		MqlDateTime result;
		TimeToStruct ( value, result );
		return result.hour;
	}

	static int get_minute ( datetime value ) {
		MqlDateTime result;
		TimeToStruct ( value, result );
		return result.min;
	}

	static int get_day_of_week() {
		MqlDateTime result;
		TimeCurrent ( result );
		return result.day_of_week;
	}
};

#endif