pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals

template Multiplier3 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal input c;
   signal mult1Box; // The mult1Box will hold first piece of multiplication
   signal output d;  

   // Constraints.  
   mult1Box <== a * b; // Computing first piece of multiplication to conform under the circom restrictions.
   d <== mult1Box * c; // Computing full multiplication 
}

component main = Multiplier3();