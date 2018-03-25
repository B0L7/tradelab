#ifndef FRAMEWORK_TIMER_MQH
#define FRAMEWORK_TIMER_MQH

class timer_t : public disposable_obj {
private:
	int _interval_in_sec;
	datetime _start;

public:
	timer_t() {
		reset();
	}

	void reset() {
		_start = layer::time_current();
	}

	void set_zero() {
		_start = _start - _interval_in_sec;
	}

	bool is_elapsed() {
		return get_distance() >= _interval_in_sec;
	}

	int get_distance() {
		return time_get_distance_in_sec ( layer::time_current(), _start );
	}

	datetime ent_time() {
		return _start + _interval_in_sec;
	}

	static timer_t *create ( int interval_in_sec ) {
		return timer_t::create ( layer::time_current(), interval_in_sec );
	}

	static timer_t *create ( datetime start, int interval_in_sec ) {
		timer_t *result = new timer_t();
		result._start = start;
		result._interval_in_sec = interval_in_sec;
		return result;
	}
};

int time_get_distance_in_sec ( datetime end, datetime start )
{
	return ( int ) ( end - start );
}

#endif