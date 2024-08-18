#!/bin/bash
#set the wall time, hh:mm:ss
#SBATCH --time=3:00:00
#SBATCH --mem=256G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=mikesiwen.wu@gmail.com
#SBATCH --job-name=Mike_blastinr_benchmark
#SBATCH --output=Mike_blastinr_benchmark_output0709.txt
#SBATCH --account=def-idohatam
#SBATCH --cpus-per-task=16

#Load module
module load r/4.4.0

#virtual environment
#source ~/cactus*/cactus_env/bin/activate

#job
#Two R scripts with the functions needed
Rscript run_parallel.R
Rscript Blast_func.R

#Pre-setting for running in parallel
export R_LIBS=~/local/R_libs/

R CMD BATCH --no-save --no-restore benchmark.R