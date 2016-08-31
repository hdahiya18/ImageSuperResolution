function [FinalImage,smallImage] = makeImage(origins,dict,row,col)

% Himanshu Dahiya(201330046)
% Sanatan Mishra (201330025)

%we have the pointer to all high resolution patches in the 'origins' and we
%just need to combine them to form the final image.
    
    %initialisations.
    resizeFactor=4;
    lrfac=8;hrfac=lrfac*resizeFactor;
    index=1;
    
    [m,n]=size(origins);
    FinalImage=[];smallImage=[];
    for i=1:row/lrfac   %for each patch.
        oneRow=[];secRow=[];
        for j=1:col/lrfac
            patch=zeros(hrfac,hrfac);smallPatch=zeros(lrfac,lrfac);
            for k=1:m-1
                %get each patch as multiplication of coefficients(alpha)
                %with corresponding patch.
                if origins(k,index)>0.01
                patch=patch+(origins(k,index)*dict{k,2});
                smallPatch=smallPatch+(origins(k,index)*dict{k,1});
                end
            end
            oneRow=[oneRow,patch];
            secRow=[secRow,smallPatch];
            index=index+1;
        end
        FinalImage=[FinalImage;oneRow];
        smallImage=[smallImage;secRow];
    end
    
end
