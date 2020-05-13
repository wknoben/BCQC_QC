% % % % % % % % % % % % % % % % % % % % % % % % 
% % % FORMATTING BCQC FILES into MAT FILES % % %
% % % % % % % % % % % % % % % % % % % % % % % % 

load('/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/bcqc_data/LIST_BCQC.mat') % import list of names and Lat x lon -- this was created by copying 
% all names with options key this matfile also includes a var LISTSTATION, which shows the station #s that correspond to lats and lons
bcqcDataPath = '/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/bcqc_data/'; % set path to where original bc1c data is
bcqcOutputPath='/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/bcqc_dataMat'; % set path to write .mat files into
len_station=length(LISTbcqc);
nanp=zeros(len_station,1); % initialize a variable that will be used to count the # of Nans in each time-series
    
% Create a time-series that of IDs to search through that doesn't include stations with too many Nans
for i=1:len_station %713 %iterate through the ID values in this file

    cd(bcqcDataPath) %change directory into path with origional data
    data=zeros(len_station,6); % initialize an empty array to be populated with formatted data

    file=LISTbcqc{i}; % Choose a file name to be used to open a file
    if exist(file, 'file') == 2     % check if this file exists
        bcqc=load(file);                 % If so, load it into the workspace
        tsstart=find(bcqc(:,1)==2017 & bcqc(:,2)==1 & bcqc(:,3)==1); % find the start of the time-series we are interested in
        tsend=find(bcqc(:,1)==2018 & bcqc(:,2)==9 & bcqc(:,3)==30); % find the start of the time-series we are interested in
        ii=0;    % initialize a counting variable
        for j=tsstart:tsend % iterate across the time period
            ii=ii+1;        % increase counting variable
            yearstr=sprintf('%4.0f',bcqc(j,1)); % Create a string for the year
            daystr=sprintf('%02d',bcqc(j,3));   % Create a string for the day
            monthstr=sprintf('%02d',bcqc(j,2)); % Create a string for the month
            data(ii,1)=str2num(strcat(yearstr,monthstr,daystr)); % Use this equation to concatonate strings then turn them into numbers
        end
        outputFile=strcat('bcqc_',num2str(LISTSTATION(i,1)),'.mat'); % Create a name for the outputfile
        ID=num2str(LISTSTATION(i,1));   % Create an ID for the outputfile
        data(:,2)=bcqc(tsstart:tsend,4)*25.4;   % set data = to prec and convert to mm
        data(:,3)=bcqc(tsstart:tsend,8)*25.4;   % set data = to swe and convert to mm
        data(:,4)=0;    % set data = to snow depth
        data(:,5)=(bcqc(tsstart:tsend,6)-32)*(5/9); % set data = to tmin and convert to C from F
        data(:,6)=(bcqc(tsstart:tsend,5)-32)*(5/9); % set data = to tmax and convert to C from F
        nanp(i,1)=sum(sum(isnan(data))); % sum the nans in the data for fun
        cd(bcqcOutputPath); % cd into directory where files will be written
 
        save(outputFile,'data','ID', 'varname', 'source', 'mqsflag', 'lle') % write these files into a folder
        clear data
    end      
end
