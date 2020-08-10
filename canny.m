%高斯滤波
I = imread('lena512.bmp');  
sigma=1.4;%标准差大小
window=5;%窗口大小一半为3*sigma
H=fspecial('gaussian', window, sigma);
img_gauss=imfilter(I,H,'replicate');
figure1 =  imshow(img_gauss,[]);
dx = zeros(size(I));         % 申请空间,存放x方向的幅值
dy = zeros(size(I));         % 申请空间,存放y方向的幅值
img_gauss = double(img_gauss);
%梯度3x3
for row = 2:511
    for cow = 2:511
        dx(row ,cow) = img_gauss(row-1,cow-1)-img_gauss(row-1,cow+1)+2*(img_gauss(row,cow-1)-img_gauss(row,cow+1)) + img_gauss(row+1,cow-1)-img_gauss(row+1,cow+1); 
        dy(row ,cow) = img_gauss(row-1,cow-1)-img_gauss(row+1,cow-1)+2*(img_gauss(row-1,cow)-img_gauss(row+1,cow)) + img_gauss(row-1,cow+1)-img_gauss(row+1,cow+1); 
    end
end
sobel = sqrt(dx.^2 + dy.^2);
sobel = uint8(sobel);
NMS = zeros(512,512);
high_threshold = 40;
low_threshold = 20;
for q = 3:510
    for p = 3:510
        if((dy(q,p)<=0 && dx(q,p)>-dy(q,p))  || (dy(q,p)>=0 && dx(q,p)<-dy(q,p)))
            d = abs(dy(q,p)/dx(q,p));  % 0°~45°方向
            gradmag = sobel(q,p);
            gradmag1 = sobel(q,p+1)*(1-d) + sobel(q-1,p+1)*d; 
            gradmag2 = sobel(q,p-1)*(1-d) + sobel(q+1,p-1)*d;
        elseif((dx(q,p)>0 && -dy(q,p)>=dx(q,p))  || (dx(q,p)<0 && -dy(q,p)<=dx(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 45°~90°方向
            gradmag = sobel(q,p);
            gradmag1 = sobel(q-1,p)*(1-d) + sobel(q-1,p+1)*d; 
            gradmag2 = sobel(q+1,p)*(1-d) + sobel(q+1,p-1)*d;
        elseif((dx(q,p)<=0 && dx(q,p)>dy(q,p)) || (dx(q,p)>=0 && dx(q,p)<dy(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 90°~135°方向
            gradmag = sobel(q,p);
            gradmag1 = sobel(q-1,p)*(1-d) + sobel(q-1,p-1)*d; 
            gradmag2 = sobel(q+1,p)*(1-d) + sobel(q+1,p+1)*d;
        elseif((dy(q,p)<0 && dx(q,p)<=dy(q,p)) || (dy(q,p)>0 && dx(q,p)>=dy(q,p)))
            d = abs(dy(q,p)/dx(q,p));  % 135°~180°方向
            gradmag = sobel(q,p);
            gradmag1 = sobel(q,p-1)*(1-d) + sobel(q-1,p-1)*d; 
            gradmag2 = sobel(q,p+1)*(1-d) + sobel(q+1,p+1)*d;
        end
        if(gradmag>=gradmag1 && gradmag>=gradmag2)
            if(gradmag >= high_threshold)   % 高阈值判别
                NMS(q,p) = 255;
            elseif(gradmag >= low_threshold)% 低阈值判别
                flag = 0;
                for m=-1:1
                    for k=-1:1
                        if(sobel(q+m,p+k)>=high_threshold)
                            flag=flag +1;
                        end
        
                    end
                end
                if(flag>=1)
                    NMS(q,p) = 255;
                else
                    NMS(q,p) = 0;
                end
                
            else
                NMS(q,p) = 0;  % 小于低阈值
            end
        else
            NMS(q,p) = 0;  % 非极大值抑制
        end
    end 
end
% imagedata = zeros(512,512);
% for q = 4:509      % 高阈值判别，检查高阈值邻域8个方向范围内是否存在低阈值
%     for p = 4:509
%         if(NMS(q,p) == 255)
%             imagedata(q,p) = 255;
%             if(NMS(q-1,p-1) == 125)
%                 NMS(q-1,p-1) = 255;
%                 imagedata(q-1,p-1) = 255;
%             end
%             if(NMS(q-1,p) == 125)
%                 NMS(q-1,p) = 255;
%                 imagedata(q-1,p) = 255;
%                 
%             end
%             if(NMS(q-1,p+1) == 125)
%                 NMS(q-1,p+1) = 255;
%                 imagedata(q-1,p+1) = 255;
%                 
%             end
%             if(NMS(q,p-1) == 125)
%                 NMS(q,p-1) = 255;
%                 imagedata(q,p-1) = 255;
%                 
%             end
%             if(NMS(q,p+1) == 125)
%                 NMS(q,p+1) = 255;
%                 imagedata(q,p+1) = 255;
%               
%             end
%             if(NMS(q+1,p-1) == 125)
%                 NMS(q+1,p-1) = 255;
%                 imagedata(q+1,p-1) = 255;
%                
%             end
%             if(NMS(q+1,p) == 125)
%                 NMS(q+1,p) = 255;
%                 imagedata(q+1,p) = 255;
%                 
%             end
%             if(NMS(q+1,p+1) == 125)
%                 NMS(q+1,p+1) = 255;
%                 imagedata(q+1,p+1) = 255;
%               
%             end
%         end
%     end
% end

imagedata = uint8(NMS);  % 16位无符号整数转化为8位无符号整数
figure,imshow(imagedata);title('my matlab canny')     % 显示非极大值抑制后的图像

