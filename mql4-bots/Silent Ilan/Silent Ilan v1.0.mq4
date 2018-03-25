//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
#property copyright "" 
#property link      ""
//ннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
double Stoploss = 500000.0;            // уровень безубытка
//ннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
extern string     EA006 =              "Настройки времени";
extern int        UseHour =            1;
extern int        StartTime =          11;
extern int        StopTime =           16;
extern bool       UsePrint =           false;
extern int        Amplitude =          2;
extern string     ExpertName =         "Silent Ilan";
extern int        FixTP =              100;
extern int        RSIPer =             13;

extern string     LT001 =              "======MONEYMANAGEMENT MODULE======";
extern string     Lots007 =            "Lots count variant";
extern int 			LotVariant =         3;
extern string     Lots008 =            "1. Fix lot";
extern double 		FixLot =             0.03;
extern string     Lots011 =            "2. Fix fracture of deposit";
extern int        MoneyForOneLot =     300;
extern int        lotdecimal =         2;
extern string     Lots015 =            "=======================";

//ннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
extern double  LotExponent = 2.0;   // на сколько умножать лот при выставлении следующего колена. пример: первый лот 0.1, серия: 0.16, 0.26, 0.43 ...
extern bool    DynamicPips                   = true; 
extern int     DefaultPips                   = 40;
extern int     Glubina = 24;
extern int     DEL = 3;
extern double  slip = 3.0;           // на сколько может отличаться цена в случае если ДЦ запросит реквоты (в последний момент немного поменяет цену)
extern int     MagicNumber = 2222;      // волшебное число (помогает советнику отличить свои ставки от чужих)
int PipStep=0;
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
extern int MaxTrades = 7;                 // максимально количество одновременно открытых ордеров
extern bool UseEquityStop = FALSE;
extern double TotalEquityRisk = 20.0;
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
double PriceTarget, StartEquity, BuyTarget, SellTarget;
double AveragePrice, SellLimit, BuyLimit;
double LastBuyPrice, LastSellPrice, Spread;
bool flag;
string EAName="Ludoman";
int timeprev = 0;
int NumOfTrades = 0;
double iLots;
int cnt = 0, total;
double Stopper = 0.0;
bool TradeNow = FALSE, LongTrade = FALSE, ShortTrade = FALSE;
int ticket;
bool  NewOrdersPlaced = FALSE;
double AccountEquityHighAmt, PrevEquity;
double TDIGreen1,TDIRed1,TDIGreen3,TDIRed3,TDIYellow,MinLot,Lot;
bool DontOpen=false;
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
int init() {
   Spread = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   MinLot=MarketInfo(Symbol(),MODE_MINLOT);
   return (0);
}

