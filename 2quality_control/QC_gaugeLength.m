% % % % % % % % % % % % % % % % % % % %
% % This script eliminates guages   % %
% %  with insufficient information  % %
% % % % % % % % % % % % % % % % % % % % 
% Gauge='gaugeInfo4.mat'
Gauge='/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/gaugeInfo1.mat';
%load the output file from GHCN_read_plato.m, which finds valid snotel gauges
%load('/Users/cjh458/Desktop/Guoquiang_WF/2read_GHCND/ghcnd_scripts/GaugeValid1.mat')
load(Gauge)
%change directory into folder containing matlab files with snoTEL data
%cd('/Users/cjh458/Desktop/Guoquiang_WF/3quality_control/ghcnd_QC_TP')

for i=1:length(ID) %iterate through the ID values in this file
%     load('/Users/cjh458/Desktop/Guoquiang_WF/2read_GHCND/ghcnd_scripts/GaugeValid1.mat')
    load(Gauge) %load file again bc it was modified
    file=strcat(ID(i),'.mat'); %create a string matching a matlab file that contains data from this station
    load(char(file));%load the file contained in this string         
    len(i)=length(data);%calculate the length of this file
    len1(i)=length(data);%calculate the length of this file
%     QC(i)=length(Qflag_prcp1);
%     if(sum(isnan(data(:)))>0)
%         break;
%         break;
%     end
%     p(i)=legnth;
    Nanp(i)=sum(isnan(data(:,6)));
    Nanp1(i)=sum(isnan(data(:,6)))/(length(data)*5);
    
%     prcp(:,i)=data(:,2);
end
load(Gauge) %load file again bc it was modified
Valid=find(len==730); %find all stations with the right amount of data
for i=1:length(Valid) %iterate from 1 to the total number of valid stations
   ID1(i,1)=ID(Valid(i)); %store valid IDs in temporaty variable
   LLE1(i,1:3)=LLE(i,1:3); %store valid LLE in a temporary variable
end
ID=ID1; LLE=LLE1; %re-declace ID and LLE varaible
clearvars -except ID LLE % QC len Nanp Nanp1 %clear temporary and other variables
% save gaugeInfo3.mat % save a new gaugeInfo

