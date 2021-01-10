package UART_Types;

    typedef enum logic {
        StopBits_1,
        StopBits_2
    } StopBits;

    typedef enum logic [1:0] {
        DataBits_8,
        DataBits_7,
        DataBits_6
    } DataBits;

    typedef enum logic[3:0] {
        Parity_None,
        Parity_Even,
        Parity_Odd,
        Parity_Mark,
        Parisy_Space
    } Parity;


endpackage
