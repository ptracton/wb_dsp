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
				wb_clk, wb_rst, data_ready, signed_data, adc_data_in
				) ;

   parameter ADC_DATA_WIDTH = 8;
   
   input wb_clk;
   input wb_rst;

   input data_ready;
   input signed_data;   
   input [ADC_DATA_WIDTH-1:0] adc_data_in;   
   output reg [31:0] data_out;
   output reg          fifo_push;
   reg [1:0] 	       byte_location;
   wire 	       sign_bit;
   wire [31:0] 	       sign_extend32;

   // If the high bit of the adc_data_in is asserted and we are looking for signed data, then grab this bit for using in sign extension
   // since the ADC_DATA_WIDTH is a parameter, it is not always in the same location
   assign sign_bit = (signed_data) ? adc_data_in[ADC_DATA_WIDTH-1] : 1'b0;

   // if we are looking for signed data, sign extend the input but the sign bit, else extend the original data to this size with leading
   // zeros since we are not operating with signed data.
   //
   // We don't do this for 8 bit data since that is the smallest size we work with.  For this size it doesn't matter if it is signed
   // or not, the 4 bytes are put together into a single word and sent out.
   assign sign_extend32 = (signed_data) ? {{(32-ADC_DATA_WIDTH){sign_bit}}, adc_data_in} : {{(32-ADC_DATA_WIDTH){1'b0}},adc_data_in};
   

   always @(posedge wb_clk)
     if (wb_rst) begin
        data_out <= 0;
        byte_location <= 0;  
        fifo_push <= 0;        
     end else begin
        if (data_ready) begin
           if (ADC_DATA_WIDTH <= 8) begin
              // 8 bits from ADC to 32 bits to FIFO
              case (byte_location)
                0: data_out[07:00] <= adc_data_in;                
                1: data_out[15:08] <= adc_data_in;                
                2: data_out[23:16] <= adc_data_in;                
                3: data_out[31:24] <= adc_data_in;                
                default: data_out <= 0;             
              endcase // case (byte_location)
              
              byte_location <= byte_location + 1;
              if (byte_location == 3) begin
                 fifo_push <= 1;                 
                 byte_location <= 0;              
              end
              
           end else if (ADC_DATA_WIDTH <=16) begin // if (data_width == 0)
              // 16 bits from ADC to 32 bits to FIFO

              case (byte_location)
		/* verilator lint_off WIDTH */
                0: data_out[15:00] <= sign_extend32[15:0];
                1: data_out[31:16] <= sign_extend32[15:0];
		/* verilator lint_on WIDTH */
                default: data_out <= 0;             
              endcase // case (byte_location)
              
              byte_location <= byte_location + 1;
              if (byte_location == 1) begin
                 fifo_push <= 1 & !fifo_push;                 
                 byte_location <= 0;              
              end 
              
           end else if (ADC_DATA_WIDTH <= 32) begin // if (data_width == 1)
	      /* verilator lint_off WIDTH */
              data_out <= sign_extend32;
	      /* verilator lint_on WIDTH */
              fifo_push <= 1;
           end else if (ADC_DATA_WIDTH > 32) begin
	      $display("INVALID ADC_DATA_WIDTH %d", ADC_DATA_WIDTH);
	      $finish();
	   end           
        end else begin
           fifo_push <= 1'b0;	   
        end // else: !if(data_ready)
     end // else: !if(wb_rst)
   
   
endmodule // wb_daq_data_aggregation
