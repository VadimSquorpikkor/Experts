#property copyright "Copyright 2020, Sqr"
#property strict

input int takeProfit = 140;//120-100
input int stopLoss = 70;
input double input_lots = 0.01;

int order_id;
int ticket;
double lots = input_lots;

extern int Magic = 12345;

int direction = OP_BUY;

int count = 0;
//int multArray[] = {1,2,4,7,10,13};
int multArray[] = {1};

int OnInit(){
   Print("Эксперт инициализирован!");
   return(INIT_SUCCEEDED);
}

void OnTick(){
   OrderSelect(0, SELECT_BY_POS);
   
   showInfo();
      
   if(OrderProfit() >= takeProfit * lots){
      Comment("Profit: " + OrderProfit());
      closeOrder();
      lots = input_lots;
      count = 0;
   }
   
   if(OrderProfit() <= (-1) * stopLoss * lots){
      Comment("Loss: " + OrderProfit());
      //int temp = direction;
      if(direction == OP_BUY){direction = OP_SELL;}
      else if(direction == OP_SELL){direction = OP_BUY;}
      //Comment("было: " + temp + " стало: " + direction);
      
      closeOrder();
      /////lots = lots + input_lots;
      count++;
      if(count>=ArraySize(multArray)){
         lots = lots + input_lots;
      } else {
         lots = input_lots * multArray[count];
      }
   }

   if (OrdersTotal() == 0){
      openOrder();
   }
}

void openOrder(){
   if(direction == OP_BUY){
      order_id = OrderSend(Symbol(), OP_BUY, lots, Ask, 10, 0, 0, "", Magic, 0);
      //if (order_id == -1) {
      //   lots = lots - input_lots;
      //   openOrder();
      //   }
   }
   else if(direction == OP_SELL) {
      order_id = OrderSend(Symbol(), OP_SELL, lots, Bid, 10, 0, 0, "", Magic, 0);
   }
}

void closeOrder(){
//      Alert("Закрытие ордера");
//    Print("sMACD (", Symbol(), ", ", Period(), ")  -  BUY!!!");
//    Comment("sMACD (", Symbol(), ", ", Period(), ")  -  BUY!!!");
//    PlaySound("TrainHorn.wav");    

      OrderSelect(0, SELECT_BY_POS);
      double temp = OrderProfit();
      if(OrderType()==OP_BUY){
         if(!OrderClose(OrderTicket(),OrderLots(),Bid,3)){
            Comment("OrderClose error! ",GetLastError());
         } //else {Comment("");}
      }
      else if(OrderType()==OP_SELL){
         if(!OrderClose(OrderTicket(),OrderLots(),Ask,3)){
            Comment("OrderClose error! ",GetLastError());
         } //else {Comment("");}
      }
      
      Alert("Закрытие ордера: " + temp);
      PlaySound("TrainHorn.wav");
}

void showInfo(){
   string type;
   string next;
   if (OrderType()==1) type="SELL";
   else type="BUY";
   if (direction==OP_SELL) next="GO_DOWN";
   else if (direction==OP_BUY) next="GO_UP";
   //Comment("" + type + " Balance: " + AccountBalance() + ", Order: " + DoubleToStr(OrderProfit(), 2) + ", Lots: " + DoubleToStr(OrderProfit()/lots, 2) + ", SL: " + stopLoss + ", TP: " + takeProfit + ", next: " + next);
   
   ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
   ObjectSet("1", OBJPROP_CORNER, 0);
   ObjectSet("1", OBJPROP_XDISTANCE, 20);
   ObjectSet("1", OBJPROP_YDISTANCE, 25);
   ObjectSetText("1", DoubleToStr(OrderProfit(), 2), "Times New Roman",Red);
   ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
   ObjectSet("2", OBJPROP_CORNER, 0);
   ObjectSet("2", OBJPROP_XDISTANCE, 20);
   ObjectSet("2", OBJPROP_YDISTANCE, 45);
   ObjectSetText("2", "Lots: " + DoubleToStr(OrderProfit()/lots, 0) + ", SL: " + stopLoss + ", TP: " + takeProfit, "Arial", Green);
   ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
   ObjectSet("3", OBJPROP_CORNER, 0);
   ObjectSet("3", OBJPROP_XDISTANCE, 20);
   ObjectSet("3", OBJPROP_YDISTANCE, 65);
   ObjectSetText("3", "Balance: " + DoubleToStr(AccountBalance(), 2), "Arial", Green);
   ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
   ObjectSet("4", OBJPROP_CORNER, 0);
   ObjectSet("4", OBJPROP_XDISTANCE, 20);
   ObjectSet("4", OBJPROP_YDISTANCE, 85);
   ObjectSetText("4", type, "Arial", Green);
   ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
   ObjectSet("5", OBJPROP_CORNER, 0);
   ObjectSet("5", OBJPROP_XDISTANCE, 20);
   ObjectSet("5", OBJPROP_YDISTANCE, 105);
   ObjectSetText("5", "Объем: " + lots, "Arial", Green);
}