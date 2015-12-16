//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_data_aggregation.v
// Description     : WB Data Acquisition Aggregation
// Author          : Philip Tracton
// Created On      : Wed Dec 16 13:02:29 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 13:02:29 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


module wb_daq_data_aggregation (/*AUTOARG*/
   // Outputs
   data_out, fifo_push,
   // Inputs
   wb_clk, wb_rst, data_ready, data_width, adc_data_in
   ) ;

   parameter dw = 32;
   parameter adc_dw = 8;
   
   input wb_clk;
   input wb_rst;

   input data_ready;
   input [1:0] data_width;
   input [adc_dw-1:0] adc_data_in;   
   output reg [dw-1:0] data_out;
   output reg          fifo_push;
   reg [adc_dw-1:0]    adc_data_local;   
   reg [1:0]           byte_location;
   reg [2:0]           shift_delay;
   wire                data_ready_local;
   reg                 aggregate_data;

   
   assign data_ready_local = shift_delay[2];   
   always @(posedge wb_clk)
     if (wb_rst) begin
        shift_delay <= 1'b0;        
     end else begin
        shift_delay <= {shift_delay[1:0], data_ready};        
     end

   always @(posedge wb_clk)
     if (wb_rst) begin
        adc_data_local <= 0;  
        aggregate_data <= 0;        
     end else begin
        if (data_ready_local) begin
           adc_data_local <= adc_data_in;
           aggregate_data <= 1;           
        end else begin
           aggregate_data <= 0;        
        end
     end

   always @(posedge wb_clk)
     if (wb_rst) begin
        data_out <= 0;
        byte_location <= 0;  
        fifo_push <= 0;        
     end else begin
        if (aggregate_data) begin
           if (data_width == 0) begin
              // 8 bits from ADC to 32 bits to FIFO
              case (byte_location)
                0: data_out[07:00] <= adc_data_local;                
                1: data_out[15:08] <= adc_data_local;                
                2: data_out[23:16] <= adc_data_local;                
                3: data_out[31:24] <= adc_data_local;                
                default: data_out <= 0;             
              endcase // case (byte_location)
              
              byte_location <= byte_location + 1;
              if (byte_location == 3) begin
                 fifo_push <= 1;                 
                 byte_location <= 0;              
              end
              
           end else if (data_width == 1) begin // if (data_width == 0)
              // 16 bits from ADC to 32 bits to FIFO

              case (byte_location)
                0: data_out[15:00] <= adc_data_local;                
                1: data_out[31:16] <= adc_data_local;                
                default: data_out <= 0;             
              endcase // case (byte_location)
              
              byte_location <= byte_location + 1;
              if (byte_location == 1) begin
                 fifo_push <= 1 & !fifo_push;                 
                 byte_location <= 0;              
              end 
              
           end else if (data_width == 2) begin // if (data_width == 1)
              data_out <= adc_data_local;
              fifo_push <= 1;
           end                                 
        end else begin
        fifo_push <= 1'b0;
        end // else: !if(aggregate_data)        
     end // else: !if(wb_rst)
   
   
endmodule // wb_daq_data_aggregation