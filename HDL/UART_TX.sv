module UART_TX
    import UART_Types::*;
(
    input  logic       i_clock,    // Clock
    input  logic       i_reset,    // Reset

    input  logic [7:0] i_data,     // Dades a tramsmitir
    input  logic       i_we,       // Habilita l'escriptura de dades

    input  Parity      i_parity,   // Paritat
    input  StopBits    i_stopBits, // Stop bits
    input  DataBits    i_dataBits, // Data bits

    input  logic       i_ce,       // Habilita el puls de transmissio
    output logic       o_busy,     // Indica que esta ocupat

    output logic       o_tx);      // Pin de sortida


    typedef enum logic [3:0] {
        State_IDLE,
        State_START,
        State_PARITY,
        State_DATA7,
        State_DATA6,
        State_DATA5,
        State_DATA4,
        State_DATA3,
        State_DATA2,
        State_DATA1,
        State_DATA0,
        State_STOP1,
        State_STOP2
    } State;


    State       state;
    State       nextState;
    logic [7:0] data;
    logic       dataRdy;


    always_ff @(posedge i_clock)
        if (i_reset)
            dataRdy <= 1'b0;
        else if (i_we & !dataRdy) begin
            data <= i_data;
            dataRdy <= 1'b1;
        end
        else if (i_ce & dataRdy) begin
            state <= nextState;
            if (nextState == State_IDLE)
                dataRdy <= 1'b0;
        end

    // Evalua el proper estat
    //
    always_comb
        unique case (state)
            State_IDLE :
                nextState = dataRdy ? State_START : state;

            State_START:
                unique case (i_dataBits)
                    DataBits_7:
                        nextState = State_DATA6;
                    DataBits_6:
                        nextState = State_DATA7;
                    default:
                        nextState = State_DATA7;
                endcase

            State_DATA7:
                nextState = State_DATA6;

            State_DATA6:
                nextState = State_DATA5;

            State_DATA5:
                nextState = State_DATA4;

            State_DATA4:
                nextState = State_DATA3;

            State_DATA3:
                nextState = State_DATA2;

            State_DATA2:
                nextState = State_DATA1;

            State_DATA1:
                nextState = State_DATA0;

            State_DATA0:
                if (i_stopBits == StopBits_1)
                    nextState = State_STOP2;
                else
                    nextState = State_STOP1;

            State_STOP1:
                nextState = State_STOP2;

            default:
                nextState = State_IDLE;
        endcase

    // Evalua la sortida o_tx
    //
    always_comb begin
        unique case (state)
            State_START : o_tx = 1'b0;
            State_PARITY: o_tx = 0;
            State_DATA7 : o_tx = data[7];
            State_DATA6 : o_tx = data[6];
            State_DATA5 : o_tx = data[5];
            State_DATA4 : o_tx = data[4];
            State_DATA3 : o_tx = data[3];
            State_DATA2 : o_tx = data[2];
            State_DATA1 : o_tx = data[1];
            State_DATA0 : o_tx = data[0];
            default     : o_tx = 1'b1;
        endcase
    end

    // Evalua la sortida o_busy
    //
    assign o_busy = state != State_IDLE;

endmodule
