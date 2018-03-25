#ifndef FRAMEWORK_TOOL_MARGIN_MQH
#define FRAMEWORK_TOOL_MARGIN_MQH

class tool_margin {
private:
	static bool can_calc_margin ( string symbol ) {
		string account_currency = layer_account::currency();

		// На данный момент работаем только с USD
		if ( account_currency != "USD" ) {
			return false;
		}

		// Смотрим данная пара состоит ли из валюты счета
		return kernel_symbol::currency_base ( symbol ) == account_currency
			   || kernel_symbol::currency_profit ( symbol ) == account_currency;
	}

public:
	static double calc_margin ( layer_order_setting *order_settings,
								double before_line ) {
		list<order *> *orders = layer_order::get ( order_settings );
		LIST_SUM_EX ( orders, double result = 0.0, order *, item, {
			if ( !item.is_order_stop()
					|| !item.is_before_line ( before_line ) ) {
				continue;
			}

			double margin = calc_margin ( item.symbol, layer::account_leverage(), item.lot, item.open_price );
			result += margin;
			double profit = item.get_profit_in_currency();
			result -= profit;
		} );

		return result;
	}

	static double calc_margin ( string symbol, double leverage, double lot, double price ) {
		if ( !can_calc_margin ( symbol ) ) {
			return lot * layer_market::margin_required ();
		}

		bool is_left_currency = kernel_symbol::currency_base ( symbol ) == layer_account::currency();
		double price_for_lot = !is_left_currency ?
							   price * layer_market::lot_size () :
							   layer_market::lot_size ();
		return ( lot * price_for_lot ) / leverage;
	}
};

#endif