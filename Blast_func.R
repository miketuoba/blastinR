#a function to run the different blast serches from within R
blstinr <- function(btype = "blastn", dbase,qry,numt=1,...){
  
  colnames <- c("qseqid","sseqid","pident","length","mismatch","gapopen","qstart",
                "qend","sstart","send","evalue","bitscore")
  
  bt <- Sys.which(paste(btype))
  
  if(nchar(bt) == 0){
    stop(paste("Can't find",btype,
               "on the computer, make sure balast suite is properly installed",
               sep = " "))} else{if(nchar(bt)>0){
                 
                 bl_out <-system2(command = paste(bt), 
                                  args = c("-db", paste(dbase),
                                           "-query", paste(qry),
                                           "-outfmt", "6",
                                           "-num_threads", paste(numt)), 
                                  wait = TRUE, stdout = TRUE) %>% 
                   as_tibble() %>% 
                   separate(col = 1, into = colnames,sep = "\t",
                            convert = TRUE) %>% 
                   mutate(Range = send - sstart)}
                
               }  
  return(bl_out)
}


#a function to retrieve the hit sequence from blast search results from within R
retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, outfile) 
{
  ###hit_sequences <- list()
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
  #return(hit_sequences)
}

#a function to make blast data given the fasta file from within R
make_blast_db <- function(infile, dbtype = "nucl", outfile = NULL) 
{
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


  
