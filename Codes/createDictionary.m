%% Create Dictionary

% Himanshu Dahiya(201330046)
% Sanatan Mishra (201330025)

% Here we will create the dictionary for example based super resolution.

close all;clear all;clc;

imageFiles=dir('*.jpg');    %get all names with specified extensions.
nFiles=length(imageFiles);

%initialisations.
lrfac=8;   %by default we are taking 8X8 for LR.
resizeFactor=4;
hrfac=lrfac*resizeFactor;    %32X32 for HR.
dx=1;means=[];dict=[];  %dict->dictionary of 64X1

for i=1:nFiles
    countdown=nFiles-i
    fileName=imageFiles(i).name;
    HRimg=imread(fileName);
    if size(HRimg,3)==3 %convert to grayscale if any.
        HRimg=rgb2gray(HRimg);
    end
    LRimg=imresize(HRimg,1/resizeFactor);
    HRimg=double(HRimg);LRimg=double(LRimg);
    [lx,ly]=size(LRimg);[lx,ly]=makeMultiple(lrfac,lx,ly); %make them ...
    ... multiple of factors.
    hx=lx*resizeFactor;hy=ly*resizeFactor;
    hrxcoor=1:hrfac:hx; lrxcoor=1:lrfac:lx;  %startings of patches.
    hrycoor=1:hrfac:hy; lrycoor=1:lrfac:ly;
    for j=1:length(lrxcoor)
        for k=1:length(lrycoor)
            %adding the correspondencies in the database and creating dictionary.
            dataBase{dx,1}=LRimg(lrxcoor(j):lrxcoor(j)+lrfac-1,...
                lrycoor(k):lrycoor(k)+lrfac-1);
            dict=[dict,reshape(dataBase{dx,1},[lrfac*lrfac,1])];
            dataBase{dx,2}=HRimg(hrxcoor(j):hrxcoor(j)+hrfac-1,...
                hrycoor(k):hrycoor(k)+hrfac-1);
            dataBase{dx,3}=sum(dataBase{dx,1}(:))/(lrfac*lrfac);
            means=[means,dataBase{dx,3}];
            dx=dx+1;
        end
    end
end

%Now dataBase contains correspondence between LR and HR patches.
%and dictionary contains linear patches for Pursuit.
save('database.mat','dataBase');
save('dictionary.mat','dict');
