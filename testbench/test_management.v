  //
   // Free Running 100 MHz clock with a 50/50 duty cycle
   //
   reg clk;
   initial begin
      clk <= 1'b0;
      forever begin
         #5 clk <= ~clk;         
      end
   end
   
   //
   // Reset button -- Just after the design starts, assert
   // reset to the device.
   //
   reg reset;
   initial begin
      reset <= 1'b0;
      #13 reset <= 1'b1;
      #150 reset <= 1'b0;            
   end

   //
   // Test Managements
   //
   reg test_passed = 1'b0;
   reg test_failed = 1'b0;

   always @(posedge test_passed) begin
      $display("TEST PASSED @ %d", $time);
      #10 $finish;      
   end

   always @(posedge test_failed) begin
      $display("\n *** TEST FAILED *** @ %d\n", $time);
      #10 $finish;      
   end

   //
   // Do not let a test bench just run forever.
   //
   initial begin
      #50000000;
      $display("TEST CASE TIMEOUT @ %d", $time);      
      test_failed <= 1'b1;      
   end
