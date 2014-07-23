function [I1,I2]=drawModel(I1,I2,model,DEs)

I1=im2double(I1);
I2=im2double(I2);
cm=jet(100);
for i_part=1:length(model.parts_conf)
   % try
        if model.parts_flag(i_part)==1
            I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%[0 0 255]);
        elseif model.parts_flag(i_part)==0
            %try
            I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%[0 255 0]);
            %end
        end
        
        if ~isempty(I1)
            if model.parts_flag(i_part)==1
                bbox=[DEs{i_part}.x_min DEs{i_part}.y_min DEs{i_part}.x_max DEs{i_part}.y_max];
                I1=drawBbox(I1,bbox,cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[0 0 255]);
            elseif model.parts_flag(i_part)==0
                bbox=[DEs{i_part}.x_min DEs{i_part}.y_min DEs{i_part}.x_max DEs{i_part}.y_max];
                I1=drawBbox(I1,bbox,cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[0 255 0]);
            end
        end
   % end
end

i_part=model.root_id;
if model.parts_flag(i_part)==1
    I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[255 0 0 ]);
elseif model.parts_flag(i_part)==0
            try
    I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[255 0 0]);
            end
end

if ~isempty(I1)
   % try
    if model.parts_flag(i_part)==1
        bbox=[DEs{i_part}.x_min DEs{i_part}.y_min DEs{i_part}.x_max DEs{i_part}.y_max];
        I1=drawBbox(I1,bbox,cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[255 0 0 ]);
    elseif model.parts_flag(i_part)==0
        bbox=[DEs{i_part}.x_min DEs{i_part}.y_min DEs{i_part}.x_max DEs{i_part}.y_max];
        I1=drawBbox(I1,bbox,cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%,[255 0 0]);
    end
   % end
end
end