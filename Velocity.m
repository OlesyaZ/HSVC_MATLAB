function [center,vel]=velocity(im,im2)
 
 
%Cut the edges
%figure();
%imagesc(im);
%figure();
%imagesc(im2);
t=8.333333333333334e-004; %time between frames
p=0.000176;   %pixel size in meters
%Convert images to black/white images with threshold
%threshold = graythresh(W);
threshold=0.8;
%bw = not(im2bw(im,threshold));
%bw2 =not(im2bw(im2,threshold));
se=strel('disk',12);
 
bw=im2bw(edge(im,'sobel'),threshold);
bw=bwareaopen(bw,15);
bw=imclose(bw,se);
bw=imfill(bw,'holes');
 
 
bw2=im2bw(edge(im2,'sobel'),threshold);
bw2=bwareaopen(bw2,15);
bw2=imclose(bw2,se);
bw2=imfill(bw2,'holes');
 
%figure(111)
%imshow(bw);
%figure(112)
%imshow(bw2);
%pause(3);
 
%remove pixels which do not belong to the objects of interest.
bw = bwareaopen(bw,17);
[B,L] = bwboundaries(bw,'noholes');
stats = regionprops(L,'Area','Centroid');
bubble_index=1;
min_rast=10000;
for k = 1:length(B)
   boundary = B(Zhou);
   if abs(stats(k).Centroid-size(bw,2))<min_rast
        bubble_index=k;
   end
end
center=stats(bubble_index).Centroid;
area=stats(bubble_index).Area*0.0676; %0.26mm-pixel size
 
bw2 = bwareaopen(bw2,17);
[B2,L2] = bwboundaries(bw2,'noholes');
stats2 = regionprops(L2,'Area','Centroid');
bubble_index2=1;
min_rast=10000;
for k = 1:length(B2)
   boundary2 = B2(Zhou);
   if abs(stats2(k).Centroid-size(bw2,2))<min_rast
        bubble_index2=k;
   end
end
center2=stats2(bubble_index2).Centroid;
%area2=stats2(bubble_index2).Area*0.0676; %0.26mm-pixel size
shift=1;
% TRANSFER IT TO THE PROPER STUFF
velx=(center(1)-center2(1))*p/(t*shift);
vely=(center(2)-center2(2))*p/(t*shift);
vel=[velx vely];
%sqrt(velx^2+vely^2);
 
end
