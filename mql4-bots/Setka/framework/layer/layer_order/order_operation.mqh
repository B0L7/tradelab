#ifndef FRAMEWORK_ORDER_OPERATION_MQH
#define FRAMEWORK_ORDER_OPERATION_MQH

enum order_operation_type_t {
	order_operation_type_none,
	order_operation_type_close,
	order_operation_type_update,
	order_operation_type_set_tp,
	order_operation_type_set_sl_tp,
	order_operation_type_open,
	order_operation_type_set_sl_tp_price,
};

class order_operation : public disposable_obj {
public:
	bool is_completed;
	int error;
	order_operation_type_t operation_type;
	int magic_number;
	int ticket;
	int lvl;
	enum_order_operation_type order_type;
	double lot;
	double price;
	double step_p;
	double stop_loss;
	double take_profit;
	int slippage;
	string comment;

	order_operation *clone() {
		order_operation *result = new order_operation();
		result.is_completed = is_completed;
		result.error = error;
		result.operation_type = operation_type;
		result.magic_number = magic_number;
		result.ticket = ticket;
		result.lvl = lvl;
		result.order_type = order_type;
		result.lot = lot;
		result.price = price;
		result.step_p = step_p;
		result.stop_loss = stop_loss;
		result.take_profit = take_profit;
		result.slippage = slippage;
		result.comment = comment;
		return result;
	}

	void reset() {
		is_completed = false;
		error = 0;
		operation_type = order_operation_type_none;
		magic_number = 0;
		ticket = 0;
		lvl = 0;
		order_type = order_operation_none;
		lot = 0;
		price = 0;
		step_p = 0;
		stop_loss = 0;
		take_profit = 0;
		slippage = 0;
		comment = EXT_STRING_EMPTY;
	}

	bool is_order_stop () {
		return order::is_order_stop ( order_type );
	}

	bool process() {
		is_completed = false;
		color order_color = order::get_order_color ( order_type );

		switch ( operation_type ) {
			case order_operation_type_none:
				is_completed = true;
				break;

			case order_operation_type_close:
				is_completed = kernel_order::delete_stop ( ticket,
							   order_color );
				break;

			case order_operation_type_update:
				is_completed = kernel_order::set_sl_tp_price ( ticket,
							   stop_loss,
							   take_profit,
							   price );
				break;

			case order_operation_type_open: {
				/*
				    if ( !free_margin_check ( orders_count, price, normalized_lot ) <= 0.0 ) {
					return false
				    }
				*/

				int responce_ticket = kernel_order::send_stop ( magic_number,
									  order_type,
									  price,
									  lot,
									  comment,
									  order_color );

				is_completed = responce_ticket != -1;

				if ( is_completed ) {
					ticket = responce_ticket;
				}

				break;
			}
		}

		if ( !is_completed ) {
			error = layer_error::get_last();
		}

		return is_completed;
	}
};

#endif