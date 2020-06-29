clear;
clc;
circleParaXYR = [];
i = imread('F:/circle.jpg');
[m,n,l] = size(i);

if l > 1
    i = rgb2gray(i);
end

BW = edge(i, 'sobel');

step_r = 1;  
step_angle = 0.1; 
minr = 100;
maxr = 125;
thresh = graythresh(i);
[hough_space,hough_circle,para] = hough_circle(BW,step_r,step_angle,minr,maxr,thresh);
%figure(1),imshow(i),title('原图')  
%figure(2),imshow(BW),title('边缘')  
%figure(3),imshow(hough_circle),title('检测结果')

%result = mean(para,2);
%fprintf(1,'Center %d %d radius %d\n',result(1),result(2),result(3));
