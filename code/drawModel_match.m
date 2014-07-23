function [I1,I2]=drawModel(I1,I2,model,DEs,name)

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





        
        idxs=find(model.parts_flag>=0);
        
       clf;
       imageSize=size(I2);
       I1r=imresize(I1,[imageSize(1) NaN]);
       scale=size(I1r,1)/size(I1,1);
                                imshow([I2 I1r]);
                                hold on;
                                 for j = 1:length(idxs)
                               xx=scale.*[ DEs{idxs(j)}.x DEs{idxs(j)}.y];
                               x= [(model.parts_bbox(1,idxs(j))+model.parts_bbox(3,idxs(j)))/2 (model.parts_bbox(2,idxs(j))+model.parts_bbox(4,idxs(j)))/2 ];
                                plot([x(1); imageSize(2)+xx(1)],[x(2); xx(2)],'Color',cm(max(1,min(100,round(50*model.parts_conf(idxs(j))+50))),:),'LineWidth',2,'Marker','x');
                                 end
                                 
set(gcf,'PaperPositionMode','auto')
                                print('-djpeg',name);
                                %  print('-djpeg',fullfile(OUTDIR,resectionType{ii},sprintf('top%d',Nputative(jj)),sprintf('inliers%04d_painting%06d_img03.jpg',length(nInliers),ndxPainting)));
%                                 
%                                 
%                                 
%                                 % Get patches and which patches to plot:
%                                 [x1,x2,x3,x4] = GetPatchCorners(DET.x(:,n),DET.scale(:,n));
%                                 nn = unique(patchNdx(nInliers));
%                                 
%                                 xp1 = project3D2D(P,DET.X1(:,n),imageSize);
%                                 xp2 = project3D2D(P,DET.X2(:,n),imageSize);
%                                 xp3 = project3D2D(P,DET.X3(:,n),imageSize);
%                                 xp4 = project3D2D(P,DET.X4(:,n),imageSize);
%                                 
%                                 
%                                 % Show all correspondences and patches
%                                 clf;
%                                 imshow([img imgCol]);
%                                 hold on;
%                                 xx = project3D2D(P,X,imageSize);
%                                 plot([x(1,nInliers); imageSize(2)+xx(1,nInliers)],[x(2,nInliers); xx(2,nInliers)],'r');
%                                 for j = 1:length(nn)
%                                     plot([x1(1,nn(j)) x2(1,nn(j)) x3(1,nn(j)) x4(1,nn(j)) x1(1,nn(j))],[x1(2,nn(j)) x2(2,nn(j)) x3(2,nn(j)) x4(2,nn(j)) x1(2,nn(j))],'y');
%                                     plot([xp2(1,nn(j)) xp2(1,nn(j)) xp3(1,nn(j)) xp4(1,nn(j)) xp1(1,nn(j))]+imageSize(2),[xp1(2,nn(j)) xp2(2,nn(j)) xp3(2,nn(j)) xp4(2,nn(j)) xp1(2,nn(j))],'y');
%                                     %plot([xp1(1,nn(j)) xp2(1,nn(j)) xp3(1,nn(j)) xp4(1,nn(j)) xp1(1,nn(j))]+imageSize(2),[xp1(2,nn(j)) xp2(2,nn(j)) xp3(2,nn(j)) xp4(2,nn(j)) xp1(2,nn(j))],'y');
%  
%                                 end
%                                 plot([x(1,nInliers); imageSize(2)+xx(1,nInliers)],[x(2,nInliers); xx(2,nInliers)],'rx','MarkerSize',3);
%                                 
%                                 
%                                 print('-djpeg',fullfile(OUTDIR,resectionType{ii},sprintf('top%d',Nputative(jj)),nameFolds{folder_idx},sprintf('painting%06d_img03.jpg',ndxPainting)));
%                                 
%                                 

        
        
        
        




end