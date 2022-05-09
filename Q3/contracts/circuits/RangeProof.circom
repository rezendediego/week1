pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);

    // [assignment] insert your code here
    // Check range at lower bound
    // if the number to be proved "in" is greater than the lower bound range[0]
    // it is inside lower bound range therefore returns 1
    high.in[0] <== in;
    high.in[1] <== range[0];

    // Check range at upper bound
    // if the number to be proved "in" is less than the upper bound range[1]
    // it is inside upper bound range therefore returns 1
    low.in[0] <== in;
    low.in[1] <== range[1];

    
    // If the number is inside the range out will receive 1, otherwise receives 0
    out <== low.out * high.out;

}