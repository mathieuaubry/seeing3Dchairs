function [responses_]=response_from_hogs(hogs_boxes,hogs_sizes,all_DEs,DEparams)
% compute all the responses of hogs_boxes to all_DEs

hog_size=size(DEparams.mu);

responses_=cell(1,length(all_DEs));
for view_id=1:length(all_DEs)
    
    N_elements=length(all_DEs{view_id}.bs);
    responses=cell(N_elements,length(hogs_boxes));

    responses_{view_id}=responses;
end
for scale_index=1:length(hogs_boxes)
    hogs_box=hogs_boxes{scale_index};
    hogs_size=hogs_sizes{scale_index};
    for view_id=1:length(all_DEs)
        b=all_DEs{view_id}.bs;
        N_elements=length(all_DEs{view_id}.bs);
        values=hogs_box*all_DEs{view_id}.ws';
        if(isempty(values))
            return;
        else
            for i_DE=1:N_elements
                  responses_{view_id}{i_DE,scale_index}=reshape((values(:,i_DE)),[hogs_size(2)-hog_size(2)-1 hogs_size(1)-hog_size(1)-1 ])'+repmat(b(i_DE),[hogs_size(1)-hog_size(1)-1 hogs_size(2)-hog_size(2)-1]);
            end
        end
     end
end
