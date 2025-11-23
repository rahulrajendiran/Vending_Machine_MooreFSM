`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2025 17:39:25
// Design Name: 
// Module Name: vending_mach_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module vending_mach_fsm(
    input  wire clk,
    input  wire reset,
    input  wire [1:0]  coin,           
    input  wire [6:0]  product_price,  
    input  wire cancel,        
    output reg  Z,            
    output reg  change_given,   
    output reg [6:0] change_amount, 
    output wire [6:0] balance_out,    
    output reg invalid_coin    
);

    localparam [8:0]
        Sin = 9'b000000001,
        S10 = 9'b000000010,
        S20 = 9'b000000100,
        S30 = 9'b000001000,
        S40 = 9'b000010000,
        S50 = 9'b000100000,
        S60 = 9'b001000000,
        S70 = 9'b010000000,
        S80 = 9'b100000000;

    reg [8:0] state, next_state;
    
    // Coin Values
    localparam TEN    = 2'b00;
    localparam TWENTY = 2'b01;
    localparam FIFTY  = 2'b10;

    // Debouncing Logic for Coin Input
    reg [1:0] stable_coin;
    reg [1:0] last_coin;
    reg [2:0] stable_count;
    reg       coin_ready;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            last_coin    <= 0;
            stable_coin  <= 0;
            stable_count <= 0;
            coin_ready   <= 0;
        end else begin
            coin_ready <= 0;

            if (coin == last_coin) begin
                stable_count <= stable_count + 1;
                if (stable_count == 3) begin
                    stable_coin <= coin;
                    coin_ready <= 1;
                end
            end else begin
                stable_count <= 1;
                last_coin <= coin;
            end
        end
    end

    // Balance Register , Timeout Auto Reset , Cancel Button

    reg [6:0] balance;
    reg [31:0] timeout_cnt;
    localparam TIMEOUT_LIMIT = 32'd500000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            balance <= 0;
            timeout_cnt <= 0;
            invalid_coin <= 0;
        end else begin
            invalid_coin <= 0;

            if (cancel) begin
                change_amount <= balance;
                change_given <= (balance > 0);
                balance <= 0;
            end

            if (coin_ready) begin
                timeout_cnt <= 0;
                case(stable_coin)
                    TEN:    balance <= balance + 10;
                    TWENTY: balance <= balance + 20;
                    FIFTY:  balance <= balance + 50;
                    default: invalid_coin <= 1;
                endcase
            end else begin
                if (timeout_cnt < TIMEOUT_LIMIT)
                    timeout_cnt <= timeout_cnt + 1;
                else begin
                    balance <= 0;
                    timeout_cnt <= 0;
                end
            end
        end
    end

    assign balance_out = balance;
    
    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= Sin;
        else
            state <= next_state;
    end

    // Next-State Logic 
    always @(*) begin
        next_state = state;

        case(state)

     
        // BASE STATE
        Sin:
            case(stable_coin)
                TEN:    next_state = S10;
                TWENTY: next_state = S20;
                FIFTY:  next_state = S50;
            endcase

        S10:
            case(stable_coin)
                TEN:    next_state = S20;
                TWENTY: next_state = S30;
                FIFTY:  next_state = S60;
            endcase

        S20:
            case(stable_coin)
                TEN:    next_state = S30;
                TWENTY: next_state = S40;
                FIFTY:  next_state = S70;
            endcase

        S30:
            case(stable_coin)
                TEN:    next_state = S40;
                TWENTY: next_state = S50;
                FIFTY:  next_state = S80;
            endcase

        default:
            next_state = Sin;

        endcase
    end

    // Output Logic 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Z <= 0;
            change_given <= 0;
            change_amount <= 0;
        end
        else begin
            Z <= 0;
            change_given <= 0;
            change_amount <= 0;
            if (balance >= product_price) begin
                Z <= 1;
                if (balance > product_price) begin
                    change_given <= 1;
                    change_amount <= balance - product_price;
                end
                balance <= 0;
            end
        end
    end

endmodule

