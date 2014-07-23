function [I2]=drawPointModel(I2,parts_bbox,parts_conf)
model={};
model.parts_conf=parts_conf;
model.parts_bbox=(parts_bbox+parts_bbox([3 4 1 2],:))./2;
model.parts_bbox([2 1 4 3],:);
I1=im2double(I2);
cm=jet(100);
for i_part=1:length(model.parts_conf)
   % try
       % if model.parts_flag(i_part)==1
            I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%[0 0 255]);
     %   elseif model.parts_flag(i_part)==0
            %try
        %    I2=drawBbox(I2,model.parts_bbox(:,i_part),cm(max(1,min(100,round(50*model.parts_conf(i_part)+50))),:));%[0 255 0]);
            %end
      %  end
        
end

end