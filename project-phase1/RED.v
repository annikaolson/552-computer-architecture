module RED();

//////////////////////////////////////////////////////////////////
// reduction unit (RED): performs reduction on 4 byte-size      //
// operands (i.e. 2 bytes each from 2 registers)                //
// e.g. rs = aaaaaaaa_bbbbbbbb; rt = cccccccc_dddddddd          //
// (signext) ((aaaaaaaa + cccccccc) + (bbbbbbbb + ddddddddd))   //
// will be in rd after the RED operation.                       //
//////////////////////////////////////////////////////////////////

endmodule