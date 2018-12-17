module I2S_Audioin(AUD_XCK,
                 reset_n,
                 AUD_BCK,
				 AUD_DATA,
				 AUD_LRCK,
				 audiodata,
				 hex0,
				 hex1,
				 hex2,
				 hex3,
				 led0,
				 hex4,
				 hex5
				 );
input AUD_XCK;
input reset_n;
output reg AUD_BCK;
//output reg AUD_BCK;
input AUD_DATA;
output reg AUD_LRCK;
output reg [15:0] audiodata;
//=================================
//test
//=================================
reg [7:0] datacount; 
output reg [6:0] hex0;
output reg [6:0] hex1;
output reg [6:0] hex2;
output reg [6:0] hex3;
output reg [6:0] hex4;
output reg led0;
output reg [6:0] hex5;
////
//input [3:0] voi;
////

reg [7:0] bck_counter;
reg [7:0] lr_counter;
wire [7:0] bitaddr;

//reg AUD_BCK;
////
//always @(*)
////

//generate BCK 1.536MHz

always @ (posedge AUD_XCK or negedge reset_n)
begin
       if(!reset_n)
		 begin
		    bck_counter <= 8'd0;
			 AUD_BCK     <= 1'b0;
		 end
		 else
		 begin
		    
			 if(bck_counter >= 8'd5) //div XCK by 12
			 begin
			     bck_counter <= 8'd0;
				  AUD_BCK <= ~AUD_BCK;
			 end
			 else
			   bck_counter <= bck_counter + 8'd1;
		 end
		 
end

//generate LRCK, 48kHz, at negedge of BCK
always @ (negedge AUD_BCK or negedge reset_n)
begin
       if(!reset_n)
		 begin
		    lr_counter <= 8'd0;
			 AUD_LRCK     <= 1'b0;
		 end
		 else
		 begin
		    
			 if(lr_counter >= 8'd15) //div BCK by 32
			 begin
			     lr_counter <= 8'd0;
				  AUD_LRCK <= ~AUD_LRCK;
			 end
			 else
			   lr_counter <= lr_counter + 8'd1;
		end
		 
end

//send data, input data avaible at posedge of lrclk, prepared at the posedge of bck

assign  bitaddr  = 8'd15- lr_counter;
//assign  audiodata[bitaddr[3:0]] = AUD_DATA;
always @(*)
begin
	audiodata[bitaddr[3:0]] = AUD_DATA;
end
		
always @(posedge AUD_DATA)
begin
	datacount<=8'hac;
end		
		
always @(*)
begin
	case(audiodata[3:0])
		0: hex0=7'b1000000;  //0
		1: hex0=7'b1111001;  //1
		2: hex0=7'b0100100;  //2
		3: hex0=7'b0110000;  //3
		4: hex0=7'b0011001;  //4
		5: hex0=7'b0010010;  //5
		6: hex0=7'b0000010;  //6
		7: hex0=7'b1111000;  //7
		8: hex0=7'b0000000;  //8
		9: hex0=7'b0010000;  //9
		10: hex0=7'b0001000;  //10
		11: hex0=7'b0000011;  //11
		12: hex0=7'b1000110;  //12
		13: hex0=7'b0100001;  //13
		14: hex0=7'b0000110;  //14
		15: hex0=7'b0001110;  //15
		default: hex0=7'b0000000;
	 endcase 
	 
	 case(audiodata[7:4])
		0: hex1=7'b1000000;  //0
		1: hex1=7'b1111001;  //1
		2: hex1=7'b0100100;  //2
		3: hex1=7'b0110000;  //3
		4: hex1=7'b0011001;  //4
		5: hex1=7'b0010010;  //5
		6: hex1=7'b0000010;  //6
		7: hex1=7'b1111000;  //7
		8: hex1=7'b0000000;  //8
		9: hex1=7'b0010000;  //9
		10: hex1=7'b0001000;  //10
		11: hex1=7'b0000011;  //11
		12: hex1=7'b1000110;  //12
		13: hex1=7'b0100001;  //13
		14: hex1=7'b0000110;  //14
		15: hex1=7'b0001110;  //15
		default: hex1=7'b0000000;
	 endcase 
	 
	 case(audiodata[11:8])
		0: hex2=7'b1000000;  //0
		1: hex2=7'b1111001;  //1
		2: hex2=7'b0100100;  //2
		3: hex2=7'b0110000;  //3
		4: hex2=7'b0011001;  //4
		5: hex2=7'b0010010;  //5
		6: hex2=7'b0000010;  //6
		7: hex2=7'b1111000;  //7
		8: hex2=7'b0000000;  //8
		9: hex2=7'b0010000;  //9
		10: hex2=7'b0001000;  //10
		11: hex2=7'b0000011;  //11
		12: hex2=7'b1000110;  //12
		13: hex2=7'b0100001;  //13
		14: hex2=7'b0000110;  //14
		15: hex2=7'b0001110;  //15
		default: hex2=7'b0000000;
	 endcase
	 
	 case(audiodata[3:0])
		0: hex3=7'b1000000;  //0
		1: hex3=7'b1111001;  //1
		2: hex3=7'b0100100;  //2
		3: hex3=7'b0110000;  //3
		4: hex3=7'b0011001;  //4
		5: hex3=7'b0010010;  //5
		6: hex3=7'b0000010;  //6
		7: hex3=7'b1111000;  //7
		8: hex3=7'b0000000;  //8
		9: hex3=7'b0010000;  //9
		10: hex3=7'b0001000;  //10
		11: hex3=7'b0000011;  //11
		12: hex3=7'b1000110;  //12
		13: hex3=7'b0100001;  //13
		14: hex3=7'b0000110;  //14
		15: hex3=7'b0001110;  //15
		default: hex3=7'b0000000;
	 endcase
	 
	 led0 = AUD_BCK;
	 
	 case(datacount[3:0])
		0: hex4=7'b1000000;  //0
		1: hex4=7'b1111001;  //1
		2: hex4=7'b0100100;  //2
		3: hex4=7'b0110000;  //3
		4: hex4=7'b0011001;  //4
		5: hex4=7'b0010010;  //5
		6: hex4=7'b0000010;  //6
		7: hex4=7'b1111000;  //7
		8: hex4=7'b0000000;  //8
		9: hex4=7'b0010000;  //9
		10: hex4=7'b0001000;  //10
		11: hex4=7'b0000011;  //11
		12: hex4=7'b1000110;  //12
		13: hex4=7'b0100001;  //13
		14: hex4=7'b0000110;  //14
		15: hex4=7'b0001110;  //15
		default: hex4=7'b0000000;
	 endcase 
	 
	 case(datacount[7:4])
		0: hex5=7'b1000000;  //0
		1: hex5=7'b1111001;  //1
		2: hex5=7'b0100100;  //2
		3: hex5=7'b0110000;  //3
		4: hex5=7'b0011001;  //4
		5: hex5=7'b0010010;  //5
		6: hex5=7'b0000010;  //6
		7: hex5=7'b1111000;  //7
		8: hex5=7'b0000000;  //8
		9: hex5=7'b0010000;  //9
		10: hex5=7'b0001000;  //10
		11: hex5=7'b0000011;  //11
		12: hex5=7'b1000110;  //12
		13: hex5=7'b0100001;  //13
		14: hex5=7'b0000110;  //14
		15: hex5=7'b0001110;  //15
		default: hex5=7'b0000000;
	 endcase
	 
end		
		

endmodule 