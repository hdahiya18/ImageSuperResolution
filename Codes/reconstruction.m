%% Reconstruction of Image

% Himanshu Dahiya(201330046)
% Sanatan Mishra (201330025)

% Till this point we will have all alphas(pointers to all corresponding HR
% patches through which we will reconstruct the image.

clear all;close all;clc;

load database.mat
load patches.mat


resizeFactor=4;
lrfac=8;hrfac=lrfac*resizeFactor;
img=imread('Inputs\shore.jpg');
if size(img,3)==3
    img=rgb2gray(img);
end

original=double(img);   %original image.
img=imresize(img,1/resizeFactor);
img=double(img);    %lr small image.

[lx,ly]=size(img); 
[lx,ly]=makeMultiple(lrfac,lx,ly);
img=img(1:lx,1:ly); %to match image size to default sizes.

nearest=imresize(img,resizeFactor,'nearest');
bilinear=imresize(img,resizeFactor,'bilinear');
bicubic=imresize(img,resizeFactor,'bicubic');   %resizing using interpolation.

[HRimg,small]=makeImage(allAlpha,dataBase,row,col); %result ...
...of resizing using our approach. HRimg is HR larger image and 'small'...
    ... is the smaller version of image found.
[firstAdd,addSmall]=makeImage(addAlpha,dataBase,row,col);
[firstSub,subSmall]=makeImage(subAlpha,dataBase,row,col);


[hx,hy]=size(HRimg); [ox,oy]=size(original); [ix,iy]=size(bicubic);

add=max(0,img-small);   %positive difference from original.
sub=max(0,small-img);   %negative difference.
%now we interpolate the difference, so we will not make the whole image
%blurred and it will be HR.
finalAdd=imresize(add,resizeFactor);
finalSub=imresize(sub,resizeFactor);

[fax,fay]=size(finalAdd); [fsx,fsy]=size(finalSub);
%make all dimensions constant.
[x,y]=correctDimensions([hx,ox,ix,fax],[hy,oy,iy,fsy]);
HRimg=HRimg(1:x,1:y);
firstAdd=firstAdd(1:x,1:y);
firstSub=firstSub(1:x,1:y);
original=original(1:x,1:y);
bicubic=bicubic(1:x,1:y);
finalAdd=finalAdd(1:x,1:y);
finalSub=finalSub(1:x,1:y);
backup=HRimg;

HRimg=HRimg+(firstAdd+finalAdd)-(firstSub+finalSub);

figure,imshow(img/255);title('Low resolution image');
figure,imshow(nearest/255);title('Nearest Interpolation');
figure,imshow(bilinear/255);title('Bilinear Interpolation');
figure,imshow(bicubic/255);title('Bicubic Interpolation');
figure,imshow(HRimg/255);title('Super-resolution zoom');   %image zoomed using 'super-resolution'.
figure,imshow(original/255);title('Ideal zoom');
