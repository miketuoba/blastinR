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

blastn <- blstinr (dbase = "C:\\Users\\sarah\\OneDrive\\Documents\\Arch2",
                   qry = "C:\\Users\\sarah\\OneDrive\\Documents\\ArchQuery.fa")
blastn

blastp <- blstinr(btype = "blastp",
                    dbase = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hbb_aa",
                    qry = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hba_aa.fasta")
blastp

blastx <- blstinr(btype = "blastx",
                    dbase = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\spike_protein_seqs_SARS",
                    qry = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\genomes_Seqs_SARS.fasta")
blastx

tblastx <- blstinr(btype = "tblastx",
                    dbase = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hbb_n",
                    qry = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hba_n.fasta")
tblastx

tblastn <- blstinr(btype = "tblastn",
                    dbase = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hbb_n",
                    qry = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\hbb_aa.fasta")
tblastn



#a function to retrieve the hit sequence from blast search results from within R
retrieve_hit_seqs <- function(query_ids, blast_results, blastdb) {
  hit_sequences <- list()
  
  for (query_id in query_ids) {

    query_results <- blast_results[blast_results$qseqid == query_id, ]
    hitSeq <- query_results$sseqid[1]
    
    hit_sequence <- system2(
      command = "blastdbcmd",
      args = c("-db", blastdb, "-entry", hitSeq),
      stdout = TRUE,
      wait = TRUE
    )
    
    hit_sequences[[paste(query_id, hitSeq, sep = "_")]] <- hit_sequence
  }
  
  
  return(hit_sequences)
}


qry_ids <- unique(blastx$qseqid)
qry_ids
mul_seq <- retrieve_hit_seqs(qry_ids, blastx, "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\spike_protein_seqs_SARS")
print(mul_seq)

qry_id1 <- blastn$qseqid[1]
 
hit_seq <- retrieve_hit_seqs(qry_id1, blastn, "C:\\Users\\sarah\\OneDrive\\Documents\\Arch2" )
hit_seq
