#ifndef FRAMEWORK_TOOL_CACHE_MQH
#define FRAMEWORK_TOOL_CACHE_MQH

#define TOOL_CACHED( type, name, action ) \
	static type name; \
	static int name##_instance_saved; \
	if( name##_instance_saved != _tool_instance_state ){ \
		name##_instance_saved = _tool_instance_state; \
		action; \
	} \
	return name;

#define TOOL_CACHED_TICK( type, name, action ) \
	static type name; \
	static int name##_tick_saved; \
	if( name##_tick_saved != _tool_tick_state ){ \
		name##_tick_saved= _tool_tick_state; \
		action; \
	} \
	return name;

#define TOOL_CACHED_TICK_TESTING( type, name, action ) \
	static type name; \
	static int name##_tick_saved; \
	static bool name##_testing_saved; \
	if(layer_account::is_testing() \
			|| layer_account::is_optimization()) { \
		if(!name##_testing_saved) { \
			name##_testing_saved = true;	\
			action; \
		} \
	} \
	else if( name##_tick_saved != _tool_tick_state ){ \
		name##_tick_saved = _tool_tick_state; \
		action; \
	} \
	return name;

#define TOOL_CACHED_INSTANCE( type, name, action ) \
	private: \
	type _##name; \
	int _##name##_instance_saved; \
	public: \
	type name() { \
		if( _##name##_instance_saved != _tool_instance_state ){ \
			_##name##_instance_saved = _tool_instance_state; \
			action; \
		} \
		return _##name; \
	}

#define TOOL_CACHED_INSTANCE_TICK( type, name, action ) \
	private: \
	type _##name; \
	int _##name##_tick_saved; \
	public: \
	type name() { \
		if( _##name##_tick_saved != _tool_tick_state ){ \
			_##name##_tick_saved = _tool_tick_state; \
			action; \
		} \
		return _##name; \
	}

int _tool_instance_state = -512;
int _tool_tick_state = -256;

class tool_cache {
public:
	static void update_instance_state() {
		_tool_instance_state += 1;
	}

	static void update_tick_state() {
		_tool_tick_state += 1;
	}
};

#endif