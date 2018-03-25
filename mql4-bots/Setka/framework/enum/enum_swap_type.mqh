#ifndef FRAMEWORK_ENUM_SWAP_TYPE_MQH
#define FRAMEWORK_ENUM_SWAP_TYPE_MQH

enum enum_swap_type {
	swap_type_in_points = 0, // в пунктах
	swap_type_in_base_symbol_currency = 1, // в базовой валюте инструмент
	swap_type_in_percent = 2, // в процентах
	swap_type_in_margin_currency = 3 // в валюте залоговых средств
};

#endif