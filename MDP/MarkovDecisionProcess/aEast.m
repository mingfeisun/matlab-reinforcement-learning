function uValue = aEast(xval,yval,xSink,ySink,U,Xmax,POINTS,k)

% can't go east if at Xmax or if in cell above sink 'because it will go to sink cell'
if ((xval==Xmax) || (xval==xSink-1 && yval==ySink))
    uValue=U(k);
else
    for h=1:size(POINTS,1)
        if (POINTS(h,1)==xval+1 && POINTS(h,2)==yval)
            row=h;
        end
    end
    uValue=U(row);
end

end


