% % % % % % % % % % % % % % % 
% % FORMAT GAUGEINFO BCQC % %
% % % % % % % % % % % % % % % 

load('/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/gaugeInfo.mat')    %Import gaugeInfo file with data for GHCND
load('/Users/cjh458/Desktop/Guoqiang_WF/2read_GHCND/bcqc_data/LIST_BCQC.mat')   %Import a list containing info for BCQC
load('/Users/cjh458/Desktop/Guoqiang_WF/2read_GHCND/bcqc_data/ID1.mat')     % Import a list of ID numbers for bcqc

for i=1:length(ID1) % iterate through bcqc stations
    for j=1:length(LLE) % iterate through ghcnd stations
        
        lat1=sprintf('%2.2f',LISTSTATION(i,2)); % sprintf a string of disired percision for lat
        lon1=sprintf('%4.2f',LISTSTATION(i,3)); % sprintf a string of disired percision for lon
        
        lat2=sprintf('%2.2f',str2num(LLE(j,1))); % sprintf a string of disired percision for lat
        lon2=sprintf('%2.2f',str2num(LLE(j,2))); % sprintf a string of disired percision for lon
        
        str1=strcmp(lat1,lat2); % compare the lat strings
        str2=strcmp(lon1,lon2); % compare the lon strings
        
        if (str1==1) && (str2==1)    % If both of these information fields are correct, create a new entry into LLE file                         
            
            LLE1(i,1)=LISTSTATION(i,2); % Set LLE equal to the lat of station data
            LLE1(i,2)=LISTSTATION(i,3); % Set LLE equal to the lon of station data
            LLE1(i,3)=LLE(j,3); % Set LLE equal to the elev of GHCND data
            
        end    
    end
end
 
clearvars -except ID1 LLE1
        
