#ifndef FACTORY_MQH
#define FACTORY_MQH

#define FACTORY_TEMPLATE( type ) \
	list<type *> *_factory_##type##_objects; \
	int _factory_##type##_position; \
	\
	class factory_##type { \
	public: \
		static void init ( int count ) { \
			_factory_##type##_position = 0; \
			_factory_##type##_objects = new list<type *> ( count ); \
			gc::push ( gc_dispose_type_on_end_deinit, _factory_##type##_objects ); \
			\
			for ( int i = 0; i < count; i++ ) \
				_factory_##type##_objects.add ( new type() ); \
		} \
		\
		static void reset() { \
			_factory_##type##_position = 0; \
		} \
		\
		static type *get() { \
			type *result = NULL; \
			\
			if ( _factory_##type##_position == _factory_##type##_objects.count ) { \
				_factory_##type##_objects.add ( result = new type() ); \
			} else { \
				result = _factory_##type##_objects.items[_factory_##type##_position]; \
			} \
			\
			result.reset(); \
			_factory_##type##_position += 1; \
			return result; \
		} \
	} \

#include "factory_order.mqh"
#include "factory_order_operation.mqh"

#endif