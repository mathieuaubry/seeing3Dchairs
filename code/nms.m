function [all_models]=nms(RESULTS_FOLDER,image_name)
% perform non-max suppression

all_models={};
all_models.bbox=zeros(0,4);
all_models.scores=[];
all_models.view_id=[];
all_models.chair_id=[];
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