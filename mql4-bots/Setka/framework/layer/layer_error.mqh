#ifndef FRAMEWORK_LAYER_ERROR_MQH
#define FRAMEWORK_LAYER_ERROR_MQH

int _layer_error_last;

class layer_error {
public:
	static void reset() {
		_layer_error_last = -1;
	}

	static int get_last() {
		return _layer_error_last = GetLastError();
	}

	static int get_last_saved() {
		return _layer_error_last;
	}

	static string get_last_saved_string() {
		return error_get_last ( get_last_saved() );
	}
};

#endif