#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom using PLONK below

# Answer of diegorezende#2184

cd contracts/circuits

mkdir Multiplier3_plonk

which 
if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

# compile circuit
circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3_plonk
snarkjs r1cs info Multiplier3_plonk/Multiplier3.r1cs


echo 'Creating input.json...'

# Check if file input.json exists, otherwise create 
which 
if [ -f Multiplier3_plonk/Multiplier3_js/input.json ]; then
    echo "input.json already exists. Skipping."
else
    echo '{"a": 3, "b": 11, "c": 13}' > Multiplier3_plonk/Multiplier3_js/input.json 
    echo '<<< input.json created >>>'   
fi

echo 'Creating witness...'

# Create Witness
cd Multiplier3_plonk/Multiplier3_js
node generate_witness.js Multiplier3.wasm input.json ../witness.wtns
ls
ls ..
cd ../..
echo '<<< witness created >>>'


echo 'Creating PLONK proof system...'

# Set up PLONK proof system
snarkjs plonk setup Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_final.zkey # Add circuit_final.zkey since PLONK does not need Phase 2

# Export the zkey
echo 'Export the zkey...'
snarkjs zkey export verificationkey Multiplier3_plonk/circuit_final.zkey Multiplier3_plonk/verification_key.json
head Multiplier3_plonk/verification_key.json


echo 'Creating the proof...'

# Create the proof
snarkjs plonk prove Multiplier3_plonk/circuit_final.zkey Multiplier3_plonk/witness.wtns Multiplier3_plonk/proof.json Multiplier3_plonk/public.json
head Multiplier3_plonk/proof.json
head Multiplier3_plonk/public.json


echo 'Verifying the proof...'

# Verify the Proof
snarkjs plonk verify Multiplier3_plonk/verification_key.json Multiplier3_plonk/public.json Multiplier3_plonk/proof.json


echo 'Generating solidity contract...'

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3_plonk/circuit_final.zkey ../Multiplier3_plonkVerifier.sol

echo '<<< solidity contract created >>>'
cd ../..