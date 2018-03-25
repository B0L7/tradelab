//+------------------------------------------------------------------+
//|                                                Generic A-TLP.mq4 |
//|                                                 Trade Like A Pro |
//|                                          http://tradelikeapro.ru |
//|                                                      open source |
//|   Версия 9.5  - добавлены фильтры по CCI                         |
//|   Версия 10.0 - проведена небольшая оптимизация кода             |
//|   Версия 11.1 - разрешены встречные сделки, введен параметр,     |
//|               ограничивающий открытие сделок в одну сторону      |
//|               в течение заданного количества минут               |
//|   Версия 11.2 - все вышесказанное соединено в один советник      |
//|               и далее будет неотемлемой его частью;              |
//|               - параметр расчета периода StDev вынесен во внешние|
//|               переменные                                         |
//|   Версия 11.3 - исправлена ошибка, связанная с CCI               |
//|   Версия 11.4 - исправлена ошибка информ-панели;                 |
//|               - добавлена возможность торговли на каждом тике;   |
//|               - проверка на минимальную волатильность теперь     |
//|               осуществляется при входе в блок открытия позиций   |
//|   Версия 11.6 - добавлен трейлинг стоп                           |
//|   Версия 11.7 - исправлены ошибкы                                |
//|   Версия 11.86- настраиваемые таймфреймы для ВВ и CCI            |
//|               - скрытие инфо панели                              |
//|               - отключение торговли после убыточной сделки       |
//|               - принт о превышении спреда                        |
//|   Версия 11.87- исправлен RollOver Filter                        |
//|   Версия 11.88- добавлен параметр MM_Depo, как расчёт лота       |
//|               размер лота (Lots) на размер депо (MM_Depo)        |
//|               - встроен VisualDebug трендовыми линиями           |
//|               - добавлен Max_Spread_mode2 как альтернатива       |
//|               ролловер фильтру, при значении больше нуля         |
//|               Max_Spread фильтрует только покупки при открытии,  |
//|               а Max_Spread_mode2 продажи при закрытии.           |
//|   Версия 11.89- возврат расчета Auto_Risk как в 11.87            |
//|   Версия 11.89.1 - fix MDR, проверка цены открытия дня           |
//|                  - убрана проверка объема М1 при every_tick=Yes  |
//|   Версия 11.90- добавлен параметр MorningClose (закрытие утром)  |
//|   Версия 11.91- переделана пауза после убытка, добавлен параметр |
//|                 LossPauseUseDirection, пауза будет только для    |
//|                 сделок. направление которых совпадает с убыточной|
//|               - фикс ошибки 4066, openD1 запрашиваеться только   |
//|                 один раз в день                                  |
//|               - MorningClose теперь учитывает комиссию и своп    |
//|               - убраны попытки открытия при запрете торговать    |
//|   Версия 11.92- добавлен фильтр по MA Daily, альтернатива MDR    |
//|               - проверка достаточности средств перед открытием   |
//|                 ордера                                           |
//|               - замена комбинации iMa + iStdDev на iBands для    |
//|                 рассчета полос боллинджера                       |
//|               - пересчет времени сессии при смене настроек       |
//|   Версия 11.93- добавлена статистика по проскальзыванию и        |
//|                 задержках при открытии и закрытии ордеров        |
//|               - параметр BrokerStatToFile записывает эту         |
//|                 статустику в файл BrokerStat.csv                 |
//|   Версия 11.94- параметр Max_Spread_mode2_profit если профит в   |
//|                 пунктах больше этого значения, закрытие даже при |
//|                 большом спреде                                   |
//|               - поправлена высота инфо панели                    |
//|               - установлены типы ошибок при которых разрешено    |
//|                 повторять запрос на открытие                     |
//|   Версия 11.94.1
//|               - Игнорирование ошибки 4051 при отсутствии комментария
//|               - Исправлено забывание предыдущей ошибки в функциях iOpenX, iVolumeX
//|               - Возврат отображения стрелок закрытия ордеров
//|   Версия 11.94.2
//|               - Если в начале дня не удалось получить цену открытия для расчета MDR, то будут повторные попытки в торговое время, и запрет открытия если не удастся получить
//|               - MorningClose теперь работает с указанного часа, а не следующего
//|               - Если Entry_Break отрицательный, раньше надписи фильтров проваливались в глубь канала, поправлено
//|   Версия 11.94.3
//|               - Проверка достаточности загруженной истории для расчета канала BB
//|   Версия 11.94.4
//|               - Удалена проверка на большое расстояние от цены BB
//|               - WorkTime теперь расчитываеться микросекундным таймером
//|               - Добавлен параметр ExitChannelTP, ставит тейк на уровень где должен быть выход по касанию канала
//|   Версия 11.94.5
//|               - Исправление ExitChannelTP
//|   Версия 11.94.6
//|               - добавлен параметр NoCloseWhileOpenSignal, запрещает закрытие сделки если есть сигнал на открытие в этом же направлении
//|                 проверка сигнала на открытие в этом случае только по границе канала, доп условия типа спреда не проверяются
//|               - добавлен параметр NoTrailWhileOpenSignal, запрещает трал если есть сигнал на открытие в этом же направлении, аналогично только по каналу
//|   Версия 11.94.7
//|               - Sell сделки при использовании Max_Spread_mode2 не будут открываться при спреде больше половины стоп-лосса, ранее открывались при любом спреде
//|               - Исправление ExitChannelTP
//+------------------------------------------------------------------+

//         author of the idea

//            Sergey5  bashni2001@mail.ru  

//         Senior Programmer

//            yur4ello

//         Huge gratitude to for the help in realization of the idea

//            Alexandr69

//            nixxer

//            grabli

//            LeoK

#property copyright "Trade Like A Pro"
#property link      "http://tradelikeapro.ru"
#property version   "11.94"
#property strict
#define _TRADE_               1
#define _PAUSE_               2

#include <stderror.mqh>
#include <stdlib.mqh>

enum     _EventYesNo{
                              YES                        = 1,                 //YES
                              NO                         = 2                  //NO
         };

enum     _EventFilter{
                              ON                         = 1,                 //ON
                              OFF                        = 2                  //OFF
         };
         

enum     _EventLogs{
                              ALL                        = 1,                 //ВСЕ
                              MAIN                       = 2,                 //ОШИБКИ
							         NONE						      = 3				      //НИЧЕГО
         };
enum     _MorningClose{
                              Off						     = 0,                  //OFF
                              BE                        = 1,                  //Перевод в безубыток
                              CLOSE                     = 2,                  //Закрыть сразу
							         CLOSE_BE 				     = 3				         //Закрыть только в профите
         };
         
struct LastOrder{
   datetime time;
   int profit;
   string sltp;
   int ticket;
   double slip;
};
LastOrder last_buy, last_sell;
int LastHistoryTotal=0; 

extern string     S_1         = "<==== Basic settings ====>"; // 
input    string               Comm                       = "G";               //Comment
input    int                  MagicNumber                = 11052016;
extern   bool                 Show_Info_Panel            = true;
input    color                Col_info                   = C'176,162,168';    //Colore of infopanel
input    double               Max_Spread                 = 40;
input    double               Max_Spread_mode2           = 0;
input    double               Max_Spread_mode2_profit    = 10;
input    int                  Slippage                   = 2;
input    _EventYesNo          every_tick                 = 1;                 //Every tick?


extern string     S_2         = "<==== MM ====>"; // 
input    double               Lots                       = 0.1;
input    double               Auto_Risk                  = 0.0;
input    int                  MM_Depo                    = 0;                 //Depo per Lots
input    bool                 no_Hedge                   = false;             //No hedge

extern string     S_3         = "<==== SL, TP, BE, TRAL ====>"; // 
extern   double               Stop_Loss                  = 30;
extern   double               Take_Profit                = 35;
input    bool                 use_dyn_TP                 = false;             //Dinamic TP
input    int                  TP_perc                    = 80;                //%% TP from canal size
input    int                  min_TP                     = 10;
input    bool                 use_BE                     = false;             //Breakeven
input    double               X                          = 7;                 //Breakeven start
input    double               Y                          = 1;                 //Breakeven size
input    bool                 use_Trailing_Stop          = true;
input    double               Trail_Start                = 7;
input    double               Trail_Size                 = 5;
input    double               Trail_Step                 = 0.1;

extern string     S_4         = "<==== Enter Settings ====>"; //
extern string     S_5         = "<==== Enter Settings. Bollinger Bands ====>"; //
input    ENUM_TIMEFRAMES      TimeFrame                  = PERIOD_M15;        //TF for Bollinger Bands
input    int                  Channel_Period             = 13;
input    int                  Entry_Break                = 1;
input    int                  Min_Volatility             = 20;

extern string     S_6         = "<==== Enter Settings. CCI ====>"; //
input    ENUM_TIMEFRAMES      TimeFrame_CCI              = PERIOD_M15;        //TF for CCI
input    _EventYesNo          use_CCI_for_open           = 2;                 //CCI for open deal
input    int                  cci_Period_open            = 14;                //CCI for open period
input    ENUM_APPLIED_PRICE   cci_Price_open             = PRICE_CLOSE;       //CCI for open type
input    int                  top_level_open             = 100;               //CCI for open high
input    int                  lower_level_open           = -100;              //CCI for open low
input    int                  shift_open                 = 1;                 //CCI for open number candle

