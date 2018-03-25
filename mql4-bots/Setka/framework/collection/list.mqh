#ifndef FRAMEWORK_LIST_MQH
#define FRAMEWORK_LIST_MQH

#define COMMA ,

#define LIST_FOREACH(list_foreach_collection, list_foreach_iterator_type, list_foreach_iterator_item_name, list_foreach_action) \
	for(int list_foreach_iterator = 0; list_foreach_iterator < list_foreach_collection.count; list_foreach_iterator++){ \
		list_foreach_iterator_type list_foreach_iterator_item_name = list_foreach_collection.items[list_foreach_iterator]; \
		list_foreach_action; \
	}

#define LIST_FOREACH_REVERSE(list_foreach_revese_collection, list_foreach_reverse_iterator_type, list_foreach_reverce_iterator_item_name, list_foreach_reverse_action) \
	for(int list_foreach_reverse_iterator = list_foreach_revese_collection.count - 1; list_foreach_reverse_iterator >= 0; list_foreach_reverse_iterator--){ \
		list_foreach_reverse_iterator_type list_foreach_reverce_iterator_item_name = list_foreach_revese_collection.items[list_foreach_reverse_iterator]; \
		list_foreach_reverse_action; \
	}

#define LIST_FOREACH2(dasdasda, iterate_type_kkkcvx, iterate_item_qwekwed, kfdsfodsi) \
	for(int i_kdaskdgfgf = 0; i_kdaskdgfgf < dasdasda.count; i_kdaskdgfgf++){ \
		iterate_type_kkkcvx iterate_item_qwekwed = dasdasda.items[i_kdaskdgfgf]; \
		kfdsfodsi; \
	}

#define LIST_WHERE(items_dsadasdasln, result_name_dsadasd, iterate_type_dsda, iterate_item_sdadasd, predicate_dsadada) \
	list<iterate_type_dsda>* result_name_dsadasd = new list<iterate_type_dsda>(); \
	for(int i = 0; i < items_dsadasdasln.count; i++){ \
		iterate_type_dsda iterate_item_sdadasd = items_dsadasdasln.items[i]; \
		if(predicate_dsadada){ \
			result_name_dsadasd.add(iterate_item_sdadasd); \
		} \
	}

#define LIST_ACTION_WHERE(list, iterate_type, iterate_name, predicate, action) \
	for(int i = 0; i < list.count; i++){ \
		iterate_type iterate_name = list.items[i]; \
		if(predicate) \
			action; \
	}

#define LIST_SORT_BUBBLE(list, field, asc) \
	if ( asc ) { \
		LIST_SORT_BUBBLE_ASC ( list, open_price ); \
	} else { \
		LIST_SORT_BUBBLE_DESC ( list, open_price ); \
	}

#define LIST_SORT_BUBBLE_ASC(list, field) \
	for(int i = 0; i < list.count - 1; i++){ \
		bool any_change = false; \
		for ( int j = 0; j < list.count - i - 1; j++ ){ \
			if ( list.items[j].##field > list.items[j + 1].##field ) { \
				list.swap ( j, j + 1 ); \
				any_change = true; \
			} \
		} \
		if ( !any_change ) \
			break; \
	}

#define LIST_SORT_BUBBLE_DESC(list, field) \
	for(int i = 0; i < list.count - 1; i++){ \
		bool any_change = false; \
		for ( int j = 0; j < list.count - i - 1; j++ ){ \
			if ( list.items[j].##field < list.items[j + 1].##field ) { \
				list.swap ( j, j + 1 ); \
				any_change = true; \
			} \
		} \
		if ( !any_change ) \
			break; \
	}

#define LIST_SORT_INSERT_ASC(list, field) \
	for(int i = 1; i < list.count; i++) \
		for ( int j = i; j > 0 &&  list.items[j - 1].##field > list.items[j].##field; j-- ) \
			list.swap ( j - 1, j );

#define LIST_SORT_INSERT_DESC(list, field) \
	for(int i = 1; i < list.count; i++) \
		for ( int j = i; j > 0 &&  list.items[j - 1].##field < list.items[j].##field; j-- ) \
			list.swap ( j - 1, j );


#define LIST_FIRST_INDEX_OF(list,result,iterator_type,iterator,predicate) \
	int result = -1;\
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){\
		iterator_type iterator = list.items[dasdkljmfdsljfds];\
		if((predicate)){ \
			result = dasdkljmfdsljfds;\
			break; \
		}\
	}

#define LIST_LAST_INDEX_OF(list,result,iterator_type,iterator,predicate) \
	int result = -1;\
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){\
		iterator_type iterator = list.items[dasdkljmfdsljfds];\
		if((predicate)) \
			result = dasdkljmfdsljfds;\
	}

