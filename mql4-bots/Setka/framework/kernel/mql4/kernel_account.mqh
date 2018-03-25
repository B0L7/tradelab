#ifndef FRAMEWORK_KERNEL_ACCOUNT_MQH
#define FRAMEWORK_KERNEL_ACCOUNT_MQH

class kernel_account {
public:
	static string company() {
		return AccountCompany();
	}

	static string server() {
		return AccountServer();
	}

	static int stopout_level() {
		return AccountStopoutLevel();
	}

	static int stopout_mode() {
		return AccountStopoutMode();
	}

	static double balance() {
		return AccountBalance();
	}

	static double equity() {
		return AccountEquity();
	}

	static long number() {
		return AccountNumber();
	}

	static string currency() {
		return AccountCurrency();
	}

	static bool is_testing() {
		return IsTesting();
	}

	static bool is_optimization() {
		return IsOptimization();
	}

	static bool is_trade_allowed() {
		return IsTradeAllowed();
	}

	static int digits() {
		return Digits;
	}

	static double free_margin() {
		return AccountFreeMargin();
	}

	static double free_margin_check ( string symbol,
									  enum_order_operation_type order_type,
									  double lot ) {
		return AccountFreeMarginCheck ( symbol,
										kernel_order::convert_order_operation_type ( order_type ),
										lot );
	}

	static int leverage() {
		return AccountLeverage();
	}
};

#endif