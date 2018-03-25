#ifndef FRAMEWORK_ENUM_TRADE_MODE_TYPE_MQH
#define FRAMEWORK_ENUM_TRADE_MODE_TYPE_MQH

enum enum_trade_mode_type {
	trade_mode_type_disabled = SYMBOL_TRADE_MODE_DISABLED, // Торговля по символу запрещена
	trade_mode_type_long_only = SYMBOL_TRADE_MODE_LONGONLY, // Разрешены только покупки
	trade_mode_type_short_only = SYMBOL_TRADE_MODE_SHORTONLY, // Разрешены только продажи
	trade_mode_type_close_only = SYMBOL_TRADE_MODE_CLOSEONLY, // Разрешены только операции закрытия позиций
	trade_mode_type_full = SYMBOL_TRADE_MODE_FULL // Нет ограничений на торговые операци
};

#endif