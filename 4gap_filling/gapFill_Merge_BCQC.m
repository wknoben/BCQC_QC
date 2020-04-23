% % % % % % % % % % % % % % % % % % % % % 
% % COMBINE FILLING DATA WIth EXISTING % %
% % % % % % % % % % % % % % % % % % % % % 

% This script combines the ML (machine learning data with origional station
% data, then outputs .csv files for input files for metSim (Meteorolgical simulator) 
% It also does a pre-check by iterating through station data and checking
% that QC procedures haven't flagged more that 20-30% of the data

% Change directory into the gap-filling file
cd('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian');

% Set some paths to existing folders for collecting data
prcpPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_prcp';
tmaxPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_tmax';
tminPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/ML_tmin';
bcqcPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/bcqc_data';
bcqcFilePath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/bcqcData/bcqc_data_fileNames';
bcqcOutputPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/bcqcData';

% Set absolute path to a .mat file with information about the gauges
gaugePath='/Users/cjh458/Desktop/snoTEL_QC/3quality_control/gaugeInfo1.mat'; 
% load('/Users/cjh458/Desktop/snoTEL_QC/1find_stations/snoTELstations.mat') %load snoTEL information file with origional station data
% load('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/date.mat') % load a time-series that has the dates for simulation period
load('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/bcqcData/bcqc_fileNames/LIST_BCQC.mat')

% load(gaugePath) %load this file into the work environment
% 
% for i=1:length(fileLIST) % Iterate through the ID values in this file, (the first file didn't work, due to bad data)
% 
% %     load('/Users/cjh458/Desktop/snoTEL_QC/1find_stations/snoTELstations.mat') %load snoTEL information file with origional station data
%     load('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/date.mat') % load a time-series that has the dates for simulation period
%     
%     for j=1:length(LLE)
%         
%         if(strlength(LLE(j,1))==5)
%             name1=sprintf('%0.2f',name(i,2));
%         end
%         if(strlength(LLE(j,2))==7)
%             name2=sprintf('%0.2f',name(i,3));
%         end
%         if(strlength(LLE(j,1))==4)
%             name1=sprintf('%0.1f',name(i,2));
%         end
%         if(strlength(LLE(j,2))==6)
%             name2=sprintf('%0.1f',name(i,3));
%         end
%         if(strlength(LLE(j,1))==2)
%             name1=sprintf('%0.0f',name(i,2));
%         end
%         if(strlength(LLE(j,2))==4)
%             name2=sprintf('%0.0f',name(i,3));
%         end
% 
%         str1=strcmp(LLE(j,1),name1); % Compare Lat strings to information from the snoTEL sites
%         str2=strcmp(LLE(j,2),name2); % Compare Lon strings to information from the snoTEL sites
%   
%         if (str1==1) && (str2==1) % If both of these information fields are correct, create an entry in the LLE matrix and ID cell array                           
%             FL(i)=j;
%         end
%         
%     end
% end
nanp=zeros(713,1);
% Create a time-series that of IDs to search through that doesn't include stations with too many Nans
for i=1:713 %iterate through the ID values in this file

    cd(bcqcPath)
    data=zeros(638,4);

    file=fileLIST{i}; %Create a file name to open
    if exist(file, 'file') == 2     %check if this file exists
        bcqc=load(file);                 % If so, load file
        tsstart=find(bcqc(:,1)==2017 & bcqc(:,2)==1 & bcqc(:,3)==1); % find the start of the time-series we are interested in
        tsend=find(bcqc(:,1)==2018 & bcqc(:,2)==9 & bcqc(:,3)==30); % find the start of the time-series we are interested in

        outputFile=strcat('bcqc_',num2str(LISTSTATION(i)),'.csv');

        data(:,1)=bcqc(tsstart:tsend,4);
        data(:,2)=bcqc(tsstart:tsend,8);
        data(:,3)=bcqc(tsstart:tsend,5);
        data(:,4)=bcqc(tsstart:tsend,6);
        nanp(i,1)=sum(sum(isnan(data)));

        cd(bcqcOutputPath)
%             T=array2table(data); % Create a table from this Matrix
%             T.Properties.VariableNames(1:4) = {'prec','swe','tmin','tmax'}; % Set table header names
%             writetable(T,outputFile); % write this table to file 
        clear data
    end      
end
% Nanpi=(Nanp/730)*100; % calculate the percentage of missing data points 
% percent=30; %threashold for missing data
% ts=2:length(ID); %initialize an origional timeseries list;
% 
% ans1=find(Nanpi(:,1)>percent); % find stations where prcp has more that 30 % nans
% ans2=find(Nanpi(:,2)>percent); % find stations where tmax has more that 30 % nans
% ans3=find(Nanpi(:,3)>percent); % find stations where tmin has more that 30 % nans
% 
% threashold=vertcat(ans1,ans2,ans3); % append time-series together
% threashold=sort(threashold); % sort this time-series from smallest to largest
% threashold=unique(threashold); % eliminate repeated values from this time-series
% 
% ts=2:length(ID); %initialize an origional timeseries list;
% 
% ts(threashold-1)=[]; % remove numbers form ts that exceed the missing number threashold
% ID(threashold-1)=[]; % remove numbers form ID that exceed the missing number threashold
% LLE(threashold-1,:)=[]; % remove numbers form LLE that exceed the missing number threashold
% 
% cd(tminPath) % cd into directory with precipitation and ML data
% 
% for i=2:length(ID) % iterate through the ID values in this file, (the first file didn't work, due to bad data)
% 
%     file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
%     
%     if exist(file, 'file') == 2 % check if this file exists; and if so ...
%         
%         load(file);  % load the file into the work space
%         
%         dataTmin(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
%         temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
%         nans=find(temp==1);  % calculate the time location of these nans
%         
%         dataTmin(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    
% 
%     end
% end
% 
% cd(tmaxPath) % cd into directory with precipitation and ML data
% 
% for i=2:length(ID) %iterate through the ID values in this file, (the first file didn't work, due to bad data)
% 
%     file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
%     
%     if exist(file, 'file') == 2 % check if this file exists; and if so ...
%         
%         load(file);  % load the file into the work space
%         
%         dataTmax(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
%         temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
%         nans=find(temp==1);  % calculate the time location of these nans
%         
%         dataTmax(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    
% 
%     end
% end
% 
% cd(prcpPath) % cd into directory with precipitation and ML data
% 
% for i=2:length(ID) %iterate through the ID values in this file, (the first file didn't work, due to bad data)
% 
%     file=strcat(num2str(i),'.mat'); % create a string corresponding to the name of ML output files
%     
%     if exist(file, 'file') == 2 % check if this file exists; and if so ...
%         
%         load(file);  % load the file into the work space
%         
%         dataPrcp(:,i)=data_stngg;  % set a new data variable = to the existing one in the loaded file
%         temp=isnan(data_stngg);  % find where the nans are that are intended to be filled
%         nans=find(temp==1);  % calculate the time location of these nans
%         
%         dataPrcp(nans,i)=VarFill_RF(nans);  % set the location of the nans == to the ML data    
% 
%     end
%     
%     zero=find(dataPrcp<0); % Basic QC to remove any negitive values induced by the ML
%     dataPrcp(zero)=0;  % Set any negative values equal to zero
% end
% 
% clearvars -except ID dataPrcp dataTmax dataTmin LLE gaugePath % clean up work space except fo any values that will be written.
% 
% csvPath='/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/dataCSV'; % Create a new path to where csvs will be written
% mkdir(csvPath); % Make a new folder == to the path
% cd(csvPath); % Change directory into a folder where out put will be written
% 
% for i=2:length(ID) % Iterate through the ID values in this file, (the first file didn't work, due to bad data)
% 
%     load('/Users/cjh458/Desktop/snoTEL_QC/1find_stations/snoTELstations.mat') %load snoTEL information file with origional station data
%     load('/Users/cjh458/Desktop/Guoqiang_WF/7GapFill_forChristian/date.mat') % load a time-series that has the dates for simulation period
% 
%     for j=1:length(snoTELstations)
%         
%         str1=strcmp(LLE(i,1),snoTELstations(j,1)); % Compare Lat strings to information from the snoTEL sites
%         str2=strcmp(LLE(i,2),snoTELstations(j,2)); % Compare Lon strings to information from the snoTEL sites
%   
%         if (str1==1) && (str2==1) % If both of these information fields are correct, create an entry in the LLE matrix and ID cell array                           
% 
%             load(gaugePath) % Load this file into the work environment    
%             outputFile=strcat(num2str(snoTELstations(j,4)),'_snotel.csv'); % Create a string that'll be used as an output name, which includes the staion #
% 
%             output=zeros(730,8); % initialize array to the size of interest
% 
%             output(:,1)=snoTELstations(j,1); % add snoTEL Latitude data to the output array
%             output(:,2)=snoTELstations(j,2); % add snoTEL Longitude data to the output array
%             output(:,3)=snoTELstations(j,3); % add snoTEL elevation data to the output array
%             output(:,4)=snoTELstations(j,4); % add snoTEL station number data to the output array
% 
%             output(:,5)=dateMat(:,1); % add date time-series to the output array
%             output(:,6)=dataTmax(:,i); % add Tmax data to the output array
%             output(:,7)=dataTmin(:,i); % add Tmin data to the output array
%             output(:,8)=dataPrcp(:,i); % add Prcp data to the output array
% 
%             T=array2table(output); % Create a table from this Matrix
%             T.Properties.VariableNames(1:8) = {'latitude','longitude','elev','site_id','date','temperature_max','temperature_min','precipitation'}; % Set table header names
%             writetable(T,outputFile); % write this table to file   
%             
%         end
%     end
% end
% 
% 
% 
