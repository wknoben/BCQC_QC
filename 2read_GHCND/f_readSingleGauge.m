function [Gdata,Gflag]=f_readSingleGauge(file,Var)
% dbstop if error

% obtain the start and end years because the year range provided in
% inventory is not always correct
fid=fopen(file,'r');
lio=fgetl(fid);
years=str2double(lio(12:15));
fseek(fid,-270,'eof');
lio=fgetl(fid);
yeare=str2double(lio(12:15));
fseek(fid,0,'bof');

% initialization
daysf=(yeare-years+1)*12*31; % fake day numbers, every month has 31 values in files
data=nan*zeros(daysf,length(Var));
date=nan*zeros(daysf,1);
temp=char(ones(daysf,1) * 'XXX'); % MFLAG,QFLAG,SFLAG
Gflag=cell(length(Var),1);
Gflag(:)={temp}; clear temp

% read data
dateold='000000';
samid=-30;
while ~feof(fid)
    li=fgetl(fid);
    if length(li)==269
        % decide whether the code comes to a new month
        datenew=li(12:17);
        if ~strcmp(datenew,dateold)
            dateold=datenew;
            samid=samid+31;  
            date(samid:samid+30)=str2double(datenew);
        end
        % which var is under processing
        vari=li(18:21);
        [ism,varid]=ismember(vari,Var);
        if ism
            % extract values
            temp1=nan*zeros(31,1);
            temp2=char(ones(31,1) * 'XXX');
            li=li(22:end);
            for dd=1:31
                temp1(dd)=str2double(li((dd-1)*8+1:(dd-1)*8+5));
                temp2(dd,:)=li((dd-1)*8+6 : (dd-1)*8+8);
%                 qflag0=li((dd-1)*8+7);
%                 if strcmp(qflag0,' ')
%                     temp2(dd)=1; % good quality
%                 else
%                     temp2(dd)=0; % unsure or bad quality
%                 end
            end
            data(samid:samid+30,varid)=temp1;
            Gflag{varid}(samid:samid+30,:)=temp2;
        end
        clear li
    else
        clear li
    end
end
fclose(fid);
if samid+30<daysf
    data(samid+31:end,:)=[];
    date(samid+31:end,:)=[];
    for i=1:length(Gflag)
        Gflag{i}(samid+31:end,:)=[];
    end
end
% delete fake dates
months=length(date)/31;
indd=zeros(length(date),1);
for i=1:months
    year=floor(date(i*31-1)/100);
    month=date(i*31-1)-year*100;
    daynumi=f_days(year,month);
    indd(i*31-30:i*31+daynumi-31)=1;
    
    % convert date from yyyymm to yyyymmdd
    tempdate=date(i*31-30:i*31+daynumi-31);
    dayser=(1:daynumi)';
    tempdate=tempdate*100+dayser;
    date(i*31-30:i*31+daynumi-31)=tempdate;
end

indd2=indd==0;
data(indd2,:)=[];
date(indd2,:)=[];
for i=1:length(Gflag)
    Gflag{i}(indd2,:)=[];
end
Gdata=[date,data];
end
