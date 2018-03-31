function uValue = aSouth(xval,yval,xSink,ySink,U,POINTS,k)

% can't go south if at Y=1 or if in cell above sink 'because it will go to sink cell'
if ((yval==1) || (xval==xSink && yval==ySink+1))
    uValue=U(k);
else
    for h=1:size(POINTS,1)
        if (POINTS(h,1)==xval && POINTS(h,2)==yval-1)
            row=h;
        end
    end
    
    uValue=U(row);
end

end

