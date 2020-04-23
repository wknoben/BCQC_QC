% function Fill_ML(stnorder1,stnorder2,varnamein)
% function Fill_ML()
stnorder1=1; stnorder2=713;
% 
varnames={'tmax','tmin'};
% varnames={'prcp','tmax','tmin'};
% 
% LSTMflag=0;
% varnames={varnamein};
if ischar(stnorder1)
    stnorder1=str2double(stnorder1);
end
if ischar(stnorder2)
    stnorder2=str2double(stnorder2);
end

stnorder=[stnorder1,stnorder2];
fprintf('Station order is %d--%d\n',stnorder1,stnorder2);

%0 Basic inputs
% % Plato
FileGauge='/Users/cjh458/Desktop/Guoqiang_WF/4unify_data/bcqc_UNI/AllGauge_QC_bcqc_noflags.nc4';
% output files
Outpath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/';

%1 Basic settings
Validnum.all=0;  % the least number of valid samples for each station and each variable to be included in the gap filling process
Validnum.month=0;  % the least number of valid samples for each month
radius=4000; % searching the nearest neightboring stations within the radius
leastne=0; % the least number of nearest gauges that is required to fill the target gauge

%3 Calculate the CC between station data and reanalysis data
% CCreaall=cell(length(varnames),1);
% for vv=1:length(varnames)
%     varvv=varnames{vv};
%     filevv=['CCrea_',varvv,'.mat'];
%     if exist(filevv,'file')
%         load(filevv,'CCrea');
%     else
%         CCrea=f_CCrea(FileGauge,FileRea,varvv);
%         save(filevv,'CCrea');
%     end
%     CCreaall{vv}=CCrea;
%     clear CCrea
% end

%4 for each station, calculate the index nearest neighbor stations
%this step takes much time
IDne_num=cell(length(varnames),1);
for vv=1:length(varnames)
    varvv=varnames{vv};
%     CCreavv=CCreaall{vv};
    CCreavv=-999;
    filevv=['IDne_info_',varvv,'.mat'];
    IDne_numv=f_findnear(FileGauge,varvv,radius,leastne,Validnum,filevv,CCreavv);
    IDne_num{vv}=IDne_numv;
    clear IDne_numv
end
% load('/Users/cjh458/Desktop/Guoquiang_WF/3quality_control/IDne_num.mat')

%6 for each station, fill the gap
for vv=1:length(varnames)
    OutpathFillvv=[Outpath,'/ML_',varnames{vv}];
    if ~exist(OutpathFillvv,'dir'); mkdir(OutpathFillvv); end
    % gap filling and save them as individual files
    varvv=varnames{vv};
    f_FillGap_ML(OutpathFillvv,FileGauge,IDne_num{vv},varvv,Validnum,stnorder);
end

% end

function IDne_num=f_findnear(FileGauge,varvv,radius,leastne,Validnum,filevv,CCreavv)
numGauge=20;
if exist(filevv,'file')
    fprintf('IDne information file exists. Loading...\n');
    load(filevv,'IDne_num');
    return;
end
if strcmp(varvv,'prcp')
    CCtype='Spearman';
else
    CCtype='Pearson';
end
% min CCreavv
CCreavvmin=nanmin(CCreavv);

% this version is based on v2, but use .nc4 as inputs and can handle every
% variable
overyear=0; % the nearest gauge must have more than 5-year overlap period with the target gauges

% read the variable data
% variable data. only using data with flag==0
dstn=ncread(FileGauge,varvv);
command=['flag1=ncread(FileGauge,''',varvv,'_qf'');'];  %_QC: quality control data
eval(command);
command=['flag2=ncread(FileGauge,''',varvv,'_qfraw'');'];  %_QC: quality control data
eval(command);
dstn(flag1>0)=nan; dstn(flag2>0)=nan;
clear flag1 flag2

lle=ncread(FileGauge,'LLE');
lat=lle(:,1);
lon=lle(:,2);
gnum=length(lat);
IDnum=(1:gnum)';

% find stations that don't satisfy Validnum
temp1=sum(~isnan(dstn));
indno=temp1<Validnum.all;
dstn(:,indno)=nan;
lat(indno)=nan;
lon(indno)=nan;

% initialization
IDne_num=nan*zeros(gnum,numGauge);
IDne_cc=nan*zeros(gnum,numGauge);
IDne_dist=nan*zeros(gnum,numGauge);

for i=1:gnum
    fprintf('%s Find Near Gauge %d--%d\n',varvv,i,gnum);
   
    % calculate distance
    disi=zeros(gnum,2);
    disi(:,1)=IDnum;
    disi(:,2)=f_lldistkm(lat(i),lon(i),lat,lon);
    disi(i,2)=100000;
    % exclude too far gagues
    disi(disi(:,2)>radius|isnan(disi(:,2)),:)=[];
    IDne=disi(:,1);
    
    % calculate the CC between target and neighboring stations
    vtar=dstn(:,i);
    vne=dstn(:,IDne);
    CCne=nan*zeros(length(IDne),1);
    for in=1:length(IDne)
        dg=[vne(:,in),vtar];
        dg(isnan(dg(:,1))|isnan(dg(:,2)),:)=[];
        if size(dg,1)>overyear*365
            CCne(in)=corr(dg(:,1),dg(:,2),'Type',CCtype);
        end
    end
    
    % exclude some stations
    indi=CCne<-1 | isnan(CCne);
    disi(indi,:)=[];
    CCne(indi)=[];
    numne=length(CCne);
    
    if numne>=leastne
        [CCne,indsort]=sort(CCne,'descend');
        disi=disi(indsort,:);
        numne=min(numne,numGauge);
        IDne_num(i,1:numne)=disi(1:numne,1);
        IDne_cc(i,1:numne)=CCne(1:numne);
        IDne_dist(i,1:numne)=disi(1:numne,2);
    end    
end
save(filevv,'IDne_num','IDne_cc','IDne_dist','-v7.3');

end

