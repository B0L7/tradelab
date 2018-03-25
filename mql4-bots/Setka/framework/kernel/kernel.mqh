#ifndef FRAMEWORK_KERNEL_MQH
#define FRAMEWORK_KERNEL_MQH

#define CURRENT_SYMBOL layer_order::get_order_layer_symbol_current_symbol().full

#ifdef MQL4
#include "mql4/kernel_time.mqh"
#include "mql4/kernel_error.mqh"
#include "mql4/kernel_account.mqh"
#include "mql4/kernel_order.mqh"
#include "mql4/kernel_market.mqh"
#include "mql4/kernel_symbol.mqh"
#include "mql4/kernel_quotes.mqh"
#endif

#ifdef MQL5
#include "mql5/kernel_time.mqh"
#include "mql5/kernel_error.mqh"
#include "mql5/kernel_account.mqh"
#include "mql5/kernel_order.mqh"
#include "mql5/kernel_market.mqh"
#include "mql5/kernel_symbol.mqh"
#include "mql5/kernel_quotes.mqh"
#endif

#endif