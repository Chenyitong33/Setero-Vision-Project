% Test stereo images in real world
%===================================================================================================================
% Read in a pair of images
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','bottle_left.jpg');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','bottle_right.jpg');

wsize = 128;% window size is 64*64
% center pixel of the first window
xgrid = 1+(wsize-1)/2;
ygrid = 1+(wsize-1)/2;

% Search region = 5x Window Size, Square
region_time = 5;

tic
[dpx,dpy] = myfn(image1, image2, wsize, xgrid, ygrid, 1, region_time);
figure
shading interp

subplot(2,1,1)
surf(dpx)
title('dpx when search region is 5 times bigger')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar

subplot(2,1,2)
surf(dpy)
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
title('dpy when search region is 5 times bigger')
colorbar
toc

%% function
% see xgrid is centre location of x1 and x2, 
% xgrid = x1 + (x2-x1)/2
% xgrid = x1 + (wsize-1)/2
% so x1 = xgrid - (wsize-1)/2
function [dpx_all,dpy_all] = myfn(image1, image2, wsize, ~, ~, overlap, region_time)

M1_original = rgb2gray(imread(image1));
M2_original = rgb2gray(imread(image2));

% Get the number of windows
tx = size(M1_original, 2);
ty = size(M1_original, 1);
x_windows = ceil(tx/wsize);
y_windows = ceil(ty/wsize);
% Divide the image into enough windows
Template = zeros(wsize,wsize,x_windows*(1/overlap) * y_windows*(1/overlap));% 1/overlap = 2
region = zeros(wsize*region_time,wsize*region_time,x_windows*(1/overlap) * y_windows*(1/overlap));% 5x window size

% Padding enough 0s to M1.
% The last window may be shifted outside, could multiply size by 2 for convenience.
M1 = zeros(ty*2, tx*2);
M1(1:ty,1:tx) = M1_original;
% Padding enough 0s to M2
M2 = zeros(ty*2, tx*2);
M2(1:ty,1:tx) = M2_original;

% Break the left image into enough windows
for i = 1:y_windows*(1/overlap)
    for j = 1:x_windows*(1/overlap)
        Template(:,:,(i-1)*y_windows*(1/overlap)+j) = M1((i-1)*(wsize*overlap)+1:wsize*(i*overlap-overlap+1),(j-1)*(wsize*overlap)+1:wsize*(j*overlap-overlap+1));
    end
end

% generate a new search region with 0s surrounding the original region
M2_new = zeros(size(M2, 1)+wsize*(region_time-1),size(M2, 2)+wsize*(region_time-1));
M2_new(:,:) = 0;
M2_new(wsize*(region_time-1)/2+1:size(M2, 1)+wsize*(region_time-1)/2,wsize*(region_time-1)/2+1:size(M2, 2)+wsize*(region_time-1)/2) = M2;
% Break the corresponding windows in the right image
for i = 1:y_windows*(1/overlap)
    for j = 1:x_windows*(1/overlap)
        region(:,:,(i-1)*y_windows*(1/overlap)+j) = M2_new((i-1)*(wsize*overlap)+1:wsize*(i*overlap-overlap+region_time),(j-1)*(wsize*overlap)+1:wsize*(j*overlap-overlap+region_time));
    end
end

% The maximum of the cross-correlation corresponds to the 
% estimated location of the lower-right corner of the template on background.
% like 5 times means there is the double size at two sides, 
% so the offset is 3 times of the window size from (0,0).
x_offset = wsize*((region_time-1)/2+1);
y_offset = wsize*((region_time-1)/2+1);
%==========================================================================

%==========================================================================
dpx_all = zeros(y_windows*(1/overlap),x_windows*(1/overlap));
dpy_all = zeros(y_windows*(1/overlap),x_windows*(1/overlap));
% Scan all the templates around the search region to find similar features using cross correlation
for i = 1:y_windows*(1/overlap)
    for j = 1:x_windows*(1/overlap)
        template = Template(:,:,(i-1)*y_windows*(1/overlap)+j);
        background = region(:,:,(i-1)*y_windows*(1/overlap)+j);
        
        % cross correlation
        C = normxcorr2(template, background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        dpx_all(i,j) = ji-x_offset;
        dpy_all(i,j) = ij-y_offset;
        
    end
end
end

