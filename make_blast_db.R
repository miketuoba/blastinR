#a function to make blast data given the fasta file from within R
#default database type is nucleotide. 
make_blast_db <- function(infile = file.choose(), dbtype = "nucl", outfile = NULL) {
  # Check if output file name is provided
  if (length(outfile) == 0) {
    stop("Output file name must be included.")
  }
  
  result <- system2(
    command = "makeblastdb",
    args = c("-in", infile,
             "-dbtype", dbtype,
             "-out", outfile,
             "-parse_seqids"),
    stdout = TRUE,
    wait = TRUE
  )
  
}