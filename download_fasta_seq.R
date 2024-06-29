#8:
library(seqinr)
ripos <- seqinr::choosebank()

bank <- seqinr::choosebank(bank=ripos[str_which(ripos, "16s")], infobank = T)

bank
bacteria <- seqinr::query( listname = "Bacteria", query="TID=2")
bacteria
bacteria2 <- unlist(seqinr::getSequence(bacteria$req[1:2000],as.string = T))

#9:
my_fave_bac_set <- DNAStringSet(bacteria2)
names(my_fave_bac_set) <- unlist(lapply(bacteria$req[1:2000], '[[',1))
my_fave_bac_set
my_fave_bac_set_rc <- reverseComplement(my_fave_bac_set)
my_fave_bac_set_rc

#10: 
Longest_seq <- max(width(my_fave_bac_set))
Longest_seq

#11:
library(Biostrings)
writeXStringSet(my_fave_bac_set,"test_db.fa")
