# 🚨 Trading Alert: Avoid CFDs 🚨

**_Warning_:**  
Trading Contracts for Difference (CFDs) can be extremely risky. Due to high leverage and volatility, CFDs can expose you to losses that exceed your initial investment—**potentially resulting in the loss of all your money**. 

**🔔 _Recommendation_:**  
For a safer trading environment, consider trading on **SPOT markets** (such as crypto spot or forex spot) where you are dealing with actual assets. SPOT trading generally involves lower leverage, which may reduce the risk of significant losses.  

**💡 _Reminder_:**  
- Always use proper risk management techniques.  
- Only trade with capital you can afford to lose.  
- Make sure to do thorough research or consult with a qualified financial advisor before making any trading decisions.

**_Disclaimer_:**  
This alert is provided for informational purposes only and does **not** constitute financial advice.




# ENHANCED MACD

**ENHANCED MACD** is a custom MACD indicator for MetaTrader 4 developed by [Seif Rached](https://github.com/seifrached/). It has been designed to offer enhanced flexibility and dynamic histogram visualization by allowing users to adjust key parameters and selectively display components.

### Image
![Image](https://github.com/user-attachments/assets/87288329-7b69-43b4-a8c8-2456adddfa6d)

## Key Features

- **Customizable Parameters:**  
  - **FastLength:** Fast moving average period (default = 12)  
  - **SlowLength:** Slow moving average period (default = 26)  
  - **SignalLength:** Signal smoothing period (default = 14)  
  - **Applied Price & MA Method:** Uses EMA by default (applied to the closing price).

- **Selective Display Options:**  
  - You can choose to show/hide the MACD line, signal line, and zero line.
  - Option to display or hide the histogram.

- **Dynamic Histogram Coloring:**  
  - The histogram’s color dynamically adjusts based on market conditions:
    - **Positive Values:** Displays with either a rising or falling color (default up: MediumSeaGreen when rising and Black when falling).
    - **Negative Values:** Displays with a rising or falling color (default down: Black when rising, Red when falling).
  - A dedicated buffer records numeric color codes (1=up positive, 2=up falling, 3=down positive, 4=down falling).

- **Multiple Indicator Buffers:**  
  - Uses 8 buffers to store and display the MACD line, signal line, dynamic histogram components, and a constant zero line for reference.

## How It Works

### Indicator Calculation

1. **MACD Line Calculation:**  
   - For each bar, the indicator computes two moving averages (using the selected method and applied price) with periods defined by `FastLength` and `SlowLength`.
   - The MACD line is the difference between the fast MA and the slow MA.
   
2. **Signal Line Smoothing:**  
   - If the EMA method is used, the signal line is calculated using an exponential smoothing based on a multiplier (2 / (SignalLength + 1)).
   - Otherwise, a simple moving average of the MACD line is used for the signal calculation.

3. **Histogram Generation:**  
   - The histogram is computed as the difference between the MACD line and the signal line.
   - The indicator then assigns the histogram value to one of four buffers (positive rising, positive falling, negative rising, negative falling) depending on whether the current histogram value has increased or decreased from the previous bar.
   - A separate buffer captures a numeric color code which can later be used for further analysis or modifications.

4. **Zero Line:**  
   - A constant buffer is populated with zero values to serve as a baseline, making it easier to visualize when the histogram crosses from positive to negative territory.

### Graphical Setup

- **Line & Histogram Styles:**  
  - The MACD line is drawn in blue (if enabled) and the signal line in orange.
  - The histogram is drawn as a histogram with a default width of 4 pixels (the color of each histogram bar is managed dynamically).
  - An optional zero-line is drawn in gray as a reference.

- **Buffers and Labels:**  
  - Each visual component (MACD, Signal, Histogram parts, and Zero) is tied to its own buffer, ensuring that the indicator displays a clear and organized view in a separate window.

## Customization Options

- **Display Options:**  
  Use boolean inputs to decide whether to show the MACD line (`ShowMACD`), signal line (`ShowSignal`), zero line (`ShowZeroLine`), or the histogram (`ShowHistogram`).

- **Histogram Colors:**  
  Adjust the colors for different histogram conditions:
  - `UpRisingColor`: Color when the histogram is positive and increasing.
  - `UpFallingColor`: Color when the histogram is positive but falling.
  - `DownRisingColor`: Color when the histogram is negative but rising.
  - `DownFallingColor`: Color when the histogram is negative and falling.

## Installation

1. **Copy the File:**  
   Place the `MY-PERSONAL-MACD.mq4` file into your `MQL4/Indicators` folder.
   
2. **Compile:**  
   Open the file in MetaEditor and compile it.
   
3. **Attach to Chart:**  
   In MetaTrader 4, open the Navigator panel, and drag the indicator onto a chart. It will display in a separate window as per the defined settings.

## Usage Notes

- **Data Handling:**  
  The indicator processes the current symbol’s data in the timeframe you are viewing. Ensure your chart has sufficient historical data for accurate calculation.
  
- **Performance:**  
  The indicator is optimized for performance, but as with any multi-buffer indicator, more bars in the chart may affect calculation speed.

## License

This indicator is open-source. For more details on permitted usage and distribution, please refer to the LICENSE file.

## Credits

Developed by [Seif Rached](https://github.com/seifrached/). Contributions, suggestions, and improvements are welcome!

