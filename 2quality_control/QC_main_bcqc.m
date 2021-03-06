clc;clear;close all
% Plato path
% Inpath='/home/gut428/GapFill/Data/AllGauge';
% Outpath='/home/gut428/GapFill/Data/AllGauge_QC';
% mac path
Inpath='/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/bcqc_dataMat/';
Outpath='/Users/cjh458/Desktop/BCQC_QC/2quality_control/QC_TP_bcqc';
mkdir(Outpath);
% GaugeInfo0=[Inpath,'/GaugeInfo.mat'];
load('/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/gaugeInfo_bcqc.mat')
IDall=ID; clear ID
% copyfile(GaugeInfo0,Outpath);
% % (1) basic time length and valid data ratio control
% % Flag 0: don't use, 1: use
% BCfile='GaugeInfo.mat';
% BC.validratio=[0.7,0.7,0.7]; % [prpc tmin tmax]. if none of the variables reach the validratio, the gauge is excluded
% BC.ylen=8;
% BC.yrange=[1979,2018];
% if ~exist(BCfile,'file')
%     BCindex=f_BasicControl(Inpath,ID,LLE,BC);
%     save(BCfile,'BCindex');
% else
%     load(BCfile,'BCindex');
% end
% 
% ID(BCindex==0)=[];
% Source(BCindex==0)=[];
% LLE(BCindex==0,:)=[];
% Year(BCindex==0,:)=[];
% BCindex(BCindex(:,1)==0,:)=[];

% (2) for each gauge, find up to ten closest gauges within the radius of 400 km
% which should have similar len coverage
IDnefile='IDne_num.mat';                                                                %Make sure to delete existing IDall file if using different sites!
if ~exist(IDnefile,'file')
    radius=400; % find up to 10 nearest gauges within 400 km
    [IDne_num,IDne_dist]=f_FindNearGauge(double(LLE(:,1)),double(LLE(:,2)),radius);
    save(IDnefile,'IDne_num','IDne_dist');
else
    load(IDnefile,'IDne_num','IDne_dist');
end
% (3) quality control model
for i=1:length(IDall)  % 
    Infile=[Inpath,'/bcqc_',num2str(IDall{i}),'.mat'];
%     Infile=strcat(Inpath,'/bcqc_',num2str(IDall{i}),'.mat');
    Outfile=[Outpath,'/bcqc_',num2str(IDall{i}),'.mat'];
%     Outfile=strcat(Outpath,'/bcqc_',num2str(IDall{i}),'.mat');
    fprintf('Quality control %d--%d\n',i,length(IDall));
    if ~exist(Outfile,'file')
        % read target gauge
        load(Infile);      
        date=data(:,1);
        p=data(:,2);
        swe=data(:,3);
        swowD=data(:,4);
        Tmin=data(:,5);
        Tmax=data(:,6);
        Tmean=(Tmin+Tmax)/2;
        
        NEcal.tarind=i;
        NEcal.lleall=LLE;
        NEcal.IDall=IDall;
        NEcal.Inpath=Inpath;
        
        % GHCND quality control of precipitation
        Qflag_prcp1=f_GHCNDQC_P(p,date,NEcal,Tmean);
        
        % APHRODITE quality control of precipitation
        temp=IDne_num(i,:); temp(isnan(temp))=[];
        if length(temp)>=5 % at least five, at most ten
            IDne=IDall(temp);
            pne=f_NearGaugeData(Inpath,IDne,date);
        else
            pne=[];
        end
        Qflag_prcp2=f_APHROQC_P(p,pne,date);
        
        % quality control of temperature
        [Qflag_tmin,Qflag_tmax]=f_GHCNDQC_T(Tmin,Tmax,date,NEcal);
                
        copyfile(Infile,Outfile);
        save(Outfile,'Qflag_tmin','Qflag_tmax','Qflag_prcp1','Qflag_prcp2','-append'); % just update "data"
    end
end