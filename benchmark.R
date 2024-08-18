if (!require(tidyverse)) {
  install.packages("tidyverse", dependencies = TRUE)
  library(tidyverse)
} else {
  library(tidyverse)
}
options(scipen = 999) # avoid scientific notation

# generate different fasta db's and fasta files for query
# this code has been replaced by a Python code to reduce 
# generation time significantly
num_sequences <- c(100000)
sequence_length <- c(2000)
for(seq in num_sequences){
  for(len in sequence_length){
    random_fasta_generator(seq, len, is_db = T)
    random_fasta_generator(seq, len, is_db = F)
  }
}

#-------------------------------Benchmarking Starts-----------------------------#
# Select sizes for the databases and fasta files
num_sequences_db <- c(50000, 100000, 200000, 500000)
sequence_length_db <- c(2000)

num_sequences <- c(5000, 10000, 20000, 50000, 100000, 200000)
sequence_length <- c(2000)

# Generate an empty list for the results
bench <- vector(mode='list', length = length(num_sequences_db) * length(num_sequences) * length(sequence_length_db) * length(sequence_length))
ct <- 1
for (i_db in num_sequences_db){
  for (j_db in sequence_length_db){
    db_name <- paste0("db_", i_db, "_", j_db)
    for (i in num_sequences){
      for (j in sequence_length){
        names(bench)[ct] <- paste0("sequence_", i, "_", j, "_against_", db_name)
        ct <- ct + 1
      }
    }
  }
}


# Use randomly generated sequences to query against randomly generated db's
i <- 1
ncores <- c(1,2,4,8)
for(seq_db in num_sequences_db){
  for(len_db in sequence_length_db){
    dbase_file <- paste0("random_fasta_db_", seq_db, "_", len_db, ".fasta")
    if (!file.exists(paste0("random_fasta_db_", seq_db, "_", len_db, ".ndb"))) {
      print(paste0("database for ", seq_db, "_", len_db, "does not exist. Creating now..."))
      make_blast_db(infile = dbase_file)
      print("database created")
    }
    dbase <- paste0("random_fasta_db_", seq_db, "_", len_db)
    for(seq in num_sequences){
      for(len in sequence_length){
        record <- list()
        # Record the start time
        print(paste0("Benchmarking for ", seq, "_", len, " against database ", seq_db, "_", len_db))
        # print(paste0("Cores = ", 1))
        # start_time <- Sys.time()
        # 
        # blstinr(dbase = dbase, qry = paste0("random_fasta_", seq, "_", len, ".fasta"))
        # 
        # # Record the end time
        # end_time <- Sys.time()
        # 
        # # Calculate the elapsed time
        # elapsed_time_no_par <- end_time - start_time
        # 
        # # Print the elapsed time
        # print(elapsed_time_no_par)
        # 
        # 
        # record <- append(record, as.numeric(elapsed_time_no_par, units = "secs"))
        
        
        for (core in ncores){
          # Record the start time
          print(paste0("Cores = ", core))
          
          start_time <- Sys.time()
          
          run_parallel(dbase = dbase, qry = paste0("random_fasta_", seq, "_", len, ".fasta"), ncores = core)
          
          # Record the end time
          end_time <- Sys.time()
          
          # Calculate the elapsed time
          elapsed_time_par <- end_time - start_time
          
          # Print the elapsed time
          print(elapsed_time_par)
          
          record <- append(record, as.numeric(elapsed_time_par, units = "secs"))
        }
        
        
        # print(paste0("Cores = ", 4))
        # 
        # # Record the start time
        # start_time <- Sys.time()
        # 
        # run_parallel(dbase = dbase, qry = paste0("random_fasta_", seq, "_", len, ".fasta"), ncores = 4)
        # 
        # # Record the end time
        # end_time <- Sys.time()
        # 
        # # Calculate the elapsed time
        # elapsed_time_par <- end_time - start_time
        # 
        # # Print the elapsed time
        # print(elapsed_time_par)
        # 
        # record <- append(record, as.numeric(elapsed_time_par, units = "secs"))
        # 
        # print(paste0("Cores = ", 8))
        # 
        # # Record the start time
        # start_time <- Sys.time()
        # 
        # run_parallel(dbase = dbase, qry = paste0("random_fasta_", seq, "_", len, ".fasta"), ncores = 8)
        # 
        # # Record the end time
        # end_time <- Sys.time()
        # 
        # # Calculate the elapsed time
        # elapsed_time_par <- end_time - start_time
        # 
        # # Print the elapsed time
        # print(elapsed_time_par)
        # 
        # record <- append(record, as.numeric(elapsed_time_par, units = "secs"))
        
        names(record) <- paste0('cores = ', sapply(ncores, c))
        # c('cores = 1', 'cores = 2', 'cores = 4', 'cores = 8')
        
        bench[[i]] <- record
        i <- i + 1
        print(paste0("Benchmarking for ", seq, "_", len, " against database ", seq_db, "_", len_db, " has ended"))
        
      }
    }
  }
}


#---------------------------- Results Interpretation-----------------------------#
# Function to extract data from the nested list
extract_data <- function(nested_list) {
  data <- data.frame()
  for (seq_key in names(nested_list)) {
    seq_info <- strsplit(seq_key, "_")[[1]]
    sequence_size <- seq_info[2]
    db_size <- seq_info[6]
    for (core_key in names(nested_list[[seq_key]])) {
      cores <- as.numeric(gsub("cores = ", "", core_key))
      time <- nested_list[[seq_key]][[core_key]]
      data <- rbind(data, data.frame(
        sequence_size = as.numeric(sequence_size),
        db_size = as.numeric(db_size),
        cores = cores,
        time = time
      ))
    }
  }
  return(data)
}


# Transform nested list to data frame
df <- extract_data(bench)

write.csv(df, file = "results.csv")


#--------------------------Data Visualization------------------------#
library(ggplot2)

# Convert cores to a factor with specified levels
df$cores <- factor(df$cores, levels = c(1, 2, 4, 8))

# Create a plot
image <- ggplot(df, aes(x = cores, y = log2(time), color = as.factor(sequence_size), shape = as.factor(db_size))) +
  geom_point(size = 3) +
  geom_line(aes(group = interaction(sequence_size, db_size))) +
  labs(title = "Running Time (log-transformed) vs Number of Cores",
       x = "Number of Cores/Threads",
       y = "Running Time (seconds in log2)",
       color = "Sequence Size",
       shape = "Database Size") +
  scale_x_discrete(labels = c(1, 2, 4, 8)) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12), # Adjust tick label size
        axis.title.x = element_text(size = 14), # Adjust x-axis title size
        axis.title.y = element_text(size = 14), # Adjust y-axis title size
        legend.title = element_text(size = 12), # Adjust legend title size
        legend.text = element_text(size = 10))  # Adjust legend text size

print(image)
ggsave(filename = "benchmark_image_log2.png", plot = image, width = 10, height = 8, bg = "white")
