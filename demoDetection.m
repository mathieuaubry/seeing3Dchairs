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




%% perform non-max suppression and evaluate results

all_models={};
all_models.bbox=zeros(0,4);
all_models.scores=[];
all_models.view_id=[];
all_models.chair_id=[];
fid=fopen(sprintf('%s/%s_%s.txt',RESULTS_FOLDER,'confidence','chair'),'w');
N_object_per_image=5;
fn=sprintf('%s/models_I.mat',RESULTS_FOLDER);
load(fn','confidences','bboxes','chair_ids','view_ids');
bboxes_used=zeros(4,0);
[sorted order]=sort(confidences,'descend');
i_file=0;
i_object=0;
I=imfinfo(image_name);

while i_object<N_object_per_image && i_file<length(order)
    i_file=i_file+1;
    model_id=order(i_file);
    chair_id=chair_ids(model_id);
    view_id=view_ids(model_id);
    bbox_detection=bboxes(:,model_id);
    conf=confidences(model_id);
    
    %% real object bbox slightly larger than original object bbox
    extens=0.1;
    sd=bbox_detection(3)-bbox_detection(1);
    bbox_detection(1)=bbox_detection(1)-extens*sd;
    bbox_detection(3)=bbox_detection(3)+extens*sd;
    sd=bbox_detection(4)-bbox_detection(2);
    bbox_detection(2)=bbox_detection(2)-extens*sd;
    bbox_detection(4)=bbox_detection(4)+extens*sd;
    bb1=max(1,min(I.Height,bbox_detection(2)));
    bb2=max(1,min(I.Width,bbox_detection(1)));
    bb3=max(1,min(I.Height,bbox_detection(4)));
    bb4=max(1,min(I.Width,bbox_detection(3)));
    bbox_detection=[bb2 bb1 bb4 bb3]';
    
    % non max suppression
    ov=bboxoverlapval(bbox_detection',bboxes_used');
    if isempty(ov) || max(ov)<0.5
        i_object=i_object+1;
        bboxes_used(:,end+1)=bbox_detection;
        if isempty(ov)
            penal=0;
        else
            penal=max(0,max(ov));
        end
        %
        conf=conf-10*penal;% penalize overlaping bboxes
        
        all_models.bbox=cat(1,all_models.bbox,bbox_detection');
        all_models.scores=cat(1,all_models.scores,conf);
        all_models.view_id=cat(2,all_models.view_id,view_id);
        all_models.chair_id=cat(2,all_models.chair_id,chair_id);
    end
end




%% generate HTML to visualize results

filename=sprintf('%s/index.html',HTML_FOLDER);
html_file=fopen(filename,'w');
title_page='Matches';
title='Matches';
comments='<img src="test_image.jpg" style="height:15em;" /> Top retrieved models after non-max suppression for this image.';
I=im2double(imread(image_name));
imwrite(I,sprintf('%s/test_image.jpg',HTML_FOLDER));
title_cols={'order' 'confidence' 'detection' 'model'};
initiate_html(html_file,title_page,title,comments,title_cols);

[all_models.scores order]= sort(all_models.scores,'descend');
all_models.bbox=all_models.bbox(order,:);
all_models.view_id=all_models.view_id(order);
all_models.chair_id=all_models.chair_id(order);
for i=1:min(5,length(order))
    O=drawBbox(I,all_models.bbox(i,:));
    imwrite(O,sprintf('%s/figures/detection_%i.jpg',HTML_FOLDER,i));
    
    load(sprintf('%s/%s/all_DEs_calib.mat',DATA_FOLDER,folder_names{all_models.chair_id(i)}),'all_DEs');
    O=im2double(imread(all_DEs{all_models.view_id(i)}.view_name));%[MODELS_DIR '/' {all_models.view_id(i)} '/renders/']));
    imwrite(O,sprintf('%s/figures/model_%i.jpg',HTML_FOLDER,i));
    
    color='black';
    fprintf(html_file,'     <tr> \n');
    fprintf(html_file,'      <td align="center" style="color:%s"> %i </td> \n',color,i);
    fprintf(html_file,'      <td align="center" style="color:%s"> %02f </td> \n',color,all_models.scores(i));
    fprintf(html_file,'      <td align="center"> <img src="%s" style="height:15em;" /> </td>\n',sprintf('figures/detection_%i.jpg',i));
    fprintf(html_file,'      <td align="center"> <img src="%s" style="height:15em;" /> </td>\n',sprintf('figures/model_%i.jpg',i));
    fprintf(html_file,'     </tr> \n');
end
