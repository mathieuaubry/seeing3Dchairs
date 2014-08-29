
function all_models=get_model_from_responses(all_responses,all_DEs,DEparams)
for view_id=1:length(all_DEs)
    DEs=all_DEs{view_id};
    responses=all_responses{view_id};
    models={};
    thr_confidence_root=0;
    thr_size_root=0;
    N_elements=size(responses,1);
    N_levels=size(responses,2);
    sbin=DEparams.sbin;
    model_count=0;
    
    for i_root_DE=1:N_elements
        root_size=DEs.bboxes(i_root_DE,3)-DEs.bboxes(i_root_DE,1)+1;%DE_root.x_max-DE_root.x_min+1;
        if root_size<thr_size_root;
            continue;
        end
        
        for i_root_level=1:N_levels;
            root_scale=2^(-(i_root_level-1)/DEparams.levels_per_octave);
            root_orig_size=DEs.bboxes(i_root_DE,3)-DEs.bboxes(i_root_DE,1)+1;
            root_size=DEparams.hog_size(2)*sbin/root_scale;
            if isempty(responses{i_root_DE,i_root_level})
                break;
            end
            is_valid_root=true;
            
            root_level_mod=responses{i_root_DE,i_root_level};
            while is_valid_root
                [root_value root_location]=max(root_level_mod(:));
                if root_value>thr_confidence_root
                    [row col]=ind2sub([size(responses{i_root_DE,i_root_level},1) size(responses{i_root_DE,i_root_level},2)], root_location);
                    for dx=-DEparams.jit:DEparams.jit
                        for dy=-DEparams.jit:DEparams.jit
                            if row+dy>0 && col+dx>0 && row+dy<=size(responses{i_root_DE,i_root_level},1) && col+dx<=size(responses{i_root_DE,i_root_level},2)
                                root_level_mod(row+dy,col+dx)=NaN;
                            end
                        end
                    end
                    row_root=(row)*sbin/root_scale+1;
                    col_root=(col)*sbin/root_scale+1;
                    model_count=model_count+1;
                    parts_conf=zeros(N_elements,1);
                    parts_flag=zeros(N_elements,1);
                    for i_part=1:N_elements
                        part_orig_size=DEs.bboxes(i_part,3)-DEs.bboxes(i_part,1)+1;
                        rel_size=part_orig_size/root_orig_size;
                        rel_level=log(rel_size)*DEparams.levels_per_octave/log(2);
                        part_level=round(i_root_level+rel_level);
                        if part_level<1 || part_level>N_levels || isempty(responses{i_part,part_level})%part_level>N_levels-1
                            parts_conf(i_part)=NaN;
                            parts_flag(i_part)=-1;
                            continue;
                        end
                        row_part=row_root+(DEs.bboxes(i_part,1)-DEs.bboxes(i_root_DE,1))*root_size/root_orig_size;%row_root+(DE_part.y_min-DE_root.y_min)*root_size/root_orig_size;
                        col_part=col_root+(DEs.bboxes(i_part,2)-DEs.bboxes(i_root_DE,2))*root_size/root_orig_size;%col_root+(DE_part.x_min-DE_root.x_min)*root_size/root_orig_size;
                        part_scale=2^((-(part_level-1)/DEparams.levels_per_octave));
                        row_part_level=round(((row_part-1)/sbin)*part_scale+1)-1;%
                        col_part_level=round(((col_part-1)/sbin)*part_scale+1)-1;%
                        
                        l_size=size(responses{i_part,part_level});
                        py_min=min(max(1,row_part_level-DEparams.jit),l_size(1));
                        py_max=min(max(1,row_part_level+DEparams.jit),l_size(1));
                        px_min=min(max(1,col_part_level-DEparams.jit),l_size(2));
                        px_max=min(max(1,col_part_level+DEparams.jit),l_size(2));
                        responses_part=responses{i_part,part_level}(py_min:py_max,px_min:px_max);
                        if isempty(responses_part)
                            parts_flag(i_part)=-1;
                            parts_conf(i_part)= -Inf;
                        elseif size(responses_part,1)<2*DEparams.jit+1 || size(responses_part,2)<2*DEparams.jit+1
                            parts_flag(i_part)=0;
                            parts_conf(i_part)= max(responses_part(:));
                        else
                            parts_flag(i_part)=1;
                            parts_conf(i_part)= max(responses_part(:));
                        end
                        
                    end
                    bbox_y_min=row_root+(DEs.object_bbox(1)-DEs.bboxes(i_root_DE,1))*root_size/root_orig_size;
                    bbox_y_max=row_root+(DEs.object_bbox(3)-DEs.bboxes(i_root_DE,1))*root_size/root_orig_size;
                    bbox_x_min=col_root+(DEs.object_bbox(2)-DEs.bboxes(i_root_DE,2))*root_size/root_orig_size;
                    bbox_x_max=col_root+(DEs.object_bbox(4)-DEs.bboxes(i_root_DE,2))*root_size/root_orig_size;
                    models{model_count}.detection_bbox=[bbox_x_min bbox_y_min bbox_x_max bbox_y_max];
                    models{model_count}.confidence=sum(parts_conf(parts_flag==1))+sum(max(0,parts_conf(parts_flag==0)));%sum(parts_conf>0);%
                    models{model_count}.N_inliers=sum(parts_conf>0);%
                else
                    is_valid_root=false;
                end
            end
        end
    end
    
    all_models{view_id}=models;
end