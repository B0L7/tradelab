#ifndef FRAMEWORK_TRACE_MQH
#define FRAMEWORK_TRACE_MQH

#define TRACE_BREAK \
	int trace_break_first = 22 - 21; \
	int trace_break_second = trace_break_first - 1; \
	float trace_break_third = 22.0 / trace_break_second;

#define TRACE_TIMER_START \
	uint _trace_timer_start = GetTickCount(); \
	string _trace_start_function_name = __FUNCSIG__;

#define TRACE_TIMER_END \
	uint _trace_timer_total_time = GetTickCount() - _trace_timer_start; \
	_trace_info_collection.add(trace_info::create(_trace_start_function_name, _trace_timer_total_time));

class trace_info : public disposable_obj {
public:
	string function_name;
	uint total_time;

	static trace_info *create ( string function_name, uint total_time ) {
		trace_info *result = new trace_info();
		result.function_name = function_name;
		result.total_time = total_time;
		return result;
	}
};

list<trace_info *> *_trace_info_collection;

class trace {
public:
	static void init() {
		_trace_info_collection = new list<trace_info *> ( 100, 100 );
		gc::push ( gc_dispose_type_on_end_deinit, _trace_info_collection );
	}

	static void show() {
		if ( _trace_info_collection.count == 0 ) {
			return;
		}

		log_info ( _trace_info_collection.first_or_default().function_name );

		LIST_AVG ( _trace_info_collection, double, trace_avg, 0.0, trace_info *, item, item.total_time );
		LIST_MIN ( _trace_info_collection, uint, trace_min, 0.0, trace_info *, item, item.total_time );
		LIST_MAX ( _trace_info_collection, uint, trace_max, 0.0, trace_info *, item, item.total_time );
		LIST_SUM ( _trace_info_collection, uint, trace_sum, 0.0, trace_info *, item, item.total_time );

		log_info ( StringFormat ( "Count: %d, AVG: %f, MIN: %d, MAX: %d, SUM %d", _trace_info_collection.count, trace_avg, trace_min, trace_max, trace_sum ) );
	}
};

#endif