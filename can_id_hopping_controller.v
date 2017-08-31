
//V1.0 2017.3.20 wwf in nagoya university

// This module for can_id_hopping.
module can_id_hopping_controller
( 
  clk,
 // rest_bit,
  we,
  id_i,
  receive_bit,
  send_bit,
  rx_tx_message_counter,
  
  
  id_o_1,  //convert application id to hopping ID for physical
  id_o_2  //convert hopping id to application ID
  
 // ID_table_page_addr,//for test  
 // priority_of_id_needle//for test
);
input   clk;
//input   rest_bit;
input   we;
input   [10:0] id_i;// Message wiht ID from application layer softwre; ID table write.
input   receive_bit;
input   send_bit;
input   [3:0]  rx_tx_message_counter;//meesage counter from physical

output  [10:0] id_o_1;
output  [10:0] id_o_2;//Is the output port can not be shared ?
//output  [7:0] priority_of_id_needle;//for test
//input   [3:0] ID_table_page_addr;//for test
//reg   [10:0] id_o_reg;  //Output ID
//reg   [7:0] priority_order; 

reg   [3:0]  IDchange_cunt; //like id_table_page_addr

//wire  [10:0] id_for_physical_send;
//wire  [10:0] id_for_application_receive;
wire  [7:0]  id_out_priority_reg; //The priority order of the current ID is determined based on the input ID and the previous application layer ID
wire  [7:0]  id_in_priority_reg;
//wire  [3:0]  ID_table_page_address;//like id_table_page_addr
//wire  [3:0]  rx_tx_message_counter;//meesage counter from physical
// Declare the ID_table variable

// Variable to hold the registered read address
//reg [3:0] addr_reg;
//wire over;

//instantiation of the id_priprity_order_table module
can_id_priority_table  i_can_id_priority_table
(
  .we(we),//write
	.clk(clk),
	.receive_bit(receive_bit),
	.send_bit(send_bit),
	
	.application_id_input(id_i),//ID of message come from application layer software 
	.addr(id_in_priority_reg),//Priority of the physical message ID
	
	.priority_sent_id(id_out_priority_reg),//priority outout
	.application_id_output(id_o_2)//convert priority to ID
);	

//instantiation of the id_table_ram module
can_id_hopping_table_ram  i_can_id_hopping_table_ram
(
	.we(we),//write enable
  .clk(clk),
	.receive_bit(receive_bit),
	.send_bit(send_bit),
	
	.data(id_i),//the ID input,Written in the deployment phase, and the id input from the accept filter
	.id_priority_input(id_out_priority_reg),//The address of the input id, based on the priority of the input  IDs
	.ID_table_page_addr(rx_tx_message_counter),//the page address of the output ID ,bansed on the key and the message counter.
	
	.idout(id_o_1),	//the physical id , will be transmission on the physical network
	.id_priority_output(id_in_priority_reg)	 //the priority of the receiver message ID.

);

//assign id_o_1=id_for_physical_send;
//assign id_o_2=id_for_application_receive;
//assign priority_of_id_needle=id_out_priority_reg;//for test 
//assign rx_tx_message_counter_wire=rx_tx_message_counter;//why when is 100 ,become to 10???wwfly2017.5.12
///////////////////////////////////////////////////////////
	
//Reg [10,0]  ID_table_for_ BasicCAN_message[7, 0]; 
initial
 begin
   IDchange_cunt=0;  

 end
 /*
always@(rx_tx_message_counter)//According to the message counter to determine the ID of the equipment cycle,
                             // according to the application layer to determine the KEY conversion rules
   begin
     
     //if(rx_tx_message_counter==255)//When the message counter is over 255, an ID hopping is performed     
     // IDchange_cunt=IDchange_cunt+1;        
     // if(IDchange_cunt==16)IDchange_cunt=0;
   end
*/
endmodule

