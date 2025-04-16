//+------------------------------------------------------------------+
//|                               MY-PERSONAL-MACD.mq4               |
//|          Copyright, Seif Rached - https://github.com/seifrached/ |
//|                                   https://github.com/seifrached/ |
//+------------------------------------------------------------------+
#property copyright "Copyright, Seif Rached - https://github.com/seifrached/"
#property link      "https://github.com/seifrached/"
#property version   "1.00"
#property description "MY PERSONAL MACD"


#property indicator_separate_window
#property indicator_buffers 8
//--- Colors for the plotted lines (MACD, Signal, Zero line)
#property indicator_color1 Blue          // MACD Line color
#property indicator_color2 Orange        // Signal Line color
#property indicator_color7 Gray          // Zero line

// The histogram colors will be set dynamically via inputs below.
// However, default colors are defined in the extern inputs.

#property indicator_width1 2
#property indicator_width2 2

// For histogram buffers, the style is defined in code.
#property indicator_style3 DRAW_HISTOGRAM
#property indicator_style4 DRAW_HISTOGRAM
#property indicator_style5 DRAW_HISTOGRAM
#property indicator_style6 DRAW_HISTOGRAM
#property indicator_style7 DRAW_LINE

//---- Input parameters
extern int   FastLength      = 12;  // Default was 12, now 100
extern int   SlowLength      = 26;  // Default was 26, now 200
extern int   SignalLength    = 14;   // Default was 9, now 14

extern ENUM_MA_METHOD MAMethod = MODE_EMA;
extern ENUM_APPLIED_PRICE AppliedPrice = PRICE_CLOSE;

extern bool  ShowMACD         = true; // Show MACD line, please set to False when using FastLength and SlowLength > 100
extern bool  ShowSignal       = true; // Show Signal line, please set to False when using FastLength and SlowLength > 100
extern bool  ShowZeroLine     = true;
extern bool  ShowHistogram    = true;

//---- External color inputs for the histogram conditions
extern color UpRisingColor    = clrMediumSeaGreen; // For positive histogram when rising
extern color UpFallingColor   = clrBlack;          // For positive histogram when falling
extern color DownRisingColor  = clrBlack;          // For negative histogram when rising
extern color DownFallingColor = clrRed;            // For negative histogram when falling


