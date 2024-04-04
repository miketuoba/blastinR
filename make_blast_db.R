#a function to make blast data given the fasta file from within R
#default database type is nucleotide. 
make_blast_db <- function(infile = file.choose(), dbtype = "nucl", outfile = NULL) {
  # Check if output file name is provided
  if(is.null(outfile))
  {
    outfile <- gsub("\\.[^.]*$", "", infile)
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
  print(paste("Blast databae was sucssesful. Outfile name: ", outfile))
  
}
