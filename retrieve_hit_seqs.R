# a function to retrieve the hit sequence from blast search results from within R
# Parameters: 
# query_ids: a vector of query IDs
# blast_results: a data frame of blast search results
# blastdb: blast database file path/name
# outfile: output file name
# Returns: 
# Hit sequences as a vector of characters
retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, outfile) {
  
  # Initialize a character vector to store the output
  output_lines <- character()
  
  # Loop through each query ID
  for (query_id in query_ids) {
    
    # Subset the blast results for the current query 
    query_results <- blast_results[blast_results$qseqid == query_id, ]
    
    # Extract the hit sequence ID assuming it is the first one in the result
    hitSeq <- query_results$sseqid[1]
    
    # Use blastdbcmd to retrieve the hit sequence
    hit_sequence <- system2(
      command = "blastdbcmd",
      args = c("-db", blastdb, "-entry", hitSeq),
      stdout = TRUE,
      wait = TRUE
    )
    
    # Append query ID and hit sequence ID to output_lines
    output_lines <- c(output_lines, paste(query_id, hitSeq, sep = "__"))
    
    # Append hit sequence to output_lines
    output_lines <- c(output_lines, hit_sequence)
    
  }
  
  # Write output_lines to a text file
  writeLines(output_lines, con = outfile)
  
  # Return the output lines
  return(output_lines)
}