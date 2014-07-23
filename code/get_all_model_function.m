function get_all_model_function(analysis_dir,N_chairs)

%full_models={};
%% extract data for all models

fn=sprintf('%s/models_I.mat',analysis_dir);

confidences=[];
bboxes=zeros(4,0);
chair_ids=[];
view_ids=[];
real_model_ids=[];
for i_chair=1:N_chairs
    mat_name=sprintf('%s/models_chair_%i_I.mat',analysis_dir,i_chair);
    load(mat_name,'all_models');
    for i_view=1:length(all_models)
        
        
        for i_model=1:length(all_models{i_view})
            
            if all_models{i_view}{i_model}.confidence>0.5
                real_model_ids(end+1)=i_model;
                confidences(end+1)=all_models{i_view}{i_model}.confidence+1*min(0,all_models{i_view}{i_model}.N_inliers-5);%-0.05.*i_model_;sum(min(1,model.parts_conf(isfinite(model.parts_conf))))
                bboxes(:,end+1)=all_models{i_view}{i_model}.detection_bbox;%round(model.detection_bbox/2 +0.5);
                chair_ids(end+1)=i_chair;
                view_ids(end+1)=i_view;
            end
        end
    end
end

save(fn,'real_model_ids','confidences','bboxes','chair_ids','view_ids');
