% 4. Cross Correlation Optimisation
% a) Window Overlap = 50%
% b) Search region = 5x Window Size, Square

%===================================================================================================================
% Read in a pair of images
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','left_portal.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','right_portal.tiff');

wsize = 64;% window size is 64*64
% center pixel of the first window
xgrid = 1+(wsize-1)/2;
ygrid = 1+(wsize-1)/2;
% a) Window overlap = 50%, default is 1
overlap = 0.5;
% b) Search region = 5x Window Size, Square, default is 3
region_time = 5;

%==========================================================================
tic
[dpx,dpy] = myfn(image1, image2, wsize, xgrid, ygrid, overlap, 3);
figure
shading interp

subplot(2,1,1)
surf(dpx)
title('dpx when overlap is 50%')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar

subplot(2,1,2)
surf(dpy)
title('dpy when overlap is 50%')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar
toc
%==========================================================================
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

%==========================================================================
tic
% default function for first pass
[dpx_est,dpy_est] = myfn(image1, image2, wsize, xgrid, ygrid, 1, 3);
% second pass
[dpx,dpy] = myfn2(image1, image2, wsize, xgrid, ygrid, dpx_est, dpy_est);
figure
shading interp

subplot(2,1,1)
surf(dpx)
title('dpx when second pass')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar

subplot(2,1,2)
surf(dpy)
title('dpy when second pass')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
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

% Generate a new search region with 0s surrounding the original region
M2_new = zeros(size(M2, 1)+wsize*(region_time-1),size(M2, 2)+wsize*(region_time-1));
M2_new(:,:) = 0;
M2_new(wsize*(region_time-1)/2+1:size(M2, 1)+wsize*(region_time-1)/2,wsize*(region_time-1)/2+1:size(M2, 2)+wsize*(region_time-1)/2) = M2;

% Break the corresponding windows in the right image
for i = 1:y_windows*(1/overlap)
    for j = 1:x_windows*(1/overlap)
        region(:,:,(i-1)*y_windows*(1/overlap)+j) = M2_new((i-1)*(wsize*overlap)+1:wsize*(i*overlap-overlap+region_time),(j-1)*(wsize*overlap)+1:wsize*(j*overlap-overlap+region_time));
    end
end

% 5 times means there is the double size at two sides, 
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

%% function 2 - 2nd pass
function [dpx_all,dpy_all] = myfn2(image1, image2, wsize, ~, ~, dpx_est, dpy_est)
M1_original = rgb2gray(imread(image1));
M2_original = rgb2gray(imread(image2));

% Get the number of windows
tx = size(M1_original, 2);
ty = size(M1_original, 1);
x_windows = ceil(tx/wsize);
y_windows = ceil(ty/wsize);
% Divide the image into enough windows
Template = zeros(wsize,wsize,x_windows*y_windows);
region = zeros(wsize,wsize,x_windows*y_windows);% 1x window size

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

% generate a new search region with enough 0s surrounding the original region
M2_new = zeros(size(M2, 1)+wsize*4,size(M2, 2)+wsize*4);
M2_new(:,:) = 0;
M2_new(wsize*2+1:size(M2, 1)+wsize*2,wsize*2+1:size(M2, 2)+wsize*2) = M2;
% Break the corresponding windows in the right image
for i = 1:y_windows
    for j = 1:x_windows
        region(:,:,(i-1)*y_windows+j) = M2_new((i-1)*wsize+wsize*2+1+dpy_est(i,j):i*wsize+wsize*2+dpy_est(i,j),(j-1)*wsize+wsize*2+1+dpx_est(i,j):j*wsize+wsize*2+dpx_est(i,j));
    end
end

%==========================================================================
dpx_all = zeros(y_windows*2,x_windows*2);
dpy_all = zeros(y_windows*2,x_windows*2);
% Scan all the templates around the search region to find similar features using cross correlation
% 2nd pass is 32*32 (more detailed)
for i = 1:y_windows
    for j = 1:x_windows
        template = Template(:,:,(i-1)*y_windows+j);
        background = region(:,:,(i-1)*y_windows+j);
        
        % dpx/dpy is the relative coordinate substract the offset of
        % the part, and then plus the estimated dpx/dpy.
        
        % 1.cross correlation for top-left part
        C = normxcorr2(template(1:wsize/2,1:wsize/2), background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        
        dpx_all((i-1)*2+1,(j-1)*2+1) = ji-wsize/2+dpx_est(i,j);
        dpy_all((i-1)*2+1,(j-1)*2+1) = ij-wsize/2+dpy_est(i,j);
        
        % 2.cross correlation for top-right part
        C = normxcorr2(template(1:wsize/2,1+wsize/2:wsize), background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        dpx_all((i-1)*2+1,j*2) = ji-wsize+dpx_est(i,j);
        dpy_all((i-1)*2+1,j*2) = ij-wsize/2+dpy_est(i,j);
        
        % 3.cross correlation for bot-left part
        C = normxcorr2(template(wsize/2+1:wsize,1:wsize/2), background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        dpx_all(i*2,(j-1)*2+1) = ji-wsize/2+dpx_est(i,j);
        dpy_all(i*2,(j-1)*2+1) = ij-wsize+dpy_est(i,j);
        
        % 4.cross correlation for bot-right part
        C = normxcorr2(template(wsize/2+1:wsize,1+wsize/2:wsize), background);
        [~,snd] = max(C(:));% get index of the high point in the vector
        [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
        dpx_all(i*2,j*2) = ji-wsize+dpx_est(i,j);
        dpy_all(i*2,j*2) = ij-wsize+dpy_est(i,j);
        
    end
end
end
%% Self-implemented normalised cross correlation function
function C = selfnormxcorr2(M2, M1)
img = M1;% M1 is the search region (whole image)
Sec = M2;% M2 is the template (section)

% Subtract the mean value so that there are roughly equal numbers of negative and positive values.
nimg = img-mean(mean(img));
nSec = Sec-mean(mean(Sec));

[M,N] = size(nimg);
m = 1:M;
n = 1:N;

[P,Q] = size(nSec);
p = 1:P;
q = 1:Q;

% Make a zero matrix and put the search region in the center
Xt = zeros([M+2*P N+2*Q]);
Xt(m+P,n+Q) = nimg;

% initialize the cross correlation matrix
C = zeros([M+P N+Q]);

for k = 1:M+P+1
    for l = 1:N+Q+1
        Xtl = Xt(p+k-1,q+l-1); %(1:P)+k-1,(1:Q)+l-1 because k and l start from 1 (should be 0).
        C(k,l) = sum(sum(Xtl.*conj(nSec)))/sqrt(sum(dot(Xtl,Xtl))*sum(dot(nSec,nSec)));%normalisation
    end
end

% trim NaN surrounding the matrix
C = C(2:(M+P),2:(N+Q));
end