extern string     S_7         = "<==== Enter Settings. Other ====>"; //

input    int                  MaxDailyRange              = 0;                 //MaxDailyRange, pips = 0 - выкл.
input    int                  DailyMA                    = 0;                 //MA Daily period = 0 - выкл.
input    double               DeltaMA                    = 0.5;               //MA Daily slope
input    int                  time_break                 = 240;               //PauseAfterBigLoss minute
extern   int                  loss                       = 30;                //BigLossSize pp
extern   bool                 LossPauseUseDirection      = false;

extern string     S_8         = "<==== Close Deal Settings ====>"; //
input    _MorningClose        MorningClose               = 0; 
input    int                  MorningCloseHourStart      = 6;
input    int                  MorningCloseHourEnd        = 20;
extern string     S_81        = "==============================="; //
extern   bool                 NoCloseWhileOpenSignal     = false;
extern   bool                 NoTrailWhileOpenSignal     = false;
extern string     S_82        = "==============================="; //
input    _EventFilter         Filter_1                   = 1;                 //Filter output №1. Time Filter
input    int                  Exit_Minutes               = 140;
input    int                  Time_Profit_Pips           = 0;
input    _EventFilter         Filter_2                   = 1;                 //Filter output №2. Channel Filter
input    int                  Exit_Distance              = -13;
input    int                  Exit_Profit_Pips           = -12;
input    bool                 ExitChannelTP              = false;
input    _EventFilter         Filter_3                   = 1;                 //Filter output №3. MA Filter
input    int                  ma_period                  = 2;
input    int                  Reverse_Profit             = 20;
input    _EventFilter         Filter_4                   = 2;                 //Filter output №4. CCI Filter
input    int                  cci_Period_close           = 14;                //CCI for output period
input    ENUM_APPLIED_PRICE   cci_Price_close            = PRICE_CLOSE;       //CCI for output type
input    int                  top_level_close            = 100;               //CCI for output high
input    int                  lower_level_close          = -100;              //CCI for output low
input    int                  shift_close                = 1;                 //CCI for output number candle

extern string     S_9         = "<==== Close Deal Settings. Roll Over Filter  ====>"; //

input    _EventYesNo          use_rollover_filter        = 1;                 //CloseDealOnRollover
input    string               rollover_start             = "23:55";           //rollover start
input    string               rollover_end               = "00:35";           //rollover end
         
         double               maxlot                     = 0.01;
         double               lotstep                    = 0.01;
         double               old_point                  = 0.0001;
         double               minlot                     = 0.0;
         int                  lotsize                    = 0;
         int                  stoplevel                  = 0;
         double               lots                       = 0;
         int                  count_sell;
         int                  count_buy;
         int                  day_of_trade;
         string               tr_hr                      = "";
         string               tp_info                    = "";
         string               be_info                    = "";
         string               f1_info                    = "\n  Filter №1 - OFF";
         string               f2_info                    = "\n  Filter №2 - OFF";
         string               f3_info                    = "\n  Filter №3 - OFF";
         string               f4_info                    = "\n  Filter №4 - OFF";
         string               filter_info                = "";
         string               risk_info                  = "";
         string               set_name_info              = "";
         string               warn_trading               = "";
         int                  slippage;
         datetime             need_to_verify_channel;
//--------------------------------------
extern   string S_17          = "<==== Other Settings ====>";                  // >   >   >   >   >   >    >    >    >    > 
input    _EventLogs           LogMode                    = 1;                 //Режим логирования
extern   bool                 VisualDebug                = true;
extern   bool                 BrokerStatToFile           = true;
input    color                ColorDrawChannel           = clrYellow;
input    color                ColorDrawChannelExit       = clrCornflowerBlue;
input    color                ColorDrawWarn              = clrRed;
input    string               S10                        = "===============================";

input    string               S11                        = " TIME FILTER";

input    string               S12                        = " DayOfWeek Filter";
input    _EventYesNo          monday                     = 1;                 //MONDAY
input    string               monday_open                = "22:00";
input    string               monday_pause_start         = "0";
input    string               monday_pause_stop          = "0";
input    string               monday_close               = "23:59";

input    _EventYesNo          tuesday                    = 1;                 //TUESDAY
input    string               tuesday_open               = "00:00";
input    string               tuesday_pause_start        = "01:00";
input    string               tuesday_pause_stop         = "22:00";
input    string               tuesday_close              = "23:59";

input    _EventYesNo          wednesday                  = 1;                 //WEDNESDAY
input    string               wednesday_open             = "00:00";
input    string               wednesday_pause_start      = "01:00";
input    string               wednesday_pause_stop       = "22:00";
input    string               wednesday_close            = "23:59";

input    _EventYesNo          thursday                   = 1;                 //THURSDAY
input    string               thursday_open              = "00:00";
input    string               thursday_pause_start       = "01:00";
input    string               thursday_pause_stop        = "22:00";
input    string               thursday_close             = "23:59";

input    _EventYesNo          friday                     = 1;                 //FRIDAY
input    string               friday_open                = "00:00";
input    string               friday_pause_start         = "01:00";
input    string               friday_pause_stop          = "22:00";
input    string               friday_close               = "23:59";

input    _EventYesNo          sunday                     = 2;                 //SUNDAY
input    string               sunday_open                = "08:30";
input    string               sunday_pause_start         = "15:30";
input    string               sunday_pause_stop          = "17:55";
input    string               sunday_close               = "21:35";


         double               channel_upper;
         double               channel_lower;
         double               ma_shift_1;
         double               ma_shift_2;
         double               channel_width;
         double               stoploss;
         double               takeprofit;
         
         int                  ticksize;
         double               trailstart,
                              trailsize,
                              trailstep;
         
         int                  flag_trade;
         datetime             time1,
                              time2,
                              time3,
                              time4,
                              rtime1,
                              rtime2;
