#ifndef RU_RU_MQH
#define RU_RU_MQH

#include "../framework/localization/ru_ru.mqh"

#define SRC_SETKA_TERMINAL_VERSION_MSG "���� ��������� %s"
#define SRC_SETKA_VERSION_MSG "������ %s (%s) �� %s"
#define SRC_SETKA_TRADE_NOT_ALLOWED "�������� � ������� ��������� ���������� ����������� ���������"
#define SRC_SETKA_MIN_LOT "����������� ��� %f"
#define SRC_SETKA_COUNT_SYMBOL_FOR_AVG  "���-�� �������� ���� ��� ���������� %d"
#define SRC_SETKA_NOT_GOOD_LOTSTEP "������������ ����������� ��� ����� %f"
#define SRC_SETKA_INIT_COMPLETED "������������� ������ �������"
#define SRC_SETKA_DEINIT_REASON "������ ���� ���������. ��� ����������: %s"
#define SRC_SETKA_NO_MONEY "��������� �������� ����"

#define SRC_SETKA_DRAWDOWN_MSG "��� �������� ��������. �������� %s"
#define SRC_SETKA_DRAWDOWN_CLOSE_ALL_BY_DRAWDOWN_MSG "�������� %s �������� %s ����������� ��������. �������� ������."
#define SRC_SETKA_DRAWDOWN_CLOSE_ALL_BY_PROFIT_MSG "������� %s �������� %s ����������� ��������. �������� ������."
#define SRC_SETKA_DRAWDOWN_CLOSE_ALL_STOP_TRADE_MSG "��������� ������ ����� �������� ���� �������."

#define SRC_SETKA_STOP_DRAWDOWN_ON "�������� %s �������� %s �������� ��������� ���������� ��������."
#define SRC_SETKA_STOP_DRAWDOWN_OFF "�������� %s �������� %s �������� ���������� ���������� ��������."

#define SRC_SETKA_VALID_NOT_GOOD "����������� ����� ���� ��� ��������� ����������."
#define SRC_SETKA_TEST_NOT_GOOD "�� �������� ����� �� ������������ ������ �������� �������."
#define SRC_SETKA_TEST_GOOD "����� �� ������������ ������� ���������� � ������ �������� ������� ������ �������."
#define SRC_SETKA_MARKET_CLOSE "����� ������"
#define SRC_SETKA_MARKET_CLOSE_ERROR "����� ������ ������� ��� ���������"

#define SRC_SETKA_SYMBOL_TRADE_MODE_DISABLED "�������� �� ������� ���������"
#define SRC_SETKA_SYMBOL_TRADE_MODE_LONGONLY "��������� ������ �������"
#define SRC_SETKA_SYMBOL_TRADE_MODE_SHORTONLY "��������� ������ �������"
#define SRC_SETKA_SYMBOL_TRADE_MODE_CLOSEONLY "��������� ������ �������� �������� �������"

#define SRC_SETKA_ACCOUNT_COMPANY "���� ��������������� � �������� %s"
#define SRC_SETKA_ACCOUNT_CURRENCY "������ ����� %s"
#define SRC_SETKA_ACCOUNT_LEVERAGE "��������� ����� 1:%s"
#define SRC_SETKA_ACCOUNT_NUMBER_ENCODED "����������� ����� ����� %s"
#define SRC_SETKA_ACCOUNT_SERVER "������ %s"
#define SRC_SETKA_ACCOUNT_STOPOUT "������� �������� %s"
#define SRC_SETKA_ACCOUNT_STOPOUT_MODE "����� ������� �������� %s"
#define SRC_SETKA_BID "Bid %s"
#define SRC_SETKA_ASK "Ask %s"

