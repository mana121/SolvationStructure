#!/bin/bash
#SBATCH -J lammps
#SBATCH --output=%x.%j.out # %x.%j expands to slurm JobName.JobID
#SBATCH --error=%x.%j.err # prints the error message
#SBATCH --partition=general 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --mem-per-cpu=4000M # Maximum allowable mempry per CPU 4G
#SBATCH --qos=low
#SBATCH --account=ddlab # Replace PI_ucid which the NJIT UCID of PI
#SBATCH --time=71:59:59  # D-HH:MM:SS

###############################################
#
# Purge and load modules needed for run
#
################################################
module purge
module load wulver # Load slurm, easybuild
module load foss/2021b LAMMPS

srun -n $SLURM_NTASKS lmp -in in.lmp