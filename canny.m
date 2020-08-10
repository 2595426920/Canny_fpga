%��˹�˲�
I = imread('lena512.bmp');  
sigma=1.4;%��׼���С
window=5;%���ڴ�Сһ��Ϊ3*sigma
H=fspecial('gaussian', window, sigma);
img_gauss=imfilter(I,H,'replicate');
figure1 =  imshow(img_gauss,[]);
dx = zeros(size(I));         % ����ռ�,���x����ķ�ֵ
dy = zeros(size(I));         % ����ռ�,���y����ķ�ֵ
img_gauss = double(img_gauss);
%�ݶ�3x3
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
            d = abs(dy(q,p)/dx(q,p));  % 0��~45�㷽��
            gradmag = sobel(q,p);
            gradmag1 = sobel(q,p+1)*(1-d) + sobel(q-1,p+1)*d; 
            gradmag2 = sobel(q,p-1)*(1-d) + sobel(q+1,p-1)*d;
        elseif((dx(q,p)>0 && -dy(q,p)>=dx(q,p))  || (dx(q,p)<0 && -dy(q,p)<=dx(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 45��~90�㷽��
            gradmag = sobel(q,p);
            gradmag1 = sobel(q-1,p)*(1-d) + sobel(q-1,p+1)*d; 
            gradmag2 = sobel(q+1,p)*(1-d) + sobel(q+1,p-1)*d;
        elseif((dx(q,p)<=0 && dx(q,p)>dy(q,p)) || (dx(q,p)>=0 && dx(q,p)<dy(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 90��~135�㷽��
            gradmag = sobel(q,p);
            gradmag1 = sobel(q-1,p)*(1-d) + sobel(q-1,p-1)*d; 
            gradmag2 = sobel(q+1,p)*(1-d) + sobel(q+1,p+1)*d;
        elseif((dy(q,p)<0 && dx(q,p)<=dy(q,p)) || (dy(q,p)>0 && dx(q,p)>=dy(q,p)))
            d = abs(dy(q,p)/dx(q,p));  % 135��~180�㷽��
            gradmag = sobel(q,p);
            gradmag1 = sobel(q,p-1)*(1-d) + sobel(q-1,p-1)*d; 
            gradmag2 = sobel(q,p+1)*(1-d) + sobel(q+1,p+1)*d;
        end
        if(gradmag>=gradmag1 && gradmag>=gradmag2)
            if(gradmag >= high_threshold)   % ����ֵ�б�
                NMS(q,p) = 255;
            elseif(gradmag >= low_threshold)% ����ֵ�б�
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
                NMS(q,p) = 0;  % С�ڵ���ֵ
            end
        else
            NMS(q,p) = 0;  % �Ǽ���ֵ����
        end
    end 
end
% imagedata = zeros(512,512);
% for q = 4:509      % ����ֵ�б𣬼�����ֵ����8������Χ���Ƿ���ڵ���ֵ
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

imagedata = uint8(NMS);  % 16λ�޷�������ת��Ϊ8λ�޷�������
figure,imshow(imagedata);title('my matlab canny')     % ��ʾ�Ǽ���ֵ���ƺ��ͼ��

