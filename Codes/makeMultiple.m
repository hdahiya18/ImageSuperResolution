function [newRow,newCol] = makeMultiple(factor,row,col)

% Himanshu Dahiya(201330046)
% Sanatan Mishra (201330025)

%make row and col multiples of factor.
    newRow=factor*floor(row/factor);
    newCol=factor*floor(col/factor);
end
