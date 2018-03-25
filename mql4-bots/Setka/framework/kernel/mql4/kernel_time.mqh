#ifndef FRAMEWORK_KERNEL_TIME_MQH
#define FRAMEWORK_KERNEL_TIME_MQH

class kernel_time {
public:
	static int get_hour ( datetime value ) {
		return TimeHour ( value );
	}

	static int get_minute ( datetime value ) {
		return TimeMinute ( value );
	}

	static int get_day_of_week() {
		return DayOfWeek();
	}
};

#endif