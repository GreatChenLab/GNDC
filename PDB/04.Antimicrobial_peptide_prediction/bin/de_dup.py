#!/usr/bin/python3
import sys
from collections import OrderedDict

def deduplicate_fasta(input_file, output_file):
    sequences = OrderedDict()
    
    with open(input_file, 'r') as infile:
        seq_id = None
        seq = []
        
        for line in infile:
            line = line.strip()
            if line.startswith('>'):
                if seq_id and seq:
                    seq_str = ''.join(seq)
                    if seq_str not in sequences:
                        sequences[seq_str] = seq_id
                seq_id = line  # Store the sequence ID
                seq = []  # Reset sequence
            else:
                seq.append(line)
        
        # Process the last sequence
        if seq_id and seq:
            seq_str = ''.join(seq)
            if seq_str not in sequences:
                sequences[seq_str] = seq_id
    
    with open(output_file, 'w') as outfile:
        for seq, seq_id in sequences.items():
            outfile.write(f"{seq_id}\n{seq}\n")

if len(sys.argv) == 3:
    input_fasta = sys.argv[1]
    output_fasta = sys.argv[2]
    deduplicate_fasta(input_fasta, output_fasta)
else:
    print("Usage:python3 %s input.fasta output.fasta\n" % sys.argv[0])

