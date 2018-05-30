% 5. Test Scan on Computer Generated Calibrated Images
% Should first run the part 2 for building the calibration model
tic
% Read in a pair of images
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','test_left_2.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','test_right_2.tiff');

wsize = 64;% window size is 64*64
xgrid = 1+(wsize-1)/2;% x pixel of the center point
ygrid = 1+(wsize-1)/2;% y pixel of the center point
region_time = 5;

[dpx_all,dpy_all,i_left_test,j_left_test,x_windows,y_windows] = myfn(image1, image2, wsize, xgrid, ygrid, 1, 5);
i_right_test = i_left_test + dpx_all;
j_right_test = j_left_test + dpy_all;

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
title('dpy')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar
%==========================================================================
% % Remove spurious vectors larger than 50
% for i = 1:y_windows
%     for j = 1:x_windows
%         if(abs(dpx_all(i,j)) > 50)
%             dpx_all(i,j) = NaN;
%         end
%     end
% end
% for i = 1:y_windows
%     for j = 1:x_windows
%         if(abs(dpy_all(i,j)) > 50)
%             dpy_all(i,j) = NaN;
%         end
%     end
% end
% 
% figure
% shading interp
% 
% subplot(2,1,1)
% surf(dpx_all)
% title('dpx after removing spurious vectors')
% xlabel('windows x')
% ylabel('windows y')
% zlabel('difference value')
% colorbar
% 
% subplot(2,1,2)
% surf(dpy_all)
% title('dpy after removing spurious vectors')
% xlabel('windows x')
% ylabel('windows y')
% zlabel('difference value')
% colorbar

%% Get real models using calibration model
X = matlabFunction(sx);
Y = matlabFunction(sy);
Z = matlabFunction(sz);

Xreal_model = X(i_left_test,j_left_test,i_right_test,j_right_test);
Yreal_model = Y(i_left_test,j_left_test,i_right_test,j_right_test);
Zreal_model = Z(i_left_test,j_left_test,i_right_test,j_right_test);
% Plot 3D construction
figure;
%plot3(Zreal_model,Yreal_model,Xreal_model,'oc')
hold on
surf(reshape(Zreal_model,size(Zreal_model)),reshape(Yreal_model,size(Yreal_model)),reshape(Xreal_model,size(Xreal_model)),dpx_all)
xlabel('z [mm]')
ylabel('y [mm]')
zlabel('x [mm]')
axis equal
z_min = 0;
z_max = 2200;
y_min = -100;
y_max = 500;
x_min = -800;
x_max = 800; 
axis([z_min , z_max , y_min , y_max , x_min , x_max ]);
grid on
colorbar

toc
%% function
% see xgrid is centre location of x1 and x2, 
% xgrid = x1 + (x2-x1)/2
% xgrid = x1 + (wsize-1)/2
% so x1 = xgrid - (wsize-1)/2
function [dpx_all,dpy_all,i_left_test,j_left_test, x_windows, y_windows] = myfn(image1, image2, wsize, xgrid, ygrid, overlap, region_time)
%function [dpx_all,dpy_all] = myfn(image1, image2, wsize, ~, ~, overlap, region_time)

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

% padding enough 0s to M1, the last window will be shifted outside, should multiplied by 2 for convenience.
M1 = zeros(ty*2, tx*2);
M1(1:ty,1:tx) = M1_original;
% padding enough 0s to M2
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
i_left_test = zeros(y_windows,x_windows);
j_left_test = zeros(y_windows,x_windows);
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
        i_left_test(i,j) = j*xgrid;
        j_left_test(i,j) = i*ygrid;
        
    end
end
end