#define LIST_JOIN(left_list,right_list,left_iterator_type, left_iterator_name, right_iterator_type, right_iterator_name, predicate, action) \
	for(int i = 0; i < left_list.count; i++){ \
		left_iterator_type left_iterator_name = left_list.items[i]; \
		for(int j = 0; j < right_list.count; j++){ \
			right_iterator_type right_iterator_name = right_list.items[j]; \
			if((predicate)) \
				action; \
		} \
	}

#define LIST_COUNT(list, result, iterator_type, iterator, predicate) \
	int result = 0; \
	for(int i = 0; i < list.count; i++){ \
		iterator_type iterator = list.items[i]; \
		if(predicate) \
			result += 1; \
	}

#define LIST_SUM(list, result_type, result_name, result_default, iterator_type, iterator, field) \
	result_type result_name = result_default; \
	for(int i = 0; i < list.count; i++) { \
		iterator_type iterator = list.items[i]; \
		result_name += field; \
	} \

#define LIST_SUM_EX(list, result_with_type, iterator_type, iterator, action) \
	result_with_type; \
	for(int i = 0; i < list.count; i++){ \
		iterator_type iterator = list.items[i]; \
		action; \
	}

#define LIST_AVG(list, result_type, result_name, result_default, iterator_type, iterator, field) \
	result_type result_name = result_default; \
	for(int i = 0; i < list.count; i++) { \
		iterator_type iterator = list.items[i]; \
		result_name += field; \
	} \
	result_name /= list.count;

#define LIST_MIN(list, result_type, result_name, result_default, iterator_type, iterator, field) \
	result_type result_name = result_default; \
	for(int i = 0; i < list.count; i++) { \
		iterator_type iterator = list.items[i]; \
		if(i == 0) \
			result_name = field; \
		else if(result_name > field) \
			result_name = field; \
	}

#define LIST_MAX(list, result_type, result_name, result_default, iterator_type, iterator, field) \
	result_type result_name = result_default; \
	for(int i = 0; i < list.count; i++) { \
		iterator_type iterator = list.items[i]; \
		if(i == 0) \
			result_name = field; \
		else if(result_name < field) \
			result_name = field; \
	}

#define LIST_FIRST_OR_DEFAULT(list,result,iterator_type,iterator,predicate) \
	iterator_type result = NULL;\
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){\
		iterator_type iterator = list.items[dasdkljmfdsljfds];\
		if((predicate)){ \
			result = iterator;\
			break; \
		}\
	}

#define LIST_CONTAINS(list,result,contains_check_item) \
	bool result = false; \
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){ \
		if(contains_check_item == list.items[dasdkljmfdsljfds]){ \
			result = true; \
			break; \
		}\
	}

#define LIST_ANY(list,result,iterator_type,iterator,predicate) \
	bool result = false; \
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){ \
		iterator_type iterator = list.items[dasdkljmfdsljfds];\
		if((predicate)){ \
			result = true; \
			break; \
		}\
	}

#define LIST_ALL(list,result,iterator_type,iterator,predicate) \
	bool result = true; \
	for(int dasdkljmfdsljfds = 0; dasdkljmfdsljfds < list.count; dasdkljmfdsljfds++){ \
		iterator_type iterator = list.items[dasdkljmfdsljfds];\
		if(!(predicate)){ \
			result = false; \
			break; \
		}\
	}

template<typename t_left, typename t_right>
class left_right_t : public disposable_obj {
public:
	t_left left;
	t_right right;
};

#define LIST_LEFT_JOIN(result_name, left_list, right_list,left_iterator_type, left_iterator_name, right_iterator_type, right_iterator_name, predicate) \
	list<left_right_t<left_iterator_type,right_iterator_type>*>* result_name = new list<left_right_t<left_iterator_type,right_iterator_type>*>(); \
	for(int i = 0; i < left_list.count; i++){ \
		left_iterator_type left_iterator_name = left_list.items[i]; \
		for(int j = 0; j < right_list.count; j++){ \
			right_iterator_type right_iterator_name = right_list.items[j]; \
			if((predicate)) { \
				left_right_t<left_iterator_type,right_iterator_type>* for_add = new left_right_t<left_iterator_type,right_iterator_type>(); \
				for_add.left = left_iterator_name; \
				for_add.right = right_iterator_name; \
				result_name.add(for_add); \
			} \
		} \
	} \
	for(int i = 0; i < left_list.count; i++){ \
		left_iterator_type left_iterator_name = left_list.items[i]; \
		LIST_ANY( result_name, \
				  left_contains, \
				  left_right_t<left_iterator_type COMMA right_iterator_type>*, \
				  item, \
				  item.left == left_iterator_name ); \
		if(!left_contains){ \
			left_right_t<left_iterator_type,right_iterator_type>* for_add = new left_right_t<left_iterator_type,right_iterator_type>(); \
			for_add.left = left_iterator_name; \
			for_add.right = NULL; \
			result_name.add(for_add); \
		} \
	}

