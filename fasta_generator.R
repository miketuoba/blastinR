### This file has been replaced by a python script due to low efficiency

# Load necessary library
library(Biostrings)

# Function to generate a random DNA sequence
generate_random_dna_sequence <- function(length) {
  bases <- c("A", "T", "C", "G")
  paste(sample(bases, length, replace = TRUE), collapse = "")
}

# Function to save sequences to a FASTA file
save_to_fasta <- function(sequences, file_name) {
  fasta_content <- ""
  for (i in 1:length(sequences)) {
    fasta_content <- paste(fasta_content, 
                           paste0(">sequence_", i), 
                           sequences[[i]], 
                           sep = "\n")
  }
  write(fasta_content, file = file_name)
}

random_fasta_generator <- function(num_sequences, sequence_length, is_db = F){
  # Generate a list of random DNA sequences
  set.seed(sample(1:1000, 1))
  sequences <- lapply(1:num_sequences, function(x) generate_random_dna_sequence(sequence_length))
  
  if (is_db){
    # Save sequences to a FASTA file
    file_name <- paste0("random_fasta_db_", num_sequences, "_", sequence_length,".fasta")
  }else{
    file_name <- paste0("random_fasta_", num_sequences, "_", sequence_length,".fasta")
  }
    save_to_fasta(sequences, file_name)
    
    cat("FASTA file saved as", file_name)
}
