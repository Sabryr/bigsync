#!/bin/bash

# Job name:
#SBATCH --job-name=check_folder_sizes
#SBATCH --nodes=2 --ntasks-per-node=16
#SBATCH --account=staff
#SBATCH --time=3-00:01:00
#SBATCH --mem-per-cpu=3G

source /cluster/bin/jobsetup
module purge   # clear any inherited modules
set -o errexit # exit on errors

location="/projects/cees/in_progress"
module load openmpi.intel/3.1.2

progress="progress.log"
echo $(date) >> "$progress"

mpirun -n 8 analyser.sh "$location"  "$progress"o