#define SRC_SETKA_MODE_LOW "(MODE_LOW) ����������� ������� ���� - %s"
#define SRC_SETKA_MODE_HIGH "(MODE_HIGH) ������������ ������� ���� - %s"
#define SRC_SETKA_MODE_TIME "(MODE_TIME) ����� ����������� ��������� ��������� - %s"
#define SRC_SETKA_MODE_BID "(MODE_BID) ��������� ����������� ���� ����������� - %s"
#define SRC_SETKA_MODE_ASK "(MODE_ASK) ��������� ����������� ���� ������� - %s"
#define SRC_SETKA_MODE_POINT "(MODE_POINT) ������ ������ � ������ ��������� - %s"
#define SRC_SETKA_MODE_DIGITS "(MODE_DIGITS) ���������� ���� ����� ������� � ���� ����������� - %s"
#define SRC_SETKA_MODE_SPREAD "(MODE_SPREAD) ����� � ������� - %s"
#define SRC_SETKA_MODE_STOPLEVEL "(MODE_STOPLEVEL) ���������� ���������� ������� ����-�����/����-������� � ������� - %s"
#define SRC_SETKA_MODE_LOTSIZE "(MODE_LOTSIZE) ������ ��������� � ������� ������ ����������� - %s"
#define SRC_SETKA_MODE_TICKVALUE "(MODE_TICKVALUE) ������ ������������ ��������� ���� ����������� � ������ �������� - %s"
#define SRC_SETKA_MODE_TICKSIZE "(MODE_TICKSIZE) ����������� ��� ��������� ���� ����������� � ������� - %s"
#define SRC_SETKA_MODE_SWAPLONG "(MODE_SWAPLONG) ������ ����� ��� ������� �� ������� - %s"
#define SRC_SETKA_MODE_SWAPSHORT "(MODE_SWAPSHORT) ������ ����� ��� ������� �� ������� - %s"
#define SRC_SETKA_MODE_STARTING "(MODE_STARTING) ����������� ���� ������ ������ (������ ������������ ��� ���������) - %s"
#define SRC_SETKA_MODE_EXPIRATION "(MODE_EXPIRATION) ����������� ���� ����� ������ (������ ������������ ��� ���������) - %s"
#define SRC_SETKA_MODE_TRADEALLOWED "(MODE_TRADEALLOWED) ���������� ������ �� ���������� ����������� - %s"
#define SRC_SETKA_MODE_MINLOT "(MODE_MINLOT) ����������� ������ ���� - %s"
#define SRC_SETKA_MODE_LOTSTEP "(MODE_LOTSTEP) ��� ��������� ������� ���� - %s"
#define SRC_SETKA_MODE_MAXLOT "(MODE_MAXLOT) ������������ ������ ���� - %s"
#define SRC_SETKA_MODE_SWAPTYPE "(MODE_SWAPTYPE) ����� ���������� ������ - %s"
#define SRC_SETKA_MODE_PROFITCALCMODE "(MODE_PROFITCALCMODE) ������ ������� ������� - %s"
#define SRC_SETKA_MODE_MARGINCALCMODE "(MODE_MARGINCALCMODE) ������ ������� ��������� ������� - %s"
#define SRC_SETKA_MODE_MARGININIT "(MODE_MARGININIT) ������ ������� ��������� ������� - %s"
#define SRC_SETKA_MODE_MARGINMAINTENANCE "(MODE_MARGINMAINTENANCE) ��������� ��������� ���������� ��� 1 ���� - %s"
#define SRC_SETKA_MODE_MARGINHEDGED "(MODE_MARGINHEDGED) ������ ��������� ������� ��� ��������� �������� ������� � ������� �� 1 ��� - %s"
#define SRC_SETKA_MODE_MARGINREQUIRED "(MODE_MARGINREQUIRED) ������ ��������� �������, ����������� ��� �������� 1 ���� �� ������� - %s"
#define SRC_SETKA_MODE_FREEZELEVEL "(MODE_FREEZELEVEL) ������� ��������� ������� � ������� - %s"

#define SRC_HANDLER_BASE_SHORT "�������"
#define SRC_HANDLER_BASE_LONG "�������"
#define SRC_HANDLER_BASE_NOT_GOOD_LOT "�� ���������� ������� ��� �������� ������ � ����� %f"
#define SRC_HANDLER_BASE_NOT_GOOD_STOP_LOT "�� ���������� ������� ��� �������� ����������� ������ � ����� %f"
#define SRC_HANDLER_BASE_UPDATE_TP "�������� �� %s -> %s"
#define SRC_HANDLER_BASE_TIMER_UPDATE_TP "������������ �� %s -> %s �� �������."
#define SRC_HANDLER_BASE_TRY_OPEN_LVL "������� ������� ������ � %s, ��� %s, ����������� '%s'"
#define SRC_HANDLER_BASE_VERY_STRONG_MOTION "����� ������� �������� ����, ����������� ������ �������������. ��������������� %f, ��� ����� %f, ����� %f."
#define SRC_HANDLER_BASE_ERROR_UPDATE_TP "��� ������� �������� �� ��������� ������: %s"
#define SRC_HANDLER_BASE_ERROR_OPEN_LVL "��� ������� ������� ����� ��������� ������: %s"
#define SRC_HANDLER_BASE_OPENED_NEW_CANDLE_NO_SIGNAL "C����� �� ���� �����������"
#define SRC_HANDLER_BASE_BAD_PRICE "���� ����� ���� ����������. ������� %s, ������� %s"
#define SRC_HANDLER_BASE_PRICE_GOTO_START "���� ���� ������� � ����������� ������. ������� %s, ������� %s"
#define SRC_HANDLER_BASE_SPREAD_NOT_GOOD "����� %d ���� ������������ %d. ����� %d ���, �� %s."
#define SRC_HANDLER_BASE_VOL_NOT_GOOD "������ ����� %f ���� ������������ %d. ����� %d ���, �� %s."
#define SRC_HANDLER_BASE_TIMER_STOP_ON_CLOSE "������� �� %d ���. ��-�� �������� �����."
#define SRC_HANDLER_BASE_TIMER_CLOSE_ORDERS "����� %d ���. ���� ��������� ������� �����"
#define SRC_HANDLER_BASE_ERROR_CLOSE_ORDERS "��� ������� ������� ����� ��������� ������: %s"
#define SRC_HANDLER_BASE_TRY_OPEN_STOP_LVL "������� ��������� ���������� ������ � %s, ��� %s, ��� %s, ����������� '%s'"

