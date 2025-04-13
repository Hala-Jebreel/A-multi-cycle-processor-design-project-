//Sara Awaysa-1211642
//Hala Jebreel-1210606
//Section3
//Multi cycle processor

//_______________________________________________________top level module_____________________________________________________________ 
	
module top_level ( 
	input reset,
    input clk,
	output reg [15:0] pc_out,
	output reg signed [15:0] alu_result,
	output reg signed [15:0] data_out, 
	output reg [2:0] pcSrc,
	output reg[1:0] selection1,
	output reg [1:0]  ALUop,
	output reg  extOp,  src1, zero, carry, overflow, positive, negative, selection2, memoryData, wbData, memoryRead, memoryWrite, operand2, mode, dataSelector ,
	output reg [15:0] instruction,
	output reg [2:0] stage 
);	 	

//___________________________________________________-Give initial Valuse for control signals___________________________________________
	
	initial begin	
		pcSrc=0;
		extOp<=0;
		selection1<=0;
		src1 <=0;
		zero<=0;
		carry<=0;
		overflow<=0;
		positive<=0;
		negative<=0;
		ALUop<=0;
		selection2<=0;
		memoryData<=0;
		memoryRead<=0;
		memoryWrite<=0;
		operand2 <=0;
	    wbData <= 0;   
		mode <= 0;
		dataSelector<=0;
	  end
	  
//_____________________________________defin Memorys & register file_________________________________________________________________

		parameter AND = 2'b00;   //defin and as parametr with 2'b00
	    parameter ADD = 2'b01;   //defin add as parametr with 2'b01
	    parameter SUB = 2'b10;   //defin sub as parametr with 2'b10
	    reg signed [7:0] dataMem [0:200] ;	//defin Data memory  
		reg signed [15:0] registers [0:7];  //dein registers 
		reg signed [15:0] data_in;			//defin data in 
	    reg [7:0] mem [0:200];		 
	    reg [3:0] opcode; //defin opcode
	    reg [15:0] dest;
	    reg write_reg_file;	  	    
		reg [15:0] pc_in;  
		reg [2:0] temp ;
	
//__________________________________initillaize values for the register file & data memory ____________________________________________
	
		initial begin
		registers[0]= 16'h0000; 	 
		registers[1]= 16'h1066; 
		registers[2]= 16'h15DC;
		registers[3]= 16'h385A;
		registers[4]= 16'h1DBC; 
		registers[5]= 16'h19EE; 
		registers[6]= 16'h2738; 
		registers[7]= 16'h0F5A; 
		
		dataMem[1] <= 8'h04;
		dataMem[2] <= 8'h00;
		dataMem[5] <= 8'h80;
		dataMem[129] <=	8'h88;
		
//___________________________________ Initialize memory with encoded instructions_______________________________________________________

        mem[0]  = 8'h10;   
        mem[1]  = 8'h02;   	   
        mem[2]  = 8'h58;   
        mem[3]  = 8'h14;   
        mem[4]  = 8'hE0;   
        mem[5]  = 8'h26;    
        mem[6]  = 8'h66;   
        mem[7]  = 8'h34;
        mem[8]  = 8'h9F;   
        mem[9]  = 8'h45;   
        mem[10] = 8'h01;  
        mem[11] = 8'h51;    
        mem[12] = 8'h21;
        mem[13] = 8'h65;
        mem[14] = 8'hA1;   
        mem[15] = 8'h6D;   
        mem[16] = 8'h04;   
        mem[17] = 8'h75; 
		mem[18] = 8'h04; 
        mem[19] = 8'h65;   
        mem[20] = 8'h05;   
        mem[21] = 8'h6D; 
		mem[22] = 8'h64;
		mem[23] = 8'h82; 
		//mem[22] = 8'h44;
		//mem[23] = 8'h83;
		mem[24] = 8'h58; 
		mem[25] = 8'h14; 
		mem[26] = 8'h10;   
        mem[27] = 8'h02;  
		mem[28] = 8'h04;
		mem[29] = 8'h89; 
		mem[30] = 8'h58;
		mem[31] = 8'h14;
		mem[32] = 8'h10;
		mem[33] = 8'h02;  
		mem[34] =  8'h26;
		mem[35] = 8'hD0;
		mem[36] = 8'h58;
		mem[37] = 8'h14;
		mem[38] = 8'h14;
		mem[39] = 8'hF0;  
		mem[40] = 8'h00;
		mem[41] = 8'hE0;
		stage= 3'b000; //start with the first stage
		pc_in = 0; 	   //pc_in start with 0
		end
				 
	
