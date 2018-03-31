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

% This work was done as part of a course while I was a graduate student in 
% the University of Tokyo in spring 2011 while working for late Professor Carson
% Reynolds of the Masatoshi Ishikawa Lab, Graduate School of Information 
% Science and Technology

% This code demonstrates the reinforcement learning (Q-learning) algorithm using an example of a maze 
% in which a robot has to reach its destination by moving in the left, right,
% up and down directions only. At each step, based on the outcome of the
% robot action it is taught and re-taught whether it was a good move or not
% eventually the whole process is repeated time and again until it reaches
% its destination. At this point the process will start again so
% that what ever has been learned can be verified and un-necessary moves
% made during the first pass can be forgotten and so on. It is good tutorial example
% for situations in which learning has to be done on the go i.e. without
% the use of training examples. Can be used in games to learn and improve the
% competitive capability of AI algorithm with that of human players and
% several other scenarios.

% On small maze the convergence will be fast where as on large maze
% convergence can take some time. You can improve convergence speed by
% modifying the code to make Q-learning efficient.

% There are four m-files
% QLearning_Maze_Walk.m - demonstrates the working of Q-learning algorithm on a selected maze
% Random_Maze_Walk.m - demonstrates the working of random selection for comparison
% Read_Maze.m - will read the maze provided as input and translate into numeric representation for processing
% Textscanu.m - reads the raw maze text file

% Two maze files are included:
% maze-9-9.txt
% maze-61-21.txt
% which can be provided as input by changing the fileName in the code

function QLearning_Maze_Walk
clear all;
close all;

global maze2D;
global tempMaze2D;

DISPLAY_FLAG = 1; % 1 means display maze and 0 means no display
NUM_ITERATIONS = 100; % change this value to set max iterations 
% initialize global variable about robot orientation
currentDirection = 1; % robot is facing up

% row col will be initalized with the position of starting point of robot
% in the loop in which maze is read below
fileName = 'maze-9-9.txt';
[maze2D,row,col] = Read_Maze(fileName);
imagesc(maze2D) % show the maze

% make some copies of maze to use later for display
orgMaze2D = maze2D;
orgMaze2D(row,col) = 50;
[goalX,goalY,val] = find(orgMaze2D == 100);
tempMaze2D = orgMaze2D;

% record robots starting location for use later
startX = row;
startY = col;

% build a state action matrix by finding all valid states from maze
% we have four actions for each state.
Q = zeros(size(maze2D,1),size(maze2D,2),4);

% only used for priority visiting for larger maze
%visitFlag = zeros(size(maze2D,1),size(maze2D,2));

% status message for goal and bump
GOAL = 3;
BUMP = 2;

% learning rate settings
alpha = 0.8; 
gamma = 0.5;

for i=1:NUM_ITERATIONS   
    tempMaze2D(goalX,goalY) = 100;
    row = startX; col = startY;
    status = -1;
    countActions = 0;
    currentDirection = 1;

    % only used for priority visiting for larger maze 
%    visitFlag = zeros(size(maze2D,1),size(maze2D,2));
%    visitFlag(row,col) = 1;            
    
    while status ~= GOAL
        % record the current position of the robot for use later
        prvRow = row; prvCol = col;
        
        % select an action value i.e. Direction
        % which has the maximum value of Q in it
        % if more than one actions has same value then select randomly from them
        [val,index] = max(Q(row,col,:));
        [xx,yy] = find(Q(row,col,:) == val);
        if size(yy,1) > 1            
            index = 1+round(rand*(size(yy,1)-1));
            action = yy(index,1);
        else
            action = index;
        end

        % based on the selected actions correct the orientation of the
        % robot to conform to rules of simulator
        while currentDirection ~= action
            currentDirection = TurnLeft(currentDirection);
            % count the actions required to reach the goal
            countActions = countActions + 1;            
        end
                
        % do the selected action i.e. MoveAhead
        [row,col,status] = MoveAhead(row,col,currentDirection);

        % count the actions required to reach the goal        
        countActions = countActions + 1;            
        
        % Get the reward values i.e. if final state then max reward
        % if bump into a wall then -1 is the reward for that action
        % other wise the reward value is 0                
        if status == BUMP
            rewardVal = -1;
        elseif status == GOAL
            rewardVal = 1;
        else
            rewardVal = 0;
        end

        % enable this piece of code if testing larger maze
