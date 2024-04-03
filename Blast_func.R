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
    
    ###hit_sequences[[paste(query_id, hitSeq, sep = "__")]] <- hit_sequence
  }
  ###writeLines(unlist(hit_sequences), con = outfile)

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


  


qry_ids <- unique(blastx$qseqid)
qry_ids
mul_seq <- retrieve_hit_seqs(qry_ids, blastx, "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\spike_protein_seqs_SARS", 
                             outfile = "mul_hit_seq.txt")
print(mul_seq)

qry_id1 <- blastn$qseqid[1]
 
hit_seq <- retrieve_hit_seqs(qry_id1, blastn, "C:\\Users\\sarah\\OneDrive\\Documents\\Arch2", outfile = "Arc_hitSeq.txt")
hit_seq

make_blast_db(infile = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\dnaSeq.fasta", outfile = "C:\\Users\\sarah\\OneDrive\\Documents\\blastinR\\dnaSeq")
make_blast_db(infile = "prot.fasta", dbtype = "prot", outfile = "prot")
make_blast_db(infile = "aa.fasta", dbtype = "prot", outfile = "aa")

v1 = Sys.which("blastn")
v = Sys.which("blastj")
f = Sys.which("makeblastdb")
f
v
nchar(v)
nchar(v1)
