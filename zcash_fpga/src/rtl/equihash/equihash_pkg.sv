/*
  Parameter values and tasks for the verification system.
 
  Copyright (C) 2019  Benjamin Devlin and Zcash Foundation

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

package equihash_pkg;
  
  // Variables used in the equihash PoW
  parameter [31:0] N = 32'd200;
  parameter [31:0] K = 32'd9;
  parameter       INDICIES_PER_HASH = (512/N);
  parameter       COLLISION_BIT_LEN = N/(K+1);
  parameter [7:0] BLAKE2B_DIGEST_BYTS = (N*INDICIES_PER_HASH)/8;
  parameter       SOL_BITS =  COLLISION_BIT_LEN+1;
  parameter       SOL_LIST_LEN = 1 << K;
  
  parameter [127:0] POW_TAG = {K, N, "WoPhsacZ"}; // ZcashPoW is reversed here
  
  parameter SOL_LIST_ENC = (SOL_LIST_LEN*SOL_BITS/8 < 8'hFD ? 1 : 3); // 3 Bytes used to encode size for N = 200, K = 9. 
  parameter SOL_LIST_BYTS = SOL_LIST_ENC + SOL_LIST_LEN*SOL_BITS/8;
  
  parameter MAX_BLOCK_BYTS = 2*1024*1024; // 2MB
  
  
  // Values used for resulting error masks
  typedef struct packed {
    logic [2:0] padding;
    logic DUPLICATE_FND;
    logic BAD_ZERO_ORDER;
    logic BAD_IDX_ORDER;
    logic XOR_NON_ZERO;
    logic DIFFICULTY_FAIL;
  } equihash_bm_t; 
  
  // Format for equihash input - should be 144 bytes
  typedef struct packed {
    logic [31:0]  index;
    logic [255:0] nonce;
    logic [31:0]  bits;
    logic [31:0]  my_time;
    logic [255:0] hash_reserved;
    logic [255:0] hash_merkle_root;
    logic [255:0] hash_prev_block;
    logic [31:0]  version;
  } equihash_gen_in_t;
  
  typedef struct packed {
    logic [SOL_LIST_LEN-1:0][SOL_BITS-1:0] sol;
    logic [SOL_LIST_ENC*8-1:0] size; // Contains size of solution array - should be 1347 for (200,9)
  } equihash_sol_t;
  
  // Header format for block header (CBlockheader)
  typedef struct packed {
    logic [255:0] nonce;
    logic [31:0]  bits;
    logic [31:0]  my_time;
    logic [255:0] hash_final_sapling_root;
    logic [255:0] hash_merkle_root;
    logic [255:0] hash_prev_block;
    logic [31:0]  version;
  } cblockheader_t;
  
  // Header format for block header (CBlockheader) inc. solution
  typedef struct packed {
    equihash_sol_t equihash_sol;
    cblockheader_t cblockheader;
  } cblockheader_sol_t;
  

endpackage