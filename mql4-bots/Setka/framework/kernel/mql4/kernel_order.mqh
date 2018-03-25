#ifndef FRAMEWORK_KERNEL_ORDER_MQH
#define FRAMEWORK_KERNEL_ORDER_MQH

class kernel_order {
public:
	static int count() {
		return OrdersTotal();
	}

	static int count_history() {
		return OrdersHistoryTotal();
	}

	static bool select_by_index ( int tiket ) {
		return OrderSelect ( tiket, SELECT_BY_POS, MODE_TRADES );
	}

	static bool select_by_ticket ( int tiket ) {
		return OrderSelect ( tiket, SELECT_BY_TICKET, MODE_TRADES );
	}

	static bool select_by_index_history ( int tiket ) {
		return OrderSelect ( tiket, SELECT_BY_POS, MODE_HISTORY );
	}

	static bool select_by_ticket_history ( int tiket ) {
		return OrderSelect ( tiket, SELECT_BY_TICKET, MODE_HISTORY );
	}

	static int send ( int magic_number,
					  enum_order_operation_type order_type,
					  double price,
					  double lot,
					  int slippage,
					  string comment,
					  color col ) {
		return OrderSend ( CURRENT_SYMBOL,
						   convert_order_operation_type ( order_type ),
						   lot,
						   price,
						   slippage,
						   0,
						   0,
						   comment,
						   magic_number,
						   0,
						   col );
	}

	static int send_stop ( int magic_number,
						   enum_order_operation_type order_stop_type,
						   double price,
						   double lot,
						   string comment,
						   color col ) {
		return OrderSend ( CURRENT_SYMBOL,
						   convert_order_operation_type ( order_stop_type ),
						   lot,
						   price,
						   0,
						   0,
						   0,
						   comment,
						   magic_number,
						   0,
						   col );
	}

	static bool set_price ( int ticket,
							double price,
							color order_color ) {
		if ( !select_by_ticket ( ticket ) ) {
			return false;
		}

		if ( layer::correct_price ( price ) == OrderOpenPrice()  ) {
			return true;
		}

		return OrderModify ( ticket,
							 price,
							 OrderStopLoss(),
							 OrderTakeProfit(),
							 0,
							 order_color );
	}

	static bool delete_stop ( int ticket,
							  color order_color ) {
		return select_by_ticket ( ticket )
			   && OrderDelete ( ticket,
								order_color );
	}

	static bool close ( int ticket,
						double lot,
						double price_close,
						int slippage,
						color order_color ) {
		return select_by_ticket ( ticket )
			   && OrderClose ( ticket,
							   lot,
							   price_close,
							   slippage,
							   order_color );
	}

	static bool set_tp ( int magic_number,
						 int ticket,
						 double tp ) {
		return select_by_ticket ( ticket )
			   && OrderModify ( ticket,
								OrderOpenPrice(),
								OrderStopLoss(),
								tp,
								0,
								Yellow );
	}

	static bool set_sl_tp ( int ticket,
							double sl,
							double tp ) {
		return select_by_ticket ( ticket )
			   && OrderModify ( ticket,
								OrderOpenPrice(),
								sl,
								tp,
								0,
								Yellow );
	}

	static bool set_sl_tp_price ( int ticket,
								  double sl,
								  double tp,
								  double price ) {
		return select_by_ticket ( ticket )
			   && OrderModify ( ticket,
								price,
								sl,
								tp,
								0,
								Yellow );
	}

	static string symbol() {
		return OrderSymbol();
	}

	static long magic_number() {
		return OrderMagicNumber();
	}

	static enum_order_operation_type type() {
		return convert_to_order_operation_type ( OrderType() );
	}

	static int ticket() {
		return OrderTicket();
	}

	static double lots() {
		return OrderLots();
	}

	static double open_price() {
		return OrderOpenPrice();
	}

	static double take_profit() {
		return OrderTakeProfit();
	}

	static double stop_loss() {
		return OrderStopLoss();
	}

	static double commission() {
		return OrderCommission();
	}

	static double swap() {
		return OrderSwap();
	}

	static datetime open_time() {
		return OrderOpenTime();
	}

	static datetime close_time() {
		return OrderCloseTime();
	}

	static int convert_order_operation_type ( enum_order_operation_type type ) {
		switch ( type ) {
			case order_operation_buy:
				return OP_BUY;

			case order_operation_sell:
				return OP_SELL;

			case order_operation_buy_stop:
				return OP_BUYSTOP;

			case order_operation_buy_limit:
				return OP_BUYLIMIT;

			case order_operation_sell_stop:
				return OP_SELLSTOP;

			case order_operatione_sell_limit:
				return OP_SELLLIMIT;

			case order_operation_none:
			default:
				return -1;
		}
	}

private:
	static enum_order_operation_type convert_to_order_operation_type ( int type ) {
		switch ( type ) {
			case OP_BUY:
				return order_operation_buy;

			case OP_SELL:
				return order_operation_sell;

			case OP_BUYSTOP:
				return order_operation_buy_stop;

			case OP_BUYLIMIT:
				return order_operation_buy_limit;

			case OP_SELLSTOP:
				return order_operation_sell_stop;

			case OP_SELLLIMIT:
				return order_operatione_sell_limit;

			default:
				return order_operation_none;
		}
	}
};

#endif