%         if visitFlag(row,col) == 0
%             rewardVal = rewardVal + 0.2;
%             visitFlag(row,col) = 1;            
%         else
%             rewardVal = rewardVal - 0.2;
%         end
                
        % update information for robot in Q for later use
        Q(prvRow,prvCol,action) = Q(prvRow,prvCol,action) + alpha*(rewardVal+gamma*max(Q(row,col,:)) - Q(prvRow,prvCol,action));
        
        % display the maze after some steps
        if rem(countActions,1) == 0 & DISPLAY_FLAG == 1
            X = [row col];
            Y = [goalX goalY];        
            dist = norm(X-Y,1);            
            s = sprintf('Manhattan Distance = %f',dist);
            imagesc(tempMaze2D);%,colorbar;
            title(s);            
            drawnow
        end
    end
    
    iterationCount(i,1) = countActions;
    
    % display the final maze
    imagesc(tempMaze2D);%,colorbar;
    disp(countActions);
    %bar(iterationCount);  
    drawnow
end

figure,bar(iterationCount)
disp('----- Mean Result -----')
meanA = mean(iterationCount);
disp(meanA);
%save Q_Learn_9-9.mat;


%-------------------------------%
%  1
% 2 3
%  4
% Current Direction
% 1 - means robot facing up
% 2 - means robot facing left
% 3 - means robot facing right
% 4 - means robot facing down
%------------------------------%
% based on the current direction and convention rotate the robot left
function currentDirection = TurnLeft(currentDirection)
if currentDirection == 1
    currentDirection = 2;
elseif currentDirection == 2
    currentDirection = 4;
elseif currentDirection == 4
    currentDirection = 3;
elseif currentDirection == 3
    currentDirection = 1;
end

% based on the current direction and convention rotate the robot right
function currentDirection = TurnRight(currentDirection)
if currentDirection == 1
    currentDirection = 3;
elseif currentDirection == 3
    currentDirection = 4;
elseif currentDirection == 4
    currentDirection = 2;
elseif currentDirection == 2
    currentDirection = 1;
end


% return the information just in front of the robot (local)
function [val,valid] = LookAhead(row,col,currentDirection)  
global maze2D;
valid = 0;
if currentDirection == 1
    if row-1 >= 1 & row-1 <= size(maze2D,1)
        val = maze2D(row-1,col);
        valid = 1;
    end
elseif currentDirection == 2
    if col-1 >= 1 & col-1 <= size(maze2D,2)
        val = maze2D(row,col-1);
        valid = 1;
    end
elseif currentDirection == 3
    if col+1 >= 1 & col+1 <= size(maze2D,2)
        val = maze2D(row,col+1);
        valid = 1;
    end
elseif currentDirection == 4
    if row+1 >= 1 & row+1 <= size(maze2D,1)
        val = maze2D(row+1,col);
        valid = 1;
    end
end

% status = 1 then move ahead successful
% status = 2 then bump into wall or boundary
% status = 3 then goal achieved
% Move the robot to the next location if no bump 
function [row,col,status] = MoveAhead(row,col,currentDirection)  
global tempMaze2D;

% based on the current direction check whether next location is space or
% bump and get information of use below
[val,valid] = LookAhead(row,col,currentDirection);
% check if next location for moving is space
% other wise set the status
% this checks the collision with boundary of maze
if valid == 1
    % now check if the next location for space or bump
    % this is for walls inside the maze
    if val > 0
        oldRow = row; oldCol = col;
        if currentDirection == 1
            row = row - 1;
        elseif currentDirection == 2 
            col = col - 1;
        elseif currentDirection == 3 
            col = col + 1;
        elseif currentDirection == 4 
            row = row + 1;    
        end
        status = 1;        
        
        if val == 100
            % goal achieved             
            status = 3;
            disp(status);            
        end
        
        % update the current position of the robot in maze for display
        tempMaze2D(oldRow,oldCol) = 50;                 
        tempMaze2D(row,col) = 60; 
    elseif val == 0
        % bump into wall
        status = 2;        
    end
else
    % return a bump signal if valid is 0
    status = 2;
end 

