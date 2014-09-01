function get_DEs_chair_by_K(folder_names,folder_id_,content_name,MODELS_DIR,RESULTS_FOLDER,DEparams,K)
  hogs_name='./negative_hogs.mat';
        h=load(hogs_name);
       
for folder_id=folder_id_:min(folder_id_+K-1,length(folder_names))
%try
%    load(sprintf('%s/%s/all_DEs_calib.mat',RESULTS_FOLDER,folder_names{folder_id}));
%catch err
    %% get the names for the given orientation
    N_views=length(content_name);
    
    %% loop on all models
    all_DEs={};
    for view_id=1:N_views
        
        %% get uncalibrated DEs
        view=(imread([ MODELS_DIR '/' folder_names{folder_id} '/renders/' content_name{view_id}]));
        DEs=DEs_from_image(view,DEparams);
        
        
        %% calibration
       results=h.neg_hogs*single(DEs.ws)';
        results=sort(results,1,'ascend');
        s1=results(round(size(results,1)*0.9999),:);
        
        s2=DEs.ws*DEparams.mu(:);
        DEs.bs=zeros(1,size(DEs.ws,1));
        
        for i=1:size(DEs.ws,1);
            a=1/(s1(i)-s2(i));
            b=-a*s2(i)-1;
            DEs.ws(i,:)=a*DEs.ws(i,:);
            DEs.bs(i)=b;
        end
        
        %% add other infos to DEs
        view=rgb2gray(im2double(view));
        [row col]=find(view<0.95);
        xmin=min(col);
        xmax=max(col);
        ymin=min(row);
        ymax=max(row);
        
        DEs.object_bbox=[ymin xmin ymax xmax];
        %        DEs.theta_id=theta_id;
        %       DEs.phi_id=phi_id;
        DEs.view_id=view_id;
        DEs.view_id=folder_id;
        DEs.view_name=[ MODELS_DIR '/' folder_names{folder_id} '/renders/' content_name{view_id}];
        
        
        
        all_DEs{end+1}=DEs;
    %end
    end
    mkdir(sprintf('%s/%s',RESULTS_FOLDER,folder_names{folder_id}))
    save(sprintf('%s/%s/all_DEs_calib.mat',RESULTS_FOLDER,folder_names{folder_id}),'all_DEs');
end
