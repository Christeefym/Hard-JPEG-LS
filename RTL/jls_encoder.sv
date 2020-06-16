`timescale 1ns/1ns

module jls_encoder #(
    parameter  MAXLEN_LEVEL = 12               // min=3, max=14
) (
    input  wire                     rst,
    input  wire                     clk,
    input  wire [MAXLEN_LEVEL-1:0]  width,     // 4~(1<<MAXLEN_LEVEL-1)
    input  wire [            15:0]  height,
    input  wire                     ivalid,
    input  wire [             7:0]  idata,
    
    output reg                      pvalid,
    output reg  [             4:0]  pones,
    output reg  [             3:0]  pcnts,
    output reg  [            15:0]  pdata,
    
    output reg                      bvalid,
    output reg  [             5:0]  bcnts,
    output reg  [            15:0]  bdata,
    
    output reg          ovalid,
    output reg  [ 7:0]  odata
);

initial {ovalid, odata} = '0;
initial {pvalid, pdata, pcnts, pones} = '0;
initial {bvalid, bdata, bcnts} = '0;

wire [  3:0] vLUT [512]; assign vLUT[0]=4'd0; assign vLUT[1]=4'd7; assign vLUT[2]=4'd7; assign vLUT[3]=4'd7; assign vLUT[4]=4'd7; assign vLUT[5]=4'd7; assign vLUT[6]=4'd7; assign vLUT[7]=4'd7; assign vLUT[8]=4'd7; assign vLUT[9]=4'd7; assign vLUT[10]=4'd7; assign vLUT[11]=4'd7; assign vLUT[12]=4'd7; assign vLUT[13]=4'd7; assign vLUT[14]=4'd7; assign vLUT[15]=4'd7; assign vLUT[16]=4'd7; assign vLUT[17]=4'd7; assign vLUT[18]=4'd7; assign vLUT[19]=4'd7; assign vLUT[20]=4'd7; assign vLUT[21]=4'd7; assign vLUT[22]=4'd7; assign vLUT[23]=4'd7; assign vLUT[24]=4'd7; assign vLUT[25]=4'd7; assign vLUT[26]=4'd7; assign vLUT[27]=4'd7; assign vLUT[28]=4'd7; assign vLUT[29]=4'd7; assign vLUT[30]=4'd7; assign vLUT[31]=4'd7; assign vLUT[32]=4'd7; assign vLUT[33]=4'd7; assign vLUT[34]=4'd7; assign vLUT[35]=4'd7; assign vLUT[36]=4'd7; assign vLUT[37]=4'd7; assign vLUT[38]=4'd7; assign vLUT[39]=4'd7; assign vLUT[40]=4'd7; assign vLUT[41]=4'd7; assign vLUT[42]=4'd7; assign vLUT[43]=4'd7; assign vLUT[44]=4'd7; assign vLUT[45]=4'd7; assign vLUT[46]=4'd7; assign vLUT[47]=4'd7; assign vLUT[48]=4'd7; assign vLUT[49]=4'd7; assign vLUT[50]=4'd7; assign vLUT[51]=4'd7; assign vLUT[52]=4'd7; assign vLUT[53]=4'd7; assign vLUT[54]=4'd7; assign vLUT[55]=4'd7; assign vLUT[56]=4'd7; assign vLUT[57]=4'd7; assign vLUT[58]=4'd7; assign vLUT[59]=4'd7; assign vLUT[60]=4'd7; assign vLUT[61]=4'd7; assign vLUT[62]=4'd7; assign vLUT[63]=4'd7; assign vLUT[64]=4'd7; assign vLUT[65]=4'd7; assign vLUT[66]=4'd7; assign vLUT[67]=4'd7; assign vLUT[68]=4'd7; assign vLUT[69]=4'd7; assign vLUT[70]=4'd7; assign vLUT[71]=4'd7; assign vLUT[72]=4'd7; assign vLUT[73]=4'd7; assign vLUT[74]=4'd7; assign vLUT[75]=4'd7; assign vLUT[76]=4'd7; assign vLUT[77]=4'd7; assign vLUT[78]=4'd7; assign vLUT[79]=4'd7; assign vLUT[80]=4'd7; assign vLUT[81]=4'd7; assign vLUT[82]=4'd7; assign vLUT[83]=4'd7; assign vLUT[84]=4'd7; assign vLUT[85]=4'd7; assign vLUT[86]=4'd7; assign vLUT[87]=4'd7; assign vLUT[88]=4'd7; assign vLUT[89]=4'd7; assign vLUT[90]=4'd7; assign vLUT[91]=4'd7; assign vLUT[92]=4'd7; assign vLUT[93]=4'd7; assign vLUT[94]=4'd7; assign vLUT[95]=4'd7; assign vLUT[96]=4'd7; assign vLUT[97]=4'd7; assign vLUT[98]=4'd7; assign vLUT[99]=4'd7; assign vLUT[100]=4'd7; assign vLUT[101]=4'd7; assign vLUT[102]=4'd7; assign vLUT[103]=4'd7; assign vLUT[104]=4'd7; assign vLUT[105]=4'd7; assign vLUT[106]=4'd7; assign vLUT[107]=4'd7; assign vLUT[108]=4'd7; assign vLUT[109]=4'd7; assign vLUT[110]=4'd7; assign vLUT[111]=4'd7; assign vLUT[112]=4'd7; assign vLUT[113]=4'd7; assign vLUT[114]=4'd7; assign vLUT[115]=4'd7; assign vLUT[116]=4'd7; assign vLUT[117]=4'd7; assign vLUT[118]=4'd7; assign vLUT[119]=4'd7; assign vLUT[120]=4'd7; assign vLUT[121]=4'd7; assign vLUT[122]=4'd7; assign vLUT[123]=4'd7; assign vLUT[124]=4'd7; assign vLUT[125]=4'd7; assign vLUT[126]=4'd7; assign vLUT[127]=4'd7; assign vLUT[128]=4'd7; assign vLUT[129]=4'd7; assign vLUT[130]=4'd7; assign vLUT[131]=4'd7; assign vLUT[132]=4'd7; assign vLUT[133]=4'd7; assign vLUT[134]=4'd7; assign vLUT[135]=4'd7; assign vLUT[136]=4'd7; assign vLUT[137]=4'd7; assign vLUT[138]=4'd7; assign vLUT[139]=4'd7; assign vLUT[140]=4'd7; assign vLUT[141]=4'd7; assign vLUT[142]=4'd7; assign vLUT[143]=4'd7; assign vLUT[144]=4'd7; assign vLUT[145]=4'd7; assign vLUT[146]=4'd7; assign vLUT[147]=4'd7; assign vLUT[148]=4'd7; assign vLUT[149]=4'd7; assign vLUT[150]=4'd7; assign vLUT[151]=4'd7; assign vLUT[152]=4'd7; assign vLUT[153]=4'd7; assign vLUT[154]=4'd7; assign vLUT[155]=4'd7; assign vLUT[156]=4'd7; assign vLUT[157]=4'd7; assign vLUT[158]=4'd7; assign vLUT[159]=4'd7; assign vLUT[160]=4'd7; assign vLUT[161]=4'd7; assign vLUT[162]=4'd7; assign vLUT[163]=4'd7; assign vLUT[164]=4'd7; assign vLUT[165]=4'd7; assign vLUT[166]=4'd7; assign vLUT[167]=4'd7; assign vLUT[168]=4'd7; assign vLUT[169]=4'd7; assign vLUT[170]=4'd7; assign vLUT[171]=4'd7; assign vLUT[172]=4'd7; assign vLUT[173]=4'd7; assign vLUT[174]=4'd7; assign vLUT[175]=4'd7; assign vLUT[176]=4'd7; assign vLUT[177]=4'd7; assign vLUT[178]=4'd7; assign vLUT[179]=4'd7; assign vLUT[180]=4'd7; assign vLUT[181]=4'd7; assign vLUT[182]=4'd7; assign vLUT[183]=4'd7; assign vLUT[184]=4'd7; assign vLUT[185]=4'd7; assign vLUT[186]=4'd7; assign vLUT[187]=4'd7; assign vLUT[188]=4'd7; assign vLUT[189]=4'd7; assign vLUT[190]=4'd7; assign vLUT[191]=4'd7; assign vLUT[192]=4'd7; assign vLUT[193]=4'd7; assign vLUT[194]=4'd7; assign vLUT[195]=4'd7; assign vLUT[196]=4'd7; assign vLUT[197]=4'd7; assign vLUT[198]=4'd7; assign vLUT[199]=4'd7; assign vLUT[200]=4'd7; assign vLUT[201]=4'd7; assign vLUT[202]=4'd7; assign vLUT[203]=4'd7; assign vLUT[204]=4'd7; assign vLUT[205]=4'd7; assign vLUT[206]=4'd7; assign vLUT[207]=4'd7; assign vLUT[208]=4'd7; assign vLUT[209]=4'd7; assign vLUT[210]=4'd7; assign vLUT[211]=4'd7; assign vLUT[212]=4'd7; assign vLUT[213]=4'd7; assign vLUT[214]=4'd7; assign vLUT[215]=4'd7; assign vLUT[216]=4'd7; assign vLUT[217]=4'd7; assign vLUT[218]=4'd7; assign vLUT[219]=4'd7; assign vLUT[220]=4'd7; assign vLUT[221]=4'd7; assign vLUT[222]=4'd5; assign vLUT[223]=4'd5; assign vLUT[224]=4'd5; assign vLUT[225]=4'd5; assign vLUT[226]=4'd5; assign vLUT[227]=4'd5; assign vLUT[228]=4'd5; assign vLUT[229]=4'd5; assign vLUT[230]=4'd5; assign vLUT[231]=4'd5; assign vLUT[232]=4'd5; assign vLUT[233]=4'd5; assign vLUT[234]=4'd5; assign vLUT[235]=4'd5; assign vLUT[236]=4'd5; assign vLUT[237]=4'd5; assign vLUT[238]=4'd5; assign vLUT[239]=4'd5; assign vLUT[240]=4'd3; assign vLUT[241]=4'd3; assign vLUT[242]=4'd3; assign vLUT[243]=4'd3; assign vLUT[244]=4'd3; assign vLUT[245]=4'd3; assign vLUT[246]=4'd3; assign vLUT[247]=4'd3; assign vLUT[248]=4'd1; assign vLUT[249]=4'd1; assign vLUT[250]=4'd1; assign vLUT[251]=4'd1; assign vLUT[252]=4'd1; assign vLUT[253]=4'd1; assign vLUT[254]=4'd0; assign vLUT[255]=4'd0; assign vLUT[256]=4'd0; assign vLUT[257]=4'd0; assign vLUT[258]=4'd0; assign vLUT[259]=4'd2; assign vLUT[260]=4'd2; assign vLUT[261]=4'd2; assign vLUT[262]=4'd2; assign vLUT[263]=4'd2; assign vLUT[264]=4'd2; assign vLUT[265]=4'd4; assign vLUT[266]=4'd4; assign vLUT[267]=4'd4; assign vLUT[268]=4'd4; assign vLUT[269]=4'd4; assign vLUT[270]=4'd4; assign vLUT[271]=4'd4; assign vLUT[272]=4'd4; assign vLUT[273]=4'd6; assign vLUT[274]=4'd6; assign vLUT[275]=4'd6; assign vLUT[276]=4'd6; assign vLUT[277]=4'd6; assign vLUT[278]=4'd6; assign vLUT[279]=4'd6; assign vLUT[280]=4'd6; assign vLUT[281]=4'd6; assign vLUT[282]=4'd6; assign vLUT[283]=4'd6; assign vLUT[284]=4'd6; assign vLUT[285]=4'd6; assign vLUT[286]=4'd6; assign vLUT[287]=4'd6; assign vLUT[288]=4'd6; assign vLUT[289]=4'd6; assign vLUT[290]=4'd6; assign vLUT[291]=4'd8; assign vLUT[292]=4'd8; assign vLUT[293]=4'd8; assign vLUT[294]=4'd8; assign vLUT[295]=4'd8; assign vLUT[296]=4'd8; assign vLUT[297]=4'd8; assign vLUT[298]=4'd8; assign vLUT[299]=4'd8; assign vLUT[300]=4'd8; assign vLUT[301]=4'd8; assign vLUT[302]=4'd8; assign vLUT[303]=4'd8; assign vLUT[304]=4'd8; assign vLUT[305]=4'd8; assign vLUT[306]=4'd8; assign vLUT[307]=4'd8; assign vLUT[308]=4'd8; assign vLUT[309]=4'd8; assign vLUT[310]=4'd8; assign vLUT[311]=4'd8; assign vLUT[312]=4'd8; assign vLUT[313]=4'd8; assign vLUT[314]=4'd8; assign vLUT[315]=4'd8; assign vLUT[316]=4'd8; assign vLUT[317]=4'd8; assign vLUT[318]=4'd8; assign vLUT[319]=4'd8; assign vLUT[320]=4'd8; assign vLUT[321]=4'd8; assign vLUT[322]=4'd8; assign vLUT[323]=4'd8; assign vLUT[324]=4'd8; assign vLUT[325]=4'd8; assign vLUT[326]=4'd8; assign vLUT[327]=4'd8; assign vLUT[328]=4'd8; assign vLUT[329]=4'd8; assign vLUT[330]=4'd8; assign vLUT[331]=4'd8; assign vLUT[332]=4'd8; assign vLUT[333]=4'd8; assign vLUT[334]=4'd8; assign vLUT[335]=4'd8; assign vLUT[336]=4'd8; assign vLUT[337]=4'd8; assign vLUT[338]=4'd8; assign vLUT[339]=4'd8; assign vLUT[340]=4'd8; assign vLUT[341]=4'd8; assign vLUT[342]=4'd8; assign vLUT[343]=4'd8; assign vLUT[344]=4'd8; assign vLUT[345]=4'd8; assign vLUT[346]=4'd8; assign vLUT[347]=4'd8; assign vLUT[348]=4'd8; assign vLUT[349]=4'd8; assign vLUT[350]=4'd8; assign vLUT[351]=4'd8; assign vLUT[352]=4'd8; assign vLUT[353]=4'd8; assign vLUT[354]=4'd8; assign vLUT[355]=4'd8; assign vLUT[356]=4'd8; assign vLUT[357]=4'd8; assign vLUT[358]=4'd8; assign vLUT[359]=4'd8; assign vLUT[360]=4'd8; assign vLUT[361]=4'd8; assign vLUT[362]=4'd8; assign vLUT[363]=4'd8; assign vLUT[364]=4'd8; assign vLUT[365]=4'd8; assign vLUT[366]=4'd8; assign vLUT[367]=4'd8; assign vLUT[368]=4'd8; assign vLUT[369]=4'd8; assign vLUT[370]=4'd8; assign vLUT[371]=4'd8; assign vLUT[372]=4'd8; assign vLUT[373]=4'd8; assign vLUT[374]=4'd8; assign vLUT[375]=4'd8; assign vLUT[376]=4'd8; assign vLUT[377]=4'd8; assign vLUT[378]=4'd8; assign vLUT[379]=4'd8; assign vLUT[380]=4'd8; assign vLUT[381]=4'd8; assign vLUT[382]=4'd8; assign vLUT[383]=4'd8; assign vLUT[384]=4'd8; assign vLUT[385]=4'd8; assign vLUT[386]=4'd8; assign vLUT[387]=4'd8; assign vLUT[388]=4'd8; assign vLUT[389]=4'd8; assign vLUT[390]=4'd8; assign vLUT[391]=4'd8; assign vLUT[392]=4'd8; assign vLUT[393]=4'd8; assign vLUT[394]=4'd8; assign vLUT[395]=4'd8; assign vLUT[396]=4'd8; assign vLUT[397]=4'd8; assign vLUT[398]=4'd8; assign vLUT[399]=4'd8; assign vLUT[400]=4'd8; assign vLUT[401]=4'd8; assign vLUT[402]=4'd8; assign vLUT[403]=4'd8; assign vLUT[404]=4'd8; assign vLUT[405]=4'd8; assign vLUT[406]=4'd8; assign vLUT[407]=4'd8; assign vLUT[408]=4'd8; assign vLUT[409]=4'd8; assign vLUT[410]=4'd8; assign vLUT[411]=4'd8; assign vLUT[412]=4'd8; assign vLUT[413]=4'd8; assign vLUT[414]=4'd8; assign vLUT[415]=4'd8; assign vLUT[416]=4'd8; assign vLUT[417]=4'd8; assign vLUT[418]=4'd8; assign vLUT[419]=4'd8; assign vLUT[420]=4'd8; assign vLUT[421]=4'd8; assign vLUT[422]=4'd8; assign vLUT[423]=4'd8; assign vLUT[424]=4'd8; assign vLUT[425]=4'd8; assign vLUT[426]=4'd8; assign vLUT[427]=4'd8; assign vLUT[428]=4'd8; assign vLUT[429]=4'd8; assign vLUT[430]=4'd8; assign vLUT[431]=4'd8; assign vLUT[432]=4'd8; assign vLUT[433]=4'd8; assign vLUT[434]=4'd8; assign vLUT[435]=4'd8; assign vLUT[436]=4'd8; assign vLUT[437]=4'd8; assign vLUT[438]=4'd8; assign vLUT[439]=4'd8; assign vLUT[440]=4'd8; assign vLUT[441]=4'd8; assign vLUT[442]=4'd8; assign vLUT[443]=4'd8; assign vLUT[444]=4'd8; assign vLUT[445]=4'd8; assign vLUT[446]=4'd8; assign vLUT[447]=4'd8; assign vLUT[448]=4'd8; assign vLUT[449]=4'd8; assign vLUT[450]=4'd8; assign vLUT[451]=4'd8; assign vLUT[452]=4'd8; assign vLUT[453]=4'd8; assign vLUT[454]=4'd8; assign vLUT[455]=4'd8; assign vLUT[456]=4'd8; assign vLUT[457]=4'd8; assign vLUT[458]=4'd8; assign vLUT[459]=4'd8; assign vLUT[460]=4'd8; assign vLUT[461]=4'd8; assign vLUT[462]=4'd8; assign vLUT[463]=4'd8; assign vLUT[464]=4'd8; assign vLUT[465]=4'd8; assign vLUT[466]=4'd8; assign vLUT[467]=4'd8; assign vLUT[468]=4'd8; assign vLUT[469]=4'd8; assign vLUT[470]=4'd8; assign vLUT[471]=4'd8; assign vLUT[472]=4'd8; assign vLUT[473]=4'd8; assign vLUT[474]=4'd8; assign vLUT[475]=4'd8; assign vLUT[476]=4'd8; assign vLUT[477]=4'd8; assign vLUT[478]=4'd8; assign vLUT[479]=4'd8; assign vLUT[480]=4'd8; assign vLUT[481]=4'd8; assign vLUT[482]=4'd8; assign vLUT[483]=4'd8; assign vLUT[484]=4'd8; assign vLUT[485]=4'd8; assign vLUT[486]=4'd8; assign vLUT[487]=4'd8; assign vLUT[488]=4'd8; assign vLUT[489]=4'd8; assign vLUT[490]=4'd8; assign vLUT[491]=4'd8; assign vLUT[492]=4'd8; assign vLUT[493]=4'd8; assign vLUT[494]=4'd8; assign vLUT[495]=4'd8; assign vLUT[496]=4'd8; assign vLUT[497]=4'd8; assign vLUT[498]=4'd8; assign vLUT[499]=4'd8; assign vLUT[500]=4'd8; assign vLUT[501]=4'd8; assign vLUT[502]=4'd8; assign vLUT[503]=4'd8; assign vLUT[504]=4'd8; assign vLUT[505]=4'd8; assign vLUT[506]=4'd8; assign vLUT[507]=4'd8; assign vLUT[508]=4'd8; assign vLUT[509]=4'd8; assign vLUT[510]=4'd8; assign vLUT[511]=4'd8;
wire [  8:0] classmapabs [729]; assign classmapabs[0]=9'd0;assign classmapabs[1]=9'd1;assign classmapabs[2]=9'd1;assign classmapabs[3]=9'd2;assign classmapabs[4]=9'd2;assign classmapabs[5]=9'd3;assign classmapabs[6]=9'd3;assign classmapabs[7]=9'd4;assign classmapabs[8]=9'd4;assign classmapabs[9]=9'd5;assign classmapabs[10]=9'd6;assign classmapabs[11]=9'd7;assign classmapabs[12]=9'd8;assign classmapabs[13]=9'd9;assign classmapabs[14]=9'd10;assign classmapabs[15]=9'd11;assign classmapabs[16]=9'd12;assign classmapabs[17]=9'd13;assign classmapabs[18]=9'd5;assign classmapabs[19]=9'd7;assign classmapabs[20]=9'd6;assign classmapabs[21]=9'd9;assign classmapabs[22]=9'd8;assign classmapabs[23]=9'd11;assign classmapabs[24]=9'd10;assign classmapabs[25]=9'd13;assign classmapabs[26]=9'd12;assign classmapabs[27]=9'd14;assign classmapabs[28]=9'd15;assign classmapabs[29]=9'd16;assign classmapabs[30]=9'd17;assign classmapabs[31]=9'd18;assign classmapabs[32]=9'd19;assign classmapabs[33]=9'd20;assign classmapabs[34]=9'd21;assign classmapabs[35]=9'd22;assign classmapabs[36]=9'd14;assign classmapabs[37]=9'd16;assign classmapabs[38]=9'd15;assign classmapabs[39]=9'd18;assign classmapabs[40]=9'd17;assign classmapabs[41]=9'd20;assign classmapabs[42]=9'd19;assign classmapabs[43]=9'd22;assign classmapabs[44]=9'd21;assign classmapabs[45]=9'd23;assign classmapabs[46]=9'd24;assign classmapabs[47]=9'd25;assign classmapabs[48]=9'd26;assign classmapabs[49]=9'd27;assign classmapabs[50]=9'd28;assign classmapabs[51]=9'd29;assign classmapabs[52]=9'd30;assign classmapabs[53]=9'd31;assign classmapabs[54]=9'd23;assign classmapabs[55]=9'd25;assign classmapabs[56]=9'd24;assign classmapabs[57]=9'd27;assign classmapabs[58]=9'd26;assign classmapabs[59]=9'd29;assign classmapabs[60]=9'd28;assign classmapabs[61]=9'd31;assign classmapabs[62]=9'd30;assign classmapabs[63]=9'd32;assign classmapabs[64]=9'd33;assign classmapabs[65]=9'd34;assign classmapabs[66]=9'd35;assign classmapabs[67]=9'd36;assign classmapabs[68]=9'd37;assign classmapabs[69]=9'd38;assign classmapabs[70]=9'd39;assign classmapabs[71]=9'd40;assign classmapabs[72]=9'd32;assign classmapabs[73]=9'd34;assign classmapabs[74]=9'd33;assign classmapabs[75]=9'd36;assign classmapabs[76]=9'd35;assign classmapabs[77]=9'd38;assign classmapabs[78]=9'd37;assign classmapabs[79]=9'd40;assign classmapabs[80]=9'd39;assign classmapabs[81]=9'd41;assign classmapabs[82]=9'd42;assign classmapabs[83]=9'd43;assign classmapabs[84]=9'd44;assign classmapabs[85]=9'd45;assign classmapabs[86]=9'd46;assign classmapabs[87]=9'd47;assign classmapabs[88]=9'd48;assign classmapabs[89]=9'd49;assign classmapabs[90]=9'd50;assign classmapabs[91]=9'd51;assign classmapabs[92]=9'd52;assign classmapabs[93]=9'd53;assign classmapabs[94]=9'd54;assign classmapabs[95]=9'd55;assign classmapabs[96]=9'd56;assign classmapabs[97]=9'd57;assign classmapabs[98]=9'd58;assign classmapabs[99]=9'd59;assign classmapabs[100]=9'd60;assign classmapabs[101]=9'd61;assign classmapabs[102]=9'd62;assign classmapabs[103]=9'd63;assign classmapabs[104]=9'd64;assign classmapabs[105]=9'd65;assign classmapabs[106]=9'd66;assign classmapabs[107]=9'd67;assign classmapabs[108]=9'd68;assign classmapabs[109]=9'd69;assign classmapabs[110]=9'd70;assign classmapabs[111]=9'd71;assign classmapabs[112]=9'd72;assign classmapabs[113]=9'd73;assign classmapabs[114]=9'd74;assign classmapabs[115]=9'd75;assign classmapabs[116]=9'd76;assign classmapabs[117]=9'd77;assign classmapabs[118]=9'd78;assign classmapabs[119]=9'd79;assign classmapabs[120]=9'd80;assign classmapabs[121]=9'd81;assign classmapabs[122]=9'd82;assign classmapabs[123]=9'd83;assign classmapabs[124]=9'd84;assign classmapabs[125]=9'd85;assign classmapabs[126]=9'd86;assign classmapabs[127]=9'd87;assign classmapabs[128]=9'd88;assign classmapabs[129]=9'd89;assign classmapabs[130]=9'd90;assign classmapabs[131]=9'd91;assign classmapabs[132]=9'd92;assign classmapabs[133]=9'd93;assign classmapabs[134]=9'd94;assign classmapabs[135]=9'd95;assign classmapabs[136]=9'd96;assign classmapabs[137]=9'd97;assign classmapabs[138]=9'd98;assign classmapabs[139]=9'd99;assign classmapabs[140]=9'd100;assign classmapabs[141]=9'd101;assign classmapabs[142]=9'd102;assign classmapabs[143]=9'd103;assign classmapabs[144]=9'd104;assign classmapabs[145]=9'd105;assign classmapabs[146]=9'd106;assign classmapabs[147]=9'd107;assign classmapabs[148]=9'd108;assign classmapabs[149]=9'd109;assign classmapabs[150]=9'd110;assign classmapabs[151]=9'd111;assign classmapabs[152]=9'd112;assign classmapabs[153]=9'd113;assign classmapabs[154]=9'd114;assign classmapabs[155]=9'd115;assign classmapabs[156]=9'd116;assign classmapabs[157]=9'd117;assign classmapabs[158]=9'd118;assign classmapabs[159]=9'd119;assign classmapabs[160]=9'd120;assign classmapabs[161]=9'd121;assign classmapabs[162]=9'd41;assign classmapabs[163]=9'd43;assign classmapabs[164]=9'd42;assign classmapabs[165]=9'd45;assign classmapabs[166]=9'd44;assign classmapabs[167]=9'd47;assign classmapabs[168]=9'd46;assign classmapabs[169]=9'd49;assign classmapabs[170]=9'd48;assign classmapabs[171]=9'd59;assign classmapabs[172]=9'd61;assign classmapabs[173]=9'd60;assign classmapabs[174]=9'd63;assign classmapabs[175]=9'd62;assign classmapabs[176]=9'd65;assign classmapabs[177]=9'd64;assign classmapabs[178]=9'd67;assign classmapabs[179]=9'd66;assign classmapabs[180]=9'd50;assign classmapabs[181]=9'd52;assign classmapabs[182]=9'd51;assign classmapabs[183]=9'd54;assign classmapabs[184]=9'd53;assign classmapabs[185]=9'd56;assign classmapabs[186]=9'd55;assign classmapabs[187]=9'd58;assign classmapabs[188]=9'd57;assign classmapabs[189]=9'd77;assign classmapabs[190]=9'd79;assign classmapabs[191]=9'd78;assign classmapabs[192]=9'd81;assign classmapabs[193]=9'd80;assign classmapabs[194]=9'd83;assign classmapabs[195]=9'd82;assign classmapabs[196]=9'd85;assign classmapabs[197]=9'd84;assign classmapabs[198]=9'd68;assign classmapabs[199]=9'd70;assign classmapabs[200]=9'd69;assign classmapabs[201]=9'd72;assign classmapabs[202]=9'd71;assign classmapabs[203]=9'd74;assign classmapabs[204]=9'd73;assign classmapabs[205]=9'd76;assign classmapabs[206]=9'd75;assign classmapabs[207]=9'd95;assign classmapabs[208]=9'd97;assign classmapabs[209]=9'd96;assign classmapabs[210]=9'd99;assign classmapabs[211]=9'd98;assign classmapabs[212]=9'd101;assign classmapabs[213]=9'd100;assign classmapabs[214]=9'd103;assign classmapabs[215]=9'd102;assign classmapabs[216]=9'd86;assign classmapabs[217]=9'd88;assign classmapabs[218]=9'd87;assign classmapabs[219]=9'd90;assign classmapabs[220]=9'd89;assign classmapabs[221]=9'd92;assign classmapabs[222]=9'd91;assign classmapabs[223]=9'd94;assign classmapabs[224]=9'd93;assign classmapabs[225]=9'd113;assign classmapabs[226]=9'd115;assign classmapabs[227]=9'd114;assign classmapabs[228]=9'd117;assign classmapabs[229]=9'd116;assign classmapabs[230]=9'd119;assign classmapabs[231]=9'd118;assign classmapabs[232]=9'd121;assign classmapabs[233]=9'd120;assign classmapabs[234]=9'd104;assign classmapabs[235]=9'd106;assign classmapabs[236]=9'd105;assign classmapabs[237]=9'd108;assign classmapabs[238]=9'd107;assign classmapabs[239]=9'd110;assign classmapabs[240]=9'd109;assign classmapabs[241]=9'd112;assign classmapabs[242]=9'd111;assign classmapabs[243]=9'd122;assign classmapabs[244]=9'd123;assign classmapabs[245]=9'd124;assign classmapabs[246]=9'd125;assign classmapabs[247]=9'd126;assign classmapabs[248]=9'd127;assign classmapabs[249]=9'd128;assign classmapabs[250]=9'd129;assign classmapabs[251]=9'd130;assign classmapabs[252]=9'd131;assign classmapabs[253]=9'd132;assign classmapabs[254]=9'd133;assign classmapabs[255]=9'd134;assign classmapabs[256]=9'd135;assign classmapabs[257]=9'd136;assign classmapabs[258]=9'd137;assign classmapabs[259]=9'd138;assign classmapabs[260]=9'd139;assign classmapabs[261]=9'd140;assign classmapabs[262]=9'd141;assign classmapabs[263]=9'd142;assign classmapabs[264]=9'd143;assign classmapabs[265]=9'd144;assign classmapabs[266]=9'd145;assign classmapabs[267]=9'd146;assign classmapabs[268]=9'd147;assign classmapabs[269]=9'd148;assign classmapabs[270]=9'd149;assign classmapabs[271]=9'd150;assign classmapabs[272]=9'd151;assign classmapabs[273]=9'd152;assign classmapabs[274]=9'd153;assign classmapabs[275]=9'd154;assign classmapabs[276]=9'd155;assign classmapabs[277]=9'd156;assign classmapabs[278]=9'd157;assign classmapabs[279]=9'd158;assign classmapabs[280]=9'd159;assign classmapabs[281]=9'd160;assign classmapabs[282]=9'd161;assign classmapabs[283]=9'd162;assign classmapabs[284]=9'd163;assign classmapabs[285]=9'd164;assign classmapabs[286]=9'd165;assign classmapabs[287]=9'd166;assign classmapabs[288]=9'd167;assign classmapabs[289]=9'd168;assign classmapabs[290]=9'd169;assign classmapabs[291]=9'd170;assign classmapabs[292]=9'd171;assign classmapabs[293]=9'd172;assign classmapabs[294]=9'd173;assign classmapabs[295]=9'd174;assign classmapabs[296]=9'd175;assign classmapabs[297]=9'd176;assign classmapabs[298]=9'd177;assign classmapabs[299]=9'd178;assign classmapabs[300]=9'd179;assign classmapabs[301]=9'd180;assign classmapabs[302]=9'd181;assign classmapabs[303]=9'd182;assign classmapabs[304]=9'd183;assign classmapabs[305]=9'd184;assign classmapabs[306]=9'd185;assign classmapabs[307]=9'd186;assign classmapabs[308]=9'd187;assign classmapabs[309]=9'd188;assign classmapabs[310]=9'd189;assign classmapabs[311]=9'd190;assign classmapabs[312]=9'd191;assign classmapabs[313]=9'd192;assign classmapabs[314]=9'd193;assign classmapabs[315]=9'd194;assign classmapabs[316]=9'd195;assign classmapabs[317]=9'd196;assign classmapabs[318]=9'd197;assign classmapabs[319]=9'd198;assign classmapabs[320]=9'd199;assign classmapabs[321]=9'd200;assign classmapabs[322]=9'd201;assign classmapabs[323]=9'd202;assign classmapabs[324]=9'd122;assign classmapabs[325]=9'd124;assign classmapabs[326]=9'd123;assign classmapabs[327]=9'd126;assign classmapabs[328]=9'd125;assign classmapabs[329]=9'd128;assign classmapabs[330]=9'd127;assign classmapabs[331]=9'd130;assign classmapabs[332]=9'd129;assign classmapabs[333]=9'd140;assign classmapabs[334]=9'd142;assign classmapabs[335]=9'd141;assign classmapabs[336]=9'd144;assign classmapabs[337]=9'd143;assign classmapabs[338]=9'd146;assign classmapabs[339]=9'd145;assign classmapabs[340]=9'd148;assign classmapabs[341]=9'd147;assign classmapabs[342]=9'd131;assign classmapabs[343]=9'd133;assign classmapabs[344]=9'd132;assign classmapabs[345]=9'd135;assign classmapabs[346]=9'd134;assign classmapabs[347]=9'd137;assign classmapabs[348]=9'd136;assign classmapabs[349]=9'd139;assign classmapabs[350]=9'd138;assign classmapabs[351]=9'd158;assign classmapabs[352]=9'd160;assign classmapabs[353]=9'd159;assign classmapabs[354]=9'd162;assign classmapabs[355]=9'd161;assign classmapabs[356]=9'd164;assign classmapabs[357]=9'd163;assign classmapabs[358]=9'd166;assign classmapabs[359]=9'd165;assign classmapabs[360]=9'd149;assign classmapabs[361]=9'd151;assign classmapabs[362]=9'd150;assign classmapabs[363]=9'd153;assign classmapabs[364]=9'd152;assign classmapabs[365]=9'd155;assign classmapabs[366]=9'd154;assign classmapabs[367]=9'd157;assign classmapabs[368]=9'd156;assign classmapabs[369]=9'd176;assign classmapabs[370]=9'd178;assign classmapabs[371]=9'd177;assign classmapabs[372]=9'd180;assign classmapabs[373]=9'd179;assign classmapabs[374]=9'd182;assign classmapabs[375]=9'd181;assign classmapabs[376]=9'd184;assign classmapabs[377]=9'd183;assign classmapabs[378]=9'd167;assign classmapabs[379]=9'd169;assign classmapabs[380]=9'd168;assign classmapabs[381]=9'd171;assign classmapabs[382]=9'd170;assign classmapabs[383]=9'd173;assign classmapabs[384]=9'd172;assign classmapabs[385]=9'd175;assign classmapabs[386]=9'd174;assign classmapabs[387]=9'd194;assign classmapabs[388]=9'd196;assign classmapabs[389]=9'd195;assign classmapabs[390]=9'd198;assign classmapabs[391]=9'd197;assign classmapabs[392]=9'd200;assign classmapabs[393]=9'd199;assign classmapabs[394]=9'd202;assign classmapabs[395]=9'd201;assign classmapabs[396]=9'd185;assign classmapabs[397]=9'd187;assign classmapabs[398]=9'd186;assign classmapabs[399]=9'd189;assign classmapabs[400]=9'd188;assign classmapabs[401]=9'd191;assign classmapabs[402]=9'd190;assign classmapabs[403]=9'd193;assign classmapabs[404]=9'd192;assign classmapabs[405]=9'd203;assign classmapabs[406]=9'd204;assign classmapabs[407]=9'd205;assign classmapabs[408]=9'd206;assign classmapabs[409]=9'd207;assign classmapabs[410]=9'd208;assign classmapabs[411]=9'd209;assign classmapabs[412]=9'd210;assign classmapabs[413]=9'd211;assign classmapabs[414]=9'd212;assign classmapabs[415]=9'd213;assign classmapabs[416]=9'd214;assign classmapabs[417]=9'd215;assign classmapabs[418]=9'd216;assign classmapabs[419]=9'd217;assign classmapabs[420]=9'd218;assign classmapabs[421]=9'd219;assign classmapabs[422]=9'd220;assign classmapabs[423]=9'd221;assign classmapabs[424]=9'd222;assign classmapabs[425]=9'd223;assign classmapabs[426]=9'd224;assign classmapabs[427]=9'd225;assign classmapabs[428]=9'd226;assign classmapabs[429]=9'd227;assign classmapabs[430]=9'd228;assign classmapabs[431]=9'd229;assign classmapabs[432]=9'd230;assign classmapabs[433]=9'd231;assign classmapabs[434]=9'd232;assign classmapabs[435]=9'd233;assign classmapabs[436]=9'd234;assign classmapabs[437]=9'd235;assign classmapabs[438]=9'd236;assign classmapabs[439]=9'd237;assign classmapabs[440]=9'd238;assign classmapabs[441]=9'd239;assign classmapabs[442]=9'd240;assign classmapabs[443]=9'd241;assign classmapabs[444]=9'd242;assign classmapabs[445]=9'd243;assign classmapabs[446]=9'd244;assign classmapabs[447]=9'd245;assign classmapabs[448]=9'd246;assign classmapabs[449]=9'd247;assign classmapabs[450]=9'd248;assign classmapabs[451]=9'd249;assign classmapabs[452]=9'd250;assign classmapabs[453]=9'd251;assign classmapabs[454]=9'd252;assign classmapabs[455]=9'd253;assign classmapabs[456]=9'd254;assign classmapabs[457]=9'd255;assign classmapabs[458]=9'd256;assign classmapabs[459]=9'd257;assign classmapabs[460]=9'd258;assign classmapabs[461]=9'd259;assign classmapabs[462]=9'd260;assign classmapabs[463]=9'd261;assign classmapabs[464]=9'd262;assign classmapabs[465]=9'd263;assign classmapabs[466]=9'd264;assign classmapabs[467]=9'd265;assign classmapabs[468]=9'd266;assign classmapabs[469]=9'd267;assign classmapabs[470]=9'd268;assign classmapabs[471]=9'd269;assign classmapabs[472]=9'd270;assign classmapabs[473]=9'd271;assign classmapabs[474]=9'd272;assign classmapabs[475]=9'd273;assign classmapabs[476]=9'd274;assign classmapabs[477]=9'd275;assign classmapabs[478]=9'd276;assign classmapabs[479]=9'd277;assign classmapabs[480]=9'd278;assign classmapabs[481]=9'd279;assign classmapabs[482]=9'd280;assign classmapabs[483]=9'd281;assign classmapabs[484]=9'd282;assign classmapabs[485]=9'd283;assign classmapabs[486]=9'd203;assign classmapabs[487]=9'd205;assign classmapabs[488]=9'd204;assign classmapabs[489]=9'd207;assign classmapabs[490]=9'd206;assign classmapabs[491]=9'd209;assign classmapabs[492]=9'd208;assign classmapabs[493]=9'd211;assign classmapabs[494]=9'd210;assign classmapabs[495]=9'd221;assign classmapabs[496]=9'd223;assign classmapabs[497]=9'd222;assign classmapabs[498]=9'd225;assign classmapabs[499]=9'd224;assign classmapabs[500]=9'd227;assign classmapabs[501]=9'd226;assign classmapabs[502]=9'd229;assign classmapabs[503]=9'd228;assign classmapabs[504]=9'd212;assign classmapabs[505]=9'd214;assign classmapabs[506]=9'd213;assign classmapabs[507]=9'd216;assign classmapabs[508]=9'd215;assign classmapabs[509]=9'd218;assign classmapabs[510]=9'd217;assign classmapabs[511]=9'd220;assign classmapabs[512]=9'd219;assign classmapabs[513]=9'd239;assign classmapabs[514]=9'd241;assign classmapabs[515]=9'd240;assign classmapabs[516]=9'd243;assign classmapabs[517]=9'd242;assign classmapabs[518]=9'd245;assign classmapabs[519]=9'd244;assign classmapabs[520]=9'd247;assign classmapabs[521]=9'd246;assign classmapabs[522]=9'd230;assign classmapabs[523]=9'd232;assign classmapabs[524]=9'd231;assign classmapabs[525]=9'd234;assign classmapabs[526]=9'd233;assign classmapabs[527]=9'd236;assign classmapabs[528]=9'd235;assign classmapabs[529]=9'd238;assign classmapabs[530]=9'd237;assign classmapabs[531]=9'd257;assign classmapabs[532]=9'd259;assign classmapabs[533]=9'd258;assign classmapabs[534]=9'd261;assign classmapabs[535]=9'd260;assign classmapabs[536]=9'd263;assign classmapabs[537]=9'd262;assign classmapabs[538]=9'd265;assign classmapabs[539]=9'd264;assign classmapabs[540]=9'd248;assign classmapabs[541]=9'd250;assign classmapabs[542]=9'd249;assign classmapabs[543]=9'd252;assign classmapabs[544]=9'd251;assign classmapabs[545]=9'd254;assign classmapabs[546]=9'd253;assign classmapabs[547]=9'd256;assign classmapabs[548]=9'd255;assign classmapabs[549]=9'd275;assign classmapabs[550]=9'd277;assign classmapabs[551]=9'd276;assign classmapabs[552]=9'd279;assign classmapabs[553]=9'd278;assign classmapabs[554]=9'd281;assign classmapabs[555]=9'd280;assign classmapabs[556]=9'd283;assign classmapabs[557]=9'd282;assign classmapabs[558]=9'd266;assign classmapabs[559]=9'd268;assign classmapabs[560]=9'd267;assign classmapabs[561]=9'd270;assign classmapabs[562]=9'd269;assign classmapabs[563]=9'd272;assign classmapabs[564]=9'd271;assign classmapabs[565]=9'd274;assign classmapabs[566]=9'd273;assign classmapabs[567]=9'd284;assign classmapabs[568]=9'd285;assign classmapabs[569]=9'd286;assign classmapabs[570]=9'd287;assign classmapabs[571]=9'd288;assign classmapabs[572]=9'd289;assign classmapabs[573]=9'd290;assign classmapabs[574]=9'd291;assign classmapabs[575]=9'd292;assign classmapabs[576]=9'd293;assign classmapabs[577]=9'd294;assign classmapabs[578]=9'd295;assign classmapabs[579]=9'd296;assign classmapabs[580]=9'd297;assign classmapabs[581]=9'd298;assign classmapabs[582]=9'd299;assign classmapabs[583]=9'd300;assign classmapabs[584]=9'd301;assign classmapabs[585]=9'd302;assign classmapabs[586]=9'd303;assign classmapabs[587]=9'd304;assign classmapabs[588]=9'd305;assign classmapabs[589]=9'd306;assign classmapabs[590]=9'd307;assign classmapabs[591]=9'd308;assign classmapabs[592]=9'd309;assign classmapabs[593]=9'd310;assign classmapabs[594]=9'd311;assign classmapabs[595]=9'd312;assign classmapabs[596]=9'd313;assign classmapabs[597]=9'd314;assign classmapabs[598]=9'd315;assign classmapabs[599]=9'd316;assign classmapabs[600]=9'd317;assign classmapabs[601]=9'd318;assign classmapabs[602]=9'd319;assign classmapabs[603]=9'd320;assign classmapabs[604]=9'd321;assign classmapabs[605]=9'd322;assign classmapabs[606]=9'd323;assign classmapabs[607]=9'd324;assign classmapabs[608]=9'd325;assign classmapabs[609]=9'd326;assign classmapabs[610]=9'd327;assign classmapabs[611]=9'd328;assign classmapabs[612]=9'd329;assign classmapabs[613]=9'd330;assign classmapabs[614]=9'd331;assign classmapabs[615]=9'd332;assign classmapabs[616]=9'd333;assign classmapabs[617]=9'd334;assign classmapabs[618]=9'd335;assign classmapabs[619]=9'd336;assign classmapabs[620]=9'd337;assign classmapabs[621]=9'd338;assign classmapabs[622]=9'd339;assign classmapabs[623]=9'd340;assign classmapabs[624]=9'd341;assign classmapabs[625]=9'd342;assign classmapabs[626]=9'd343;assign classmapabs[627]=9'd344;assign classmapabs[628]=9'd345;assign classmapabs[629]=9'd346;assign classmapabs[630]=9'd347;assign classmapabs[631]=9'd348;assign classmapabs[632]=9'd349;assign classmapabs[633]=9'd350;assign classmapabs[634]=9'd351;assign classmapabs[635]=9'd352;assign classmapabs[636]=9'd353;assign classmapabs[637]=9'd354;assign classmapabs[638]=9'd355;assign classmapabs[639]=9'd356;assign classmapabs[640]=9'd357;assign classmapabs[641]=9'd358;assign classmapabs[642]=9'd359;assign classmapabs[643]=9'd360;assign classmapabs[644]=9'd361;assign classmapabs[645]=9'd362;assign classmapabs[646]=9'd363;assign classmapabs[647]=9'd364;assign classmapabs[648]=9'd284;assign classmapabs[649]=9'd286;assign classmapabs[650]=9'd285;assign classmapabs[651]=9'd288;assign classmapabs[652]=9'd287;assign classmapabs[653]=9'd290;assign classmapabs[654]=9'd289;assign classmapabs[655]=9'd292;assign classmapabs[656]=9'd291;assign classmapabs[657]=9'd302;assign classmapabs[658]=9'd304;assign classmapabs[659]=9'd303;assign classmapabs[660]=9'd306;assign classmapabs[661]=9'd305;assign classmapabs[662]=9'd308;assign classmapabs[663]=9'd307;assign classmapabs[664]=9'd310;assign classmapabs[665]=9'd309;assign classmapabs[666]=9'd293;assign classmapabs[667]=9'd295;assign classmapabs[668]=9'd294;assign classmapabs[669]=9'd297;assign classmapabs[670]=9'd296;assign classmapabs[671]=9'd299;assign classmapabs[672]=9'd298;assign classmapabs[673]=9'd301;assign classmapabs[674]=9'd300;assign classmapabs[675]=9'd320;assign classmapabs[676]=9'd322;assign classmapabs[677]=9'd321;assign classmapabs[678]=9'd324;assign classmapabs[679]=9'd323;assign classmapabs[680]=9'd326;assign classmapabs[681]=9'd325;assign classmapabs[682]=9'd328;assign classmapabs[683]=9'd327;assign classmapabs[684]=9'd311;assign classmapabs[685]=9'd313;assign classmapabs[686]=9'd312;assign classmapabs[687]=9'd315;assign classmapabs[688]=9'd314;assign classmapabs[689]=9'd317;assign classmapabs[690]=9'd316;assign classmapabs[691]=9'd319;assign classmapabs[692]=9'd318;assign classmapabs[693]=9'd338;assign classmapabs[694]=9'd340;assign classmapabs[695]=9'd339;assign classmapabs[696]=9'd342;assign classmapabs[697]=9'd341;assign classmapabs[698]=9'd344;assign classmapabs[699]=9'd343;assign classmapabs[700]=9'd346;assign classmapabs[701]=9'd345;assign classmapabs[702]=9'd329;assign classmapabs[703]=9'd331;assign classmapabs[704]=9'd330;assign classmapabs[705]=9'd333;assign classmapabs[706]=9'd332;assign classmapabs[707]=9'd335;assign classmapabs[708]=9'd334;assign classmapabs[709]=9'd337;assign classmapabs[710]=9'd336;assign classmapabs[711]=9'd356;assign classmapabs[712]=9'd358;assign classmapabs[713]=9'd357;assign classmapabs[714]=9'd360;assign classmapabs[715]=9'd359;assign classmapabs[716]=9'd362;assign classmapabs[717]=9'd361;assign classmapabs[718]=9'd364;assign classmapabs[719]=9'd363;assign classmapabs[720]=9'd347;assign classmapabs[721]=9'd349;assign classmapabs[722]=9'd348;assign classmapabs[723]=9'd351;assign classmapabs[724]=9'd350;assign classmapabs[725]=9'd353;assign classmapabs[726]=9'd352;assign classmapabs[727]=9'd355;assign classmapabs[728]=9'd354;
wire [728:0] classmapsign = 729'b000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000111111111000000000111111111000000000111111111000000000111111111010101010;

wire signed [      9:0] Px;
wire [             7:0] Rx, Ix, Ra, Rb, Rc, Rd, ALatch;
wire [             9:0] Val    = 7'd81 * vLUT[9'h100+Rd-Rb] + 7'd9 * vLUT[9'h100+Rb-Rc] + vLUT[9'h100+Rc-Ra];
wire [             8:0] CmAbs  = classmapabs[Val];
wire                    CmSign = classmapsign[Val];
wire [MAXLEN_LEVEL-1:0] RunCnt;
wire                    regular, continue_run, end_run, rlastcol, wlastcol;
reg                     Rl=1'b0, Cl=1'b0;
wire [             7:0] RxR, RxE;
reg  [             7:0] RxC = '0;
reg  [MAXLEN_LEVEL-1:0] widthm1 = '0;
reg  [            15:0] heightl = '0;

wire                bvalid1, bvalid2;
reg                 bvalid_l = 1'b0;
wire signed [10:0]  merror1, merror2;
wire        [ 3:0]  k1     , k2;
wire        [ 3:0]  limitreduce;
reg  signed [10:0]  merror = '0;
reg         [ 3:0]  kp1 = '0;
reg  signed [10:0]  unary  = '0;
reg         [15:0]  shiftk = '0;
reg         [ 4:0]  limit  = 5'd25;

wire                pvalidw;
wire        [ 4:0]  ponesw;
wire        [15:0]  pdataw;
wire        [ 3:0]  pcntsw;

reg                 pvalid_l = '0;
reg         [ 4:0]  pones_l = '0;
reg         [15:0]  pdata_l = '0;
reg         [ 3:0]  pcnts_l = '0;

reg         [ 6:0]  mcnt = '0;
reg         [63:0]  mdata = '0;

wire                coder_ready, coder_flush;
wire        [ 6:0]  coder_cnt;
wire        [63:0]  coder_data;

reg         [ 8:0]  rstcnt = '0;
reg         [ 4:0]  precnt = 5'h0;
reg                 prerst = 1'b0;

wire                cvalid;
wire        [ 7:0]  cdata;

wire [  7:0] header [25];
assign header[0] = 8'hFF;
assign header[1] = 8'hD8;
assign header[2] = 8'hFF;
assign header[3] = 8'hF7;
assign header[4] = 8'h00;
assign header[5] = 8'h0B;
assign header[6] = 8'h08;
assign {header[7],header[ 8]} = heightl;
assign {header[9],header[10]} = widthm1+16'd1;
assign header[11] = 8'h01;
assign header[12] = 8'h01;
assign header[13] = 8'h11;
assign header[14] = 8'h00;
assign header[15] = 8'hFF;
assign header[16] = 8'hDA;
assign header[17] = 8'h00;
assign header[18] = 8'h08;
assign header[19] = 8'h01;
assign header[20] = 8'h01;
assign header[21] = 8'h00;
assign header[22] = 8'h02;
assign header[23] = 8'h00;
assign header[24] = 8'h00;

assign Ix = idata;
assign end_run = ~regular & ~continue_run;
assign Rx = Rl ? RxR : (Cl ? RxC : RxE);

always @ (posedge clk)
    if(rst) begin
        {Rl, Cl, RxC} <= '0;
    end else begin
        if(ivalid)
            {Rl, Cl, RxC} <= {regular, continue_run, ALatch};
    end

always @ (posedge clk)
    if(rst) begin
        widthm1 <= (width>3) ? width-1 : 3;
        heightl <= height;
    end

always @ (posedge clk) begin
    {prerst, precnt} <= '0;
    if(rst) begin
        if(rstcnt>=9'd336 && rstcnt<9'd361) begin
            prerst <= 1'b1;
            precnt <= rstcnt - 9'd336;
        end
        if(rstcnt<9'd368)
            rstcnt <= rstcnt + 9'd1;
    end else
        rstcnt <= '0;
end

predictor predictor_i(.Ra(Ra), .Rb(Rb), .Rc(Rc), .Px(Px));

context_gen #(
    .MAXLEN_LEVEL ( MAXLEN_LEVEL     )
) context_gen_i (
    .rst          ( rst              ),
    .clk          ( clk              ),
    .iimax        ( widthm1          ),
    .ivalid       ( ivalid           ),
    .Rx           ( Rx               ),
    .Ra           ( Ra               ),
    .Rb           ( Rb               ),
    .Rc           ( Rc               ),
    .Rd           ( Rd               ),
    .wlastcol     ( wlastcol         )
);

status_manage #(
    .MAXLEN_LEVEL ( MAXLEN_LEVEL     )
) status_manage_i(
    .rst          ( rst              ),
    .clk          ( clk              ),
    .ivalid       ( ivalid           ),
    .wlastcol     ( wlastcol         ),
    .val_eq_zero  ( Val == 0         ),
    .Ix           ( Ix               ),
    .Ra           ( Ra               ),
    .a_latch      ( ALatch           ),
    .run_cnt      ( RunCnt           ),
    .regular      ( regular          ),
    .continue_run ( continue_run     ),
    .rlastcol     ( rlastcol         )
);

regular_mode regular_mode_i(
    .rst          ( rst              ),
    .clk          ( clk              ),
    .rstcnt       ( rstcnt           ),
    .ivalid       ( ivalid & regular ),
    .Sign         ( CmSign           ),
    .Q            ( CmAbs            ),
    .Px           ( Px               ),
    .Ix           ( Ix               ),
    .Rx           ( RxR              ),
    .ivalid_ll    ( bvalid1          ),
    .MErrval_ll   ( merror1          ),
    .k_ll         ( k1               )
);

run_mode run_mode_i(
    .rst          ( rst              ),
    .clk          ( clk              ),
    .ivalid       ( ivalid & end_run ),
    .rlastcol     ( rlastcol         ),
    .run_cnt      ( RunCnt + 16'd0   ),
    .Ra           ( ALatch           ),
    .Rb           ( Rb               ),
    .Ix           ( Ix               ),
    .Rx           ( RxE              ),
    .ivalid_ll    ( bvalid2          ),
    .MErrval_ll   ( merror2          ),
    .k_ll         ( k2               ),
    .limitreduce  ( limitreduce      ),
    .pvalid       ( pvalidw          ),
    .pones        ( ponesw           ),
    .pdata        ( pdataw           ),
    .pcnts        ( pcntsw           )
);

always @ (posedge clk) begin
    automatic logic        [ 3:0] k_tmp;
    automatic logic signed [10:0] merror_tmp;
    bvalid_l <= bvalid1 | bvalid2;
    if(bvalid1) begin
        merror_tmp = merror1;
        k_tmp = k1;
        limit <= 5'd25;
    end else if(bvalid2) begin
        merror_tmp = merror2;
        k_tmp = k2;
        limit <= 5'd24 - {1'b0,limitreduce};
    end else begin
        merror_tmp = '0;
        k_tmp = 4'hf;
        limit <= 5'd25;
    end
    merror <= merror_tmp;
    kp1    <= k_tmp + 4'd1;
    unary  <= (merror_tmp>>>k_tmp);
    shiftk <= (16'd1<<k_tmp);
end

always @ (posedge clk)
    if(bvalid_l) begin
        bvalid <= 1'b1;
        if(unary<$signed({6'd0,limit})) begin
            bdata <= shiftk + ({5'd0,$unsigned(merror)} & (shiftk-16'd1));
            bcnts <= {2'h0,kp1} + {1'b0,unary[4:0]};
        end else begin
            bdata <= 16'd63 + {5'd0,$unsigned(merror)};
            bcnts <= 6'd7 + {1'b0,limit};
        end
    end else begin
        {bvalid, bdata, bcnts} <= '0;
    end

always @ (posedge clk) begin
    pvalid_l <= pvalidw;
    pones_l <= ponesw;
    pcnts_l <= pcntsw;
    pdata_l <= pdataw;
end

always @ (posedge clk) begin
    pvalid <= pvalid_l && (pones_l!='0 || pcnts_l!='0);
    pones <= pones_l;
    pcnts <= pcnts_l;
    pdata <= pdata_l;
end

always @ (posedge clk) begin
    mcnt  <= {2'h0, pones} + {3'h0, pcnts} + {1'h0, bcnts};
    mdata <= {48'h0, bdata} | ({48'h0, pdata}<<bcnts) | (64'hFFFFFFFF_FFFFFFFF<<(bcnts+{2'h0,pcnts}));
end


reg       last = 1'b0;
reg [4:0] lastshift = '0;
reg [MAXLEN_LEVEL-1:0]  xcnt = '0;
reg [            15:0]  ycnt = '0;
always @ (posedge clk) begin
    last <= 1'b0;
    if(ycnt==heightl && heightl!='0) begin
        last <= 1'b1;
        ycnt <= heightl + 16'h1;
    end
    if(rst) begin
        xcnt <= '0;
        ycnt <= '0;
    end else begin
        if(ivalid) begin
            if(xcnt<widthm1) begin
                xcnt <= xcnt + 1;
            end else begin
                xcnt <= '0;
                if(ycnt<heightl)
                    ycnt <= ycnt + 16'h1;
            end
        end
    end
end

always @ (posedge clk)
    lastshift <= {lastshift[3:0], last};

simple_fifo coder_fifo(
    .rst    ( prerst                               ),
    .clk    ( clk                                  ),
    .ivalid (  lastshift[4] | mcnt != '0           ),
    .idata  ( {lastshift[4],  mcnt, mdata}         ),
    .oready ( coder_ready                          ),
    .odata  ( {coder_flush, coder_cnt, coder_data} )
);

coder coder_i(
    .rst    ( prerst       ),
    .clk    ( clk          ),
    .iready ( coder_ready  ),
    .flush  ( coder_flush  ),
    .icnt   ( coder_cnt    ),
    .idata  ( coder_data   ),
    .ovalid ( cvalid       ),
    .odata  ( cdata        )
);

always @ (posedge clk)
    if(cvalid)
        {ovalid, odata} <= {1'b1, cdata};
    else if(prerst)
        {ovalid, odata} <= {1'b1, header[precnt]};
    else
        {ovalid, odata} <= '0;

endmodule
















module simple_fifo(
    input  wire         rst,
    input  wire         clk,
    input  wire         ivalid,
    input  wire  [71:0] idata,
    input  wire         oready,
    output wire  [71:0] odata
);

reg  [71:0] fdata [8];
reg  [2:0] wptr='0, rptr='0;

assign odata = (wptr!=rptr) ? fdata[rptr] : '0;

always @ (posedge clk)
    if(rst) begin
        wptr <= '0;
    end else begin
        if(ivalid) begin
            fdata[wptr] <= idata;
            wptr <= wptr + 3'd1;
        end
    end

always @ (posedge clk)
    if(rst) begin
        rptr <= '0;
    end else begin
        if((wptr!=rptr) & oready) begin
            rptr <= rptr + 3'd1;
        end
    end
    
endmodule












module coder(
    input  wire          rst,
    input  wire          clk,
    
    output wire          iready,
    input  wire          flush,
    input  wire  [ 6:0]  icnt,
    input  wire  [63:0]  idata,
    
    output reg           ovalid,
    output reg   [ 7:0]  odata
);

initial {ovalid, odata} = '0;

reg          isff = 1'b0;
reg  [ 5:0]  ptr  = '1;
reg  [ 2:0]  rptr = '1;
reg  [63:0]  buffer = '0;

assign iready =  (ptr-{rptr,3'b111}-6'd1) >= (flush ? 6'd24 : icnt[5:0]);

always @ (posedge clk)
    if(rst) begin
        {ovalid, odata} <= '0;
        isff <= 1'b0;
        ptr  <= '1;
        rptr <= '1;
        buffer <= '0;
    end else begin
        if(iready) begin
            if(flush) begin
                if(ptr[2:0] != 3'b111)
                    ptr[5:3]--;
                ptr[2:0] = 3'b000;
                buffer[ptr+:8] = 8'hFF;
                ptr[5:3]--;
                buffer[ptr+:8] = 8'hD9;
                ptr--;
            end else begin
                for(logic [6:0] ii=7'd63; ~ii[6]; ii--) begin
                    if(ii<icnt) begin
                        buffer[ptr] = idata[ii];
                        ptr--;
                        if(~idata[ii]) isff = 1'b0;
                        if(ptr[2:0]=='1) begin
                            if(isff) begin
                                buffer[ptr] = 1'b0;
                                ptr--;
                            end
                            isff = ~isff;
                        end
                    end
                end
            end
        end
        if(ptr[5:3]!=rptr) begin
            ovalid <= 1'b1;
            odata  <= buffer[8*rptr+:8];
            buffer[8*rptr+:8] = '0;
            rptr--;
        end else
            {ovalid, odata} <= '0;
    end

endmodule






















module predictor(
    input  wire       [7:0] Ra, 
    input  wire       [7:0] Rb, 
    input  wire       [7:0] Rc,
    output reg signed [9:0] Px
);

always_comb begin
    automatic logic [7:0] minx, maxx;
    if(Rb>Ra) begin
        minx = Ra;
        maxx = Rb;
    end else begin
        maxx = Ra;
        minx = Rb;
    end
    if(Rc>=maxx)
        Px = $signed({2'b00, minx});
    else if(Rc<=minx)
        Px = $signed({2'b00, maxx});
    else 
        Px = $signed({2'b00,Ra}) + $signed({2'b00,Rb}) - $signed({2'b00,Rc});
end

endmodule














module regular_mode(
    input  wire                rst,
    input  wire                clk,
    input  wire        [ 8:0]  rstcnt,
    input  wire                ivalid,
    input  wire                Sign,
    input  wire        [ 8:0]  Q,
    input  wire signed [ 9:0]  Px,
    input  wire        [ 7:0]  Ix,
    output reg         [ 7:0]  Rx,
    output reg                 ivalid_ll,
    output reg  signed [10:0]  MErrval_ll,
    output reg         [ 3:0]  k_ll
);

initial {ivalid_ll, MErrval_ll, k_ll} = '0;

function automatic logic [3:0] getK(input [6:0] Nt, input [10:0] At);
    automatic logic [17:0] Ntmp;
    automatic logic [17:0] Atmp;
    automatic logic [ 3:0] k;
    Ntmp = {11'h0, Nt};
    Atmp = { 7'h0, At};
    for(k=4'h0; k<4'd12; k=k+4'h1) begin
        if((Ntmp<<k)>=Atmp)
            break;
    end
    return k;
endfunction

wire        [ 5:0] Nr;
wire        [10:0] Ar;
wire        [ 5:0] Br;
wire        [ 7:0] Cr;

reg                ivalidl = 1'b0;
reg         [ 8:0] Ql;
reg                Signl = '0;
reg  signed [10:0] Pxl = '0;
reg  signed [10:0] Ixl = '0;
reg         [30:0] wdata;

RamSinglePortWriteFirst #(
    .SIZE     ( 512           ),  // actually using 0~364
    .WIDTH    ( 31            )
) ram_for_context (
    .clk      ( clk           ),
    .wen      ( rst | ivalidl ),
    .waddr    ( ivalidl ? Ql    : rstcnt                   ),
    .wdata    ( ivalidl ? wdata : {6'd0,11'd2,6'd0,8'd128} ),
    .ren      ( ivalid        ),
    .raddr    ( Q             ),
    .rdata    ( {Nr,Ar,Br,Cr} )
);
    
always @ (posedge clk)
    if(rst) begin
        ivalidl <= 1'b0;
        Ql  <= '0;
        Signl <= '0;
        Pxl <= '0;
        Ixl <= '0;
    end else begin
        ivalidl <= ivalid;
        if(ivalid) begin
            Ql  <= Q;
            Signl <= Sign;
            Pxl <= Px;
            Ixl <= Ix;
        end
    end
    
    logic         [ 6:0] Nt;
    logic         [10:0] At;
    logic         [ 7:0] Ct;
    logic         [ 3:0] k;
    logic signed  [10:0] PxF;
    logic signed  [10:0] RxF;
    logic signed  [10:0] Errval;
    logic signed  [10:0] qErrval;
    logic signed  [10:0] absErrval;
    logic signed  [10:0] MErrval;
    logic signed  [10:0] BtF;
    logic signed  [10:0] CtF;

always_comb begin
    Nt    = {1'b0,Nr} + 7'd1;
    At    = Ar;
    Ct    = Cr;
    k     = getK(Nt, At);
    CtF   = $signed({3'd0,Ct}) - $signed(11'd128);
    PxF   = Signl ? Pxl - CtF : Pxl + CtF;
    PxF   = (PxF>$signed(11'd255)) ? $signed(11'd255) : ( (PxF<$signed(11'd0)) ? $signed(11'd0) : PxF );
    Errval= Signl ? PxF-$signed(Ixl) : $signed(Ixl)-PxF;
    if(Errval<$signed(11'd0))
        qErrval = - ( ($signed(11'd2)-Errval) / $signed(11'd5) );
    else
        qErrval =   ( ($signed(11'd2)+Errval) / $signed(11'd5) );
    RxF   = Signl ? PxF-$signed(11'd5)*qErrval : PxF+$signed(11'd5)*qErrval;
    Rx    = (RxF>$signed(11'd255)) ? 8'd255 : ( (RxF<$signed(11'd0)) ? 8'd0 : RxF[7:0] );
    
    if(qErrval <  $signed(11'd0) )
        qErrval += $signed(11'd52);
    if(qErrval >= $signed(11'd26)) begin
        qErrval -= $signed(11'd52); 
        absErrval = -qErrval;
        MErrval = (absErrval<<<1) - $signed(11'd1);
    end else begin
        absErrval =  qErrval;
        MErrval = (absErrval<<<1);
    end
    BtF = $signed({5'h0,Br}) - $signed(11'd5) * qErrval;
    At += $unsigned(absErrval);
    if(Nt>=7'd64) begin
        Nt >>>= 1;
        At >>>= 1;
        BtF = (-((-BtF)>>>1));
    end
    if(BtF>$signed({4'h0,Nt})) begin
        if(Ct>8'd0) Ct--;
        BtF -= ( $signed({4'h0,Nt}) + $signed(11'd1) );
        if(BtF>$signed({4'h0,Nt})) BtF = $signed({4'h0,Nt});
    end else if(BtF<$signed(11'd0)) begin
        if(Ct<8'd255) Ct++;
        BtF += ( $signed({4'h0,Nt}) + $signed(11'd1) );
        if(BtF<$signed(11'd0)) BtF = $signed(11'd0);
    end
    wdata = {Nt[5:0], At, BtF[5:0], Ct};
end

always @ (posedge clk) begin
    ivalid_ll <= ivalidl;
    if(ivalidl) begin
        MErrval_ll <= MErrval;
        k_ll <= k;
    end
end

endmodule




















module run_mode(
    input  wire               rst,
    input  wire               clk,
    input  wire               ivalid,
    input  wire               rlastcol,
    input  wire       [15:0]  run_cnt,
    input  wire       [ 7:0]  Ra,
    input  wire       [ 7:0]  Rb,
    input  wire       [ 7:0]  Ix,
    output reg        [ 7:0]  Rx,
    output reg                ivalid_ll,
    output reg signed [10:0]  MErrval_ll,
    output reg        [ 3:0]  k_ll,
    output reg        [ 3:0]  limitreduce,
    output reg                pvalid,
    output reg        [ 4:0]  pones,
    output reg        [15:0]  pdata,
    output reg        [ 3:0]  pcnts
);

wire  [ 3:0] J [32];   assign J[0]=4'd0;assign J[1]=4'd0;assign J[2]=4'd0;assign J[3]=4'd0;assign J[4]=4'd1;assign J[5]=4'd1;assign J[6]=4'd1;assign J[7]=4'd1;assign J[8]=4'd2;assign J[9]=4'd2;assign J[10]=4'd2;assign J[11]=4'd2;assign J[12]=4'd3;assign J[13]=4'd3;assign J[14]=4'd3;assign J[15]=4'd3;assign J[16]=4'd4;assign J[17]=4'd4;assign J[18]=4'd5;assign J[19]=4'd5;assign J[20]=4'd6;assign J[21]=4'd6;assign J[22]=4'd7;assign J[23]=4'd7;assign J[24]=4'd8;assign J[25]=4'd9;assign J[26]=4'd10;assign J[27]=4'd11;assign J[28]=4'd12;assign J[29]=4'd13;assign J[30]=4'd14;assign J[31]=4'd15;
reg   [ 4:0] jidx      = '0, jidxw;
reg   [ 3:0] limitw;
reg   [15:0] run_cnt_l = '0;
reg          llastcol  = '0;
reg          ivalidl   = '0;

reg   [ 6:0] NR [2];
reg   [10:0] AR [2];
reg   [ 5:0] BR [2];

initial {NR[0], NR[1]} = '0;
initial {AR[0], AR[1]} = '0;
initial {BR[0], BR[1]} = '0;
initial Rx = '0;
initial {pvalid, pones, pdata, pcnts} = '0;
initial {ivalid_ll, MErrval_ll, k_ll, limitreduce} = '0;

logic        [ 7:0] RbRaDelta;
logic               RItype;
logic        [ 3:0] k;
logic        [ 6:0] Nt;
logic        [10:0] At, AtF;
logic        [ 5:0] Bt;
logic        [ 7:0] xpr;
logic        [ 7:0] RxW;
logic signed [10:0] Errval;
logic signed [10:0] qErrval;
logic signed [10:0] MErrval;
logic signed [10:0] absErrval;
logic signed [10:0] RxF;
logic               oldmap;

reg signed [10:0] MErrval_l = '0;
reg        [ 3:0] k_l = '0;
reg        [ 4:0] ponesw;
reg        [15:0] pdataw;
reg        [ 3:0] pcntsw;
reg               rstl     = '0;

always_comb begin
    RbRaDelta = (Rb>Ra) ? (Rb-Ra) : (Ra-Rb);
    RItype    = (RbRaDelta <= 8'd2);
    Nt  = NR[RItype];
    At  = AR[RItype];
    Bt  = BR[RItype];
    AtF = At;
    xpr = RItype ? Ra : Rb;
    Errval = $signed({3'd0,Ix}) - $signed({3'd0,xpr});
    if(RItype)
        AtF += {5'd0, Nt[6:1]};
    else if(Rb<Ra)
        Errval = -Errval;
    if(Errval<$signed(11'd0))
        qErrval = - ( ($signed(11'd2)-Errval) / $signed(11'd5) );
    else
        qErrval =   ( ($signed(11'd2)+Errval) / $signed(11'd5) );
    if(RItype || (Rb>=Ra))
        RxF = $signed({3'd0,xpr}) + $signed(11'd5) * qErrval;
    else
        RxF = $signed({3'd0,xpr}) - $signed(11'd5) * qErrval;
    RxW = (RxF>$signed(11'd255)) ? 8'd255 : ( (RxF<$signed(11'd0)) ? 8'd0 : RxF[7:0] );
    
    for(k=4'h0; k<4'd12; k=k+4'h1) begin
        if(({11'h0, Nt}<<k)>={7'h0,AtF})
            break;
    end
    if(qErrval <  $signed(11'd0) )
        qErrval += $signed(11'd52);
    if(qErrval >= $signed(11'd26))
        qErrval -= $signed(11'd52);
    oldmap = ( k==4'h0 && (qErrval!=$signed(11'd0)) && {11'h0,Bt,1'b0}<({11'h0,Nt}<<k) );
    if(qErrval <  $signed(11'd0) ) begin
        MErrval = -$signed(11'd2) * qErrval - (RItype ? $signed(11'd2) : $signed(11'd1)) + (oldmap ? $signed(11'd1) : $signed(11'd0));
        Bt++;
    end else begin
        MErrval =  $signed(11'd2) * qErrval - (RItype ? $signed(11'd1) : $signed(11'd0)) - (oldmap ? $signed(11'd1) : $signed(11'd0));
    end
    absErrval = ( MErrval + (RItype ? $signed(11'd0) : $signed(11'd1)) ) / $signed(11'd2);
    At += $unsigned(absErrval);
    if(Nt>=7'd64) begin
        Nt >>>= 1;
        At >>>= 1;
        Bt >>>= 1;
    end
    Nt++;
end

always @ (posedge clk)
    if(rst) begin
        {NR[0], NR[1]} <= {7'd1 , 7'd1 };
        {AR[0], AR[1]} <= {11'd2, 11'd2};
        {BR[0], BR[1]} <= {6'd0 , 6'd0 };
        Rx <= '0;
    end else begin
        if(ivalid) begin
            if(rlastcol) begin
                Rx <= Ra;
            end else begin
                NR[RItype] <= Nt;
                AR[RItype] <= At;
                BR[RItype] <= Bt;
                Rx <= RxW;
            end
        end
    end

always @ (posedge clk)
    rstl <= rst;

always @ (posedge clk)
    if(rst) begin
        ivalidl <= '0;
        MErrval_l <= '0;
        k_l <= '0;
        llastcol <= '0;
        run_cnt_l <= '0;
    end else begin
        ivalidl <= ivalid;
        if(ivalid) begin
            MErrval_l <= MErrval;
            k_l <= k;
            run_cnt_l <= run_cnt;
            llastcol <= rlastcol;
        end
    end

always @ (posedge clk) begin
    ivalid_ll <= ivalidl & ~llastcol;
    if(ivalidl) begin
        MErrval_ll <= MErrval_l;
        k_ll <= k_l;
    end
end

always_comb begin
    jidxw = jidx;
    limitw= limitreduce;
    if(ivalidl) begin
        ponesw = 5'd0;
        pdataw = run_cnt_l;
        for(int ii=0; ii<32; ii++) begin
            if(pdataw >= (16'd1<<J[jidxw])) begin
                pdataw -= (16'd1<<J[jidxw]);
                jidxw++;
                ponesw++;
            end
        end
        if(llastcol) begin
            if(pdataw>16'd0) begin
                pcntsw = 4'd1;
                pdataw = 16'd1;
            end else begin
                pcntsw = 4'd0;
                pdataw = 16'd0;
            end
        end else begin
            pcntsw = J[jidxw] + 4'd1;
            limitw = J[jidxw];
            if(jidxw>4'd0)
                jidxw--;
        end
    end else begin
        {ponesw, pdataw, pcntsw} = '0;
    end
end

always @ (posedge clk)
    if(rstl) begin
        jidx  <= '0;
        limitreduce <= '0;
        pvalid<= 1'b0;
        pones <= '0;
        pdata <= '0;
        pcnts <= '0;
    end else begin
        jidx  <= jidxw;
        limitreduce <= limitw;
        pvalid<= ivalidl;
        pones <= ponesw;
        pdata <= pdataw;
        pcnts <= pcntsw;
    end

endmodule























module status_manage #(
    parameter  MAXLEN_LEVEL = 12 // min = 3
) (
    input  wire                    rst,
    input  wire                    clk,
    input  wire                    ivalid,
    input  wire                    wlastcol,
    input  wire                    val_eq_zero,
    input  wire [             7:0] Ix,
    input  wire [             7:0] Ra,
    output reg  [             7:0] a_latch,
    output reg  [MAXLEN_LEVEL-1:0] run_cnt,
    output reg                     regular,
    output reg                     continue_run,
    output reg                     rlastcol
);

reg                    running;
reg                    running_l = 1'b0;
reg [MAXLEN_LEVEL-1:0] run_cnt_l = '0;
reg [             7:0] a_latch_l = '0;
reg [             7:0] delta;

always @ (posedge clk)
    if(rst) begin
        running_l <= 1'b0;
        run_cnt_l <= '0;
        a_latch_l <= '0;
    end else begin
        if(ivalid) begin
            running_l <= running;
            run_cnt_l <= run_cnt;
            a_latch_l <= a_latch;
        end
    end

always_comb begin
    running = running_l;
    run_cnt = run_cnt_l;
    a_latch = a_latch_l;
    {regular, continue_run, rlastcol} = '0;
    if(~running) begin
        run_cnt = 0;
        a_latch = Ra;
        if(val_eq_zero)
            running = 1'b1;
        else
            regular = 1'b1;
    end
    delta = (Ix>a_latch) ? (Ix-a_latch) : (a_latch-Ix);
    if(running) begin
        if(delta>8'd2) begin
            running = 1'b0;
        end else if(wlastcol) begin
            running = 1'b0;
            rlastcol = 1'b1;
            run_cnt = run_cnt + 1;
        end else begin
            continue_run = 1'b1;
            run_cnt = run_cnt + 1;
        end
    end
end

endmodule














module context_gen #(
    parameter  MAXLEN_LEVEL = 12 // min = 3
) (
    input  wire                    rst,
    input  wire                    clk,
    input  wire [MAXLEN_LEVEL-1:0] iimax,  // 3~(2^MAXLEN_LEVEL-2)
    input  wire                    ivalid,
    input  wire [             7:0] Rx,
    output wire [             7:0] Ra,
    output wire [             7:0] Rb,
    output wire [             7:0] Rc,
    output wire [             7:0] Rd,
    output wire                    wlastcol
); 

reg                     nfirst = 1'b0;
reg  [MAXLEN_LEVEL-1:0] ii     = '0;
reg  [             7:0] RbRaw='0, RcRaw='0, RcTmp='0;
wire [             7:0] RdRaw;

assign wlastcol = (ii>=iimax);

assign Ra = ii=='0 ? RbRaw : Rx;
assign Rb = nfirst ? RbRaw : '0;
assign Rc = nfirst ? ( ii=='0   ? RcTmp : RcRaw ) : '0;
assign Rd = nfirst ? ( wlastcol ? RbRaw : RdRaw ) : '0;

always @ (posedge clk)
    if(rst) begin
        ii     <= '0;
        nfirst <= 1'b0;
    end else begin
        if(ivalid) begin
            if(wlastcol) begin
                ii     <= '0;
                nfirst <= 1'b1;
            end else
                ii     <= ii + 1;
        end
    end

always @ (posedge clk)
    if(rst) begin
        RcRaw <= '0;
        RbRaw <= '0;
    end else begin
        if(ivalid) begin
            RcRaw <= RbRaw;
            RbRaw <= RdRaw;
        end
    end

always @ (posedge clk)
    if(rst) begin
        RcTmp <= '0;
    end else begin
        if(ivalid && (ii=='0))
            RcTmp <= RbRaw;
    end

wire [MAXLEN_LEVEL-1:0] three;
assign three[             1:0] = 2'b11;
assign three[MAXLEN_LEVEL-1:2] = '0;

shift_buffer #(
    .MAXLEN_LEVEL ( MAXLEN_LEVEL  ),
    .DWIDTH       ( 8             )
) shift_buffer_i (
    .rst          ( rst           ),
    .clk          ( clk           ),
    .length       ( iimax - three ),
    .ivalid       ( ivalid        ),
    .idata        ( Rx            ),
    .odata        ( RdRaw         )
);

endmodule

















module shift_buffer #(
    parameter                      MAXLEN_LEVEL = 12,
    parameter                      DWIDTH       = 8
) (
    input                          rst,
    input                          clk,
    
    input      [MAXLEN_LEVEL-1:0]  length,  // length = 0 ~ (1<<MAXLEN_LEVEL-1)
    
    input                          ivalid,
    input      [      DWIDTH-1:0]  idata,

    output     [      DWIDTH-1:0]  odata
);

localparam MAXLEN = 1<<MAXLEN_LEVEL;

reg                     rvalid = 1'b0;
wire [      DWIDTH-1:0] rdata;
reg  [      DWIDTH-1:0] ldata = '0;
reg  [MAXLEN_LEVEL-1:0] ptr = '0;

always @ (posedge clk)
    if(rst)
        ptr <= '0;
    else begin
        if(ivalid) begin
            if(ptr<length)
                ptr <= ptr + 1;
            else
                ptr <= '0;
        end
    end

always @ (posedge clk)
    if(rst)
        rvalid <= 1'b0;
    else
        rvalid <= ivalid;

always @ (posedge clk)
    if(rvalid)
        ldata <= rdata;
    
assign odata = rvalid ? rdata : ldata;

RamSinglePort #(
    .SIZE     ( MAXLEN      ),
    .WIDTH    ( DWIDTH      )
) ram_for_bitlens (
    .clk      ( clk         ),
    .wen      ( ivalid      ),
    .waddr    ( ptr         ),
    .wdata    ( idata       ),
    .raddr    ( ptr         ),
    .rdata    ( rdata       )
);

endmodule














module RamSinglePortWriteFirst #(
    parameter  SIZE     = 1024,
    parameter  WIDTH    = 32
)(
    clk,
    wen,
    waddr,
    wdata,
    ren,
    raddr,
    rdata
);

function automatic integer clogb2(input integer val);
    integer valtmp;
    valtmp = val;
    for(clogb2=0; valtmp>0; clogb2=clogb2+1) valtmp = valtmp>>1;
endfunction

input                       clk;
input                       wen;
input  [clogb2(SIZE-1)-1:0] waddr;
input  [WIDTH-1:0]          wdata;
input                       ren;
input  [clogb2(SIZE-1)-1:0] raddr;
output [WIDTH-1:0]          rdata;

wire                        clk;
wire                        wen;
wire   [clogb2(SIZE-1)-1:0] waddr;
wire   [WIDTH-1:0]          wdata;
wire                        ren;
wire   [clogb2(SIZE-1)-1:0] raddr;
wire   [WIDTH-1:0]          rdata, rdataraw;

reg                         renl = 1'b0;
reg    [WIDTH-1:0]          rdatal = '0;
reg    [WIDTH-1:0]          bypass_data = 1'b0;
reg                         bypass_valid= '0;

always @ (posedge clk) begin
    if(renl) rdatal <= (bypass_valid ? bypass_data : rdataraw);
    renl <= ren;
    bypass_valid <= (wen && waddr==raddr);
    bypass_data  <= wdata;
end

assign rdata = renl ? (bypass_valid ? bypass_data : rdataraw) : rdatal;

RamSinglePort #(
    .SIZE     ( SIZE        ),
    .WIDTH    ( WIDTH       )
) ram_for_writefirst (
    .clk      ( clk         ),
    .wen      ( wen         ),
    .waddr    ( waddr       ),
    .wdata    ( wdata       ),
    .raddr    ( raddr       ),
    .rdata    ( rdataraw    )
);

endmodule





















module RamSinglePort #(
    parameter  SIZE     = 1024,
    parameter  WIDTH    = 32
)(
    clk,
    wen,
    waddr,
    wdata,
    raddr,
    rdata
);

function automatic integer clogb2(input integer val);
    integer valtmp;
    valtmp = val;
    for(clogb2=0; valtmp>0; clogb2=clogb2+1) valtmp = valtmp>>1;
endfunction

input                       clk;
input                       wen;
input  [clogb2(SIZE-1)-1:0] waddr;
input  [WIDTH-1:0]          wdata;
input  [clogb2(SIZE-1)-1:0] raddr;
output [WIDTH-1:0]          rdata;

wire                        clk;
wire                        wen;
wire   [clogb2(SIZE-1)-1:0] waddr;
wire   [WIDTH-1:0]          wdata;
wire   [clogb2(SIZE-1)-1:0] raddr;
reg    [WIDTH-1:0]          rdata;

reg [WIDTH-1:0] mem [SIZE];

always @ (posedge clk)
    if(wen)
        mem[waddr] <= wdata;

initial rdata = '0;
always @ (posedge clk)
    rdata <= mem[raddr];

endmodule

