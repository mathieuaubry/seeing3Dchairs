% This script use Discriminative Elements to select the optimal 3D model
% and viewpoint to align to an images.
%

%% paths to modify
RESULTS_FOLDER='./results';
HTML_FOLDER='./html';
DATA_FOLDER='./DEs';
MODELS_DIR='./rendered_chairs';

addpath('./code');

mkdir(RESULTS_FOLDER);
mkdir(HTML_FOLDER);
mkdir([HTML_FOLDER '/figures']);
DEinit_n100_ms4 ;

image_name='test_image_1.jpg';

%% get 3D chair folder names
load([MODELS_DIR '/all_chair_names.mat'],'folder_names')
N_chairs=length(folder_names);


%% get model for each chair and on each image
%% WARNING: this part should be parralelized or used for less chairs
for chair_id=1:20:N_chairs
    match_DEs_to_image_by_20(DATA_FOLDER,RESULTS_FOLDER,DEparams,chair_id,image_name,folder_names); % compute potential matches for each 3D chair and test image
end


%% get all the models for a given image
get_all_model_function(RESULTS_FOLDER,N_chairs); % concatenate all potential model for a given image




%% perform non-max suppression
nms(RESULTS_FOLDER)



%% generate HTML to visualize results
generate_html(all_models,HTML_FOLDER)