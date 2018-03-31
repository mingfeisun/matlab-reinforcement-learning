function maxValue = maxindex(a )

b=1;
for i=1:size(a,2)
    %b = (a(b) > a(i)) ? b : i;  % '?'=then , ':'=else
    if a(b) > a(i)
        b=b;
    else
        b=i;
    end   
end

maxValue= b;

end

