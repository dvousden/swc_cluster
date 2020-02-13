#!/bin/bash

#SBATCH -J pipeline_reg
#SBATCH -N 1
#SBATCH -c 20
#SBATCH -t 0-12:00
#SBATCH -p cpu
#SBATCH --mem-per-cpu=10G
#SBATCH -n 1


if [ "$1" != "" ] 
	then if [ -d $1 ]
		then stackspath=$1
		echo "Input directory is $stackspath"
	else 
		raise error "Invalid input directory supplied"
	fi
else
	raise error "Must supply input directory"
fi

# Create a temporary directory
slurmdir=`pwd`/slurm${SLURM_JOB_ID}
mkdir -p $slurmdir
echo "SLURM output directory: $slurmdir"

# Run pipeline reg
srun -n 1 -c 20 -o $slurmdir/pipeline_reg.out -e $slurmdir/pipeline_reg.err /mnt/glusterfs/apps/mathworks/R2018a/bin/matlab -nosplash -nodesktop -r "stackspath = '${stackspath}';" < runPipelineReg.m; 


