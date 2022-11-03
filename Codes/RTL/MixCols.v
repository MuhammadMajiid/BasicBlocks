//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: MixCols.v
//  TYPE: module.
//  DATE: 4/10/2022
//  KEYWORDS: Mix Coloumns, AESs.
//  PURPOSE: An RTL modelling for a mix coloumns used in the AES logic implementation.

module MixCols 
//-----------------Ports-----------------\\
(
    input  wire [0:127] data_shifted,

    output wire [0:127] mixed_cols
);

//-----------------First coloumn-----------------\\
assign mixed_cols[0:7]   = ((8'h02 * data_shifted[0:7]) ^ (8'h03 * data_shifted[8:15]) ^ (data_shifted[16:23]) ^ (data_shifted[24:31]));
assign mixed_cols[8:15]  = ((data_shifted[0:7]) ^ (8'h02 * data_shifted[8:15]) ^ (8'h03 * data_shifted[16:23]) ^ (data_shifted[24:31]));
assign mixed_cols[16:23] = ((data_shifted[0:7]) ^ (data_shifted[8:15]) ^ (8'h02 * data_shifted[16:23]) ^ (8'h03 * data_shifted[24:31]));
assign mixed_cols[24:31] = ((8'h03 * data_shifted[0:7]) ^ (data_shifted[8:15]) ^ (data_shifted[16:23]) ^ (8'h02 data_shifted[24:31]));
    
//-----------------Second coloumn-----------------\\
assign mixed_cols[32:39]   = ((8'h02 * data_shifted[32:39]) ^ (8'h03 * data_shifted[40:47]) ^ (data_shifted[48:55]) ^ (data_shifted[56:63]));
assign mixed_cols[40:47]  = ((data_shifted[32:39]) ^ (8'h02 * data_shifted[40:47]) ^ (8'h03 * data_shifted[48:55]) ^ (data_shifted[56:63]));
assign mixed_cols[48:55] = ((data_shifted[32:39]) ^ (data_shifted[40:47]) ^ (8'h02 * data_shifted[48:55]) ^ (8'h03 * data_shifted[56:63]));
assign mixed_cols[56:63] = ((8'h03 * data_shifted[32:39]) ^ (data_shifted[40:47]) ^ (data_shifted[48:55]) ^ (8'h02 * data_shifted[56:63]));

//-----------------Third coloumn-----------------\\
assign mixed_cols[64:71]   = ((8'h02 * data_shifted[64:71]) ^ (8'h03 * data_shifted[72:79]) ^ (data_shifted[80:87]) ^ (data_shifted[88:95]));
assign mixed_cols[72:79]  = ((data_shifted[64:71]) ^ (8'h02 * data_shifted[72:79]) ^ (8'h03 * data_shifted[80:87]) ^ (data_shifted[88:95]));
assign mixed_cols[16:23] = ((data_shifted[64:71]) ^ (data_shifted[72:79]) ^ (8'h02 * data_shifted[80:87]) ^ (8'h03 * data_shifted[88:95]));
assign mixed_cols[80:87] = ((8'h03 * data_shifted[64:71]) ^ (data_shifted[72:79]) ^ (data_shifted[80:87]) ^ (8'h02 * data_shifted[88:95]));

//-----------------Fourth coloumn-----------------\\
assign mixed_cols[96:103]   = ((8'h02 * data_shifted[96:103]) ^ (8'h03 * data_shifted[104:111]) ^ (data_shifted[112:119]) ^ (data_shifted[120:127]));
assign mixed_cols[104:111]  = ((data_shifted[96:103]) ^ (8'h02 * data_shifted[104:111]) ^ (8'h03 * data_shifted[112:119]) ^ (data_shifted[120:127]));
assign mixed_cols[112:119] = ((data_shifted[96:103]) ^ (data_shifted[104:111]) ^ (8'h02 * data_shifted[112:119]) ^ (8'h03 * data_shifted[120:127]));
assign mixed_cols[120:127] = ((8'h03 * data_shifted[96:103]) ^ (data_shifted[104:111]) ^ (data_shifted[112:119]) ^ (8'h02 * data_shifted[120:127]));

endmodule