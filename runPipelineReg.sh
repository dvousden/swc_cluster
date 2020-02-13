#!/bin/bash
#SBATCH -J pipeline_reg
#SBATCH -N 1
#SBATCH -c 20
#SBATCH -t 0-12:00
#SBATCH -p cpu
#SBATCH --mem-per-cpu=10G
#SBATCH -n 1

#echo $1
stackspath=$1;

# commented out on 07mar19 because got error saying invalid dir supplied
if [ "$stackspath" != "" ] 
	then if [ -d $stackspath ]
	#then stackspath=$1
		then echo "Input directory is $stackspath"
	else
		echo 'Error! Invalid input directory supplied'
		exit 1
	fi
else
	echo "Error! Must supply input directory"
	exit 1
fi


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

srun -n 1 -c 20 -o $slurmdir/pipeline_reg.out -e $slurmdir/pipeline_reg.err /opt/mathworks/R2018a/bin/matlab -nosplash -nodesktop -r "stackspath = '${stackspath}';" < runPipelineReg.m; 
