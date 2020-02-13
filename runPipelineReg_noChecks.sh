#!/bin/bash
#SBATCH -J 11jan19
#SBATCH -N 1
#SBATCH -c 20
#SBATCH -t 0-12:00
#SBATCH -p cpu
#SBATCH --mem-per-cpu=10G
#SBATCH -n 1

#echo $1
stackspath=$1;

if [ "$stackspath" != "" ] 
	then echo "Input directory is $stackspath"
else
	echo "Error! Must supply input directory"
	exit 1
fi

# Create a temporary directory
slurmdir=`pwd`/slurm${SLURM_JOB_ID}
mkdir -p $slurmdir
echo "SLURM output directory: $slurmdir"

# Run pipeline reg
srun -n 1 -c 20 -o $slurmdir/pipeline_reg.out -e $slurmdir/pipeline_reg.err /mnt/glusterfs/apps/mathworks/R2018a/bin/matlab -nosplash -nodesktop -r "stackspath = '${stackspath}';" < runPipelineReg.m; 

