#!/bin/bash

# Job name:
#SBATCH --job-name=megahit
#
# Project:
#SBATCH --account=staff
#
# Wall clock limit:
#SBATCH --time=00:05:00
#
# Max memory usage:
#SBATCH --mem-per-cpu=1G

## Set up job environment:
source /cluster/bin/jobsetup
module purge   # clear any inherited modules
set -o errexit # exit on errors
module load megahit/0_0_3_a

## Copy input files to the work directory:
#cp /usit/abel/u1/sabryr/nobackup/software/megaht/data/readsInterleaved3.fa $SCRATCH

## Make sure the results are copied back to the submit directory (see Work Directory below):
#chkfile megahit_out

## Do some work:
#cd $SCRATCH
#megahit -r readsInterleaved3.fa -o megahit_out 
ls -lh
