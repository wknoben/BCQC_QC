function f_FillGap_ML(OutpathFillvv,FileGauge,IDne_numvv,varvv,Validnum,stnorder)
% dbstop if error
%1. read station data
% basic information
% 
% clearvars
% load('sampleParamsPRCP.mat')
% IDne_numvv=IDne_num{1,1};

ID=ncread(FileGauge,'ID');
LLE=ncread(FileGauge,'LLE');

% variable data. only using data with flag==0
data_stn=ncread(FileGauge,varvv);
data_stn=single(data_stn);
command=['flag1=ncread(FileGauge,''',varvv,'_qf'');'];  %_QC: quality control data
eval(command);
command=['flag2=ncread(FileGauge,''',varvv,'_qfraw'');'];  %_QC: quality control data
eval(command);
data_stn(flag1>0)=nan; data_stn(flag2>0)=nan;
clear flag1 flag2

% basic control of stations using Validnum
samnum1=sum(~isnan(data_stn));
indexfill=samnum1>=Validnum.all;
data_stn(:,~indexfill)=nan;

%3. initialization of outputs
for gg=stnorder(1)+1:stnorder(2)
    fprintf('Filling: %s--current %d--total %d\n',varvv,gg,stnorder(2));
    IDgg=ID(gg,:); LLEgg=LLE(gg,:);
    outfilegg=[OutpathFillvv,'/',num2str(gg),'.mat'];
%    if exist(outfilegg,'file'); continue; end
    
    % 4. gap filling preparation
    %4.1 basic identification
%     if ~indexfill(gg)  % the station does not satisfy Validnum
%         save(outfilegg,'gg');
%         continue;
%     end
    
    %4.1 read data: read target station data and its cdf data
    % separte it into two parts
    data_stngg=data_stn(:,gg);

    %4.1 read data: read NE (neighboring) stations and cdf data (all doy 1-366)
    IDne_numgg=IDne_numvv(gg,:); %[30]
    IDne_numgg(isnan(IDne_numgg))=[];
    if ~isempty(IDne_numgg)
        data_stn_negg=data_stn(:,IDne_numgg);
    else
        continue;
    end
    
    % Start gap filling

    % Machine learning filling:
    % Data preparation:
    [xdata,ydata,xcomb]=ff_MLdata(data_stn_negg,data_stngg);
%     if isempty(xdata)
%         save(outfilegg,'gg');
%         continue;
%     end
    
    xdata=data_stn_negg; 
    ydata=data_stngg;
    maxnum=min(size(xdata,2),5);
    xcomb=1:maxnum;
   
    % Remove xdata that has nans in the time periods of interest -C.Hart
    % modifed section ($)
    temp=isnan(data_stngg);  % Find where the nans are that are intended to be filled
    nans=find(temp==1);  % Calculate the time location of these nans
    
    for ii=1:size(xdata,2)  % Iterate through the nearest stations        
         tempX=isnan(xdata(:,ii)); % and find where the nans of those stations
         valid(ii)=sum(tempX(nans)); % overlap with that nans in the current station  
    end
    rmStation=find(valid>0); % Convert these overlapping time-series to an integer 
    xdata(:,rmStation)=[]; % Remove the overlapping stations from the xdata variable
    
    % estimate
    VarFill_RF=f_MLfill(xdata,ydata,xcomb,varvv);
    VarFill_RF=VarFill_RF(:,1);
    % evaluate
    KGEFill_RF=ff_KGE(data_stngg,VarFill_RF);
    
    NumComb=size(xcomb,1);
    save(outfilegg,'VarFill_RF','KGEFill_RF','IDgg','LLEgg','gg','data_stngg','NumComb','-v7.3');
end

end


