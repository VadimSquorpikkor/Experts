#property copyright "Copyright 2020, Sqr"
#property link      ""
#property version   "1.00"
#property strict




int OnInit()
  {
   Print("Эксперт инициализирован!");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
//---
   
  }

void OnTick()
  {
      Comment("Новая котировка - " + Symbol());
  }

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }

