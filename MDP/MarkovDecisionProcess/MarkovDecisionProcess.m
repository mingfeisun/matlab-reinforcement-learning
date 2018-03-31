%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    [Visualization-HW2] Fatuma Shifa.
%    I found the java version of this code in:
%    https://galweejit.wordpress.com/2010/12/16/ai-class-implementation-of-mdp-grid-world-from-week-5-unit-9/
%    I coverted it to Matlab code and I made it with graphical representation.
%    The code accepts only one obstacle 'sink' value. 
%    You can change terminals, obstacle and start positions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DEFINE THE 2-D R ARRAY
MAX_X=4;
MAX_Y=3;

Ra = -3; %reward in non-terminal states (used to initialise r[][])

%This array stores the coordinates of the R and the 
%Objects in each coordinate
R=Ra*ones(MAX_X,MAX_Y);
Pi=ones(MAX_X,MAX_Y);

% Obtain Obstacle, Target and Robot Position
% Initialize the R
% Obstacle=-1,Target = 0,Robot=1,Space=2
axis([0 MAX_X 0 MAX_Y])   
%set(gca,'color', [1 1 0]);
%set(gca,'color','b');

set(gca,'XTick',[1:MAX_X])  
set(gca,'YTick',[1:MAX_Y]) 

grid on;
hold on;

% Determine Terminals, Obstacles, Start Locations

%Terminals
%Winning point
xWin=4;%X Coordinate of the Winning point
yWin=3;%Y Coordinate of the Winning point
R(xWin,yWin)=100;%Reward = 100
Pi(xWin,yWin)='+';%Policy
plot(xWin-.5,yWin-.5,'gd');
text(xWin-.9,yWin-.3,'Winning +100')

%Loss point
xLos=4;%X Coordinate of the Loss point
yLos=2;%Y Coordinate of the Loss point
R(xLos,yLos)=-100;%Reward = -100
Pi(xLos,yLos)='-';%Policy
plot(xLos-.5,yLos-.5,'rd');
text(xLos-.8,yLos-.4,'Loss -100')

%Obstacles
xObs=2;%X Coordinate of the First Obstacle
yObs=2;%Y Coordinate of the First Obstacle
R(xObs,yObs)=0;%Reward = 0
Pi(xObs,yObs)='#';%Policy
plot(xObs-.5,yObs-.5,'ro');
text(xObs-.8,yObs-.4,'Obsticale')

%Start
xStart=2;%X Coordinate of the Start
yStart=1;%Y Coordinate of the Start
plot(xStart-.5,yStart-.5,'bo');
text(xStart-.6,yStart-.4,'Start')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 10000; %max number of iterations of Value Iteration

deltaMin = 1e-9; %convergence criterion for iteration
delta = 0;

POINTS_COUNT= MAX_X * MAX_Y;
POINTS=[POINTS_COUNT,6];

%Put all the points in list with their rewards and initial UP and U
%POINTS 
%LIST |X val |Y val |Reward |Uprime |Utility |Policy

k=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
          POINTS(k,1)=i;
          POINTS(k,2)=j;
          POINTS(k,3)=R(i,j);
          POINTS(k,4)=0;
          POINTS(k,5)=0;
          POINTS(k,6)=Pi(i,j);

          k=k+1;
    end
end

R=POINTS(:,3);%instantaneous reward
Up=POINTS(:,4);%UPrime, used in updates
U=POINTS(:,5);%long-term utility
Pi=POINTS(:,6);%policy


n=0;

%while((delta < deltaMin) && (n < N))
while 1
    
    POINTS(:,5)=POINTS(:,4);%U=Up
    U=Up;
    
    n=n+1;
    
    delta = 0;
    
    for i=1:MAX_X
        for j=1:MAX_Y
            upPi=updateUPrimePi(i,j,POINTS,Ra);
            Up=upPi(:,1);
            Pi=upPi(:,2);
            POINTS(:,4)=Up;
            POINTS(:,6)=Pi;
            
            k=find(POINTS(:,1)==i & POINTS(:,2)==j);
            %k=k(1);

            diff=abs(Up(k)-U(k));

            if diff > delta
                delta = diff;
            end

        end
    end
    
    if (delta < deltaMin || n > N)
        break;
    end
    
end

charPi=char(Pi);

for i=1:MAX_X
    for j=1:MAX_Y
        k=find(POINTS(:,1)==i & POINTS(:,2)==j);
        text(i-.7,j-.2,num2str(U(k)),'color','g')
        text(i-.5,j-.8,charPi(k),'color','b')
    end
end

path=[];

i=1;
path(1,1)=xStart;
path(1,2)=yStart;

newX=xStart;
newY=yStart;

while 1
k=find(POINTS(:,1)==newX & POINTS(:,2)==newY);
if (charPi(k)~='+' && charPi(k)~='-' && charPi(k)~='#')
    i=i+1;
    if charPi(k)=='N'        
        path(i,1)=newX;
        path(i,2)=newY+1;        
        newX=newX;
        newY=newY+1;
    else if charPi(k)=='S'
            path(i,1)=newX;
            path(i,2)=newY-1;
            newX=newX;
            newY=newY-1;
        else if charPi(k)=='W'
                path(i,1)=newX-1;
                path(i,2)=newY;    
                newX=newX-1;
                newY=newY;
            else %'E'
                path(i,1)=newX+1;
                path(i,2)=newY;
                newX=newX+1;
                newY=newY;
            end
            
        end
    end
else
    break;
end

i=size(path,1);
 %Plot the Path!
 p=plot(path(i,1)-.5,path(i,2)-.5,'bo');

for i=1:size(path,1)
  pause(.25);
  set(p,'XData',path(i,1)-.5,'YData',path(i,2)-.5);
 drawnow ;
 end;
plot(path(:,1)-.5,path(:,2)-.5);
end





