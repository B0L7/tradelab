#ifndef FRAMEWORK_ORDER_COUNT_MQH
#define FRAMEWORK_ORDER_COUNT_MQH

class order_count_t : public disposable_obj {
private:
	int _order;
	int _stop;
	int _limit;
	int _all;

public:
	int order() {
		return _order;
	}

	int stop() {
		return _stop;
	}

	int limit() {
		return _limit;
	}

	int all() {
		return _all;
	}

	order_count_t() {
		clear();
	}

	void clear() {
		_order = 0;
		_stop = 0;
		_limit = 0;
		_all = 0;
	}

	void inc_by_type ( enum_order_operation_type type ) {
		_all += 1;

		if ( order::is_order ( type ) ) {
			_order += 1;
		} else if ( order::is_order_stop ( type ) ) {
			_stop += 1;
		}  else {
			_limit += 1;
		}
	}

	void deinc_by_type ( enum_order_operation_type type ) {
		_all -= 1;

		if ( order::is_order ( type ) ) {
			_order -= 1;
		} else if ( order::is_order_stop ( type ) ) {
			_stop -= 1;
		}  else {
			_limit -= 1;
		}
	}
};

#endif