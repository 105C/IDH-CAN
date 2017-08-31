//input id output id_priority
`include "can_defines.v"

module can_id_priority_table
(
	input [10:0] application_id_input,
	input [7:0] addr,
	input we, clk,receive_bit,send_bit,
	output [7:0] priority_sent_id,////priority of the IDs outout
	output [10:0] application_id_output
);
  // Declare the RAM variable
  parameter weikuan=16;//maxmum 256 
	reg [10:0] ram[weikuan-1:0];

	// Variable to hold the registered read address
	//reg [7:0] addr_reg;
	reg [7:0]  outt;
	reg [10:0] application_id_output_reg;
	integer i;
	
	`ifdef CAN_ID_HOPPING_simulation
	initial
	begin
	//$readmemb("a_id_priority_table.txt",ram);
	for(i=0;i<weikuan;i=i+1)
	ram[i]<=i;	
	end
	`endif
	
//	always @ (application_id_input or addr or posedge clk)
  //always @(application_id_input or posedge send_bit )
  
  
	//always @(posedge clk or negedge send_bit) //2017.7.4
	always @(posedge clk )
	begin 
	// Write	
		   //if (we)
			//ram[addr] <= application_id_input;//write		//2017.7.4
		if(application_id_input===11'bx)//input IDs\ output priority of the ID
		outt<=8'bZ;
		else if(send_bit)
		  begin
			 for(i=0;i<weikuan;i=i+1)
			 
			    if(ram[i]==application_id_input)			 
			      outt=i;//putout the address of the input ID.
			      //addr_reg <= addr;
			end
	end	

	//always @(addr or clk)//2017.7.3
	always @(posedge clk)
	begin 	
		  if (receive_bit)		
		   application_id_output_reg<= ram[addr];			
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	
	//assign q = ram[addr_reg];
	assign priority_sent_id=outt;//output the priority of the input IDs
	assign application_id_output=application_id_output_reg;
endmodule