#define GET_VALUE_OR_DEFAULT(item, action) \
	item == NULL ? NULL : action

#define GET_VALUE_OR_MANUAL(item, action, manual) \
	item == NULL ? manual : action

#define ACTION_ON_VALUE_OR_DEFAULT(item, action) \
	if(item != NULL) { \
		action; \
	}

#define ACTION_ON_NONVALUE_OR_DEFAULT(item, action) \
	if(item == NULL) { \
		action; \
	}

template<typename T>
class list_without_ptr : public disposable_obj {
public:
	int _capacity;
	int _capacity_step;
	int position;
	int count;
	T items[];

	list_without_ptr() {
		_capacity = 3;
		_capacity_step = _capacity;

		ArrayResize ( items, _capacity );
	}

	list_without_ptr ( int capacity ) {
		_capacity = capacity;
		_capacity_step = _capacity;

		ArrayResize ( items, _capacity );
	}

	void add ( T value ) {
		if ( count + 1 > _capacity ) {
			_capacity += _capacity_step;
			ArrayResize ( items, _capacity );
		}

		items[count++] = value;
	}

	void clear() {
		position = 0;
		count = 0;
	}

	T get ( int index ) {
		return items[index];
	}
};

template<typename T>
class list : public disposable_obj {
public:
	int _capacity;
	int _capacity_step;
	int position;
	int count;
	T items[];

	~list() {
		clear();
	}

	list() {
		_capacity = 3;
		_capacity_step = 3;

		ArrayResize ( items, _capacity );
	}

	list ( int capacity ) {
		_capacity = capacity;
		_capacity_step = 3;

		ArrayResize ( items, _capacity );
	}

	list ( int capacity,
		   int capacity_step ) {
		_capacity = capacity;
		_capacity_step = capacity_step;

		ArrayResize ( items, _capacity );
	}

	void add ( T value ) {
		if ( count + 1 > _capacity ) {
			_capacity += _capacity_step;
			ArrayResize ( items, _capacity );
		}

		items[count++] = value;
	}

	void delete_at ( int index ) {
		if ( index > count - 1 ) {
			return;
		}

		items[index] = NULL;

		for ( int i = index; i < count - 1; i++ ) {
			swap ( i, i + 1 );
		}

		int new_count = ArraySize ( items ) - 1;
		ArrayResize ( items, new_count );
		count = new_count;
	}

	void clear() {
		LIST_FOREACH ( this, T, item, {
			if ( item != NULL && CheckPointer ( item ) != POINTER_INVALID ) {
				delete item;
			}
		} );

		position = 0;
		count = 0;
	}

	void clear_without_dispoce() {
		position = 0;
		count = 0;
	}

	T pop() {
		return count == 0 ? NULL : items[count--];
	}

	void pop ( T value ) {
		LIST_FIRST_INDEX_OF ( this, delete_item_index, T, item, item == value );
		delete_at ( delete_item_index );
	}

	T get() {
		return position >= count ? NULL : items[position];
	}

	T first_or_default() {
		return count == 0 ? NULL : items[0];
	}

	T last_or_default() {
		return count == 0 ? NULL : items[count - 1];
	}

	list<T> *skip ( int skip_count ) {
		list<T> *result = new list<T> ( count - skip_count );

		for ( int i = skip_count - 1; i < count; i++ ) {
			result.add ( items[i] );
		}

		return result;
	}

	list<T> *take ( int take_count ) {
		list<T> *result = new list<T> ( take_count );

		for ( int i = 0; i < take_count; i++ ) {
			result.add ( items[i] );
		}

		return result;
	}

	void swap ( int first_pos, int second_pos ) {
		if ( first_pos >= count
				|| second_pos >= count ) {
			return;
		}

		T swap_item = items[first_pos];
		items[first_pos] = items[second_pos];
		items[second_pos] = swap_item;
	}

	void swap ( int swap_pos ) {
		swap ( position, swap_pos );
	}
};

#endif