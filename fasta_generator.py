import random
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO

def generate_random_dna_sequence(length):
    bases = ["A", "T", "C", "G"]
    return ''.join(random.choices(bases, k=length))

def save_to_fasta(sequences, file_name):
    fasta_sequences = []
    for i, seq in enumerate(sequences):
        record = SeqRecord(Seq(seq), id=f"sequence_{i+1}", description="")
        fasta_sequences.append(record)
    SeqIO.write(fasta_sequences, file_name, "fasta")

def random_fasta_generator(num_sequences, sequence_length, is_db=False):
    # Generate a list of random DNA sequences
    random.seed(random.randint(1, 1000))
    sequences = [generate_random_dna_sequence(sequence_length) for _ in range(num_sequences)]

    if is_db:
        file_name = f"random_fasta_db_{num_sequences}_{sequence_length}.fasta"
    else:
        file_name = f"random_fasta_{num_sequences}_{sequence_length}.fasta"
    
    save_to_fasta(sequences, file_name)
    print(f"FASTA file saved as {file_name}")

# Generate different fasta db's and fasta files for query
num_sequences_list = [10000, 20000, 50000, 100000]
sequence_variations = 5
for num_sequences in num_sequences_list:
    for sequence_length in range(sequence_variations):
        random_fasta_generator(num_sequences, random.randint(1000, 5000), is_db=True)
        random_fasta_generator(num_sequences, random.randint(1000, 5000), is_db=False)
