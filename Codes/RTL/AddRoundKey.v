//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: AddRoundKey.v
//  TYPE: module.
//  DATE: 4/10/2022
//  KEYWORDS: Add Round Key, AES.
//  PURPOSE: An RTL modelling for an add round key used in the AES logic implementation.

module AddRoundKey 
//-----------------Ports-----------------\\
(
    input  wire [0:127] round_key,
    input  wire [0:127] mixed_cols_data,

    output wire [0:127] next_round_data
);

//-----------------Output logic-----------------\\
assign next_round_data[0:31]   = round_key[0:31]   ^  mixed_cols_data[0:31];
assign next_round_data[32:63]  = round_key[32:63]  ^  mixed_cols_data[32:63];
assign next_round_data[64:95]  = round_key[64:95]  ^  mixed_cols_data[64:95];
assign next_round_data[96:127] = round_key[96:127] ^  mixed_cols_data[96:127]; 

endmodule