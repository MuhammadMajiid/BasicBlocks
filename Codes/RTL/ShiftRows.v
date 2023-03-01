//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: ShiftRows.v
//  TYPE: module.
//  DATE: 4/10/2022
//  KEYWORDS: Rotator, AES.
//  PURPOSE: An RTL modelling for a left rotator used in the AES logic implementation.

module ShiftRows 
//-----------------Ports-----------------\\
(
    input  wire [0:127] data_sbox,

    output wire [0:127] shifted_rows
);

// //-----------------Original-----------------\\
// first_row  = {data_sbox[0:7],data_sbox[32:39],data_sbox[64:71],data_sbox[96:103]};
// second_row = {data_sbox[8:15],data_sbox[40:47],data_sbox[72:79],data_sbox[104:111]};
// third_row  = {data_sbox[16:23],data_sbox[48:55],data_sbox[80:87],data_sbox[112:119]};
// fourth_row = {data_sbox[24:31],data_sbox[56:63],data_sbox[88:95],data_sbox[120:127]};

//-----------------Output logic-----------------\\
assign shifted_rows = {
    data_sbox[0:7],     data_sbox[32:39],   data_sbox[64:71],   data_sbox[96:103],  //  first row shifted by zero bytes
    data_sbox[40:47],   data_sbox[72:79],   data_sbox[104:111], data_sbox[8:15],    //  second row shifted by one bytes
    data_sbox[80:87],   data_sbox[112:119], data_sbox[16:23],   data_sbox[48:55],   //  third row shifted by two bytes
    data_sbox[120:127], data_sbox[24:31],   data_sbox[56:63],   data_sbox[88:95]    //  fourth row shifted by three bytes
};

endmodule