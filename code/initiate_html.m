function []=initiate_html(file,title_page,title,comments,title_cols)

%% header
fprintf(file,'<html>\n');
fprintf(file,' <head>\n');
fprintf(file,'  <title>%s</title>\n',title_page);
fprintf(file,'  <link rel="stylesheet" type="text/css" href="style.css" media="screen"/>\n');
fprintf(file,' </head>\n\n');

%% title
fprintf(file,' <body>\n');
fprintf(file,'  <font>\n');
fprintf(file,'     <p>\n');
fprintf(file,'      <center>\n');
fprintf(file,'       <font size="6">%s</font>\n',title);
fprintf(file,'      </center>');
fprintf(file,'     </p>\n');

fprintf(file,'   <p>\n');
fprintf(file,'%s\n',comments);
fprintf(file,'   <p>\n');


%% table first line
fprintf(file,'   <center>\n');
fprintf(file,'    <table width="100%%" align="center">\n');
 fprintf(file,'     <tr> \n');
 for i=1:length(title_cols)
 fprintf(file,'   	    <td align="center"> %s</td>\n',title_cols{i});
 end
 fprintf(file,'     </tr> \n');