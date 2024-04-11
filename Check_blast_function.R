check_blast <- function(blpath = "makeblastdb")
{
  bl <- Sys.which(paste(blpath))
  
  if(nchar(bl) == 0){
    stop(paste("Can't find blast on the computer or the path can't be found, 
               make sure blast suite is properly installed"))} 
  else{if(nchar(bl)>0)
    print("Blast is installed correctly and the path can be found.")
    return(TRUE)
  }
}


