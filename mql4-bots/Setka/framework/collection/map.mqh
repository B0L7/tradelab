#ifndef FRAMEWORK_MAP_MQH
#define FRAMEWORK_MAP_MQH

template<typename T1, typename T2>
class kvp {
public:
	T1 item1;
	T2 item2;
};

//TODO: нужно сделать правильный map на основе hash code и дерева
template<typename TKey, typename TValue>
class map : public disposable_obj {
private:
	list<kvp<TKey, TValue>*> *_items;

public:
	~map() {
		if ( _items != NULL && CheckPointer ( _items ) != POINTER_INVALID ) {
			delete _items;
		}
	}

	map() {
		_items = new list<kvp<TKey, TValue>*> ( 3 );
	}

	map ( int capacity ) {
		_items = new list<kvp<TKey, TValue>*> ( capacity );
	}

	int count() {
		return _items.count;
	}

	bool pushIf ( TKey key, TValue value ) {
		LIST_FIRST_OR_DEFAULT ( _items, exists_item, kvp<TKey COMMA TValue> *, item, item.item1 == key );

		if ( exists_item != NULL ) {
			return false;
		}

		kvp<TKey, TValue> *result = new kvp<TKey, TValue>();
		result.item1 = key;
		result.item2 = value;

		_items.add ( result );
		return true;
	}

	TValue get_value_or_default ( TKey key ) {
		LIST_FIRST_OR_DEFAULT ( _items, exists_item, kvp<TKey COMMA TValue> *, item, item.item1 == key );
		return GET_VALUE_OR_DEFAULT ( exists_item, exists_item.item2 );
	}

	bool contains_key ( TKey key ) {
		LIST_FIRST_OR_DEFAULT ( _items, exists_item, kvp<TKey COMMA TValue> *, item, item.item1 == key );
		return exists_item != NULL;
	}
};

#endif