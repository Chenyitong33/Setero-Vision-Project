% 1. Dot Detection Algorithm

% Read the image
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_2000.tiff');

M2 = rgb2gray(imread(image1)); 
% Gaussian template
M1 = [0,5,11,5,0
5,53,117,53,5
11,117,255,117,11
5,53,117,53,5
0,5,11,5,0];
surf(M1)
colorbar

% normalised cross correlation
C = normxcorr2(M1, M2);

% draw the original search region image
figure
title('Finding and plotting on the image')
% imagesc(M2)
% axis image off
% colormap gray
xlabel('x [mm]')
ylabel('y [mm]')
axis equal
axis([0 , 2500 , 0 , 1600]);   
for i = 1:17*21
    [~,snd] = max(C(:));% get index of the high point in the vector
    [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
    % get the x and y coordinates of the template zone
    x1=ij-size(M1,1)+1;
    x2=ij;
    y1=ji-size(M1,2)+1;
    y2=ji;
    hold on
    x = [x1, x2, x2, x1, x1];
    y = [y1, y1, y2, y2, y1];
    plot(y, x, 'r');
    C(ij-5:ij+5,ji-5:ji+5) = 0;% make the cross correlation zone of found dot to zero
end

