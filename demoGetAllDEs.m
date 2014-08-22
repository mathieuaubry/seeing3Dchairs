% This script allows to compute the discriminative elements from the 3D
% views. It need to be runned only once.
% Alternatively, you can use the discriminative elements we will release on
% our website


%% folders definitions (yu may want to modify themo)
MODELS_DIR='./rendered_chairs';
DE_DIR='./DEs';
mkdir(DE_DIR)
addpath('./code');
DEinit_n100_ms4;

load([MODELS_DIR '/all_chair_names.mat'],'folder_names','instance_names')
N_chairs=length(folder_names);

tic
%% WARNING: this part should be parallelized or used for less chair models
%% (~10 minutes per model)
for chair_id=1:20:N_chairs
        mkdir(sprintf('%s/%s',DE_DIR,folder_names{chair_id}));
        get_DEs_chair(folder_names,chair_id,instance_names,MODELS_DIR,DE_DIR,DEparams);
end
toc




   
  

