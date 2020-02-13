% Description
% runs matlab pipeline_register on cluster 

if ~exist('regpath')
	error('Error: Must provide pipeline_register file');
end

fprintf('Input file is: %s',regpath);
% build save path from input stacks paths
%savedir_path = strrep(stackspath, 'raw_data', 'processed_data');

%if ~exist(savedir_path)
%	mkdir(savedir_path);
%end

%resultspaths = fullfile(savedir_path, '/processed_register_with_dftagg.mat');
%fprintf('New output file: %s',resultspaths);

% Create a local cluster object
pc = parcluster('local');

% explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
pc.JobStorageLocation = strcat(pwd,'/slurm', getenv('SLURM_JOB_ID'))
fprintf('JobStorageLocation: %s',pc.JobStorageLocation)

%% Registration
parpool(pc, str2num(getenv('SLURM_CPUS_PER_TASK')),'IdleTimeout',Inf);


% options used for registration (see 'pipeline_register' documentation)
%options.extract_si_metadata = false;
%options.n_batches = 60;  %default is 15
%options.batch_size = 30;  %default is 20
%options.margins = [0, 60]; %default is 60
%options.maxshift = 15;
%options.refchannel = [];
%options.win_size = 200;
%options.verbose = true;
%options.chunksize = 20; %default is 10
%options.useparfor = true;


% register/average each stack in turn
%fprintf('Registering stack within day started %s \n',datestr(now,'HH:MM:SS.FFF'));
%stacks = pipeline_register(resultspaths, stackspath, options);
%fprintf('### registration complete at %s ### \n',datestr(now,'HH:MM:SS.FFF'));

% Load results
% load registration results, assuming the first 2 passes have been computed with pipeline_register
results = load(regpath);
maxshift = 70;
fprintf('here');
results
% reload the stacks
fprintf('Loading stacks...');
stacks = stacksload(results.stackspath);

stackspath = results.stackspath{1};
fprintf('stackpath is %s',stackspath);

% build save path from input stacks paths
savedir_path = strrep(stackspath, 'raw_data', 'processed_data');

if ~exist(savedir_path)
	mkdir(savedir_path);
end

resultspath = fullfile(savedir_path, '/processed_register_with_dftagg.mat');
fprintf('New output file: %s',resultspath);

% Run registration
xyshifts_70_dftagg = stacksregister_dftagg(stacks, ...
    'maxshift', maxshift, ...
    'margins', results.opts.margins);

xyshifts_orig = results.xyshifts;
xyshifts = {xyshifts_70_dftagg};

% Copy old file
copyfile(regpath,resultspath);
save(resultspath,'xyshifts_orig','xyshifts','-append');

delete(gcp);
exit;

