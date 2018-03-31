function uValue = aWest(xval,yval,xSink,ySink,U,POINTS,k)

% can't go west if at X=1 or if in cell above sink 'because it will go to sink cell'
if ((xval==1) || (xval==xSink+1 && yval==ySink))
    uValue=U(k);
else
    for h=1:size(POINTS,1)
        if (POINTS(h,1)==xval-1 && POINTS(h,2)==yval)
            row=h;
        end
    end
    uValue=U(row);
end

end
