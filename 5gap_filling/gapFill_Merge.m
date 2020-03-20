% % % % % % % % % % % % % % % % % % % % % 
% % COMBINE FILLING DATA WIth EXISTING % %
% % % % % % % % % % % % % % % % % % % % % 

% This script combines the ML (machine learning data with origional station
% data, then outputs .csv files for input files for metSim (Meteorolgical simulator) 

% Change directory into the gap-filling file
cd('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian');

% Set some paths to existing folders for collecting data
prcpPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_prcp';
tmaxPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_tmax';
tminPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_tmin';

% Set absolute path to a .mat file with information about the gauges
gaugePath='/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/gaugeInfo1.mat'; 
load(gaugePath) %load this file into the work environment

cd(tminPath) % cd into directory with precipitation and ML data

for i=2:length(ID) % iterate through the ID values in this file, (the first file didn't work, due to bad data)

    file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
    
    if exist(file, 'file') == 2 % check if this file exists; and if so ...
        
        load(file);  % load the file into the work space
        
        dataTmin(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
        temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
        nans=find(temp==1);  % calculate the time location of these nans
        
        dataTmin(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    

    end
end

cd(tmaxPath) % cd into directory with precipitation and ML data

for i=2:length(ID) %iterate through the ID values in this file, (the first file didn't work, due to bad data)

    file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
    
    if exist(file, 'file') == 2 % check if this file exists; and if so ...
        
        load(file);  % load the file into the work space
        
        dataTmax(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
        temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
        nans=find(temp==1);  % calculate the time location of these nans
        
        dataTmax(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    

    end
end

cd(prcpPath) % cd into directory with precipitation and ML data

for i=2:length(ID) %iterate through the ID values in this file, (the first file didn't work, due to bad data)

    file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
    
    if exist(file, 'file') == 2 % check if this file exists; and if so ...
        
        load(file);  % load the file into the work space
        
        dataPrcp(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
        temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
        nans=find(temp==1);  % calculate the time location of these nans
        
        dataPrcp(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    

    end
    
    zero=find(dataPrcp<0); % Basic QC to remove any negitive values induced by the ML
    dataPrcp(zero)=0;  % Set any negative values equal to zero
end

clearvars -except ID dataPrcp dataTmax dataTmin LLE gaugePath % clean up work space except fo any values that will be written.

csvPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/dataCSV'; % Create a new path to where csvs will be written
mkdir(csvPath); % Make a new folder == to the path
cd(csvPath); % Change directory into a folder where out put will be written

for i=2:length(ID) % Iterate through the ID values in this file, (the first file didn't work, due to bad data)

    load('/Users/cjh458/Desktop/Guoqiang_WF/1find_stations/snoTELstations.mat') %load snoTEL information file with origional station data
    load('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/date.mat')

    load(gaugePath) % Load this file into the work environment    
    outputFile=strcat(num2str(snoTELstations(i,4)),'_snotel.csv'); % Create a string that'll be used as an output name
    
    output=zeros(730,8);
    
    output(:,1)=snoTELstations(i,1);
    output(:,2)=snoTELstations(i,2);
    output(:,3)=snoTELstations(i,3);
    output(:,4)=snoTELstations(i,4);
    output(:,5)=dateMat(:,1);
    output(:,6)=dataTmax(:,i);
    output(:,7)=dataTmin(:,i);
    output(:,8)=dataPrcp(:,i);
    
    T=array2table(output);   % Create a table from this Matrix
    T.Properties.VariableNames(1:8) = {'latitude','longitude','elev','site_id','date','temperature_max','temperature_min','precipitation'}; % Set table header names
    writetable(T,outputFile); % write this table to file
    
end