//_________________________________________________________________________________________________________________________


    always @(posedge clk or posedge reset) begin 
		if (reset)	begin
			pc_out = 16'b0;
			stage = 3'b000;
		end	
		else begin
            case (stage)   // Cases beased on stage
				
//__________________________________________________Fetch Stage_____________________________________________________________
				
                3'b000: begin   // Fetch Stage  
                    pc_out = pc_in;   // Increment by 2 for next instruction
                    stage = 3'b001;	  // go to stage 3'b001 (decode)
                end	
				
//___________________________________________________Decode Stage___________________________________________________________
				
                3'b001: begin // Decode stage    
                    instruction = {mem[pc_out+1], mem[pc_out]};  	//concatination
                    opcode = instruction[15:12];  // the opcode is the [15:12] from the instruction
                    stage = 3'b010;	  // move to excecute stage 
                end	
				
//__________________________________________________Execute stage___________________________________________________________
				
                3'b010: begin 	    // Execution logic based on opcode 	
                    if (opcode == 4'b0000) begin //AND R-type
						pc_in = pc_in + 2;	 //pc_in is pc_in + 2
                        dest = instruction[11:9];  //the destination is the instruction from [11:9] 
                        alu_result = registers[instruction[8:6]] & registers[instruction[5:3]]; // the alu result 
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b100;    //write back stage
						wbData = 2'b00;    //wbdata is 2'b00
						pcSrc = 0;		   // pcSrc is 0
						//extOp = 1'hx;    //this  is not essination in the test bench it loook like x  becuse it is adont care
						selection1 = 0;	   //selection is 0
						src1 =1;		   //src1 is 1
						
						
						//check if alu result equal to 0 
						if (alu_result ==0)begin 
							zero =1; //  set zero flag
						end	
						else  //if alu result !=0 
							zero=0;   //zero flag =0
							carry =0;   //cary flag 0
						    overflow = 0;   //overflow falg 0
							
							
						if (alu_result >0)begin // if alu result is grater than 0   
							positive =1;  //positive flag =1
							negative =0;  // negative flag =0
						end	  
						
						
						else if (alu_result <0) begin // if alu result is less than 0 
							positive =0;  //positive flag =0
							negative =1;  //negative flag =1
						end	   
						
						ALUop = AND; //the Alu op is and 
						selection2 =1;  //selection is 1 
						//memoryData = 1'hx;  this value is not essination in the test bench it loook like x  becuse it is adont care
						memoryRead=0;	 //memory read is 0
						memoryWrite=0;   //memorywrite is 0 
						operand2=1;	     //operand 1 is 1 
						
                    end	 
					//**********************************************
					
					 else if (opcode == 4'b0001) begin // ADD R-type
						pc_in = pc_in + 2;	//incremet pc_in with2
                        dest = instruction[11:9]; //dest in the instruction from [11:9]
                        {carry,alu_result} = registers[instruction[8:6]] + registers[instruction[5:3]];
						alu_result= registers[instruction[8:6]] + registers[instruction[5:3]];
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b100; 	//write back stage 
						wbData = 2'b00; 	//wbData is 2'b00
						pcSrc = 0;		   //pcSrc is 0
						//extOp = 1'hx;	  this value is not essination in the test bench it loook like x  becuse it is adont care
						selection1 = 0;  //selection 1 is 0
						src1 =1;	
						
						if (alu_result ==0)begin   //check if alu result equal to 0 
							zero =1; //set zero flag to 1
						end	 
						
						else 
							zero=0;	//zero flag is 0
						if ((registers[instruction[8:6]][15] && registers[instruction[5:3]][15] && !(alu_result[15])) || (!(registers[instruction[8:6]][15]) && !(registers[instruction[5:3]][15]) && alu_result[15])) 
						    overflow = 1; //over flow flag is 1
						
						else 
							overflow = 0; // over flow flag is 0
							
						if (alu_result >0)begin //check if alu result gtreater than  0 
							positive =1;   //positive flag is 1 
							negative =0;   //negative falg is 0
						end	 
						
						else if (alu_result <0) begin //check if alu result less than 0 
							positive =0;	//positive flag is 0
							negative =1;	//negative flag is 1
						end	
						
						ALUop = ADD; //Alu operation is add
						selection2 =1;	 //selection2 is 1 
						//memoryData = 1'hx;  this value is not essination in the test bench it loook like x  becuse it is adont care
						memoryRead=0;	 //memory read is 0
						memoryWrite=0;	 //memory write is 0
						operand2=1;		 //  operand2 is 1
                    end		
					//********************************************** 
					
					else if (opcode == 4'b0010) begin // SUB R-type	
						pc_in = pc_in + 2;	  // increment pc_in + 2 
                        dest = instruction[11:9];	
                        alu_result = registers[instruction[8:6]] - registers[instruction[5:3]];  //ALU resule (sub operation) 
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b100;	 //write back stage
						wbData = 2'b00; //Wbdata is 2'b00
						pcSrc = 0;		// pc src is 0 
						//extOp = 1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care
						selection1 = 0;	//selection 1 is 0
						src1 =1;		//src 1 is 1
						
						if (alu_result ==0)begin  //check if alu result equal to 0
							zero =1;  //zero flag is 1
						end	   
						else 
							zero=0; //zero falg is 0
							
						if (registers[instruction[8:6]]>=registers[instruction[5:3]])begin 		
							carry =1; // Borrow =0
						end
						else  
							carry =0; // Borrow =1
							
						if ((registers[instruction[8:6]][15] && registers[instruction[5:3]][15] && !(alu_result[15])) || (!(registers[instruction[8:6]][15]) && !(registers[instruction[5:3]][15]) && alu_result[15])) 
						overflow = 1; //overflow falg is 1
						else
							overflow = 0; //over flow falg is 0
							
						if (alu_result >0)begin //check if alu result greater than0
							positive =1;  //positive flag is 1
							negative =0; //negative flag is 0
						end	   
						
						else if (alu_result <0) begin //check if alu result less than 0
							positive =0;  //positive flag is 0
							negative =1;  //negative flag is 1
						end
						
						ALUop = SUB; //the alu operation is sub
						selection2 =1;	 //selection 2 is 1
						memoryRead=0;	 //memory read is 0
						memoryWrite=0;	 //memmory write is 0
						operand2=1; 	 //operand 2 is 1
						//memoryData = 1'hx; this value is not essination in the test bench it loook like x  becuse it is adont care

                    end	   
					//**********************************************
				   
					else if (opcode == 4'b0011) begin // ADDI I
						pc_in = pc_in + 2;  //incremet oc_in with 2
                        dest = instruction[10:8]; 
                       {carry, alu_result} = registers[instruction[7:5]] + {{11{instruction[4]}},instruction[4:0]};
					   	alu_result = registers[instruction[7:5]] + {{11{instruction[4]}},instruction[4:0]};
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b100;	 //Write back stage
						wbData = 2'b00;  //wbData 2'b00
						pcSrc = 0;		 //pc srs 0
						extOp = 1;		 //exctintion
						src1 =1;
						//selection1 = 1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care	
						
						if (alu_result ==0)begin//check if alu result equal to 0 
							zero =1;  //zero flag is 1
						end	 
						else 
							zero=0;	 //zero flag is 0
							
						if ((registers[instruction[7:5]][15] && {{11{instruction[4]}},registers[instruction[4:0]]}[15] && !(alu_result[15])) || (!(registers[instruction[7:5]][15]) && !({{11{instruction[4]}},registers[instruction[4:0]]}[15]) && alu_result[15])) 
						overflow = 1;
						else
							overflow = 0;  
							
						if (alu_result >0)begin //check if alu result greater than 0
							positive =1;  //positive flag is 1
							negative =0;  //negative flag is 0
						end	 
						
						else if (alu_result <0) begin //check if alu result less than 0
							positive =0; //positive flag is 0
							negative =1; //negative flag is 1
						end	   
						
						ALUop = ADD;  //operation in alu is add
						selection2 =1;
						memoryRead=0;
						memoryWrite=0;
						operand2=0;	
						//memoryData = 1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care
                    end	   
					//**********************************************
					
					else if (opcode == 4'b0100) begin // AND I	 
						pc_in = pc_in + 2;	 //incremant pc by 2
                        dest = instruction[10:8];  //destination reg 
                        alu_result = registers[instruction[7:5]] & {11'b0,instruction[4:0]}; //alu resut 
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b100; //Stage is write back
						wbData = 2'b00; 
						pcSrc = 0;
						extOp = 0;
						src1 =1;
						//selection1 = 1'hx;  
						
						if (alu_result ==0)begin //check alu result
							zero =1;  //zero flag 1
						end	 
						else 
						zero=0;	 //zero flag is 0
						carry =0;  //carry flag	 0
						overflow = 0; 	//overflow flag is 0
						
						if (alu_result >0)begin 
							positive =1; // positive flag is 1
							negative =0; // negative flag is 0
						end	 		 
						
						else if (alu_result <0) begin
							positive =0; //positive flag is 0
							negative =1; //positive flag is1
						end	   
						
						ALUop = AND; //operation is and
						selection2 =1; //selection 2 is 1
						memoryRead=0; //memory read is 0
						memoryWrite=0; //memory write is0
						operand2=0;    //operand 2 is 0
						//memoryData = 1'hx; this value is not essination in the test bench it loook like x  becuse it is adont care

                    end		
					//**********************************************
					
					else if (opcode == 4'b0101) begin // LW I-wbDatape
						pc_in = pc_in + 2; //increamat pc_in by 2
                        dest = instruction[10:8]; //destination reg
                        alu_result = registers[instruction[7:5]] +  {{11{instruction[4]}},instruction[4:0]};  
						//give the valuse for the control signals
                        write_reg_file = 1; // Set write enable for register file
						stage = 3'b011;
						wbData = 2'b01; 
						pcSrc = 0;
						extOp = 1;
						src1 =1;
						ALUop = ADD;
						selection2 =1;
						memoryRead=1;
						memoryWrite=0;
						operand2=0; 
						dataSelector = 0;
						//selection1 = 1'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
						//memoryData = 1'hx; 	
                    end
					
					//**********************************************
					else if (opcode == 4'b0110)begin //LB
						pc_in = pc_in + 2;
						 write_reg_file = 1; // Set write enable for register file
						stage = 3'b011; 
						wbData = 2'b01; 
						dest = instruction[10:8]; 
						dataSelector = 1;
						
						//when mode bit is 0
						if (instruction[11]==0)begin //LB unsigned ==> zero extension 
                        alu_result = registers[instruction[7:5]] + {{11{instruction[4]}},instruction[4:0]}; 
						pcSrc = 0;	 //give valluse for the control signals
						extOp = 1;
						src1 =1;
						ALUop = ADD;
						selection2 =1;
						memoryRead=1;
						memoryWrite=0;
						operand2=0; 
						mode = 0;
						//memoryData = 1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care
						//selection1 = 1'hx; 	
						end	
					
						//when mode bit is 1 is LBS
					else if (instruction[11]==1)begin	  
				        alu_result = registers[instruction[7:5]] + {{11{instruction[4]}},instruction[4:0]}; 
					    pcSrc = 0; ////give valluse for the control signals
						extOp = 1;
						src1 =1;
						ALUop = ADD;
						selection2 =1;
						memoryRead=1;
						memoryWrite=0;
						operand2=0; 	
						mode = 1;
						//memoryData = 1'hx; this value is not essination in the test bench it loook like x  becuse it is adont care
						//selection1 = 1'hx; 	
					end	  
						end	
					//********************************************** 
					
					else if (opcode == 4'b0111) begin  //SW 
						dest = instruction[10:8]; 
                        alu_result = registers[instruction[7:5]] +  {{11{instruction[4]}},instruction[4:0]};
                        write_reg_file = 0; // Set write enable for register file
						stage = 3'b011;  
						pcSrc = 0;
						extOp = 1;
						src1 =1;
						ALUop = ADD;
						selection2 =1;
						memoryData = 1;
						memoryRead=0;
						memoryWrite=1;
						operand2=0;
						pc_in = pc_in + 2;
						//wbData = 2'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care	 
						//selection1 = 1'hx; 	
					end	 	
					//**********************************************
					
					else if (opcode == 4'b1000) begin // BGT & BGTZ 	
						dest = instruction[10:8];  //destination reg
						write_reg_file = 0;	  
						stage = 3'b000;   //fetch stage
						//wbData = 2'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
						if (instruction[11]==0) begin 
							src1= 1;
							selection1 =1;
							if (registers[dest]>registers[instruction[7:5]])begin	// Branch is taken 
								pcSrc = 1;	//give valuse forcontrol signals
								extOp =1; 
								zero =0;
								overflow = 0;
								negative =0;
								positive =1; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
							    //carry = 1'hx;		
							    //selection2 = 1'hx; 	
								//memoryData = 1'hx; 	
								pc_in = pc_in + {{11{instruction[4]}},instruction[4:0]};

							end	
							
						else if (instruction[11]==0 &&registers[dest]<=registers[instruction[7:5]]) begin // Branch is not taken
								pcSrc = 0;	//give valuse for control signals
								extOp =1; 
								overflow = 0;
								negative = 1;
								positive =0; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care	
								//selection2 = 1'hx; 	
								//memoryData = 1'hx; 
								//carry = 1'hx;
								//zero = 1'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
							    pc_in = pc_in +2;
							end	
						end
						
					//**********************************************	
					else if (instruction[11]==1) begin 	// BGTZ  
						src1= 0;
						selection1 =1;
							if (registers[dest]>registers[0])begin
								pc_in = pc_in + {{11{instruction[4]}},instruction[4:0]}; //change the value of pc_in
								pcSrc = 1;	//give valus for control signals
								extOp =1; 
								zero = 0; 
								negative = 0;
								positive =1; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//selection2 = 1'hx;	 
								//memoryData = 1'hx; 	
								//operand2=1'hx; 	  
								//overflow = 1'hx;	
								//carry = 1'hx;	 	
							end	
							
							else if (instruction[11]==1 &&registers[dest]<=registers[0]) begin
							    pc_in = pc_in +2;  //incremant pc_in
						      	pcSrc = 0;	 //give valuse for the control signals
								extOp =1; 
								negative = 1;
								positive =0; 
								ALUop = SUB; 
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;this value is not essination in the test bench it loook like x  becuse it is adont care 		
								//zero = 1'hx;	 
								//overflow = 1'hx;	
								//carry = 1'hx;	
								//selection2 = 1'hx;	
								//memoryData = 1'hx; 

							end	
							
						end	
						
					end	
					
					//**********************************************
					else if (opcode == 4'b1001) begin //BLT
						dest = instruction[10:8];  //destination register
						write_reg_file = 0;
						stage = 3'b000	 ; //fetch stage
						//wbData = 2'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
						if (instruction[11]==0) begin  
							src1= 1;
							selection1 =1;
							if (registers[dest]<registers[instruction[7:5]])begin	 // Branch is taken 
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]}; //change pc valus
								pcSrc = 1;	 //give valuse for control signals
								extOp =1; 
								overflow = 0;
								negative =1;
								positive =0; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care	 
							   //zero =1'hx;  
							   //selection2 = 1'hx;	
							  //memoryData = 1'hx;	
							  //carry = 1'hx;	 	
							end	
							
							else if (instruction[11]==0 &&registers[dest]>registers[instruction[7:5]]) begin  // Branch is not taken 
								pc_in = pc_in +2; //change the vakus fir the pc by incremant with 2
								pcSrc = 0; //give valuse for control sigmals
								extOp =1; 
								overflow = 0;
								negative =0;
								positive =1; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;  	this value is not essination in the test bench it loook like x  becuse it is adont care
								//selection2 = 1'hx; 	
								//memoryData = 1'hx; 	
								//zero =1'hx;  	
								//carry = 1'hx;		
								
								
							end	
						end
					
					//**********************************************
					else if (instruction[11]==1) begin // BLTZ
						   	src1= 0;
							selection1 =1;
							if (registers[dest]<registers[0])begin	  // Taken
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]}; //change the value of the pc_in
								pcSrc = 1;	  //give value for the control signals
								extOp =1; 
								negative =1;
								positive =0; 
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx; 	this value is not essination in the test bench it loook like x  becuse it is adont care
								//selection2 = 1'hx; 	 
								//memoryData = 1'hx; 	
								//carry = 1'hx;	
								//zero =1'hx; 	
								//overflow = 1'hx;		
							end	
							
							else if (instruction[11]==1 &&registers[dest]>registers[0]) begin   // Not taken
							pc_in = pc_in +2;	//change the value of the _in
							pcSrc = 0; //give valuse for the control signals
							extOp =1; 
							negative =0;
							positive =1; 
							ALUop = SUB;
							memoryRead =0;
							memoryWrite =0;
							//operand2=1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care	
							//selection2 = 1'hx; 	
							//memoryData = 1'hx; 	
							//zero =1'hx;	
							//overflow = 1'hx;
							//carry = 1'hx;	
							end	
							
						end	
					end	
					//**********************************************
					
					else if (opcode == 4'b1010) begin // BEQ
						dest = instruction[10:8];  //destination reg
						write_reg_file = 0;
						stage = 3'b000	 ; 	//fetch stagee
						//wbData = 2'hx;
						if (instruction[11]==0) begin
							src1= 1;
							selection1 =1;
							if (registers[dest]==registers[instruction[7:5]])begin	//Taken 
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]};  //change the value of the pc_in
								pcSrc = 1;	//give valuse for the control signals
								extOp =1; 
								zero =1;
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care
								//selection2 = 1'hx;	
								//memoryData = 1'hx; 
								//overflow = 1'hx; 
								//negative =1'hx;	
								//positive =1'hx; 	
								//carry = 1'hx;	
			
							end	
							
							else if (instruction[11]==0 &&registers[dest]!=registers[instruction[7:5]]) begin // Not taken
								pc_in = pc_in +2; 	//change the value of the pc_in
								pcSrc = 0;	//give valuse for the control signals
								extOp =1; 
								zero =0;
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care	   
						        //overflow = 1'hx;		
								//negative =1'hx; 	
								//positive =1'hx; 	
								//carry = 1'hx;	  		
								//selection2 = 1'hx; 
								//memoryData = 1'hx; 

							end	
						end
						
					else if (instruction[11]==1) begin 
						   src1= 0;
							selection1 =1;
							if (registers[dest]==registers[0])begin // Taken
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]};	//the value of the pc_in
								pcSrc = 1;	 //give value for the control signals
								extOp =1; 
								zero =1;
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;   	this value is not essination in the test bench it loook like x  becuse it is adont care
								//overflow = 1'hx; 
								//negative =1'hx;  	
								//positive =1'hx; 
								//carry = 1'hx;
								//selection2 = 1'hx;	 
								//memoryData = 1'hx;	
								
								
							end	
							
							else if (instruction[11]==1 &&registers[dest]!=registers[0]) begin	// Not taken 
							pc_in = pc_in +2; 
							pcSrc = 0;
								extOp =1; 
								zero =0;
								
								ALUop = SUB;
								
								memoryRead =0;
								memoryWrite =0;
								//overflow = 1'hx;	this value is not essination in the test bench it loook like x  becuse it is adont care
								//negative =1'hx;  	
								//positive =1'hx;  	
								//carry = 1'hx;	
								//operand2=1'hx; 	
								//selection2 = 1'hx; 	
								//memoryData = 1'hx; 	
								
								
							end	
							
						end	
					end	 
					//**********************************************
					
					else if (opcode == 4'b1011) begin  // BNE
						dest = instruction[10:8];  //destinantion reg
						write_reg_file = 0;
						stage = 3'b000	 ; //fetch stage
						//wbData = 2'hx;
						if (instruction[11]==0) begin	
								src1= 1;
								selection1 =1;
							if (registers[dest]!=registers[instruction[7:5]])begin	
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]}; //pc_in value
								pcSrc = 1; //give valuse for the control signals
								extOp =1; 
								zero =0;
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;
								//selection2 = 1'hx; 
								//memoryData = 1'hx;
								//overflow = 1'hx;
								//negative =1'hx;
								//positive =1'hx; 
								//carry = 1'hx;

							end	
							
							else if (instruction[11]==0 &&registers[dest]==registers[instruction[7:5]]) begin
								pc_in = pc_in +2;	//pc _in incremat by 2 
								pcSrc = 0;	 //give valuse for the control signals
								extOp =1; 
								zero =1;
								ALUop = SUB; 
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;
								//selection2 = 1'hx; 
								//memoryData = 1'hx;  
								//overflow = 1'hx;
								//negative =1'hx;
								//positive =1'hx; 
								//carry = 1'hx;

							end	
						end
						
					       else if (instruction[11]==1) begin 
								src1= 0;
								selection1 =1;
							if (registers[dest]!=registers[0])begin // Taken 
								pc_in = pc_in + {{11{instruction[4]}},registers[instruction[4:0]]};
								pcSrc = 1;
								extOp =1; 
								zero =0;
								ALUop = SUB;
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;
								//selection2 = 1'hx; 
								//memoryData = 1'hx; 
								//overflow = 1'hx;
								//negative =1'hx;
								//positive =1'hx; 
								//carry = 1'hx;

							end	
							
							else if (instruction[11]==1 &&registers[dest]==registers[0]) begin
								pc_in = pc_in +2;  //value of pc_in
								pcSrc = 0; //give valuse for the control signals
								extOp =1; 
								zero =1;
								ALUop = SUB; //operation is sub
								memoryRead =0;
								memoryWrite =0;
								//operand2=1'hx;
							    //overflow = 1'hx;
								//negative =1'hx;
								//positive =1'hx; 
								//carry = 1'hx;
								//selection2 = 1'hx; 
								//memoryData = 1'hx;

							end		
						end	
					end	
					//**********************************************
					
					else if (opcode ==4'b1100) begin //JUMP   
						pc_in = {pc_in[15:12],instruction[11:0]};	
						stage = 3'b000; //fetch stage
						write_reg_file = 0; // Set write enable for register file
						pcSrc = 2;	   //hive valuse for the control signals
						memoryRead=0;
						memoryWrite=0;
						//operand2=1'hx;
						//extOp = 1'hx;
						//selection1 = 1'hx;
						//src1 =1'hx;
						//ALUop = 2'hx;
						//selection2 =1'hx;
						//memoryData = 1'hx;
						//wbData = 2'hx;

					end	
				  //**********************************************
				
					else if (opcode ==4'b1101) begin //Call  
						registers[7] = pc_in +2;
						pc_in = {pc_in[15:12],instruction[11:0]};	//pc_in value
						stage = 3'b000; 
						write_reg_file = 0; // Set write enable for register file
						pcSrc = 2;	   //give value for the control signals
						memoryRead=0;
						memoryWrite=0;
						//operand2=1'hx;
						//extOp = 1'hx;
						//selection1 = 1'hx;
						//src1 =1'hx;
						//ALUop = 2'hx;
						//selection2 =1'hx;
						//memoryData = 1'hx;
						//wbData = 2'hx;

					end	 
				  //**********************************************
				  
					else if (opcode ==4'b1110) begin  // Return
						pc_in = registers[7];	
						stage = 3'b000;    //fetch stage
						write_reg_file = 0; // Set write enable for register file
						pcSrc = 3;		 //give valuse for the control signals
						selection1 = 2;
						memoryRead=0;
						memoryWrite=0;
						//operand2=1'hx; 
						//src1 =1'hx;
						//ALUop = 2'hx;
						//selection2 =1'hx;
						//memoryData = 1'hx;
						//wbData = 2'hx;
						//extOp = 1'hx;
					end
					//**********************************************
					
					else if (opcode ==4'b1111) begin  // SV  
						temp = registers[instruction[11:9]];
                        write_reg_file = 0; // Set write enable for register file
						stage = 3'b011;	  //memory Acsses stage
						write_reg_file = 0; // Set write enable for register file
						pcSrc = 0;//give valuse for the control signals
						src1 =1;
						selection2 =0;
						memoryData = 0;
						memoryRead=0;
						memoryWrite=1;
						//operand2=1'hx;
						//ALUop = 2'hx;	  
						//extOp = 1'hx;
						//selection1 = 1'hx;
						//wbData = 2'hx;
						pc_in = pc_in + 2;
					end
					
					end // end for execution
					
//___________________________________________________ Memory Access__________________________________________________________________ 
				
				 3'b011: begin // Memory Access
					 if (opcode == 4'b0101)begin  
						 data_out = {dataMem[alu_result+1],dataMem[alu_result]}; //data out	
						 stage = 3'b100;   //write back stage

					 end  
				 else if (opcode == 4'b0110)begin
					 if (instruction[11]==0)begin //LB unsigned ==> zero extension 
					data_out = {8'h00,dataMem[alu_result]}; 
					 end
					 else 
					data_out = {{8{dataMem[alu_result][7]}},dataMem[alu_result]};	
					 stage = 3'b100; 
				 end
				 
				 else if (opcode == 4'b0111) begin 
					 dataMem[alu_result] = registers[dest][7:0];
					 dataMem[alu_result+1] = registers[dest][15:8];
					 stage = 3'b000; //fetch stage
				 end 
				 
				   else if (opcode == 4'b1111) begin 
					 dataMem[temp] = instruction [8:1]; 
					 stage = 3'b000; 

				 end 
				 end //end of memory aceese
//______________________________________________ Write Back_________________________________________________________________________ 

				  3'b100: begin // Write Back 
					if (wbData == 2'b00 && write_reg_file==1)begin 	 // We want to rewrite alu result 	
						if (dest!=0)
						registers[dest] = alu_result;
						stage = 3'b000;//fetch stage
					end	 	
					
				  else begin   
					  if (dest!=0)
					  registers[dest] = data_out; 
					  stage = 3'b000;//fetch stage 
				  end 
				  
				 end  
				 
                default: stage = 3'b000; // Default case: reset stage on unknown state
            endcase	 //end case	
			
			end
    end	  
	
endmodule	 

//______________________________________________________Test bench______________________________________________________________________


module TopLevel_TB;
	
    // defin input from the top module as reg
   //Inputs	 
   
    reg clk;
    reg reset;
    
    //defin Output from the top module as wire in the test bench 
		
    wire [15:0] pc_out;
    wire signed [15:0] alu_result;
    wire signed [15:0] data_out;   
	wire [15:0] instruction;  
	wire [2:0] pcSrc ;
	wire [1:0] selection1, ALUop;
	wire  extOp,  src1, zero, carry, overflow, positive, negative, selection2, memoryData, wbData, memoryRead, memoryWrite, operand2, mode, dataSelector ;
	wire [2:0] stage ; //defin A stage from 2 bit to defin the next stage

    // Instantiate top_level module
		
    top_level uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .alu_result(alu_result),
        .data_out(data_out),
        .pcSrc(pcSrc),
        .extOp(extOp),
        .selection1(selection1),
        .src1(src1),
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .positive(positive),
        .negative(negative),
        .ALUop(ALUop),
        .selection2(selection2),
        .memoryData(memoryData),
        .wbData(wbData),
        .memoryRead(memoryRead),
        .memoryWrite(memoryWrite),
        .operand2(operand2),
		.instruction(instruction) ,
		.stage(stage) ,
		.mode(mode),  
		.dataSelector(dataSelector)
    );
    
    // Initial block for simulation setup
    initial begin 
		reset = 1; // reset is 1 
        clk = 0;   // clk is 0
		#1ns reset = 0;	 // 1ns change the reset to 0
		end

always #2ns clk = ~clk; // change the clk after 2ns   
   
initial #1000ns $finish; //finish 
endmodule