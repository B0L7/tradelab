#ifndef FRAMEWORK_KERNEL_ORDER_MQH
#define FRAMEWORK_KERNEL_ORDER_MQH

ulong _kernel_order_current_ticket = -255;

class kernel_order {
public:
	static int count() {
		return HistoryOrdersTotal();
	}

	static int count_history() {
		return HistoryOrdersTotal();
	}

	static bool select_by_index ( int index ) {
		return ( _kernel_order_current_ticket = HistoryOrderGetTicket ( index ) ) > 0
			   && PositionSelectByTicket ( position_id() );
	}

	static bool select_by_ticket ( int ticket ) {
		_kernel_order_current_ticket = ticket;
		Print ( StringFormat ( "Pos %d", position_id() ) );


		return ( _kernel_order_current_ticket = ticket ) > 0
			   && PositionSelectByTicket ( position_id() );
	}

	static bool select_by_index_history ( int index ) {
		return ( _kernel_order_current_ticket = HistoryOrderGetTicket ( index ) ) > 0;
	}

	static bool select_by_ticket_history ( int ticket ) {
		return HistoryOrderSelect ( _kernel_order_current_ticket = ticket );
	}

	static int send ( int magic_number,
					  enum_order_operation_type order_type,
					  double price,
					  double lot,
					  int slippage,
					  string comment,
					  color col ) {
		MqlTradeRequest request;
		request.action = TRADE_ACTION_DEAL;
		request.magic = magic_number;
		request.order = 0;
		request.symbol = CURRENT_SYMBOL;
		request.volume = lot;
		request.price = price;
		request.stoplimit = 0.0;
		request.sl = 0.0;
		request.tp = 0.0;
		request.deviation = slippage;
		request.type = convert_order_operation_type ( order_type );
		request.type_filling = ORDER_FILLING_FOK;
		request.type_time = ORDER_TIME_GTC;
		request.expiration = 0;
		request.comment = comment;
		request.position = 0;
		request.position_by = 0;

		MqlTradeResult  result;

		if ( OrderSend ( request, result ) ) {
			if ( result.retcode == TRADE_RETCODE_DONE ) {
				return result.order;
			}

			Print ( StringFormat ( "RetCode %d", result.retcode ) );
		}

		return -1;
	}

	static int send_stop ( int magic_number,
						   enum_order_operation_type order_stop_type,
						   double price,
						   double lot,
						   string comment,
						   color col ) {
		return -1;
	}

	static bool set_price ( int ticket,
							double price,
							color order_color ) {
		return false;
	}

	static bool delete_stop ( int ticket,
							  color order_color ) {
		MqlTradeRequest request;
		request.action = TRADE_ACTION_REMOVE;
		request.order = ticket;

		MqlTradeResult  result;
		return OrderSend ( request, result );
	}

	static bool close ( int ticket,
						double lot,
						double price_close,
						double slippage,
						color order_color ) {
		return false;
	}

	static bool set_tp ( int magic_number,
						 int ticket,
						 double tp ) {
		MqlTradeRequest request;
		request.action = TRADE_ACTION_SLTP;
		request.symbol = CURRENT_SYMBOL;
		request.order = ticket;
		request.tp = tp;
		request.sl = 0.0;
		request.magic = magic_number;

		MqlTradeResult  result;
		return OrderSend ( request, result );
	}

	static bool set_sl_tp ( int ticket,
							double sl,
							double tp ) {
		MqlTradeRequest request;
		request.action = TRADE_ACTION_SLTP;
		request.order = ticket;
		request.sl = sl;
		request.tp = tp;

		MqlTradeResult  result;
		return OrderSend ( request, result );
	}

	static bool set_sl_tp_price ( int ticket,
								  double sl,
								  double tp,
								  double price ) {
		MqlTradeRequest request;
		request.action = TRADE_ACTION_MODIFY;
		request.order = ticket;
		request.price = price;
		request.sl = sl;
		request.tp = tp;

		MqlTradeResult  result;
		return OrderSend ( request, result );
	}

	static string symbol() {
		return HistoryOrderGetString ( _kernel_order_current_ticket, ORDER_SYMBOL );
	}

	static long magic_number() {
		return HistoryOrderGetInteger ( _kernel_order_current_ticket, ORDER_MAGIC );
	}

	static enum_order_operation_type type() {
		return convert_to_order_operation_type ( ( ENUM_ORDER_TYPE ) HistoryOrderGetInteger ( _kernel_order_current_ticket, ORDER_TYPE ) );
	}

	static ulong ticket() {
		return _kernel_order_current_ticket;
	}

	static double lots() {
		return HistoryOrderGetDouble ( _kernel_order_current_ticket, ORDER_VOLUME_INITIAL );
	}

	static double open_price() {
		return HistoryOrderGetDouble ( _kernel_order_current_ticket, ORDER_PRICE_OPEN );
	}

	static double take_profit() {
		return HistoryOrderGetDouble ( _kernel_order_current_ticket, ORDER_TP );
	}

	static double stop_loss() {
		return HistoryOrderGetDouble ( _kernel_order_current_ticket, ORDER_SL );
	}

	static double commission() {
		return 0.0;
	}

	static double swap() {
		return 0.0;
	}

	static datetime open_time() {
		return HistoryOrderGetInteger ( _kernel_order_current_ticket, ORDER_TIME_SETUP );
	}

	static datetime close_time() {
		return HistoryOrderGetInteger ( _kernel_order_current_ticket, ORDER_TIME_DONE );
	}

	static int position_id() {
		return HistoryOrderGetInteger ( _kernel_order_current_ticket, ORDER_POSITION_ID );
	}

private:
	static enum_order_operation_type convert_to_order_operation_type ( ENUM_ORDER_TYPE type ) {
		switch ( type ) {
			case ORDER_TYPE_BUY:
				return order_operation_buy;

			case ORDER_TYPE_SELL:
				return order_operation_sell;

			case ORDER_TYPE_BUY_STOP:
				return order_operation_buy_stop;

			case ORDER_TYPE_BUY_LIMIT:
				return order_operation_buy_limit;

			case ORDER_TYPE_SELL_STOP:
				return order_operation_sell_stop;

			case ORDER_TYPE_SELL_LIMIT:
				return order_operatione_sell_limit;

			default:
				return order_operation_none;
		}
	}

	static ENUM_ORDER_TYPE convert_order_operation_type ( enum_order_operation_type type ) {
		switch ( type ) {
			case order_operation_buy:
				return ORDER_TYPE_BUY;

			case order_operation_sell:
				return ORDER_TYPE_SELL;

			case order_operation_buy_stop:
				return ORDER_TYPE_BUY_STOP;

			case order_operation_buy_limit:
				return ORDER_TYPE_BUY_LIMIT;

			case order_operation_sell_stop:
				return ORDER_TYPE_SELL_STOP;

			case order_operatione_sell_limit:
				return ORDER_TYPE_SELL_LIMIT;

			case order_operation_none:
			default:
				return -1;
		}
	}
};

#endif