function days=f_days(year,month)
switch month
    case {1,3,5,7,8,10,12}
        days=31;
    case {4,6,9,11}
        days=30;
    case 2
        if (mod(year,4)==0&&mod(year,100)~=0)||mod(year,400)==0
            days=29;
        else
            days=28;
        end
end
end