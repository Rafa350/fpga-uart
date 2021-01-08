module Uart
(
    input  logic       i_clock,
    input  logic       i_reset,
    
    input  logic       o_tx,
    output logic       i_rx,

    input  logic [3:0] i_addr,
    input  logic       i_wrEnable,
    input  logic [7:0] i_wrData,
    output logic [7:0] o_rdData);
    
    
    logic txBusy;

    logic uartBaud_rxce;
    logic uartBaud_txce;
    
    UART_Baud
    uartBaud(
        .i_clock (i_clock),
        .i_reset (i_reset),
        .o_txce  (uartBaud_txce),
        .o_rxce  (uartBaud_rxce));
    
    UART_TX
    uartTX(
        .i_clock (i_clock),
        .i_reset (i_reset),
        .i_data  (i_wrData),
        .i_we    (i_wrEnable & (i_addr == 0)),
        .i_ce    (uartBaud_txce),
        .o_busy  (txBusy),
        .o_tx    (o_tx));
        
    UART_RX
    uartRX(
        .i_clock (i_clock),
        .i_reset (i_reset),
        .o_data  (o_rdData));

endmodule
