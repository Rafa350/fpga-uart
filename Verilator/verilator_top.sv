`ifdef VERILATOR
`include "UART_Types.sv"
`endif

module top
(
    input  logic i_clock,          // Clock
    input  logic i_reset,          // Reset

    input  logic [3:0] i_addr,
    input  logic       i_wrEnable,
    input  logic [7:0] i_wrData,
    output logic [7:0] o_rdData,

    input  logic i_rx,             // Senyal RX
    output logic o_tx);            // Senyal TX

    UART
    uart (
        .i_clock    (i_clock),
        .i_reset    (i_reset),
        .i_rx       (i_rx),
        .o_tx       (o_tx),
        .i_addr     (i_addr),
        .i_wrData   (i_wrData),
        .i_wrEnable (i_wrEnable),
        .o_rdData   (o_rdData));


endmodule
