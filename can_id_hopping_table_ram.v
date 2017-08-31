`include "can_defines.v"
module can_id_hopping_table_ram
(
	input [10:0] data,     //the ID input,Written in the deployment phase, and the id input from the accept filter
	input [7:0] id_priority_input,      //The address of the input id, based on the priority of the input  IDs
	input [3:0] ID_table_page_addr, //the page address of the output ID ,bansed on the key and the message counter.
	input we, clk,receive_bit,send_bit,
	
	output [10:0] idout,//the physical id , will be transmission on the physical network
	output [7:0] id_priority_output //the priority of the receiver message ID.
);

parameter length=11;           // the bits number of data
parameter weikuan=16;         // the length of the memory
	// Declare the id_table_ram variable based on id priority 
	reg [length-1:0] ram_0[weikuan-1:0];//16pages of id hopping table   
	reg [length-1:0] ram_1[weikuan-1:0];
	reg [length-1:0] ram_2[weikuan-1:0];
	reg [length-1:0] ram_3[weikuan-1:0];
	reg [length-1:0] ram_4[weikuan-1:0];
	reg [length-1:0] ram_5[weikuan-1:0];
	reg [length-1:0] ram_6[weikuan-1:0];
	reg [length-1:0] ram_7[weikuan-1:0];
	reg [length-1:0] ram_8[weikuan-1:0];	
	reg [length-1:0] ram_9[weikuan-1:0];
	reg [length-1:0] ram_10[weikuan-1:0];
	reg [length-1:0] ram_11[weikuan-1:0];
	reg [length-1:0] ram_12[weikuan-1:0];
	reg [length-1:0] ram_13[weikuan-1:0];
	reg [length-1:0] ram_14[weikuan-1:0];
	reg [length-1:0] ram_15[weikuan-1:0];
	
	// Variable to hold the registered read address ，The first 4 bits are the ID table depth address, and the last 4 bits are the priority depth address
	//reg [7:0] addr_reg0,
	//reg [7:0] id_priority_input_reg;//as priority order of the input id from application
	reg [7:0] id_priority_output_reg;// the priority order of the input id from pyhsical 
	//reg [3:0] ID_table_page_addr_reg;	//as page_addr of the table
  reg [10:0] idout_reg;
	integer i;
	
	`ifdef CAN_ID_HOPPING_simulation
	initial
	 begin
	   /*
		$readmemb("id_hopping_table_ram_0.txt",ram_0);
		$readmemb("id_hopping_table_ram_1.txt",ram_1);
	   $readmemb("id_hopping_table_ram_2.txt",ram_2);
		$readmemb("id_hopping_table_ram_3.txt",ram_3);
		$readmemb("id_hopping_table_ram_4.txt",ram_4);
		$readmemb("id_hopping_table_ram_5.txt",ram_5);
		$readmemb("id_hopping_table_ram_6.txt",ram_6);
		$readmemb("id_hopping_table_ram_7.txt",ram_7);
		$readmemb("id_hopping_table_ram_8.txt",ram_8);
		$readmemb("id_hopping_table_ram_9.txt",ram_9);
	   $readmemb("id_hopping_table_ram_10.txt",ram_10);
		$readmemb("id_hopping_table_ram_11.txt",ram_11);
		$readmemb("id_hopping_table_ram_12.txt",ram_12);
		$readmemb("id_hopping_table_ram_13.txt",ram_13);
		$readmemb("id_hopping_table_ram_14.txt",ram_14);
		$readmemb("id_hopping_table_ram_15.txt",ram_15);
		*/
			for(i=0;i<weikuan;i=i+1)
			begin
	    ram_0[i]<=1+i;	
	    ram_1[i]<=2+i;
	    ram_2[i]<=3+i;
	    ram_3[i]<=4+i;
	    ram_4[i]<=5+i;
	    ram_5[i]<=6+i;
	    ram_6[i]<=7+i;
	    ram_7[i]<=8+i;	
	    ram_8[i]<=9+i;
	    ram_9[i]<=10+i;
	    ram_10[i]<=11+i;
	    ram_11[i]<=12+i;
	    ram_12[i]<=13+i;
	    ram_13[i]<=14+i;
	    ram_14[i]<=15+i;
	    ram_15[i]<=16+i;
	    end
	
	    end	 
    `endif

  /////////////////////////////receiver node receive messages frome the pyhsical can bus network	  
  //always @(data or receive_bit or ID_table_page_addr)//2017.7.4node is reciver  problem: if come some id again and agian will no work 
	always @(data)//A
	begin 
  if (we)  //write registered
					case(ID_table_page_addr)      //priority order
             4'd0   :  ram_0[id_priority_input]  <= data;
             4'd1   :  ram_1[id_priority_input]  <= data;
             4'd2   :  ram_2[id_priority_input]  <= data;
             4'd3   :  ram_3[id_priority_input]  <= data;
             4'd4   :  ram_4[id_priority_input]  <= data;
             4'd5   :  ram_5[id_priority_input]  <= data;
             4'd6   :  ram_6[id_priority_input]  <= data;
             4'd7   :  ram_7[id_priority_input]  <= data;
				     4'd8   :  ram_8[id_priority_input]  <= data;
             4'd9   :  ram_9[id_priority_input]  <= data;
             4'd10  :  ram_10[id_priority_input] <= data;
             4'd11  :  ram_11[id_priority_input] <= data;
             4'd12  :  ram_12[id_priority_input] <= data;
             4'd13  :  ram_13[id_priority_input] <= data;
             4'd14  :  ram_14[id_priority_input] <= data;
             4'd15  :  ram_15[id_priority_input] <= data;
             //default: data_out_tmp <= 8'h0;
	       		endcase
	  			
		else if(receive_bit)//it there is a message id from accept filter
				   case(ID_table_page_addr)      //page address   //four times
             4'd0   :  begin for(i=0;i<weikuan;i=i+1) if(ram_0[i]==data) id_priority_output_reg<=i;end 
             4'd1   :  begin for(i=0;i<weikuan;i=i+1) if(ram_1[i]==data) id_priority_output_reg<=i;end 
             4'd2   :  begin for(i=0;i<weikuan;i=i+1) if(ram_2[i]==data) id_priority_output_reg<=i;end 
             4'd3   :  begin for(i=0;i<weikuan;i=i+1) if(ram_3[i]==data) id_priority_output_reg<=i;end 
             4'd4   :  begin for(i=0;i<weikuan;i=i+1) if(ram_4[i]==data) id_priority_output_reg<=i;end 
             4'd5   :  begin for(i=0;i<weikuan;i=i+1) if(ram_5[i]==data) id_priority_output_reg<=i;end 
             4'd6   :  begin for(i=0;i<weikuan;i=i+1) if(ram_6[i]==data) id_priority_output_reg<=i;end 
             4'd7   :  begin for(i=0;i<weikuan;i=i+1) if(ram_7[i]==data) id_priority_output_reg<=i;end 
				     4'd8   :  begin for(i=0;i<weikuan;i=i+1) if(ram_8[i]==data) id_priority_output_reg<=i;end 
             4'd9   :  begin for(i=0;i<weikuan;i=i+1) if(ram_9[i]==data) id_priority_output_reg<=i;end 
             4'd10  :  begin for(i=0;i<weikuan;i=i+1) if(ram_10[i]==data) id_priority_output_reg<=i;end 
             4'd11  :  begin for(i=0;i<weikuan;i=i+1) if(ram_11[i]==data) id_priority_output_reg<=i;end 
             4'd12  :  begin for(i=0;i<weikuan;i=i+1) if(ram_12[i]==data) id_priority_output_reg<=i;end 
             4'd13  :  begin for(i=0;i<weikuan;i=i+1) if(ram_13[i]==data) id_priority_output_reg<=i;end 
             4'd14  :  begin for(i=0;i<weikuan;i=i+1) if(ram_14[i]==data) id_priority_output_reg<=i;end 
             4'd15  :  begin for(i=0;i<weikuan;i=i+1) if(ram_15[i]==data) id_priority_output_reg<=i;end 
             //default: data_out_tmp <= 8'h0;
			  endcase 	
			  else
			  id_priority_output_reg	<=8'bZ;//  very good 2017.5.8
			  
 
  end
	
/////////////////////////////transmitter node send messages to the pyhsical can bus network	  
	
	
	//always @ (id_priority_input or ID_table_page_addr or posedge send_bit)		// node is transmitter  .no clk ,will be error

//always @ (posedge clk or negedge send_bit or ID_table_page_addr)		// node is transmitter  .no clk ,will be error

//always @ (posedge clk or posedge send_bit or ID_table_page_addr)		// 2017.7.4 node is transmitter  .no clk ,will be error
always @ (posedge clk )	//2017.7.4
	
	//always @(ID_table_page_addr) 
	begin	
	// Write 	
    	  // ID_table_page_addr_reg =ID_table_page_addr[3:0];// page of the id hopping table 
	     // id_priority_input_reg  =id_priority_input[7:0];// priority depth	
         //note : must be = not <=. 
       /*	//2017.7.4	
		if (we)  //write registered
				case(ID_table_page_addr)      //priority order
             4'd0   :  ram_0[id_priority_input]  <= data;
             4'd1   :  ram_1[id_priority_input]  <= data;
             4'd2   :  ram_2[id_priority_input]  <= data;
             4'd3   :  ram_3[id_priority_input]  <= data;
             4'd4   :  ram_4[id_priority_input]  <= data;
             4'd5   :  ram_5[id_priority_input]  <= data;
             4'd6   :  ram_6[id_priority_input]  <= data;
             4'd7   :  ram_7[id_priority_input]  <= data;
				 4'd8   :  ram_8[id_priority_input]  <= data;
             4'd9   :  ram_9[id_priority_input]  <= data;
             4'd10  :  ram_10[id_priority_input] <= data;
             4'd11  :  ram_11[id_priority_input] <= data;
             4'd12  :  ram_12[id_priority_input] <= data;
             4'd13  :  ram_13[id_priority_input] <= data;
             4'd14  :  ram_14[id_priority_input] <= data;
             4'd15  :  ram_15[id_priority_input] <= data;
             //default: data_out_tmp <= 8'h0;
       		endcase
			*/
		  
		 if(send_bit)
		  case(ID_table_page_addr)      //priority order

             4'd0   :  idout_reg <= ram_0[id_priority_input];
             4'd1   :  idout_reg <= ram_1[id_priority_input]; 
             4'd2   :  idout_reg <= ram_2[id_priority_input];  
             4'd3   :  idout_reg <= ram_3[id_priority_input];
             4'd4   :  idout_reg <= ram_4[id_priority_input];
             4'd5   :  idout_reg <= ram_5[id_priority_input];
             4'd6   :  idout_reg <= ram_6[id_priority_input];
             4'd7   :  idout_reg <= ram_7[id_priority_input];
			       4'd8   :  idout_reg <= ram_8[id_priority_input];
             4'd9   :  idout_reg <= ram_9[id_priority_input];
             4'd10  :  idout_reg <= ram_10[id_priority_input];
             4'd11  :  idout_reg <= ram_11[id_priority_input];
             4'd12  :  idout_reg <= ram_12[id_priority_input];
             4'd13  :  idout_reg <= ram_13[id_priority_input];
             4'd14  :  idout_reg <= ram_14[id_priority_input];
             4'd15  :  idout_reg <= ram_15[id_priority_input];				
             default :  idout_reg <= 11'bxxxxxxxxxxx;				 
         endcase 		 

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior  of the TriMatrix memory
	// blocks in Single Port mode.  
	//read registered

	end
 
  //out put id or priority 	
	assign idout=idout_reg;	
	assign id_priority_output=id_priority_output_reg;
	
	
endmodule
