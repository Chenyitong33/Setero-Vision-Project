% 3. Image Comparison
% A big dx (big disparity between the found location in each camera) means the object is close to your cameras!
% A small dx means the object is further away. 
% How far away? how close? That is what the calibration images are for. 
%===================================================================================================================
tic
% Read in a pair of images
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','left_portal.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','right_portal.tiff');
% test with the same image:
% image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','left_portal.tiff');


wsize = 64;% window size is 64*64
xgrid = 1+(wsize-1)/2;
ygrid = 1+(wsize-1)/2;

[dpx_all,dpy_all] = myfn(image1, image2, wsize, xgrid, ygrid);

figure
shading interp

subplot(2,1,1)
surf(dpx_all)
title('dpx')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar

subplot(2,1,2)
surf(dpy_all)
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar
toc
%% function
function [dpx_all,dpy_all] = myfn(image1, image2, wsize, ~, ~)

M1_original = rgb2gray(imread(image1));
M2_original = rgb2gray(imread(image2));

% Get the number of windows (if the division cannot get integer)
tx = size(M1_original, 2);
ty = size(M1_original, 1);
x_windows = ceil(tx/wsize);
y_windows = ceil(ty/wsize);
% Divide the image into enough windows (3rd dimension is the number/index)
Template = zeros(wsize,wsize,x_windows*y_windows);
region = zeros(wsize*3,wsize*3,x_windows*y_windows);% 3x window size

% padding 0s to M1
M1 = zeros(y_windows*wsize, x_windows*wsize);
M1(1:ty,1:tx) = M1_original;
% padding 0s to M2
M2 = zeros(y_windows*wsize, x_windows*wsize);
M2(1:ty,1:tx) = M2_original;
% Break the left image into enough windows
for i = 1:y_windows
    for j = 1:x_windows
        Template(:,:,(i-1)*y_windows+j) = M1((i-1)*wsize+1:i*wsize,(j-1)*wsize+1:j*wsize);
    end
end

% generate a new search region with 0s surrounding the original region
M2_new = zeros(size(M2, 1)+wsize*2,size(M2, 2)+wsize*2);
M2_new(:,:) = 0;
M2_new(wsize+1:size(M2, 1)+wsize,wsize+1:size(M2, 2)+wsize) = M2;
% Break the corresponding windows in the right image
for i = 1:y_windows
    for j = 1:x_windows
        region(:,:,(i-1)*y_windows+j) = M2_new((i-1)*wsize+1:(i+3-1)*wsize,(j-1)*wsize+1:(j+3-1)*wsize);
    end
end

% 3 times means there is the same size at two sides, so the offset is 2 times of the window size from (0,0).
x_offset = wsize*2;
y_offset = wsize*2;
%==========================================================================
dpx_all = zeros(y_windows,x_windows);
dpy_all = zeros(y_windows,x_windows);
% Scan all the templates around the search region to find similar features using cross correlation
for i = 1:y_windows
    for j = 1:x_windows
        template = Template(:,:,(i-1)*y_windows+j);
        background = region(:,:,(i-1)*y_windows+j);
        
        % cross correlation
        C = normxcorr2(template, background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        dpx_all(i,j) = ji-x_offset;
        dpy_all(i,j) = ij-y_offset;
    end
end
end