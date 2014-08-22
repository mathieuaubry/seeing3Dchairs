function []=generate_html(all_models,HTML_FOLDER)
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