int deinit() {
   return (0);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
int start()
 {
 total = CountTrades();
 if(OrdersTotal()>0)
   {
   for (cnt=OrdersTotal(); cnt>=0; cnt--) 
      {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol()==Symbol()&&(OrderMagicNumber()==MagicNumber||OrderMagicNumber()==0)) continue;
      if (OrderSymbol()!=Symbol()||(OrderMagicNumber()!=MagicNumber&&OrderMagicNumber()!=0))
         {
         DontOpen=true;
         }
      }
   }
   
 if(OrdersTotal()==0) DontOpen=false;
   
 if (DynamicPips)  
   {
     double hival=High[iHighest(NULL,0,MODE_HIGH,Glubina,1)];    // calculate highest and lowest price from last bar to 24 bars ago
     double loval=Low[iLowest(NULL,0,MODE_LOW,Glubina,1)];       // chart used for symbol and time period
     PipStep=NormalizeDouble((hival-loval)/DEL/Point,0);         // calculate pips for spread between orders
     if (PipStep<DefaultPips/DEL) PipStep = NormalizeDouble(DefaultPips/DEL,0);
     if (PipStep>DefaultPips*DEL) PipStep = NormalizeDouble(DefaultPips*DEL,0);          // if dynamic pips fail, assign pips extreme value
   }

   if (timeprev == Time[0]) return (0);
   timeprev = Time[0];
   
   double CurrentPairProfit = CalculateProfit();
   if (UseEquityStop) {
      if (CurrentPairProfit < 0.0 && MathAbs(CurrentPairProfit) > TotalEquityRisk / 100.0 * AccountEquityHigh()) {
         CloseThisSymbolAll();
         Print("Closed All due to Stop Out");
         NewOrdersPlaced = FALSE;
      }
   }
   
   CurrentPairProfit = CalculateProfit();
   
   total = CountTrades();
   if (total == 0) flag = FALSE;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
         if (OrderType() == OP_BUY) {
            LongTrade = TRUE;
            ShortTrade = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
         if (OrderType() == OP_SELL) {
            LongTrade = FALSE;
            ShortTrade = TRUE;
            break;
         }
      }
   }
   if (total > 0 && total <= MaxTrades) {
      RefreshRates();
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (LongTrade && LastBuyPrice - Ask >= PipStep * Point) TradeNow = TRUE;
      if (ShortTrade && Bid - LastSellPrice >= PipStep * Point) TradeNow = TRUE;
   }
   if (total < 1) {
      ShortTrade = FALSE;
      LongTrade = FALSE;
      TradeNow = TRUE;
      StartEquity = AccountEquity();
   }
   if (TradeNow) {
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (ShortTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(Lots() * MathPow(LotExponent, NumOfTrades), lotdecimal);
         RefreshRates();
         ticket = OpenPendingOrder(1, iLots, Bid, slip, Ask, 0, 0, EAName + "-" + NumOfTrades + "-" + PipStep, MagicNumber, 0, HotPink);
         if (ticket < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         LastSellPrice = FindLastSellPrice();
         TradeNow = FALSE;
         NewOrdersPlaced = TRUE;
      } else {
         if (LongTrade) {
            NumOfTrades = total;
            iLots = NormalizeDouble(Lots() * MathPow(LotExponent, NumOfTrades), lotdecimal);
            ticket = OpenPendingOrder(0, iLots, Ask, slip, Bid, 0, 0, EAName + "-" + NumOfTrades + "-" + PipStep, MagicNumber, 0, Lime);
            if (ticket < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice = FindLastBuyPrice();
            TradeNow = FALSE;
            NewOrdersPlaced = TRUE;
         }
      }
   }
   //Новая сделка
   if (TradeNow&&!DontOpen) 
      {
      SellLimit = Bid;
      BuyLimit = Ask;
      if (!ShortTrade && !LongTrade) 
         {
         NumOfTrades = total;
         iLots = Lots();
         if (Signal()==-1&&OrdersTotal()==0) 
            {
            ticket = OpenPendingOrder(OP_SELL, iLots, Bid, slip, SellLimit, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, HotPink);
            if (ticket < 0) 
               {
               Print("Error: ", GetLastError());
               return (0);
               }
            LastBuyPrice = FindLastBuyPrice();
            NewOrdersPlaced = TRUE;
            } 
         if (Signal()==1&&OrdersTotal()==0) 
            {
            ticket = OpenPendingOrder(OP_BUY, iLots, Ask, slip, BuyLimit, 0, 0, EAName + "-" + NumOfTrades, MagicNumber, 0, Lime);
            if (ticket < 0) 
               {
               Print("Error: ", GetLastError());
               return (0);
               }
            LastSellPrice = FindLastSellPrice();
            NewOrdersPlaced = TRUE;
            }
         TradeNow = FALSE;
         }
      }
   total = CountTrades();
   AveragePrice = 0;
   double Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
         }
      }
   }
   if (total > 0) AveragePrice = NormalizeDouble(AveragePrice / Count, Digits);
   if (NewOrdersPlaced) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
         if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
            if (OrderType() == OP_BUY) {
               PriceTarget = AveragePrice + TakeProfit(OP_BUY) * Point;
               BuyTarget = PriceTarget;
               Stopper = AveragePrice - Stoploss * Point;
               flag = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
            if (OrderType() == OP_SELL) {
               PriceTarget = AveragePrice - TakeProfit(OP_SELL) * Point;
               SellTarget = PriceTarget;
               Stopper = AveragePrice + Stoploss * Point;
               flag = TRUE;
            }
         }
      }
   }
   if (NewOrdersPlaced) {
      if (flag == TRUE) {
         for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
            ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
            if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) ticket=OrderModify(OrderTicket(), NormalizeDouble(AveragePrice,Digits), NormalizeDouble(OrderStopLoss(),Digits), NormalizeDouble(PriceTarget,Digits), 0, Yellow);
            NewOrdersPlaced = FALSE;
         }
      }
   }
   return (0);
}
//ннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      ticket=OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0))
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

void CloseThisSymbolAll() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      ticket=OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0)) {
            if (OrderType() == OP_BUY) ticket=OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue);
            if (OrderType() == OP_SELL) ticket=OrderClose(OrderTicket(), OrderLots(), Ask, slip, Red);
         }
         Sleep(1000);
      }
   }
}

//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

