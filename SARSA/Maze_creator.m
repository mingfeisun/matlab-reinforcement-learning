clear all;clc;

% n => Size of the maze
n=8;

maze=-50*ones(n,n);

% Randomly Generating Path/Links
for i=1:(n-3)*length(maze)
    maze(randi([1,n]),randi([1,n]))=1;
end

% Starting Node
maze(1,1)=1;

% Goal
maze(n,n)=10;

%Plot of the MAZE
figure
matrixPlot(maze)

% Check for atleast one path between Start & Goal