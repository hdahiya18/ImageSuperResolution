%% Main

% Himanshu Dahiya(201330046)
% Sanatan Mishra (201330025)

%Here we will have input image and we will search for each patch of inut
%image in the dataBase and solve D.alpha = patch;
%We have D(64Xk) and patch(64X1) and need to find alpha(kX1)
%here k is number of patches in dictionary and 64 is length of 1 patch. 

clear all;close all;clc;

load database.mat
load dictionary.mat
load position.mat

sortedDataBase=sortrows(dataBase,3);

%initialisations.
resizeFactor=4;
lrfac=8;hrfac=lrfac*resizeFactor;   %8X8 for LR and 32X32 for HR.

img=imread('Inputs\beach.jpg');
if size(img,3)==3
    img=rgb2gray(img);
end
img=imresize(img,1/resizeFactor);   %this will be size of input images.
img=double(img);
figure,imshow(img/255);

[row,col]=size(img);
[row,col]=makeMultiple(lrfac,row,col);  %to make img multiple of patch size.
img=img(1:row,1:col);
xcoor=1:lrfac:row;  %dividing patches.
ycoor=1:lrfac:col;
allAlpha=[]; addAlpha=[]; subAlpha=[]; %to store corresponding hr patches.
for i=1:length(xcoor)
    for j=1:length(ycoor)
        primaryCountdown=length(xcoor)-i
        secondaryCountdown=length(ycoor)-j
        
        % this part for first iteration.
        patch=img(xcoor(i):xcoor(i)+lrfac-1,ycoor(j):ycoor(j)+lrfac-1); %lr patch.
        
        linPatch=reshape(patch,[lrfac*lrfac,1]);    %convert to linear...
        ...to search in dictionary
        alpha=lsqnonneg(dict,linPatch);  %least square method to find 'alpha'.
        allAlpha=[allAlpha,alpha];
        
        % this part for next iteration.
        posDif=max(0,linPatch-dict*alpha);  %positive difference between...
        ...original and found patch.
        negDif=max(0,dict*alpha-linPatch);  %negative difference here.
        
        posDif=reshape(posDif,[lrfac*lrfac,1]); %linearising diffs.
        negDif=reshape(negDif,[lrfac*lrfac,1]);
        
        posAlpha=lsqnonneg(dict,posDif); %finding alphas for these diffs now.
        negAlpha=lsqnonneg(dict,negDif);
        
        addAlpha=[addAlpha,posAlpha];
        subAlpha=[subAlpha,negAlpha];
       
    end
end
save('patches.mat','allAlpha','addAlpha','subAlpha','row','col');
%save('patches.mat','allAlpha','row','col');