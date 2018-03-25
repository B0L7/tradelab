#ifndef FRAMEWORK_GC_MQH
#define FRAMEWORK_GC_MQH

#define GC_CHECK_PTR( ptr ) (ptr != NULL && CheckPointer ( ptr ) != POINTER_INVALID)
#define GC_DISPOSE_IF( value ) \
	if(GC_CHECK_PTR(value)){ \
		delete value; \
		value = NULL; \
	}

enum gc_dispose_type {
	gc_dispose_type_on_end_tick,
	gc_dispose_type_on_end_deinit
};

list<disposable_obj *> *gc_dispose_on_end_tick;
list<disposable_obj *> *gc_dispose_on_end_deinit;

class gc {
public:
	static void init() {
		gc_dispose_on_end_tick = new list<disposable_obj *> ( 100 );
		gc_dispose_on_end_deinit = new list<disposable_obj *> ( 100 );
	}

	static void deinit() {
		GC_DISPOSE_IF ( gc_dispose_on_end_tick );
		GC_DISPOSE_IF ( gc_dispose_on_end_deinit );
	}

	static void dispose(  ) {
		list<disposable_obj *> *items = get_list_by_type ( gc_dispose_type_on_end_tick );

		LIST_FOREACH ( items, disposable_obj *, item, {
			if ( GC_CHECK_PTR ( item ) ) {
				item.dispose();
				delete item;
			}
		} );

		items.clear();
	}

	static void push ( gc_dispose_type type, disposable_obj *obj ) {
		get_list_by_type ( type ).add ( obj );
	}

	static void pop ( gc_dispose_type type, disposable_obj *obj ) {
		list<disposable_obj *> *items = get_list_by_type ( type );
		LIST_FIRST_INDEX_OF ( items, delete_index, disposable_obj *, item, item == obj );

		if ( delete_index != -1 ) {
			items.delete_at ( delete_index );
		}
	}

private:
	static list<disposable_obj *> *get_list_by_type ( gc_dispose_type type ) {
		switch ( type ) {
			case gc_dispose_type_on_end_tick:
				return gc_dispose_on_end_tick;

			case gc_dispose_type_on_end_deinit:
				return gc_dispose_on_end_deinit;

			default:
				return NULL;
		}

	}
};

#endif