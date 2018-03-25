#ifndef API_MQH
#define API_MQH

#define PREFIX_MAIN "IG"
#define PREFIX_ORDER_STEP "OrderStep"
#define PREFIX_NEXT_ORDER_POSITION "NextOrderPosition"
#define PREFIX_LEVEL_WITHOUT_LOSS "NoLossLevel"
#define PREFIX_TAKE_PROFIT "TakeProfit"
#define PREFIX_PROFIT_IN_CURRENCY "ProfitInCurrency"
#define PREFIX_FUTURE_PROFIT_IN_CURRENCY "FutureProfitInCurrency"
#define PREFIX_LOT_SUM "LotSum"

string _prefix_long = "";
logic_handler *_api_long_handler;

string _prefix_short = "";
logic_handler *_api_short_handler;

timer_t *_api_update_time;
// Нужно как то в таймере это сделать
bool _api_first_tick;

class api {
public:
#ifdef FOR_OPTIMIZATION
	static void init() {}
	static void deinit() {}
	static void process() {}
	static void set_times ( int seconds ) {}
	static void set_short_handler ( logic_handler *value ) {}
	static void set_long_handler ( logic_handler *value ) {}
#else
	static void init() {
		_api_first_tick = true;
		GlobalVariablesDeleteAll ( _prefix_long );
		GlobalVariablesDeleteAll ( _prefix_short );
	}

	static void deinit() {
		GC_DISPOSE_IF ( _api_update_time );
	}

	static void process() {
		if ( _api_update_time == NULL
				|| ( !_api_first_tick && !_api_update_time.is_elapsed() ) ) {
			return;
		}

		_api_first_tick = false;
		handler_process ( _prefix_long, _api_long_handler );
		handler_process ( _prefix_short, _api_short_handler );
		_api_update_time.reset();
	}

	static void set_times ( int seconds ) {
		_api_update_time = seconds == 0 ? NULL : timer_t::create ( seconds );
	}

	static void set_short_handler ( logic_handler *value ) {
		_api_short_handler = value;
		_prefix_short = value.get_global_prefix ( PREFIX_MAIN );
	}

	static void set_long_handler ( logic_handler *value ) {
		_api_long_handler = value;
		_prefix_long = value.get_global_prefix ( PREFIX_MAIN );
	}

private:
#define GLOB_SET(name, value) \
	GlobalVariableSet ( StringFormat ( "%s_%s", base_prefix, name ), value )
	static void handler_process ( string base_prefix, logic_handler *handler ) {
		list<order *> *orders = layer_order::get ( handler._order_settings );

		if ( orders.count == 0 ) {
			GlobalVariablesDeleteAll ( base_prefix );
			return;
		}

		if ( !handler.can_update_params() ) {
			return;
		}

		double grid_step = layer::correct_price (  calc_grid_step::get ( handler._settings,  orders.count + 1 ) );
		double next_lvl = layer::correct_price ( handler.get_order_position ( orders.last_or_default().open_price, orders.count + 1 ) );
		double level_without_loss = layer::correct_price ( calc_take_profit::get ( handler._settings, handler._order_settings, tp_level_without_loss, 0 ) );
		double take_profit = layer::correct_price ( calc_take_profit::get ( handler._settings, handler._order_settings, orders.count ) );
		double current_price = layer_market::price_close ( handler._order_settings.order_type );

		double lot_sum = 0.0,
			   current_profit_in_currency = handler.get_profit(),
			   future_profit_in_currency = 0;
		LIST_FOREACH ( orders, order *, item, {
			lot_sum += item.lot;

			if ( item.is_order() ) {
				future_profit_in_currency += item.commission + item.swap;
				future_profit_in_currency += item.get_profit_in_currency ( take_profit );
				continue;
			}

			if ( item.is_before_line ( take_profit ) ) {
				future_profit_in_currency += item.get_profit_in_currency ( take_profit );
			}
		} );

		GLOB_SET ( PREFIX_ORDER_STEP, grid_step );
		GLOB_SET ( PREFIX_NEXT_ORDER_POSITION, next_lvl );
		GLOB_SET ( PREFIX_LEVEL_WITHOUT_LOSS, level_without_loss );
		GLOB_SET ( PREFIX_TAKE_PROFIT, take_profit );
		GLOB_SET ( PREFIX_PROFIT_IN_CURRENCY, current_profit_in_currency );
		GLOB_SET ( PREFIX_FUTURE_PROFIT_IN_CURRENCY, future_profit_in_currency );
		GLOB_SET ( PREFIX_LOT_SUM, lot_sum );
	}
#endif
};

#endif