#a function to make blast data given the fasta file from within R
make_blast_db <- function(infile, dbtype = "nucl", outfile = NULL) {
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