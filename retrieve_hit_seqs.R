#a function to retrieve the hit sequence from blast search results from within R
retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, outfile) {

  output_lines <- character()
  for (query_id in query_ids) {
    
    query_results <- blast_results[blast_results$qseqid == query_id, ]
    hitSeq <- query_results$sseqid[1]
    
    hit_sequence <- system2(
      command = "blastdbcmd",
      args = c("-db", blastdb, "-entry", hitSeq),
      stdout = TRUE,
      wait = TRUE
    )
    output_lines <- c(output_lines, paste(query_id, hitSeq, sep = "__"))
    
    output_lines <- c(output_lines, hit_sequence)
    
  }
  writeLines(output_lines, con = outfile)
  
  return(output_lines)
}