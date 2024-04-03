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