int OpenPendingOrder(int pType, double pLots, double pLevel, int sp, double pr, int sl, int tp, string pComment, int pMagic, int pDatetime, color pColor) {
   ticket = 0;
   int err = 0;
   int c = 0;
   int NumberOfTries = 100;
   switch (pType) {
   case 2:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_BUYLIMIT, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_BUYSTOP, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (c = 0; c < NumberOfTries; c++) {
         RefreshRates();
         ticket = OrderSend(Symbol(), OP_BUY, pLots, NormalizeDouble(Ask,Digits), sp, NormalizeDouble(StopLong(Bid, sl),Digits), NormalizeDouble(TakeLong(Ask, tp),Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELLLIMIT, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELLSTOP, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELL, pLots, NormalizeDouble(Bid,Digits), sp, NormalizeDouble(StopShort(Ask, sl),Digits), NormalizeDouble(TakeShort(Bid, tp),Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
   }
   return (ticket);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
double StopLong(double price, int stop) {
   if (stop == 0) return (0);
   else return (price - stop * Point);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double StopShort(double price, int stop) {
   if (stop == 0) return (0);
   else return (price + stop * Point);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double TakeLong(double price, int stop) {
   if (stop == 0) return (0);
   else return (price + stop * Point);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double TakeShort(double price, int stop) {
   if (stop == 0) return (0);
   else return (price - stop * Point);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
double CalculateProfit() {
   double Profit = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0))
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit += OrderProfit();
   }
   return (Profit);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

double AccountEquityHigh() {
   if (CountTrades() == 0) AccountEquityHighAmt = AccountEquity();
   if (AccountEquityHighAmt < PrevEquity) AccountEquityHighAmt = PrevEquity;
   else AccountEquityHighAmt = AccountEquity();
   PrevEquity = AccountEquity();
   return (AccountEquityHighAmt);
}
//нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

double FindLastBuyPrice() {
   double oldorderopenprice;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0) && OrderType() == OP_BUY) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;
         }
      }
   }
   return (oldorderopenprice);
}

double FindLastSellPrice() {
   double oldorderopenprice;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticket=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || (OrderMagicNumber() != MagicNumber&&OrderMagicNumber()!=0)) continue;
      if (OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicNumber||OrderMagicNumber()==0) && OrderType() == OP_SELL) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;
         }
      }
   }
   return (oldorderopenprice);
}
//ннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

int Signal()
   {
   double Up=iCustom(Symbol(),Period(),"Ozymandias",Amplitude,0,1);
   double Dn=iCustom(Symbol(),Period(),"Ozymandias",Amplitude,1,1);
   double RSI1=iRSI(Symbol(),0,RSIPer,0,1);
   double RSI3=iRSI(Symbol(),0,RSIPer,0,3);
   int signal=0;

         //sell
   if((UseHour==1&&Hour()>=StartTime&&Hour()<=StopTime)||UseHour==0)
      {
      if(Dn>0&&RSI1<70&&RSI3>70) signal=-1;
      }
         //buy
   if((UseHour==1&&Hour()>=StartTime&&Hour()<=StopTime)||UseHour==0)
      {
      if(Up>0&&RSI1>30&&RSI3<30) signal=1;
      }
   
   return(signal);
   }
//+------------------------------------------------------------------+

//+-----------------------------------------------------------------------------------+
double NormalizeLot(double Lot2) 
   {
   double NormLot=NormalizeDouble(Lot2,lotdecimal);
   return (NormLot);
}
//+-----------------------------------------------------------------------------------+

double Lots()
{
switch(LotVariant)
   {
   case 1: Lot=fixed_lot(); break;
   case 2: Lot=fix_prop();  break;
   }
if(Lot<MinLot) Lot=MinLot;
return(NormalizeLot(Lot));
}
//+----------------------------------------------------------------------------+

//+------------------------------------------------------------------+
double fixed_lot()
{
Lot=FixLot;
return (NormalizeLot(Lot));
}
//+----------------------------------------------------------------------------+

//+------------------------------------------------------------------------------------+

double fix_prop()
{
if (AccountFreeMargin()<MoneyForOneLot) Lot=MinLot;
Lot=MathFloor(AccountFreeMargin()/MoneyForOneLot)*MinLot;
return (NormalizeLot(Lot));
}
//+-----------------------------------------------------------------------------------+

//+----------------------------------------------------------------------------+
//|  Расчет ТП                                                                 |
//+----------------------------------------------------------------------------+

int TakeProfit(int direction)
   {
   int Take=0;
   if (direction==OP_BUY)  Take=FixTP;
   if (direction==OP_SELL) Take=FixTP;
   return (Take);
   }
//+-----------------------------------------------------------------------------------+