#define SRC_HANDLER_BASE_DETECT_GAP "��������� ��� �� %s �� %s ( %s ) ����������� ��� %s �� %s%% ( ����������� ���������� �� ����� %s )."

#define SRC_HANDLER_BASE_FAIL_SLIPPAGE_OPEN_LVL "�� ������� ������� ����� ��-�� ���������������."
#define SRC_HANDLER_BASE_FAIL_EXIT_OPEN_LVL "����������� ������ ��������."
#define SRC_HANDLER_BASE_MAX_PAIR_BLOCK "��������� ������ %d ������������ �������� ���. �������� ����� �������������."

#define SRC_HANDLER_BASE_CURRENCY_BLOCK_LONG "������� %s %d ���(�), ������� %s %d ���(�). �������� ����� �������������."
#define SRC_HANDLER_BASE_CURRENCY_BLOCK_SHORT "������� %s %d ���(�), ������� %s %d ���(�). �������� ����� �������������."

#define SRC_HANDLER_BASE_DRAWDOWN_BLOCK "�������� ����� %s%% ���� ������������ �������� %d%%. �������� ����� �������������."
#define SRC_HANDLER_BASE_DRAWDOWN_BLOCK_OFF "�������� ����� %s%% ���������� ���� �������� %d%%. ���������� �� �������� ������� ������ ���������."

#define SRC_HANDLER_BASE_TRADE_PAUSE "�������� ��������� c %s �� %s"
#define SRC_HANDLER_BASE_MODULE_CLOSE_START "���� �������� �������� ����� ����� ������"
#define SRC_HANDLER_BASE_MODULE_CLOSE_ERROR "���� �������� �� ���� ������� �����."
#define SRC_HANDLER_BASE_MODULE_CLOSE_COMPLETE "���� �������� �������� ������"
#define SRC_HANDLER_BASE_FREE_MAGIN_CHECK_NEW_ORDER "��� �������� ������ �%s �� ���� %s � ���� %s ����� �������� ����� %s"
#define SRC_HANDLER_BASE_TP_SKIP_ORDER_STOP "��� ������� �� %i ���������� ������� ������� � ������� ������ �� ���� ������ ��� ��� ��� ��������� �� ������ ��"
#define SRC_HANDLER_BASE_CALC_LOT_LOWEST "��������� ��� %s ������ ���������� %s. �������� ��������� %s � ����������."
#define SRC_HANDLER_BASE_NO_MONEY_ON_INC_LOT "������������ ����� ��� �������� ������������ ������ � ����� %s. ������ ������� ������� �����."
#define SRC_HANDLER_BASE_ERROR_INVALID_STOPS "���� ����������� ������ %s ������� ������ � �����. ����������� ���������� �� �������� ���� %s"
#define SRC_HANDLER_BASE_NOT_CLOSE_ORDER_STOP "���������� �� ��������� ���������� ������ � ���-�� %s."
#define SRC_HANDLER_BASE_PRICE_REACED_TP "���� %s �������� ����� �P %s. �������� ������ ��������."
#define SRC_HANDLER_BASE_SHOW_CALC_STOP_ORDER "���������� ����� �%s �� ���� %s � ����� %s (��� %s)."
#define SRC_HANDLER_BASE_SHOW_CALC_STOP_ORDER_WITH_TIKET "���������� ����� �%s (%s) �� ���� %s � ����� %s (��� %s)."

#define SRC_HANDLER_BASE_ALIGMENT "��������� ����������� ���������� ������."
#define SRC_HANDLER_BASE_SHOW_ALIGMENT_STOP_ORDER "���������� ����� �%s (%s) %s -> %s"

