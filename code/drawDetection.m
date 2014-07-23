function O=drawDetection(DE,I,scale,x_root,y_root,DEparams)

scale_factor=2^(1/DEparams.levels_per_octave);
scale_model=(DEparams.max_scale/scale_factor^(scale-1))*400/50;
basic_size=[5 5];%DEparams.max_scale/(sc^5-1); % comes from the DE learning

O=I;
if size(O,3)==1
    O=repmat(O,[1 1 3]);
end

bcolor=[255 0 0];
bcolor=reshape(bcolor,[1 1 3]);

my_min=basic_size(1)*(y_root-1)*scale_factor^(scale-1)+1;
mx_min=basic_size(2)*(x_root-1)*scale_factor^(scale-1)+1;
my_max=basic_size(1)*(y_root-1+DEparams.hog_size(1))*scale_factor^(scale-1);
mx_max=basic_size(2)*(x_root-1+DEparams.hog_size(2))*scale_factor^(scale-1);
bbox=round([mx_min my_min mx_max my_max]);

for dx=-1:1
    for dy=-1:1
        try
            O(bbox(2)+dy:bbox(4)+dy,bbox(1)+dx,:)=repmat(bcolor,[bbox(4)-bbox(2)+1 1 1]);
        end
        try
            O(bbox(2)+dy,bbox(1)+dx:bbox(3)+dx,:)=repmat(bcolor,[1 bbox(3)-bbox(1)+1 1]);
        end
        try
            O(bbox(2)+dy:bbox(4)+dy,bbox(3)+dx,:)=repmat(bcolor,[bbox(4)-bbox(2)+1 1 1]);
        end
        try
            O(bbox(4)+dy,bbox(1)+dx:bbox(3)+dx,:)=repmat(bcolor,[1 bbox(3)-bbox(1)+1 1]);
        end
    end
end


bcolor=[0 0 255];
bcolor=reshape(bcolor,[1 1 3]);

x_min=mx_min+(DE.x_min-100)/scale_model;
y_min=my_min+(DE.y_min-100)/scale_model;
y_max=my_min+(DE.y_max-100)/scale_model;
x_max=mx_min+(DE.x_max-100)/scale_model;
bbox=round([x_min y_min x_max y_max]);

for dx=-1:1
    for dy=-1:1
        try
            O(bbox(2)+dy:bbox(4)+dy,bbox(1)+dx,:)=repmat(bcolor,[bbox(4)-bbox(2)+1 1 1]);
        end
        try
            O(bbox(2)+dy,bbox(1)+dx:bbox(3)+dx,:)=repmat(bcolor,[1 bbox(3)-bbox(1)+1 1]);
        end
        try
            O(bbox(2)+dy:bbox(4)+dy,bbox(3)+dx,:)=repmat(bcolor,[bbox(4)-bbox(2)+1 1 1]);
        end
        try
            O(bbox(4)+dy,bbox(1)+dx:bbox(3)+dx,:)=repmat(bcolor,[1 bbox(3)-bbox(1)+1 1]);
        end
    end
end

