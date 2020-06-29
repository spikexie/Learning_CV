function [hough_space,hough_circle,para] = hough_circle(BW,step_r,step_angle,r_min,r_max,p);
%[HOUGH_SPACE,HOUGH_CIRCLE,PARA] = HOUGH_CIRCLE(BW,STEP_R,STEP_ANGLE,R_MAX,P)
%------------------------------算法概述-----------------------------
% 该算法通过a = x-r*cos(angle)，b = y-r*sin(angle)将圆图像中的边缘点
% 映射到参数空间(a,b,r)中，由于是数字图像且采取极坐标，angle和r都取
% 一定的范围和步长，这样通过两重循环（angle循环和r循环）即可将原图像
% 空间的点映射到参数空间中，再在参数空间（即一个由许多小立方体组成的
% 大立方体)中寻找圆心，然后求出半径坐标。
%-------------------------------------------------------------------
 
%------------------------------输入参数-----------------------------
% BW:二值图像；
% step_r:检测的圆半径步长
% step_angle:角度步长，单位为弧度
% r_min:最小圆半径
% r_max:最大圆半径
% p:以p*hough_space的最大值为阈值，p取0，1之间的数
%-------------------------------------------------------------------
 
%------------------------------输出参数-----------------------------
% hough_space:参数空间，h(a,b,r)表示圆心在(a,b)半径为r的圆上的点数
% hough_circl:二值图像，检测到的圆
% para:检测到的圆的圆心、半径
%-------------------------------------------------------------------
 
% From Internet,Modified by mhjerry,2011-12-11
circleParaXYR = [];
para = [];
[m,n] = size(BW);
size_r = round((r_max-r_min)/step_r)+1;
size_angle = round(2*pi/step_angle);
 
hough_space = zeros(m,n,size_r);
 
[rows,cols] = find(BW);
ecount = size(rows);
 
% Hough变换
% 将图像空间(x,y)对应到参数空间(a,b,r)
% a = x-r*cos(angle)
% b = y-r*sin(angle)
for i=1:ecount
    for r=1:size_r
        for k=1:size_angle
            a = round(rows(i)-(r_min+(r-1)*step_r)*cos(k*step_angle));
            b = round(cols(i)-(r_min+(r-1)*step_r)*sin(k*step_angle));
            if(a>0&&a<=m&&b>0&&b<=n)
                hough_space(a,b,r) = hough_space(a,b,r)+1;
            end
        end
    end
end
 

% 搜索超过阈值的聚集点
max_para = max(max(max(hough_space)));
index = find(hough_space>=max_para*p);
length = size(index);
hough_circle=zeros(m,n);
for i=1:ecount
    for k=1:length
        par3 = floor(index(k)/(m*n))+1;
        par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;
        par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;
        if((rows(i)-par1)^2+(cols(i)-par2)^2<(r_min+(par3-1)*step_r)^2+5&...
                (rows(i)-par1)^2+(cols(i)-par2)^2>(r_min+(par3-1)*step_r)^2-5)
            hough_circle(rows(i),cols(i)) = 1;
        end
    end
end
 
% 打印结果
for k=1:length
    par3 = floor(index(k)/(m*n))+1;
    par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;
    par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;
    par3 = r_min+(par3-1)*step_r;
    %fprintf(1,'Center %d %d radius %d\n',par1,par2,par3);
    para(:,k) = [par1,par2,par3]';
end

mean(para,2);
len = para(1);
depth = para(2);
r = para(3);
fprintf(1,'Center %d %d radius %d\n',len,depth,r);