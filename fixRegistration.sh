#!/bin/bash
#SBATCH -J fix_registration
#SBATCH -N 1
#SBATCH -c 20
#SBATCH -t 0-12:00
#SBATCH -p cpu
#SBATCH --mem-per-cpu=8G
#SBATCH -n 1

#echo $1
regpath=$1;

# commented out on 07mar19 because got error saying invalid dir supplied
#if [ "$regpath" != "" ] 
#	then if [ -d $stackspath ]
#	#then stackspath=$1
#		then echo "Input dir is $stackspath"
#	else
#		echo 'Error! No input dir supplied'
#		exit 1
#	fi
#else
#	echo "Error! Must supply input file"
#	exit 1
#fi

#TODO add in error check for regpath


#if [ "$stackspath" != "" ] 
		#then stackspath=$1
#	then echo "Input directory is $stackspath"
#else
#	echo "Error! Must supply input directory"
#	exit 1
#fi

# Create a temporary directory
slurmdir=`pwd`/slurm${SLURM_JOB_ID}
mkdir -p $slurmdir
echo "SLURM output directory: $slurmdir"

# Run pipeline reg
# srun -n 1 -c 20 -o $slurmdir/pipeline_reg.out -e $slurmdir/pipeline_reg.err /mnt/glusterfs/apps/mathworks/R2018a/bin/matlab -nosplash -nodesktop -r "stackspath = '${stackspath}';" < runPipelineReg.m; 

srun -n 1 -c 20 -o $slurmdir/fix_registration.out -e $slurmdir/fix_registration.err /opt/mathworks/R2018a/bin/matlab -nosplash -nodesktop -r "regpath = '${regpath}';" < fixRegistration.m; 
