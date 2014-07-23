function match_DEs_to_image_by_20(DATA_FOLDER,RESULTS_FOLDER,DEparams,model_id_,image_name,folder_names)

%% compute hog pyramid on the input image
I=imread(image_name);
I=im2double(I);
if size(I,3)==1
    I = repmat(I,[1 1 3]);
end
[Ihogs_pyramid Iscales_pyramid]=hog_pyramid(I,DEparams);


%% compute a vector of HOGs
hog_size=DEparams.hog_size;
hogs_boxes=cell(1,length(Ihogs_pyramid));
hogs_sizes=cell(1,length(Ihogs_pyramid));
bboxes=cell(1,length(Ihogs_pyramid));
for scale_index=1:length(Ihogs_pyramid)
    hogs=Ihogs_pyramid{scale_index};
    hogs_sizes{scale_index}=size(hogs);
    hogs_size=hogs_sizes{scale_index};
    [x,y]=meshgrid(2:hogs_size(1)-hog_size(1)+1-1,2:hogs_size(2)-hog_size(2)+1-1);
    bboxes{scale_index}=[x(:) y(:) x(:)+hog_size(1)-1 y(:)+hog_size(2)-1];
    bbox=bboxes{scale_index};
    n=size(bbox,1);
    hogs_box=zeros(hog_size(1),hog_size(2),hogs_size(3),n);
    for i=1:size(bbox,1)
        hogs_box(:,:,:,i)=(hogs(bbox(i,1):bbox(i,1)+hog_size(1)-1,bbox(i,2):bbox(i,2)+hog_size(2)-1,:));
    end
    hogs_boxes{scale_index}=reshape(hogs_box,hog_size(1)*hog_size(2)*hog_size(3),n)';
end



for model_id=model_id_:min(model_id_+19,length(folder_names))
    
    
    %% detect DEs in I
        
        load(sprintf('%s/%s/all_DEs_calib.mat',DATA_FOLDER,folder_names{model_id}),'all_DEs');
        
        responses=response_from_hogs(hogs_boxes,hogs_sizes,all_DEs,DEparams);
        
        
        all_models=get_model_from_responses(responses,all_DEs,DEparams);
        save(sprintf('%s/models_chair_%i_I.mat',RESULTS_FOLDER,model_id),'all_models');
   
    
end


