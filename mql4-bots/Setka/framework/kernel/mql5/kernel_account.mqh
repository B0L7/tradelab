#ifndef FRAMEWORK_KERNEL_ACCOUNT_MQH
#define FRAMEWORK_KERNEL_ACCOUNT_MQH

class kernel_account {
public:
	static string company() {
		return AccountInfoString ( ACCOUNT_COMPANY );
	}

	static string server() {
		return AccountInfoString ( ACCOUNT_SERVER );
	}

	static int stopout_level() {
		return AccountInfoDouble ( ACCOUNT_MARGIN_SO_SO );
	}

	static int stopout_mode() {
		return AccountInfoInteger ( ACCOUNT_MARGIN_SO_MODE );
	}

	static double balance() {
		return AccountInfoDouble ( ACCOUNT_BALANCE );
	}

	static double equity() {
		return AccountInfoDouble ( ACCOUNT_EQUITY );
	}

	static long number() {
		return AccountInfoInteger ( ACCOUNT_LOGIN );
	}

	static string currency() {
		return AccountInfoString ( ACCOUNT_CURRENCY );
	}

	static bool is_testing() {
		return MQLInfoInteger ( ( int ) MQL5_TESTING );
	}

	static bool is_optimization() {
		return MQLInfoInteger ( ( int ) MQL5_OPTIMIZATION );
	}

	static bool is_trade_allowed() {
		return MQLInfoInteger ( ( int ) MQL5_TRADE_ALLOWED );
	}

	static int digits() {
		return _Digits;
	}

	static double free_margin() {
		return AccountInfoDouble ( ACCOUNT_MARGIN_FREE );
	}

	static double free_margin_check ( string symbol,
									  enum_order_operation_type order_type,
									  double lot ) {
		return -1;
	}

	static int leverage() {
		return AccountInfoInteger ( ACCOUNT_LEVERAGE );
	}
};

#endif