#!/usr/bin/env bash
#SBATCH -J slurm_register
#SBATCH -t 0-12:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH -p cpu
#SBATCH --mem=40G
#SBATCH -o /dev/null

# robust options
set -u # crash on undefined variables
set -e # crash on error commands

# define input stack folder and output .mat file path
STACK_PATH="$1"
REGISTER_PATH="$2"

# create a temporary directory for matlab to store jobs for each pool of workers
SLURMDIR="$(pwd)/slurm_logs/pipeline_register-${SLURM_JOB_ID}"
mkdir -p "$SLURMDIR"
echo "SLURM output directory: $SLURMDIR"

# variable containing the matlab script to run
MATLAB_SCRIPT="
pc = parcluster('local');
pc.JobStorageLocation = '$SLURMDIR';
parpool(pc, str2num(getenv('SLURM_CPUS_PER_TASK')), 'IdleTimeout', Inf);

'EDIT REGISTRATION OPTIONS HERE (end each line with a semicolon!)';
options.margins = [0, 60];
options.useparfor = true;
options.chunksize = 10;
options.extract_si_metadata = true;
options.batch_size = 30;  %default is 20
options.maxshift = 15;
options.refchannel = [];
options.verbose = true;


pipeline_register('$REGISTER_PATH', '$STACK_PATH', options);

exit;
"

# job submission
MATLAB_PATH="/opt/mathworks/R2018a/bin/matlab"

srun -o "$SLURMDIR"/matlab_script.out \
     -e "$SLURMDIR"/matlab_script.err \
     "$MATLAB_PATH" -nosplash -nodesktop -r "$(echo $MATLAB_SCRIPT)"
