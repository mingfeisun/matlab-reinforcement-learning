function new_up_pi = updateUPrimePi(xval,yval,POINTS,Ra)

actions=[];

R=POINTS(:,3);
Up=POINTS(:,4);
U=POINTS(:,5);
Pi=POINTS(:,6);

gamma = 1; %discount factor
pGood = 0.8; %probability of taking intended action
pBad = (1-pGood)/2; % 2 bad actions, split prob between them

sink=find(POINTS(:,3)==0);%row no. of sink point in POINTS
xSink=POINTS(sink(1),1);
ySink=POINTS(sink(1),2);

Xmax=max(POINTS(:,1));
Ymax=max(POINTS(:,2));

for k=1:size(POINTS,1)
    if (POINTS(k,1)==xval && POINTS(k,2)==yval)
        if R(k)~=Ra %If at a sink state or unreachable state 'terminals' , use that value
            Up(k)=R(k);
        else %use Bellman equation  "computed using U(s), not U'(s))"
            aN= aNorth(xval,yval,xSink,ySink,Ymax,U,POINTS,k);
            aS= aSouth(xval,yval,xSink,ySink,U,POINTS,k);
            aW= aWest(xval,yval,xSink,ySink,U,POINTS,k);
            aE= aEast(xval,yval,xSink,ySink,U,Xmax,POINTS,k);
                      
            actions(1)= aN*pGood + aW*pBad + aE*pBad;
            actions(2)= aS*pGood + aW*pBad + aE*pBad;
            actions(3)= aW*pGood + aS*pBad + aN*pBad;
            actions(4)= aE*pGood + aS*pBad + aN*pBad;
            
            best= maxindex(actions);
            
            Up(k)= R(k) + gamma*actions(best);
                       
            %-------Update Pi 'Policy'
            if best==1
               Pi(k)='N';
            else if best==2
                    Pi(k)='S'; 
                else if best==3
                        Pi(k)='W';
                    else
                        Pi(k)='E';
                    end
                end
            end
            %-------
            
        end
        
    end
end

new_up_pi=[Up,Pi];

end

