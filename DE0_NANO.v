
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================
//`include "I2C_module"
module DE0_NANO(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		     [1:0]		DRAM_DQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_WE_N,

	//////////// EPCS //////////
	output		          		EPCS_ASDO,
	input 		          		EPCS_DATA0,
	output		          		EPCS_DCLK,
	output		          		EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	output		          		G_SENSOR_CS_N,
	input 		          		G_SENSOR_INT,
	output		          		I2C_SCLK,
	inout 		          		I2C_SDAT,

	//////////// ADC //////////
	output		          		ADC_CS_N,
	output		          		ADC_SADDR,
	output		          		ADC_SCLK,
	input 		          		ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	inout 		    [12:0]		GPIO_2,
	input 		     [2:0]		GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [33:0]		UP,
	input 		     [1:0]		UP_IN,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [33:0]		LOW,
	input 		     [1:0]		LOW_IN
);



parameter SELECT_ADC 					= 5'b00_101; 

//parameter LCD_CMD_FUN					= 8'bD7_D6_D5_D4_X_E_RW_RS;



//parameter LCD_CMD_SHIFT						= 8'b0010



parameter STATE_IDLE					= 0;
parameter STATE_START					= 1;
parameter STATE_READ_DATA				= 2;
parameter STATE_SEND_REG				= 3;
parameter STATE_STOP					= 4;
parameter STATE_WAIT					= 5;







parameter CLK_MAX = 50/2 - 1;

//=======================================================
//  REG/WIRE declarations
//=======================================================


integer i;
reg [7:0] clk_cnt;
reg [7:0] clk_cnt_nex;


reg [4:0] ctrl_reg_cnt;
reg [4:0] ctrl_reg_cnt_nex;
reg [4:0] adc_data_cnt;
reg [4:0] adc_data_cnt_nex;

reg [7:0] spi_clk_cnt;
reg [7:0] spi_clk_cnt_nex;

reg [5:0] state_cur;
reg [5:0] state_nex;

reg spi_clk;
reg spi_clk_nex;

reg spi_clk_en;
reg adc_cs_n;
reg spi_mosi;




reg [11:0] adc_mem;
reg [11:0] adc_mem_nex;
//=======================================================
//  Structural coding
//=======================================================


assign ADC_SCLK = spi_clk_en | spi_clk;
assign ADC_CS_N = adc_cs_n;
assign ADC_SADDR = spi_mosi;



always @(*) begin
	if(state_cur == STATE_STOP || state_cur == STATE_IDLE)
		spi_clk_en = 1;
	else
		spi_clk_en = 0;
end

always @(*) begin
	case(spi_clk_cnt)
	0:spi_mosi = SELECT_ADC[4];
	2:spi_mosi = SELECT_ADC[3];
	4:spi_mosi = SELECT_ADC[2];
	6:spi_mosi = SELECT_ADC[1];
	8:spi_mosi = SELECT_ADC[0];
	default:
		spi_mosi = 0;
	endcase
end


always @(*) begin
	if (clk_cnt == 13) begin
		for (i = 0;i<=11 ;i=i+1 ) begin
			adc_mem_nex[i] = adc_mem[i];
		end
		case(spi_clk_cnt)
			8:	adc_mem_nex[11] = ADC_SDAT;
			10:	adc_mem_nex[10] = ADC_SDAT;
			12:	adc_mem_nex[9] = ADC_SDAT;
			14:	adc_mem_nex[8] = ADC_SDAT;
			16:	adc_mem_nex[7] = ADC_SDAT;
			18:	adc_mem_nex[6] = ADC_SDAT;
			20:	adc_mem_nex[5] = ADC_SDAT;
			22:	adc_mem_nex[4] = ADC_SDAT;
			24:	adc_mem_nex[3] = ADC_SDAT;
			26:	adc_mem_nex[2] = ADC_SDAT;
			28:	adc_mem_nex[1] = ADC_SDAT;
			30:	adc_mem_nex[0] = ADC_SDAT;
		endcase
	end
	else begin
		adc_mem_nex = adc_mem;
	end
end

always @(posedge CLOCK_50 or posedge KEY[0]) begin
	if(KEY[0] == 0)	begin
		clk_cnt 		<= 0;
		state_cur 		<= 0;
		adc_data_cnt	<= 0;
		ctrl_reg_cnt	<= 0;
		spi_clk_cnt		<= 0;
		spi_clk			<= 1;
		adc_mem			<= 12'b0;
	end
	else begin
		clk_cnt 		<= clk_cnt_nex;
		state_cur		<= state_nex;
		adc_data_cnt	<= adc_data_cnt_nex; 
		ctrl_reg_cnt	<= ctrl_reg_cnt_nex;
		spi_clk_cnt		<= spi_clk_cnt_nex;
		spi_clk			<= spi_clk_nex;
		adc_mem			<= adc_mem_nex;
	end
end

always @(*) begin
	if(clk_cnt == CLK_MAX)
		clk_cnt_nex = 0;
	else
		clk_cnt_nex = clk_cnt + 1;
end
always @(*) begin
	case(state_cur)
	STATE_IDLE,STATE_STOP:
		adc_cs_n = 1;
	default: begin
		adc_cs_n = 0;
		end
	endcase
end

always @(*) begin
	if(clk_cnt == CLK_MAX)
		case (state_cur)
			STATE_STOP,STATE_START: 
				spi_clk_cnt_nex = 0;
			default: 
				spi_clk_cnt_nex = spi_clk_cnt + 1;
		endcase
	else begin
		spi_clk_cnt_nex = spi_clk_cnt;
	end
end
always @(*) begin
	if(clk_cnt == CLK_MAX/2)
		case (state_cur)
			STATE_IDLE,STATE_STOP,STATE_WAIT:
				spi_clk_nex = 1;
			default: 
				spi_clk_nex = !spi_clk;
		endcase
	else begin
		spi_clk_nex = spi_clk;
	end
end





always @(*) begin
	if(clk_cnt == CLK_MAX)begin
		case(state_cur)
		STATE_IDLE:
			state_nex = STATE_START;
		STATE_START:
			state_nex = STATE_SEND_REG;
		STATE_SEND_REG:begin
			if(spi_clk_cnt == 11)
				state_nex = STATE_READ_DATA;
			else
				state_nex = STATE_SEND_REG;
		end
		STATE_READ_DATA:begin
			if(spi_clk_cnt == 30)
				state_nex = STATE_WAIT;
			else
				state_nex = STATE_READ_DATA;
		end
		STATE_WAIT:begin
			state_nex = STATE_STOP;
		end
		STATE_STOP:begin
			state_nex = STATE_STOP;
		end
		default:
			state_nex = STATE_STOP;
		endcase
		end 
	else begin
		state_nex = state_cur;
	end
end








endmodule