#define SRC_HANDLER_BASE_NOT_COMPLETE_STOP_ORDER "�� ������� ��������� ���������� ����� �%s �� ���� %s � ����� %s (��� %s). ��������� ������� ����� �� ����� ����."
#define SRC_HANDLER_BASE_STOP_ORDER_CLEAR "���� %s �������� ����������� ������ �%s �� ���� %s � ����� %s (��� %s), ��������� � ������� ��������� ������� �����."
#define SRC_HANDLER_BASE_DELETE_STOP_ORDER "������ ��i��� ���������� ����� �%s"
#define SRC_HANDLER_BASE_CANCEL_LEVERAGE "������� ��������� ����� 1:%s ������ ������������ 1:%s. ����������� ������� ������ ��������."
#define SRC_HANDLER_BASE_CANCEL_MIN_TIME_STEP "��������� ����� �������� ������ ������ %s. ����������� ������ ��������."
#define SRC_HANDLER_BASE_CANCEL_CANDLE_SIZE_MIN "������ ������ %d ������ ����������� �������� %d. ����������� ������� ������ ��������."
#define SRC_HANDLER_BASE_CANCEL_CANDLE_SIZE_MAX "������ ������ %d ������ ����������� �������� %d. ����������� ������� ������ ��������."
#define SRC_HANDLER_BASE_RESET_STATE_CLOSE_ORDER "�������� ������� (�������) ��������"

#define SRC_ORDER_TRADE_CONTEXT_BUSY "���������� �������� ������."
#define SRC_ORDER_TRADE_CONTEXT_BUSY_EXIT "���������� �������� ������. ����� �� ��������."
#define SRC_ORDER_TRY_CLOSE_ORDER "������ ������� ����� �%s."

#define SRC_ORDER_TRY_SET_TP  "�%s ������ ���������� TP ( %s => %s )."
#define SRC_ORDER_TRY_SET_TP_EQUALS "�%s �� ������������ %s"
#define SRC_ORDER_TRY_SET_TP_WITH_SL "�%s ������ ���������� ������������ TP ( %s ) � SL ( %s ) ��� ����������� ������."
#define SRC_ORDER_TRY_SET_TP_WITH_SL_EQUALS "�%s ������������ �� ( %s ) � SL ( %s ) ��� ����������� ������ ������������."

#define SRC_ORDER_FAIL_CLOSE_ORDER "�� ������� ������� �����."

#define SRC_DEFINES_VALID_MSG "%s = %s"
#define SRC_DEFINES_ERROR_MSG "������������ �������� ��������� %s ��� ������ ������������� �������:\n%s"
#define SRC_DEFINES_OR " ��� "
#define SRC_DEFINES_AND " � "
#define SRC_DEFINES_EQUALLY " = "
#define SRC_DEFINES_NOT_EQUALLY " �� ����� "
#define SRC_DEFINES_ERROR_INPUT "������ ������� ����������"
#define SRC_DEFINES_REFLECT_SELL_SETTINGS_TO_BUY "��� buy �������� ���������� ��������� sell ���������:"

#define SRC_SCHEDULER_IS_NOT_TRADE_TIME_ON_WEEK "����� Trade. ��� ������� ������������ ������� �������� ��� ������ ������� ����� ( %s %02d:%02d - %s %02d:%02d )."
#define SRC_SCHEDULER_NEW_POSITION_PAUSE "����� NewPositionPause. ���� ��������� ��������� ����� ������� ( %s - %s )."
#define SRC_SCHEDULER_IS_TRADE_PAUSE "����� TradePause. ���� ��������� ��������� ����� ������ ( %s - %s )."
#define SRC_SCHEDULER_IS_NOR_INTRADAY "����� IntraDay. ��� ������� ������������ ������� �������� ��� ������ ������� ����� ( %02d:%02d - %02d:%02d )."
#define SRC_SCHEDULER_IS_NOR_INTRADAY_STOP_TRADE "����� IntraDayStopTrade. ��� ������� ��������� ������������ ������� �������� ( %02d:%02d - %02d:%02d )."
#define SRC_SCHEDULER_CLOSE_ALLORDERS_EVERYDAY "����� CloseAllOrders_EveryDay. ��� ���������� ������ �������� ����� ( %02d:%02d )."
#define SRC_SCHEDULER_SUNDAY "�����������"
#define SRC_SCHEDULER_MONDAY "�����������"
#define SRC_SCHEDULER_TUESDAY "�������"
#define SRC_SCHEDULER_WEDNESDAY "�����"
#define SRC_SCHEDULER_THURSDAY "�������"
#define SRC_SCHEDULER_FRIDAY "�������"
#define SRC_SCHEDULER_SATURDAY "�������"

#endif