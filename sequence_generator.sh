#!/bin/bash
#set the wall time, hh:mm:ss
#SBATCH --time=2:00:00
#SBATCH --mem=256G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=mikesiwen.wu@gmail.com
#SBATCH --job-name=Mike_blastinr_sequence_generator
#SBATCH --output=Mike_blastinr_sequence_generator_output0704.txt
#SBATCH --account=def-idohatam
#SBATCH --cpus-per-task=8

#Load module
module load python

#virtual environment
source ENV/bin/activate

#install package
pip install biopython --no-index

#job
python fasta_generator.py