//---- Indicator buffers
double ExtMacdBuffer[];       // Buffer 0: MACD line
double ExtSignalBuffer[];     // Buffer 1: Signal line
double ExtHistUpPos[];        // Buffer 2: Histogram positive rising
double ExtHistDownPos[];      // Buffer 3: Histogram positive falling
double ExtHistUpNeg[];        // Buffer 4: Histogram negative rising
double ExtHistDownNeg[];      // Buffer 5: Histogram negative falling
double ExtZeroBuffer[];       // Buffer 6: Zero line
double ExtHistColorBuffer[];  // Buffer 7: Returns the numeric color of histogram(1=green,2=black in up,3 black in down, 4 red)

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{

   SetIndexBuffer(0, ExtMacdBuffer);
   SetIndexBuffer(1, ExtSignalBuffer);
   SetIndexBuffer(2, ExtHistUpPos);
   SetIndexBuffer(3, ExtHistDownPos);
   SetIndexBuffer(4, ExtHistUpNeg);
   SetIndexBuffer(5, ExtHistDownNeg);
   SetIndexBuffer(6, ExtZeroBuffer);
   SetIndexBuffer(7, ExtHistColorBuffer);
   

   if(ShowMACD)
      SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, Blue);
   else
      SetIndexStyle(0, DRAW_NONE);
   SetIndexLabel(0, "MACD");
   
   if(ShowSignal)
      SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2, Orange);
   else
      SetIndexStyle(1, DRAW_NONE);
   SetIndexLabel(1, "Signal");
   

   if(ShowHistogram)
   {
      SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 4, UpRisingColor);
      SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 4, UpFallingColor);
      SetIndexStyle(4, DRAW_HISTOGRAM, STYLE_SOLID, 4, DownRisingColor);
      SetIndexStyle(5, DRAW_HISTOGRAM, STYLE_SOLID, 4, DownFallingColor);
   }
   else
   {
      SetIndexStyle(2, DRAW_NONE);
      SetIndexStyle(3, DRAW_NONE);
      SetIndexStyle(4, DRAW_NONE);
      SetIndexStyle(5, DRAW_NONE);
   }
   SetIndexLabel(2, "Hist Up Positive");
   SetIndexLabel(3, "Hist Down Positive");
   SetIndexLabel(4, "Hist Up Negative");
   SetIndexLabel(5, "Hist Down Negative");
   

   if(ShowZeroLine)
      SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 1, Gray);
   else
      SetIndexStyle(6, DRAW_NONE);
   SetIndexLabel(6, "Zero");
   

   SetIndexStyle(7, DRAW_NONE);
   SetIndexLabel(7, "Hist Color");
   ArrayInitialize(ExtZeroBuffer, 0);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Cleanup code if needed
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
 
   if(rates_total <= 0)
      return(0);

   
   double tempMACD[];
   ArrayResize(tempMACD, rates_total);
   
   
   for(int i = 0; i < rates_total; i++)
   {
      double fastMA = iMA(NULL, 0, FastLength, 0, MAMethod, AppliedPrice, i);
      double slowMA = iMA(NULL, 0, SlowLength, 0, MAMethod, AppliedPrice, i);
      ExtMacdBuffer[i] = fastMA - slowMA;
      tempMACD[i] = ExtMacdBuffer[i];
      
      
      ExtZeroBuffer[i] = 0;
   }
   
  
   if(MAMethod == MODE_EMA)
   {
      ExtSignalBuffer[rates_total - 1] = tempMACD[rates_total - 1];
      double multiplier = 2.0 / (SignalLength + 1);
      for(int i2 = rates_total - 2; i2 >= 0; i2--)
         ExtSignalBuffer[i2] = (tempMACD[i2] - ExtSignalBuffer[i2 + 1]) * multiplier + ExtSignalBuffer[i2 + 1];
   }
   else 
   {
      for(int i3 = 0; i3 < rates_total; i3++)
      {
         double sum = 0;
         int count = 0;
         for(int j = i3; j < i3 + SignalLength && j < rates_total; j++)
         {
            sum += tempMACD[j];
            count++;
         }
         if(count > 0)
            ExtSignalBuffer[i3] = sum / count;
         else
            ExtSignalBuffer[i3] = 0;
      }
   }
   

   for(int i4 = 0; i4 < rates_total; i4++)
   {
      double hist = ExtMacdBuffer[i4] - ExtSignalBuffer[i4];
    
      color currentColor = (hist > 0) ? 1 : 3;
      
      if(i4 == rates_total - 1)
      {
         if(hist >= 0)
         {
            ExtHistUpPos[i4] = hist;
            currentColor = 1; 
         }
         else
         {
            ExtHistUpNeg[i4] = hist;
            currentColor = 3; 
         }
      }
      else
      {
         double prevHist = ExtMacdBuffer[i4 + 1] - ExtSignalBuffer[i4 + 1];
         if(hist >= 0)
         {
            if(prevHist < hist)
            {
               ExtHistUpPos[i4] = hist;
               currentColor = 1; 
            }
            else
            {
               ExtHistDownPos[i4] = hist;
               currentColor = 2; 
            }
         }
         else
         {
            if(prevHist < hist)
            {
               ExtHistUpNeg[i4] = hist;
               currentColor = 3; 
            }
            else
            {
               ExtHistDownNeg[i4] = hist;
               currentColor = 4; 
            }
         }
      }

      ExtHistColorBuffer[i4] = currentColor;
   }
   
   return(rates_total);
}
