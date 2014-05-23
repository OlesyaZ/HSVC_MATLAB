%Bubble recognition for HSVC
%% Load file HSVC
 
clear all;
close all;
clc;
 
% path and name for movie file
file_path = 'C:\Documents and Settings\User1\My Documents\Horizontal pipe experiment\75\200\set1\HS';
file_name = 'F1580.avi';
full_file_path = [file_path, file_name]
 
% load movie file from current directory
mov = aviread('F1580.avi');
 
%% play movie (to test it)
 %for ind = 1:1:length(mov)
 %    image(mov(ind).cdata);
 %    drawnow;
  %   pause(0.0);
 %end;
% close;
%% Add cursor for the pipe
% figure(1)
% imshow(mov(1).cdata);
while(waitforbuttonpress ~= 0) end;
st_m = get(gca, 'CurrentPoint');
x_pipe = st_m(1, 1)
y_pipe = st_m(1, 2)
close(figure(1))
 
%main loop to analyze
start_frame=90;
end_frame=114;
threshold=0.8;
 
start_channel=200;
end_channel=400;
%Where to search the bubble
xstart_init=30;
xfinish_init=300;
ystart_init=1;
yfinish_init=50;
 
xstart=xstart_init;
xfinish=xfinish_init;
ystart=ystart_init;
yfinish=yfinish_init;
 
R=25;
count=1;
shift=1;
count_inside=1;
for counter=start_frame:end_frame
    data=rgb2gray(mov(counter).cdata);
    bw=im2bw(edge(data,'sobel'),threshold);
    bw=bwareaopen(bw,15);
    se=strel('disk',4);
    bw=imclose(bw,se);
    bw=imfill(bw,'holes');
    
    % area to delete
    im=zeros(size(bw,1),size(bw,2));
    im(ystart:yfinish,xstart:xfinish)=bw(ystart:yfinish,xstart:xfinish);
    bw=im;
    %imshow(bw);
    lab = bwlabel(bw);
    imshow(lab);
    property = regionprops(lab,'Centroid');
    bubble_center(count,:) = property(1).Centroid; 
    
    %Reassign values for better search
    ystart=max(max(round(bubble_center(count,2))-R,1),ystart_init);
    yfinish=min(round(bubble_center(count,2))+R,size(bw,1));
    xstart=max(round(bubble_center(count,1))-R,1);
    xfinish=min(round(bubble_center(count,1))+R,size(bw,2));
 
    if (bubble_center(count,1)>=start_channel)&&(bubble_center(count,1)<=end_channel)
        %call the velocity procedure
        data2=rgb2gray(mov(counter+shift).cdata);
        xfinish2=min(round(bubble_center(count,1))+2*R,size(bw,2));
        [center(count_inside,:),vel(count_inside,:)]=velocity(data(ystart:yfinish,xstart:xfinish2),data2(ystart:yfinish,xstart:xfinish2));
        center(count_inside,1)=xstart+center(count_inside,1);
        center(count_inside,2)=ystart+center(count_inside,2);
        count_inside=count_inside+1;
    end
    pause(0.1);
    count=count+1;
end
x = bubble_center(:,1);
y = bubble_center(:,2);
figure();
plot(x-x_pipe,y_pipe-y,'m.');
figure();
modvel=sqrt(vel(:,1).^2+vel(:,2).^2);
plot(center(:,1),modvel);
 