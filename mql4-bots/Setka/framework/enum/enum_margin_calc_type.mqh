#ifndef FRAMEWORK_ENUM_MARGIN_TYPE_MQH
#define FRAMEWORK_ENUM_MARGIN_TYPE_MQH

enum enum_margin_calc_type {
	margin_calc_type_forex = 0, // Forex
	margin_calc_type_cfd = 1, // CFD
	margin_calc_type_futures = 2, // Futures
	margin_calc_type_cfd_on_indexes = 3 // CFD на индексы
};

#endif