datetime                      lasttimewrite, lastbarwrite, lastprint, last_closetime = 0;
bool                          _RealTrade = (!IsTesting() && !IsOptimization() && !IsVisualMode());
double                        openD1;
bool                          setnamegood=false;
ulong                         OnTickStart;
double                        mintpb,mintps,tpb,tps;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   day_of_trade=-1;
   need_to_verify_channel=0;
   
   fRectLabelCreate(0,"s_h_i_p",0,0,28,160,20,clrBlue);
   if(Show_Info_Panel) fRectLabelCreate(0,"info_panel",0,0,49,160,375,Col_info);
   if(Show_Info_Panel){
      fRectLabelCreate(0,"hide_i_p",0,1,29,158,18,clrMediumSeaGreen,2,0,clrRed,STYLE_SOLID,1,false,false,true,1);
      fLabelCreate(0,"hide_text",0,80,38,"H I D E",0,"Verdana",7);
      fRectLabelCreate(0,"info_panel",0,0,85,160,240,Col_info);
   }
   else{
      fRectLabelCreate(0,"show_i_p",0,1,29,158,18,C'204,113,0',2,0,clrRed,STYLE_SOLID,1,false,false,true,1);
      fLabelCreate(0,"show_text",0,80,38,"S H O W",0,"Verdana",7);
   }
  
   stoplevel = (int)MarketInfo(_Symbol, MODE_STOPLEVEL);
   minlot = MarketInfo(_Symbol, MODE_MINLOT);
   maxlot = MarketInfo(_Symbol, MODE_MAXLOT);
   lotsize = (int)MarketInfo(_Symbol, MODE_LOTSIZE);
   lotstep = MarketInfo(_Symbol, MODE_LOTSTEP);
   ticksize = (int)MarketInfo(_Symbol,MODE_TICKSIZE);
   
   if (Digits <= 3) old_point = 0.01;
   else old_point = 0.0001;
   
   trailstart = Trail_Start * old_point;
   trailsize = Trail_Size * old_point;
   trailstep = Trail_Step * old_point;
   trailstep = MathMax(Trail_Step * old_point, ticksize * Point);
   
   slippage = (int)NormalizeDouble(Slippage / Point * old_point,0);
   
   Take_Profit = MathMax(Take_Profit,NormalizeDouble(stoplevel * Point / old_point,1));
   Stop_Loss = MathMax(Stop_Loss,NormalizeDouble(stoplevel * Point / old_point,1));
   
   lots = fGetLots();
   
   if(Filter_1 == 1) f1_info = "\n  Filter №1 - ON";
   if(Filter_2 == 1) f2_info = "\n  Filter №2 - ON";
   if(Filter_3 == 1) f3_info = "\n  Filter №3 - ON";
   if(Filter_4 == 1) f4_info = "\n  Filter №4 - ON";
   filter_info = f1_info + f2_info + f3_info + f4_info;
   
   if(Auto_Risk > 0.0) {
      if (MM_Depo == 0) {
         risk_info = "\n  AutoRisk - Activated" + "\n  Risk = " + DoubleToStr(Auto_Risk, 2) + "%"; 
         }
      else
         {
         risk_info = "\n  AutoRisk - Activated" + "\n  Risk = " + DoubleToStr(Lots, 2) + " Lot / " + IntegerToString(MM_Depo) + " "+AccountCurrency(); 
         }   
      }
   else
      risk_info = "\n\n  AutoRisk - Not activated";
   
   if(use_dyn_TP)
      tp_info = "\n  Dynamic Take Profit - " + IntegerToString(TP_perc) + "%";
   else
      tp_info = "\n  Dynamic Take Profit - NO";
   if(use_BE)
      be_info = "\n  Break Event - YES";
   else
      be_info = "\n  Break Event - NO";

   if(loss < 0) loss *= -1;
   Comment("");

   set_name_info=(StringLen(Comm)>28 ? StringSubstr(Comm,0,28)+"..." : Comm);
   string s="";
   switch(_Period){
      case PERIOD_M1:   s = "M1"; break;
      case PERIOD_M5:   s = "M5"; break;
      case PERIOD_M15:  s = "M15"; break;
      case PERIOD_M30:  s = "M30"; break;
      case PERIOD_H1:   s = "H1"; break;
      case PERIOD_H4:   s = "H4"; break;
      case PERIOD_D1:   s = "D1"; break;
      case PERIOD_W1:   s = "W1"; break;
      case PERIOD_MN1:  s = "MN1"; break;
   }
   warn_trading="Set name: ";
   if(StringFind(Comm, _Symbol)==-1) 
      warn_trading+="[Symbol WARNING] ";
   else
   if(StringFind(Comm, s)==-1) 
      warn_trading+="[TF WARNING] ";
   else
      warn_trading+="[OK]";
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Comment("");
   
   if(ObjectFind("info_panel") >= 0)   //
      fRectLabelDelete(0,"info_panel");
   if(ObjectFind("s_h_i_p") >= 0)   //
      fRectLabelDelete(0,"s_h_i_p");
   if(ObjectFind("show_i_p") >= 0)  //
      fRectLabelDelete(0,"show_i_p");
   if(ObjectFind("hide_i_p") >= 0)  //
      fRectLabelDelete(0,"hide_i_p");
   if(ObjectFind("show_text") >= 0)
      fLabelDelete(0,"show_text");
   if(ObjectFind("hide_text") >= 0)
      fLabelDelete(0,"hide_text");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   OnTickStart=GetMicrosecondCount();
   
   if(day_of_trade != DayOfWeek()){
      tr_hr = fInfoTradeHours();
      fChoiceOfDay();
      day_of_trade = DayOfWeek();
      if(Show_Info_Panel) fCreateInfoPanel();
      openD1 = iOpenX(NULL, _Period, iBarShift(NULL, _Period, StrToTime(TimeToStr(TimeCurrent(),TIME_DATE))));
   }
   
   int ht=OrdersHistoryTotal();
   if(LastHistoryTotal!=ht){
      LastHistoryTotal=ht;
      GetLastProfit(ht);
   }
   
   bool _IsTime = IsTime();
   if(!_IsTime && CountOrder() < 1) return;
   
   long tick_volume = 0;
   if(every_tick == 2) tick_volume = iVolumeX(NULL, PERIOD_M1, 0);
   if(DayOfWeek() == 1 && iVolumeX(NULL, PERIOD_D1, 0) < 5){Print(Hour(),":",Minute()," | Monday and Volume D1 < 5"); return;}
   
   if(Show_Info_Panel) fCreateInfoPanel();
      
   if(!fGetIndicatorData()) return;
   
   if(use_dyn_TP){
      Take_Profit = MathMax(NormalizeDouble(channel_width/old_point /100 * TP_perc,1), min_TP);
   }
   
   count_buy = 0;
   count_sell = 0;
   
   for(int pos = OrdersTotal() - 1; pos >= 0; pos--){
      if(!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)){
         string q = __FUNCTION__ + ": failed to allocate an order! " + fMyErDesc();
         Print(Hour(),":",Minute()," | ",q);
      }
      else{
         if(OrderType() <= OP_SELL && OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber){
            if(MorningClose>0 && !_IsTime){
               if(fMorningClose()) continue;
            }
            
            if(OrderType() == OP_BUY){
               count_buy++;
               if(OrderStopLoss() == 0.0){
                  stoploss = NormalizeDouble(OrderOpenPrice() - Stop_Loss * old_point, Digits);
                  takeprofit = NormalizeDouble(OrderOpenPrice() + Take_Profit * old_point, Digits);
                  
                  if(!ExitChannelTP) 
                     fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, takeprofit, 0, clrGreen);
                  else
                     fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, MathMax(tpb,mintpb), 0, clrGreen);
                     
                  continue;
               }

               if(use_BE && X > Y && Bid - OrderOpenPrice() >= X * old_point && OrderStopLoss() < OrderOpenPrice()){
                  stoploss = NormalizeDouble(OrderOpenPrice() + Y * old_point, Digits);
                  fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, OrderTakeProfit(), 0, clrGreen);
               }
               
               if(use_Trailing_Stop && !(NoTrailWhileOpenSignal && Bid < channel_lower - Entry_Break * old_point)) fTrailingStopFunc(trailstart,trailsize,trailstep);

               if(tick_volume <= 1.0){                          //
                  
                  if(lastprint!=Time[0]) Print(Hour(),":",Minute()," | BUY | ",IntegerToString((TimeCurrent() - OrderOpenTime())/60)," мин | ",DoubleToString((Bid - OrderOpenPrice())/old_point,1)," pips"); 
                  
                  if(NoCloseWhileOpenSignal && Bid < channel_lower - Entry_Break * old_point) continue; // Не закрывать пока есть сигнал на открытие
                  
                  if(Filter_1 == 1 &&
                     TimeCurrent() - OrderOpenTime() > 60 * Exit_Minutes &&      // ордер открыт более Exit_Minutes (2 ч 20 мин) И
                     Bid - OrderOpenPrice() > Time_Profit_Pips * old_point){     // плавающая прибыль более Time_Profit_Pips (0)
                        //condition_for_the_exit_1 = true;
                        string q = "BUY: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №1. Order open more" +
                                 IntegerToString(Exit_Minutes) + " minutes and floating profit more " +
                                 DoubleToStr(Time_Profit_Pips,1) + " points.";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("1. Time");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
                  
                  if(Filter_2 == 1 &&
                     Bid >= channel_upper + Exit_Distance * old_point &&         // цена вышла за верхнюю границу канала И
                     Bid - OrderOpenPrice() > Exit_Profit_Pips * old_point){     // плавающая прибыль более Exit_Profit_Pips (-12)
                        //condition_for_the_exit_2 = true;
                        string q = "BUY: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №2. The price risen above " +
                                 DoubleToStr(channel_upper,Digits) + "(Upper border of the channel) on " + 
                                 DoubleToStr(Exit_Distance,1) + " points and floating profit more " +
                                 DoubleToStr(Exit_Profit_Pips,1) + " points.";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("2. BB Channel");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
                  
                  if(Filter_3 == 1){
                     ma_shift_1 = iMA(NULL, PERIOD_M1, ma_period, 0, MODE_SMA, PRICE_CLOSE, 1);
                     ma_shift_2 = iMA(NULL, PERIOD_M1, ma_period, 0, MODE_SMA, PRICE_CLOSE, 2);
                     if(ma_shift_1 < ma_shift_2 &&                                  // скользящая средняя снижается И
                        Bid - OrderOpenPrice() > Reverse_Profit * old_point){       // плавающая прибыль более Reverse_Profit (20)
                           //condition_for_the_exit_3 = true;
                           string q = "BUY: order #" + IntegerToString(OrderTicket()) +
                                    " Filter output №3. The MA is reduced" +
                                    " and a floating profit more" +
                                    DoubleToStr(Reverse_Profit,1) + " points.";
                           Print(Hour(),":",Minute()," | ",q);
                           DrawWarn("3. MA");

                           fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage, clrViolet, OrderType());
                           continue;
                     }
                  }
                  
                  if(Filter_4 == 1 &&
                     fGetCCISignal(cci_Period_close,cci_Price_close,top_level_close,lower_level_close,shift_close) == OP_SELL){
                        //condition_for_the_exit_4 = true;
                        string q = "BUY: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №4. Closed on CCI.";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("4. CCI");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
               }else{
                  Print(Hour(),":",Minute()," | skip, tickvolume = ",tick_volume);
               }
               count_buy++;
               continue;
            }
            
            if(OrderType() == OP_SELL){
               count_sell++;
               if (OrderStopLoss() == 0.0){
                  
                  stoploss = NormalizeDouble(OrderOpenPrice() + Stop_Loss * old_point, Digits);
                  takeprofit = NormalizeDouble(OrderOpenPrice() - Take_Profit * old_point, Digits);
                  
                  if(!ExitChannelTP) 
                     fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, takeprofit, 0, clrGreen);
                  else
                     fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, MathMin(tps,mintps), 0, clrGreen);
                     
                  continue;
               }

               if(use_BE && X > Y && OrderOpenPrice() - Ask >= X * old_point && OrderStopLoss() > OrderOpenPrice()){
                  stoploss = NormalizeDouble(OrderOpenPrice() - Y * old_point, Digits);
                  fModifyPosition(OrderTicket(), OrderOpenPrice(), stoploss, OrderTakeProfit(), 0, clrGreen);
               }
               
               if(use_Trailing_Stop && !(NoTrailWhileOpenSignal && Bid > channel_upper + Entry_Break * old_point)) fTrailingStopFunc(trailstart,trailsize,trailstep);

               if(tick_volume <= 1.0){                          //
                  
                  if(lastprint!=Time[0]) Print(Hour(),":",Minute()," | SELL | ",IntegerToString((TimeCurrent() - OrderOpenTime())/60)," мин | ",DoubleToString((OrderOpenPrice() - Ask)/old_point,1)," pips"); 
                  
                  if(NoCloseWhileOpenSignal && Bid > channel_upper + Entry_Break * old_point) continue; // Не закрывать пока есть сигнал на открытие
                  
                  if(Filter_1 == 1 &&
                     TimeCurrent() - OrderOpenTime() > 60 * Exit_Minutes &&      // ордер открыт более Exit_Minutes (2 ч 20 мин) И
                     OrderOpenPrice() - Ask > Time_Profit_Pips * old_point){     // плавающая прибыль более Time_Profit_Pips (0)
                        //condition_for_the_exit_1 = true;
                        string q = "SELL: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №1. Order more open " +
                                 IntegerToString(Exit_Minutes) + " minutes and floating profit more " +
                                 DoubleToStr(Time_Profit_Pips,1) + " points.";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("1. Time");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
                  
                  if(Filter_2 == 1 &&
                     Bid <= channel_lower - Exit_Distance * old_point &&         // цена вышла за нижнюю границу канала И
                     OrderOpenPrice() - Ask > Exit_Profit_Pips * old_point){     // плавающая прибыль более Exit_Profit_Pips (-12)
                        //condition_for_the_exit_2 = true;
                        string q = "SELL: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №2. Price fallen below " +
                                 DoubleToStr(channel_lower,Digits) + "(The lower border of the channel) on " + 
                                 DoubleToStr(Exit_Distance,1) + " points and a floating profit " +
                                 DoubleToStr(Exit_Profit_Pips,1) + " points.";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("2. BB Channel");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
                  
                  if(Filter_3 == 1){
                     ma_shift_1 = iMA(NULL, PERIOD_M1, ma_period, 0, MODE_SMA, PRICE_CLOSE, 1);
                     ma_shift_2 = iMA(NULL, PERIOD_M1, ma_period, 0, MODE_SMA, PRICE_CLOSE, 2);
                     if(ma_shift_1 > ma_shift_2 &&                                  // скользящая средняя повышается И
                        OrderOpenPrice() - Ask > Reverse_Profit * old_point){       // плавающая прибыль более Reverse_Profit (20)
                           string q = "SELL: order #" + IntegerToString(OrderTicket()) +
                                    " Filter output №3. MA rises" +
                                    " and a floating profit more " +
                                    DoubleToStr(Reverse_Profit,1) + " points.";
                           Print(Hour(),":",Minute()," | ",q);
                           DrawWarn("3. MA");

                           fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage, clrViolet, OrderType());
                           continue;
                     }
                  }
                  
                  if(Filter_4 == 1 &&
                     fGetCCISignal(cci_Period_close,cci_Price_close,top_level_close,lower_level_close,shift_close) == OP_BUY){
                        //condition_for_the_exit_4 = true;
                        string q = "SELL: order #" + IntegerToString(OrderTicket()) +
                                 " Filter output №4. Closed on CCI";
                        Print(Hour(),":",Minute()," | ",q);
                        DrawWarn("4. CCI");

                        fClosePosition(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slippage, clrViolet, OrderType());
                        continue;
                  }
               }else{
                  Print(Hour(),":",Minute()," | skip, tickvolume = ",tick_volume);
               }
               count_sell++;
               continue;
            }
         }   //if (OrderType() <= OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
      }     // else   if (!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES))
   }        //for (int pos = OrdersTotal() - 1; pos >= 0; pos--)
   if(lastprint!=Time[0]) lastprint=Time[0];
   
   if(!_IsTime || tick_volume > 1.0) return;

  // Открытие сделок, если соблюдены все условия
   if(count_buy < 1 && //если нет открытых покупок
      Bid < channel_lower - Entry_Break * old_point){  //если произошло касание канала BB
        OpenTradeConditions("BUY",OP_BUY,count_sell);
   }
   if(count_sell < 1 && //если нет открытых продаж
      Bid > channel_upper + Entry_Break * old_point){  //если произошло касание канала BB
        OpenTradeConditions("SELL",OP_SELL,count_buy);
   } 

   int Error = GetLastError(); //поиск ошибок в завершение
   if(Error != 0) Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc(Error));
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool OpenTradeConditions(string _OrderType, int OP_TYPE, int opposite_order) { 

   if(use_CCI_for_open==1 && fGetCCISignal(cci_Period_open,PRICE_CLOSE,top_level_open,lower_level_open,1) != OP_TYPE) { //фильтр по CCI
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         string q = "CCI не вышла за диапазон: ±" + IntegerToString(top_level_open) + " Ордер " + _OrderType + " не был открыт.";
         Print(Hour(),":",Minute()," | ",q);
         DrawWarn("filter CCI");
	      lastbarwrite = Time[0];
      }   
      return(false);
   }

   if(DailyMA > 0){ //фильтр по MA
       ma_shift_1 = iMA(NULL, PERIOD_M15, DailyMA, 0, MODE_SMA, PRICE_CLOSE, 1);
       ma_shift_2 = iMA(NULL, PERIOD_M15, DailyMA, 0, MODE_SMA, PRICE_CLOSE, 2);
       if((OP_TYPE == OP_BUY && ma_shift_1 < ma_shift_2 && ma_shift_2 - ma_shift_1 >= DeltaMA*old_point) ||
          (OP_TYPE == OP_SELL && ma_shift_1 > ma_shift_2 && ma_shift_1 - ma_shift_2 >= DeltaMA*old_point)){
            if (LogMode < 2 && lastbarwrite != Time[0]) {
               Print(Hour(),":",Minute()," | Скользящая средняя направлена ",(OP_TYPE == OP_BUY ? "вниз" : "вверх"),". Ордер " + _OrderType + " не был открыт.");
               DrawWarn("filter MA Daily");
      	      lastbarwrite = Time[0];
            }   
            return(false);
      }
   }
   
   if(MaxDailyRange > 0) { //фильтр MaxDailyRange
      if(openD1==0) openD1 = iOpenX(NULL, _Period, iBarShift(NULL, _Period, StrToTime(TimeToStr(TimeCurrent(),TIME_DATE))));
      if(openD1==0) return false;
      double mdr = OP_TYPE==OP_BUY ? openD1 - Bid : Bid - openD1;
      if(mdr > MaxDailyRange*old_point){
         if (LogMode < 2 && lastbarwrite != Time[0]) {
            string q = "Дневной диапазон движения цены: (" + DoubleToStr(mdr/old_point, 0) + " пунктов) ,больше MaxDailyRange: " + IntegerToString(MaxDailyRange) + " Ордер " + _OrderType + " не был открыт.";
            Print(Hour(),":",Minute()," | ",q);
            DrawWarn("filter MDR");
   	      lastbarwrite = Time[0];
         }   
         return(false);
      }
   }
   
   if (channel_width != 0 && channel_width < Min_Volatility*old_point) { //фильтр по ширине канале
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         string q = "Текущая ширина канала: (" + DoubleToStr(channel_width/old_point, 1) + " пунктов) меньше, чем минимальная ширина канала: " + DoubleToStr(Min_Volatility, 1) + " Ордер " + _OrderType + " не был открыт.";
         Print(Hour(),":",Minute()," | ",q);
         DrawWarn("filter chanel width");
	      lastbarwrite = Time[0];
      }   
      return(false);
   }
   
   if (Max_Spread > 0 && (Ask - Bid) > Max_Spread*old_point && (Max_Spread_mode2==0 || OP_TYPE==OP_BUY || (Ask - Bid) > Stop_Loss/2*old_point)) { //фильтр по максимальному спреду
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         string q = "Spread: " + DoubleToStr((Ask - Bid) / old_point, 1) + " пунктов слишком высокий! Ордер " + _OrderType + " не был открыт.";
         Print(Hour(),":",Minute()," | ",q);
         DrawWarn("filter spread");
	      lastbarwrite = Time[0];
      }   
      return(false);
   }
   
   if (no_Hedge && opposite_order >= 1) { //фильтр запрета на хеджирования
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         string q = "Фильтр хеджирующих позиций включен и найдена противоположная сделка. Ордер " + _OrderType + " не был открыт.";
         Print(Hour(),":",Minute()," | ",q);
         DrawWarn("filter hedge");
	      lastbarwrite = Time[0];
      }   
      return(false);
   }  
   
   datetime ordertime;
   if(time_break > 0 && lastloss(OP_TYPE,ordertime)) { //если последний ордер закрыт в профит (или убыток не больше заданного) 
      if (LogMode < 2 && TimeCurrent()-lasttimewrite > 60) {
         string q = StringConcatenate(Hour(),":",Minute()) + " | Пауза после убытка " + _OrderType + " не был открыт. Осталось " + DoubleToStr(time_break-(TimeCurrent()-ordertime)/60,0)+" минут";
         Print(q);
         DrawWarn("filter pause");
	      lasttimewrite = TimeCurrent();
      }   
      return(false);
   }

   if(opposite_order >= 1 && fGetRollOver()){
      DrawWarn("rollover");
      Print(Hour(),":",Minute()," | " + _OrderType + " not open RollOver Filter");
      return(false);
   }
                
   OpenTrade(_OrderType);
 
   return(true); 
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == "show_i_p"){
         if(Show_Info_Panel) return;
         
         if(ObjectFind("show_text") >= 0)
            fLabelDelete(0,"show_text");
         if(ObjectFind("show_i_p") >= 0)  //
            fRectLabelDelete(0,"show_i_p");
         
         fRectLabelCreate(0,"hide_i_p",0,1,29,158,18,clrMediumSeaGreen,2,0,clrRed,STYLE_SOLID,1,false,false,true,1);
         fLabelCreate(0,"hide_text",0,80,38,"H I D E",0,"Verdana",7);
         fRectLabelCreate(0,"info_panel",0,0,49,160,375,Col_info);
         
         Show_Info_Panel = true;
         double spread = Ask - Bid;
         fCreateInfoPanel();
      }
      if(sparam == "hide_i_p"){
         if(!Show_Info_Panel) return;
         
         if(ObjectFind("hide_text") >= 0)
            fLabelDelete(0,"hide_text");
         if(ObjectFind("hide_i_p") >= 0)  //
            fRectLabelDelete(0,"hide_i_p");
         
         fRectLabelCreate(0,"show_i_p",0,1,29,158,18,C'204,113,0',2,0,clrRed,STYLE_SOLID,1,false,false,true,1);
         fLabelCreate(0,"show_text",0,80,38,"S H O W",0,"Verdana",7);
         
         Comment("");
         if(ObjectFind("info_panel") >= 0)
            fRectLabelDelete(0,"info_panel");
         Show_Info_Panel = false;
      }
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double fGetLots(void){
   double lot=Lots;
   if (Auto_Risk > 0.0) {
      if (MM_Depo == 0){
         lot = (MathMax(minlot, MathMin(maxlot, 
            MathFloor(AccountBalance()*Auto_Risk/100/MarketInfo(_Symbol,MODE_TICKVALUE)/(Stop_Loss*old_point/Point)/lotstep) * lotstep)));
      }else{ 
         lot = NormalizeDouble(Lots * MathFloor(MathMin(AccountBalance(),AccountEquity())/MM_Depo), 2);
         lot = MathMin(MathMax(lot, minlot), maxlot); //сравнение полученнго лота с минимальным/максимальным.
      }
   }
   return lot;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool fGetIndicatorData(){
   if(need_to_verify_channel != Time[0]){
      if(iBars(_Symbol, TimeFrame) < Channel_Period+1){
         Print(Hour(),":",Minute()," | Error: Недостаточно загруженной истории для BB");
         return false;
      }
   
      channel_upper = iBands(NULL,TimeFrame,Channel_Period,2,0,PRICE_CLOSE,MODE_UPPER,1);
      channel_lower = iBands(NULL,TimeFrame,Channel_Period,2,0,PRICE_CLOSE,MODE_LOWER,1);
      
      /*if((channel_upper > Bid+50*old_point && channel_lower > Bid+50*old_point) || (channel_upper < Bid-50*old_point && channel_lower < Bid-50*old_point)){
         Print(Hour(),":",Minute()," | Error: Обе границы канала далеко от цены, upper: ",channel_upper,", lower: ",channel_lower,", Bid: ",Bid);
         return false;
      }*/
      
      if(VisualDebug){
         DrawChannel("up", channel_upper + Entry_Break*old_point);
         DrawChannel("down", channel_lower - Entry_Break*old_point);

         DrawChannel("up_exit", channel_upper + Exit_Distance*old_point, clrCornflowerBlue);
         DrawChannel("down_exit", channel_lower - Exit_Distance*old_point, clrCornflowerBlue);
      }
      
      if(ExitChannelTP) fSetTPbyExitChannel();
            
      channel_width = channel_upper - channel_lower;
      need_to_verify_channel = Time[0];
   }
   
   return true;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void fCreateInfoPanel(void){
   if(!IsVisualMode() && (IsTesting() || IsOptimization())) return;
   
   string info_panel;
         
      info_panel = "\n\n"
         + "\n  -----------------------------------------------" 
         + "\n            GENERIC A-TLP" 
         + "\n  -----------------------------------------------" 
         + "\n   A FREE PRODUCT POWERED" 
         + "\n                     BY" 
         + "\n     http://TRADELIKEAPRO.ru" 
         + "\n  -----------------------------------------------" 
         + "\n "+set_name_info
         + "\n "+warn_trading
         + "\n ----------------------------------------------------" 
         + tr_hr
         + "\n  -----------------------------------------------"
         + tp_info
         + "\n  Take Profit = " + DoubleToStr(Take_Profit,1) + " pips"
         + "\n  Stop Loss = " + DoubleToStr(Stop_Loss,1) + " pips"
         + be_info
         + "\n  -----------------------------------------------"
         + "\n  Max Spread = " + DoubleToStr(Max_Spread,1) + " pips"
         + "\n  Spread = " + DoubleToStr((Ask - Bid) / old_point, 1) + " pips";
      
      if(Ask - Bid > Max_Spread * old_point) info_panel = info_panel + " - HIGH !!!";
      else info_panel = info_panel + " - NORMAL";
      info_panel = info_panel
         + risk_info
         + "\n  Trading Lots = " + DoubleToStr(lots, 2)
         + "\n  -----------------------------------------------"
         + filter_info
         + "\n  -----------------------------------------------";
      Comment(info_panel);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void fTrailingStopFunc(const double tr_start,const double tr_size,const double tr_step){
   if(OrderType() == OP_BUY){
      if(OrderStopLoss() < OrderOpenPrice() && Bid - OrderOpenPrice() >= tr_start){         //если SL еще не двигали
         fModifyPosition(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,clrGreen);
         return;
      }
      if(OrderStopLoss() >= OrderOpenPrice()){                                                          //если SL уже двигали
         double dif = Bid - OrderStopLoss() - tr_size;
         if(dif >= tr_step)
            fModifyPosition(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderStopLoss() + dif,Digits),
                              OrderTakeProfit(),0,clrGreen);
         return;
      }
   }
   
   if(OrderType() == OP_SELL){
      if(OrderStopLoss() > OrderOpenPrice() && OrderOpenPrice() - Ask >= tr_start){         //если SL еще не двигали
         fModifyPosition(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,clrTomato);
         return;
      }
      if(OrderStopLoss() <= OrderOpenPrice()){                                                           //если SL уже двигали
         double dif = OrderStopLoss() - Ask - tr_size;
         if(dif >= tr_step)
            fModifyPosition(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderStopLoss() - dif,Digits),
                              OrderTakeProfit(),0,clrTomato);
         return;
      }
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void fClosePosition(int ticket,double lot,double price,int slip,color col, int type){
   if(fGetRollOver()){
      DrawWarn("rollover");
      Print(Hour(),":",Minute()," | not close RollOver Filter");
      return;
   }
   
   if(Max_Spread_mode2>0){
      double OrderDistance = type == OP_BUY ? Bid - OrderOpenPrice() : OrderOpenPrice() - Ask;
      if ((Ask - Bid) > Max_Spread_mode2*old_point && type==OP_SELL && OrderDistance < Max_Spread_mode2_profit * old_point) { //фильтр по максимальному спреду
         if (LogMode < 2) {
            DrawWarn("spread");
            string q = _Symbol + "| Spread: " + DoubleToStr((Ask - Bid) / old_point, 1) + " пунктов слишком высокий! Ордер не был закрыт.";
            Print(q);
         }   
         return;
      }
   }
               
   OrderCloseX(ticket, lot, type, slippage, col);
   return;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool lastloss(int OP_TYPE, datetime &ordertime){   
   if((!LossPauseUseDirection || OP_TYPE == OP_BUY)  && last_buy.profit*-1  >= loss && TimeCurrent()-last_buy.time  < time_break*60){ ordertime=last_buy.time; return true; }
   if((!LossPauseUseDirection || OP_TYPE == OP_SELL) && last_sell.profit*-1 >= loss && TimeCurrent()-last_sell.time < time_break*60){ ordertime=last_sell.time; return true; }        
   
   return false;   
}

void GetLastProfit(int ht){
   int changes=0;
   for(int iPos=ht-1; iPos >= 0; iPos--){
      if(OrderSelect(iPos, SELECT_BY_POS, MODE_HISTORY)==false){
         if (LogMode < 3) Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc()); 
         continue;
      }
      if(OrderSymbol() != _Symbol || OrderMagicNumber() != MagicNumber) continue;
      
      if(OrderType() == OP_BUY){
         if(OrderCloseTime() > last_buy.time){
            ZeroMemory(last_buy);
            last_buy.time = OrderCloseTime();
            last_buy.profit = (int)NormalizeDouble((OrderClosePrice() - OrderOpenPrice()) / old_point,0);
            changes++;
            if(_RealTrade){
               if(StringFind(OrderComment(), "[sl]", 0)!=-1){
                  last_buy.ticket = OrderTicket();
                  last_buy.sltp = "sl";
                  last_buy.slip = NormalizeDouble((OrderStopLoss() - OrderClosePrice())/old_point,1);
               }
               if(StringFind(OrderComment(), "[tp]", 0)!=-1){
                  last_buy.ticket = OrderTicket();
                  last_buy.sltp = "tp";
                  last_buy.slip = NormalizeDouble((OrderTakeProfit() - OrderClosePrice())/old_point,1);
               }
            }
         }
      }else{
         if(OrderCloseTime() > last_sell.time){
            ZeroMemory(last_sell);
            last_sell.time = OrderCloseTime();
            last_sell.profit = (int)NormalizeDouble((OrderOpenPrice() - OrderClosePrice()) / old_point,0);
            changes++;
            if(_RealTrade){
               if(StringFind(OrderComment(), "[sl]", 0)!=-1){
                  last_sell.ticket = OrderTicket();
                  last_sell.sltp = "sl";
                  last_sell.slip = NormalizeDouble((OrderClosePrice() - OrderStopLoss())/old_point,1);
               }
               if(StringFind(OrderComment(), "[tp]", 0)!=-1){
                  last_sell.ticket = OrderTicket();
                  last_sell.sltp = "tp";
                  last_sell.slip = NormalizeDouble((OrderClosePrice() - OrderTakeProfit())/old_point,1);
               }
            }
         }
      }
   }
   
   ResetLastError();
   
   if(changes>0){
      if(LogMode < 2) Print(__FUNCTION__,", LastBuyProfit: ",last_buy.profit," pips, LastSellProfit: ",last_sell.profit," pips");
      
      if(last_buy.ticket>0){
         if(LogMode < 2) Print(__FUNCTION__,", LastBuy: ",last_buy.profit," pips [",last_buy.sltp,"], slip = ",last_buy.slip);
         BrokerStatWrite(last_buy.ticket,"close",last_buy.sltp,last_buy.slip,0,"0");
      }
      
      if(last_sell.ticket>0){
         if(LogMode < 2) Print(__FUNCTION__,", LastSell: ",last_sell.profit," pips [",last_sell.sltp,"], slip = ",last_sell.slip);
         BrokerStatWrite(last_sell.ticket,"close",last_sell.sltp,last_sell.slip,0,"0");
      }
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void fModifyPosition(int ticket,double price,double sl,double tp,datetime expir = 0,color col = clrNONE){
   if(!OrderModify(ticket, price, sl, tp, expir, col)) Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc());
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int fGetCCISignal(int period,int typeprice,int toplevel,int lowerlevel,int sh){
   double cci = iCCI(NULL,TimeFrame_CCI,period,typeprice,sh);
   if(cci > toplevel) return(OP_SELL);
   if(cci < lowerlevel) return(OP_BUY);
   return(-1);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool OpenTrade(string type){
   double price = 0;
   double signalbid = Bid;
   int cmd = -1;
   color col_type = clrNONE;
   
   if(_RealTrade && !IsTradeAllowed()){
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         Print(Hour(),":",Minute()," | ","Торговля запрещена! Ордер " + type + " не был открыт.");
         DrawWarn("Trade not allowed");
	      lastbarwrite = Time[0];
      }  
      return false;
   }
   
   lots = fGetLots();
   
   if(type == "BUY"){
      cmd = OP_BUY;
      col_type = clrAqua;
   }
   if(type == "SELL"){
      cmd = OP_SELL;
      col_type = clrRed;
   }
   
   double free_margin=AccountFreeMarginCheck(_Symbol,cmd,lots);
   if(free_margin<0){
      if (LogMode < 2 && lastbarwrite != Time[0]) {
         Print(Hour(),":",Minute()," | Not enough money for ",type," ",lots, " ",fMyErDesc());
	      lastbarwrite = Time[0];
      } 
      return false;
   }
   
   string WorkTime=DoubleToString((GetMicrosecondCount()-OnTickStart)/1000.0,2);
   
   int err=0;
   for(int count = 0; count < 5; count++){
      price = cmd==OP_BUY ? Ask : Bid;
      uint start=GetTickCount();
      int ticket = OrderSend(_Symbol, cmd, lots, price, slippage, 0, 0, Comm, MagicNumber, 0, col_type);  

      if(ticket >= 0){
         uint time=GetTickCount()-start;
         bool exit_loop = false;
         int retry = 10;
         int cnt1 = 0;
         
         while(!exit_loop && cnt1<retry){
            exit_loop = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
            if(exit_loop){
               double Slp = NormalizeDouble((cmd==OP_BUY ? OrderOpenPrice() - price : price - OrderOpenPrice())/old_point,1); 
               Print(Hour(),":",Minute()," | ",__FUNCTION__,": ",type," price / cmd / slip / delay = ",OrderOpenPrice()," / ",price," / ",DoubleToString(Slp,1)," point / ",time," ms, channel price / bid = ",NormalizeDouble(cmd==OP_BUY ? channel_lower - Entry_Break * old_point : channel_upper + Entry_Break * old_point,_Digits)," / ",signalbid,", WorkTime = ",WorkTime," ms");
               BrokerStatWrite(ticket,"open","ea",Slp,time,WorkTime);
            }else
               Sleep(1000);
            cnt1++; 
         }
         if(!exit_loop) Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc());
         
         return(true);
      }else{
         err = GetLastError();
         if(err != ERR_INVALID_PRICE && err != ERR_PRICE_CHANGED && err != ERR_REQUOTE && err != ERR_OFF_QUOTES && err != ERR_TRADE_CONTEXT_BUSY) break;

         Sleep(1000);   
         RefreshRates();
      }
   }
   if(err!=ERR_NO_ERROR && err!=ERR_NO_RESULT)  Print(Hour(),":",Minute()," | ",__FUNCTION__,": ",type," not open by price: ",price,", ",fMyErDesc(err));
   
   return(false);
}
//+------------------------------------------------------------------+
//    возвращает ИСТИНА, если сейчас время ролловера                 +
//    иначе - ЛОЖЬ                                                   +
//+------------------------------------------------------------------+
bool fGetRollOver(void){
   if(use_rollover_filter == 2){             //не закрывать сделки в ролловер
      if(rtime1 > rtime2){
         if(TimeCurrent() >= rtime1 || TimeCurrent() < rtime2)
            return(true);
      }
      else{
         if(TimeCurrent() >= rtime1 && TimeCurrent() < rtime2)
            return(true);
      }
   }
   return(false);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string fInfoTradeHours(void){
   switch(DayOfWeek()){
        case 0: {    if(sunday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(sunday_pause_start == "0" || sunday_pause_start == sunday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + sunday_open
                                 + "\n  End Hour (Broker Time) = " + sunday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + sunday_open
                                 + "\n  End First Session = " + sunday_pause_start
                                 + "\n  Start Second Session = " + sunday_pause_stop
                                 + "\n  End Second Session = " + sunday_close);
                        }
                     }
                     break;
                }
        case 1: {    if(monday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(monday_pause_start == "0" || monday_pause_start == monday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + monday_open
                                 + "\n  End Hour (Broker Time) = " + monday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + monday_open
                                 + "\n  End First Session = " + monday_pause_start
                                 + "\n  Start Second Session = " + monday_pause_stop
                                 + "\n  End Second Session = " + monday_close);
                        }
                     }
                     break;
                }
        case 2: {    if(tuesday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(tuesday_pause_start == "0" || tuesday_pause_start == tuesday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + tuesday_open
                                 + "\n  End Hour (Broker Time) = " + tuesday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + tuesday_open
                                 + "\n  End First Session = " + tuesday_pause_start
                                 + "\n  Start Second Session = " + tuesday_pause_stop
                                 + "\n  End Second Session = " + tuesday_close);
                        }
                     }
                     break;
                }
        case 3: {    if(wednesday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(wednesday_pause_start == "0" || wednesday_pause_start == wednesday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + wednesday_open
                                 + "\n  End Hour (Broker Time) = " + wednesday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + wednesday_open
                                 + "\n  End First Session = " + wednesday_pause_start
                                 + "\n  Start Second Session = " + wednesday_pause_stop
                                 + "\n  End Second Session = " + wednesday_close);
                        }
                     }
                     break;
                }        
        case 4: {    if(thursday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(thursday_pause_start == "0" || thursday_pause_start == thursday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + thursday_open
                                 + "\n  End Hour (Broker Time) = " + thursday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + thursday_open
                                 + "\n  End First Session = " + thursday_pause_start
                                 + "\n  Start Second Session = " + thursday_pause_stop
                                 + "\n  End Second Session = " + thursday_close);
                        }
                     }
                     break;
                }
        case 5: {    if(friday == 2){
                        return( "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                     }
                     else{
                        if(friday_pause_start == "0" || friday_pause_start == friday_pause_stop){
                           return( "\n  Start Hour (Broker Time) = " + friday_open
                                 + "\n  End Hour (Broker Time) = " + friday_close
                                 + "\n"
                                 + "\n");
                        }
                        else{
                           return( "\n  Start First Session = " + friday_open
                                 + "\n  End First Session = " + friday_pause_start
                                 + "\n  Start Second Session = " + friday_pause_stop
                                 + "\n  End Second Session = " + friday_close);
                        }
                     }
                     break;
                }
        default:{    return(    "\n"
                              + "\n    no trade today"
                              + "\n"
                              + "\n");
                }                                                
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool IsTime(void){
   if(flag_trade == _PAUSE_){
      if((TimeCurrent() > time1 && TimeCurrent() < time2) || (TimeCurrent() > time3 && TimeCurrent() < time4)) return(true);
      else return(false);
   }
   else{
      if(TimeCurrent() > time1 && TimeCurrent() < time4) return(true);
      else return(false);
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////////
void fChoiceOfDay(void)
{
   switch(DayOfWeek())
   {
        case 0: {
                     if(sunday == 1) fSetTimeTrade(sunday_open,sunday_pause_start,sunday_pause_stop,sunday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }
        case 1: {
                     if(monday == 1) fSetTimeTrade(monday_open,monday_pause_start,monday_pause_stop,monday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }
        case 2: {
                     if(tuesday == 1) fSetTimeTrade(tuesday_open,tuesday_pause_start,tuesday_pause_stop,tuesday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }
        case 3: {
                     if(wednesday == 1) fSetTimeTrade(wednesday_open,wednesday_pause_start,wednesday_pause_stop,wednesday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }        
        case 4: {
                     if(thursday == 1) fSetTimeTrade(thursday_open,thursday_pause_start,thursday_pause_stop,thursday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }
        case 5: {
                     if(friday == 1) fSetTimeTrade(friday_open,friday_pause_start,friday_pause_stop,friday_close);
                     else{
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                     }
                     break;
                }
        default:{
                     
                        flag_trade = _TRADE_;
                        //time1 = StrToTime("01:20");
                        //time4 = StrToTime("01:10");
                        time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:20"));
                        time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ","01:10"));
                }                                                
   }
   
   if(use_rollover_filter == 2){
      rtime1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",rollover_start));
      rtime2 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",rollover_end));
   }
}
//+------------------------------------------------------------------+
void fSetTimeTrade(string open,string pause_start,string pause_stop,string close)
{
     if(pause_start == "0" || pause_start == pause_stop)
     {
          //no pause
          //return((TimeCurrent() >= StrToTime(open)) && (TimeCurrent() <StrToTime(close)));
          flag_trade = _TRADE_;
          //time1 = StrToTime(open);
          //time4 = StrToTime(close);
          time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",open));
          time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",close));
     }
     else // pause
     {
          //return(((TimeCurrent() >= StrToTime(open)) && (TimeCurrent() <StrToTime(pause_start)))||
          //       ((TimeCurrent() >= StrToTime(pause_stop)) && (TimeCurrent() <StrToTime(close))));
          
          flag_trade = _PAUSE_;
          //time1 = StrToTime(open);
          //time4 = StrToTime(close);
          //time2 = StrToTime(pause_start);
          //time3 = StrToTime(pause_stop);
          time1 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",open));
          time4 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",close));
          time2 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",pause_start));
          time3 = StrToTime(StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",pause_stop));
     }
     //return(false);
}
/*
//+------------------------------------------------------------------+
int fGetGMTOffset() {
   int time = (int)(TimeCurrent() - TimeGMT());
   double offset = time;
   offset *= 0.01;
   offset = MathCeil(offset) * 100;
   offset = offset/3600;
   int gmtoffset = (int)NormalizeDouble(offset,0);
   return(gmtoffset);
}
*/

//+------------------------------------------------------------------+ 
//| Создает прямоугольную метку                                      | 
//+------------------------------------------------------------------+ 
bool fRectLabelCreate(const long             chart_ID    = 0,                 // ID графика 
                      const string           name        = "RectLabel",       // имя метки 
                      const int              sub_window  = 0,                 // номер подокна 
                      const int              x           = 0,                 // координата по оси X 
                      const int              y           = 0,                 // координата по оси Y 
                      const int              width       = 50,                // ширина 
                      const int              height      = 18,                // высота 
                      const color            back_clr    = C'236,233,216',    // цвет фона 
                      const ENUM_BORDER_TYPE border      = BORDER_SUNKEN,     // тип границы 
                      const ENUM_BASE_CORNER corner      = CORNER_LEFT_UPPER, // угол графика для привязки 
                      const color            clr         = clrRed,            // цвет плоской границы (Flat) 
                      const ENUM_LINE_STYLE  style       = STYLE_SOLID,       // стиль плоской границы 
                      const int              line_width  = 1,                 // толщина плоской границы 
                      const bool             back        = false,             // на заднем плане 
                      const bool             selection   = false,             // выделить для перемещений 
                      const bool             hidden      = true,              // скрыт в списке объектов 
                      const long             z_order     = 0)                 // приоритет на нажатие мышью 
{ 
//--- сбросим значение ошибки 
   ResetLastError(); 
   if(ObjectFind(chart_ID,name)==0) return true;
//--- создадим прямоугольную метку 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create a rectangular mark! " + fMyErDesc()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размеры метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим тип границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим цвет плоской рамки (в режиме Flat) 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии плоской рамки 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину плоской границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
}
//+------------------------------------------------------------------+ 
//| Удаляет прямоугольную метку                                      | 
//+------------------------------------------------------------------+ 
bool fRectLabelDelete(const long   chart_ID   = 0,           // ID графика 
                      const string name       = "RectLabel") // имя метки 
{ 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- удалим метку 
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to remove a rectangular mark! " + fMyErDesc()); 
      return(false); 
     } 
//--- успешное выполнение 
   return(true); 
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+ 
//| Создает текстовую метку                                          | 
//+------------------------------------------------------------------+ 
bool fLabelCreate(const long             chart_ID=0,               // ID графика 
                 const string            name="Label",             // имя метки 
                 const int               sub_window=0,             // номер подокна 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const string            text="Label",             // текст 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrDarkBlue,             // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_CENTER,     // способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
   if(ObjectFind(chart_ID,name)==0) return true;
//--- создадим текстовую метку 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": was unable to create a text label! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим угол наклона текста 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- установим способ привязки 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- установим цвет 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+ 
//| Удаляет текстовую метку                                          | 
//+------------------------------------------------------------------+ 
bool fLabelDelete(const long   chart_ID=0,   // ID графика 
                 const string name="Label") // имя метки 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- удалим метку 
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to remove the text label! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- успешное выполнение 
   return(true); 
  }
//+------------------------------------------------------------------+ 


void DrawChannel(string dir, double pr1, color clr=clrYellow){
   if(!VisualDebug) return;
   if(!_RealTrade && Bars<2) return;

   string name=_Symbol+dir+TimeToStr(Time[0]);
   string name_prev=_Symbol+dir+TimeToStr(Time[1]);

   double pr2=pr1;
   if(ObjectFind(name) < 0){
      if(ObjectFind(name_prev) == 0) pr2=ObjectGetDouble(0,name_prev,OBJPROP_PRICE,1);
   
      ObjectCreate(0,name,OBJ_TREND,0,Time[1],pr2,Time[0],pr1);
      ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false); 
      ObjectSet(name, OBJPROP_COLOR, clr);
   }
}

void DrawWarn(string text){
   if(!VisualDebug) return;
   
   string obid=_Symbol+TimeToStr(Time[0]);
   if(ObjectFind(obid)!=-1) ObjectDelete(obid);
   
   ENUM_ANCHOR_POINT anc;
   double price;

   if((WindowPriceMax()+WindowPriceMin())/2 < Bid){
      price=channel_lower-MathAbs(Entry_Break)*2*old_point;
      anc=ANCHOR_RIGHT;
   }else{
      price=channel_upper+MathAbs(Entry_Break)*2*old_point;
      anc=ANCHOR_LEFT;
   }
   
   ObjectCreate(obid, OBJ_TEXT, 0, Time[0], price);
   ObjectSet(obid, OBJPROP_ANGLE, 90);
   ObjectSet(obid,OBJPROP_ANCHOR,anc);
   ObjectSet(obid,OBJPROP_BACK,false);
   ObjectSetText(obid,text,10,"Arial",ColorDrawWarn);
   
   int Error = GetLastError(); //поиск ошибок в завершение
   if(Error != 0) Print(__FUNCTION__," ",fMyErDesc(Error));
}

int CountOrder(){
   int orders=0;
   if(_RealTrade){
      for(int i=OrdersTotal()-1;i>=0;i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false){ ResetLastError(); continue; }
         if(OrderSymbol()!=_Symbol || OrderMagicNumber() != MagicNumber) continue;
         orders++;
      }
   }else
      orders=OrdersTotal();

   return orders;
}

void OrderCloseX(int ticket1, double lot, int otype, int slp, color clr=CLR_NONE){
    int err = 0; double price = 0; uint start=GetTickCount();
    bool exit_loop = false;

    int retry = 5;
    int cnt1   = 0;
    
    string WorkTime=DoubleToString((GetMicrosecondCount()-OnTickStart)/1000.0,2);

    while(!exit_loop && cnt1<retry){
        if(otype == OP_BUY)  price=Bid;
        if(otype == OP_SELL) price=Ask;
        start=GetTickCount();
        if(!OrderClose(ticket1, lot, price, slp, clr)){
           err = GetLastError();
           switch(err){
             case ERR_INVALID_PRICE:
                  RefreshRates();
                  break;
             case ERR_REQUOTE:
                  RefreshRates();
                  break;
             case ERR_OFF_QUOTES:
                  RefreshRates();
                  break;
             case ERR_BROKER_BUSY:
                  break;
             default:
                  exit_loop = true;
                  break;
           }
           Sleep(1000);
           cnt1++;
        }else{
           err = 0;
           exit_loop = true;
        }
   }
   
   if(exit_loop && err == 0){ 
      uint time=GetTickCount()-start;
      retry = 10;     
      cnt1=0;
      exit_loop = false;
      
      while(!exit_loop && cnt1<retry){
         exit_loop = OrderSelect(ticket1, SELECT_BY_TICKET, MODE_HISTORY);
         if(exit_loop){
            double Slp = NormalizeDouble((OrderType()==OP_BUY ? price - OrderClosePrice() : OrderClosePrice() - price)/old_point,1); 
            Print(Hour(),":",Minute()," | ",__FUNCTION__,": ",(OrderType()==OP_BUY ? "BUY" : "SELL")," price / cmd / slip / delay = ",OrderClosePrice()," / ",price," / ",DoubleToString(Slp,1)+" point / ",time," ms",", WorkTime = ",WorkTime," ms");
            BrokerStatWrite(ticket1,"close","ea",Slp,time,WorkTime);
         }else
            Sleep(1000);
         cnt1++;
      }
      if(!exit_loop) Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc());
   }else      
      if(err != ERR_NO_ERROR && err != ERR_NO_RESULT) Print(__FUNCTION__," #",ticket1,": ",ErrorDescription(err));
}

double iOpenX(string symbol, int tf, int sh){
   int err=0;
   bool exit_loop = false;
   int retry = 10;
   int cnt1   = 0;
   double res = 0;
   while(!exit_loop && cnt1<retry){
      res = iOpen(symbol,tf,sh);
      err = GetLastError();
      if(res==0){
         if(err==4066){ 
            Sleep(1000); 
            cnt1++;
         }else
            exit_loop=true;
      }else
         exit_loop=true; 
   }
   if(err != ERR_NO_ERROR && err != ERR_NO_RESULT) Print(__FUNCTION__," ",ErrorDescription(err));
   
   return res;
}

long iVolumeX(string symbol, ENUM_TIMEFRAMES tf, int sh){
   int err=0;
   bool exit_loop = false;
   int retry = 10;
   int cnt1   = 0;
   long res = 0;
   while(!exit_loop && cnt1<retry){
      res = iVolume(symbol,tf,sh);
      err = GetLastError();
      if(res==0){
         if(err==4066){ 
            Sleep(1000); 
            cnt1++;
         }else
            exit_loop=true;
      }else
         exit_loop=true; 
   }
   if(err != ERR_NO_ERROR && err != ERR_NO_RESULT) Print("Error ",__FUNCTION__," ",ErrorDescription(err));
   
   return res;
}

double GetCommPoint(double lot, double comission){
   ticksize = (int)MarketInfo(_Symbol,MODE_TICKSIZE);
   double tickvalue = MarketInfo(_Symbol, MODE_TICKVALUE); 
   if(ticksize>0 && tickvalue>0){
      comission*=-1;
      if(comission<=0) return _Point;
      return NormalizeDouble(comission/lot/tickvalue*ticksize,_Digits);
   }else
      return 10*_Point;
}

bool fMorningClose(){
   if(Hour()>=MorningCloseHourStart && Hour()<MorningCloseHourEnd){
      if(MorningClose == 1){ //Перевод в безубыток
         if(OrderType() == OP_BUY){
            if(OrderStopLoss()<OrderOpenPrice()+_Point){ 
               double be=OrderOpenPrice() + GetCommPoint(OrderLots(), OrderSwap() + OrderCommission());
               if(Bid-stoplevel*_Point > be && !CompareDoubles(OrderStopLoss(),be)){
                  fModifyPosition(OrderTicket(), OrderOpenPrice(), be, OrderTakeProfit(), 0, clrGreen);
                  if(LogMode < 2) Print(Hour(),":",Minute()," | morning be #",OrderTicket());
                  return true;
               }
            }
         }else{
            if(OrderStopLoss()>OrderOpenPrice()-_Point){
               double be=OrderOpenPrice() - GetCommPoint(OrderLots(), OrderSwap() + OrderCommission());
               if(Ask+stoplevel*_Point < be && !CompareDoubles(OrderStopLoss(),be)){ 
                  fModifyPosition(OrderTicket(), OrderOpenPrice(), be, OrderTakeProfit(), 0, clrGreen);
                  if(LogMode < 2) Print(Hour(),":",Minute()," | morning be #",OrderTicket());
                  return true;
               }
            }
         } 
      }else{
         if(MorningClose == 2){ //Закрыть сразу
            OrderCloseX(OrderTicket(), OrderLots(), OrderType(), Slippage);
            if(LogMode < 2){
               Print(Hour(),":",Minute()," | morning close #",OrderTicket());
               DrawWarn("morning close");
            }
            return true;
         }else
         if(MorningClose == 3 && OrderProfit()+OrderSwap()+OrderCommission()>0){ //Закрыть только в профите
            OrderCloseX(OrderTicket(), OrderLots(), OrderType(), Slippage);
            if(LogMode < 2){
               Print(Hour(),":",Minute()," | morning close #",OrderTicket());
               DrawWarn("morning close");
            }
            return true;
         }
      }
   }
   return false;
}

void fSetTPbyExitChannel(){
   stoplevel = (int)MarketInfo(_Symbol, MODE_STOPLEVEL);
   mintpb = NormalizeDouble(Ask+MathMax(stoplevel,1)*_Point,_Digits);
   mintps = NormalizeDouble(Bid-MathMax(stoplevel,1)*_Point,_Digits);
   tpb = NormalizeDouble(channel_upper+Exit_Distance*old_point,_Digits);
   tps = NormalizeDouble(channel_lower-(Exit_Distance*old_point)+MathMin(MathAbs(Max_Spread_mode2>0 ? Max_Spread_mode2*old_point : Max_Spread*old_point), (Ask-Bid)),_Digits);

   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false){ Print(Hour(),":",Minute()," | ",__FUNCTION__," ",fMyErDesc()); continue; }
      if(OrderSymbol()!=_Symbol || OrderMagicNumber() != MagicNumber) continue;
      if(OrderType()==OP_BUY){
         if(tpb > OrderOpenPrice()+Exit_Profit_Pips*old_point && !CompareDoubles(tpb,OrderTakeProfit()) && tpb >= mintpb)
            fModifyPosition(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), tpb, 0, clrWhite);
      }else{
         if(tps < OrderOpenPrice()-Exit_Profit_Pips*old_point && !CompareDoubles(tps,OrderTakeProfit()) && tps <= mintps)
            fModifyPosition(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), tps, 0, clrWhite);
      }
   }
}
//+------------------------------------------------------------------+
string fMyErDesc(int err=-1){
   int aErrNum;
   if(err == -1)
      aErrNum = GetLastError();
   else
      aErrNum = err;

   return StringConcatenate("Error №: ",aErrNum," - ",ErrorDescription(aErrNum));
}
//+------------------------------------------------------------------+
void BrokerStatWrite(int ticket, string openclose, string sltp, double slip, uint delay, string ontickdelay){
   if(!_RealTrade || !BrokerStatToFile) return;
   
   string slips=DoubleToStr(slip,1);
   StringReplace(slips,".",",");
   StringReplace(ontickdelay,".",",");
   
   int file_handle=FileOpen("BrokerStat.csv", FILE_CSV|FILE_READ|FILE_WRITE);
   if (file_handle!=INVALID_HANDLE){
       if(!FileSeek(file_handle, 0, SEEK_END)) ResetLastError();
       FileWrite(file_handle,TimeToString(TimeCurrent()),_Symbol,ticket,openclose,sltp,slips,delay,ontickdelay);
       FileClose(file_handle);
   }
   
   int Error = GetLastError(); //поиск ошибок в завершение
   if(Error != 0) Print(__FUNCTION__," ",fMyErDesc(Error));
}