%---------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Copyright (c) Asad Ali 
%Website: https://sites.google.com/site/asad82/code
%Email: asad_82@yahoo.com

%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
%documentation files (the "Software"), to deal in the Software with restriction for its use for research and educational 
%purpose only, subject to the following conditions:

%The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
%Software. The Software is provided "as is", without warranty of any kind.
%---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function [maze2D,row,col] = Read_Maze(fileName)

% read the maze from file
C = textscanu(fileName, 'UTF8', 9, 13);

% convert the maze into a 2D matrix
maze1D = C{1};
[xx,yy] = find(maze1D == 10);
numCol = round(size(maze1D,2)/size(xx,2));
numRow = size(xx,2);
%maze2D = zeros(numRow,numCol);
rowIndex = 1; colIndex = 1;
for i=1:size(maze1D,2)
    if maze1D(1,i) == 10
        % carriage return
        rowIndex = rowIndex + 1;
        colIndex = 1;
    elseif maze1D(1,i) == 'G'
        % goal
        maze2D(rowIndex,colIndex) = 100;
        colIndex = colIndex + 1;        
    elseif maze1D(1,i) == 'S'
        % start point
        maze2D(rowIndex,colIndex) = 60;
        row = rowIndex; col = colIndex;
        colIndex = colIndex + 1;        
    elseif maze1D(1,i) == ' '
        % space
        maze2D(rowIndex,colIndex) = 50;
        colIndex = colIndex + 1;        
    else
        % bump
        maze2D(rowIndex,colIndex) = 0;
        colIndex = colIndex + 1;        
    end
end
