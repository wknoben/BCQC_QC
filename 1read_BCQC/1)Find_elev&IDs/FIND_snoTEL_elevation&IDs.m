% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % This script performs a search using Lat and Lons from the snoTEL % %
% % and a data file downloaded from GHCND's website to find snoTEL   % %
% % data files within the GHCND database                             % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

cd '/Users/cjh458/Desktop/snoTEL_QC/1find_stations';                                  % Change directory into the right folder

load('/Users/cjh458/Desktop/Guoqiang_WF/1find_stations/FIND_SWE_INFO/GHCNDstations.mat'); % Load list containing all the GHCND station IDs LLEs locations
load('/Users/cjh458/Desktop/Guoqiang_WF/1find_stations/FIND_SWE_INFO/LLES_snotel');     % Load a matrix with all the snotel IDs LLEs and ELEV

outFILE='guageInfo_swe.mat';                                                                % Declare name for guageInfo file used in QC_main.m                                    
count=0;                                                                                % Declare counding variable for writing station info to files

for j=1:length(snoTELstations)                                                          % Iterate through GHCND stations
    for i=1:length(GHCNDstations)                                                       % Iterate through LLE from snoTEL sites
        
        str1=strcmp(GHCNDstations(i,3),snoTELstations(j,2));                            % Compare strings in GHCND file to information from the snoTEL sites
        str2=strcmp(GHCNDstations(i,2),snoTELstations(j,1));                            % Compare strings in GHCND file to information from the snoTEL sites
  
        if (str1==1) && (str2==1)                                                       % If both of these information fields are correct, create an entry in the LLE matrix and ID cell array                           
            count=count+1;                                                              % Iterate the count variable by one                                                              
            LLE(count,1)=snoTELstations(j,1);                                           % Set latitude = to that of the snoTEL station
            LLE(count,2)=snoTELstations(j,2);                                           % Set longitude = to that of the snoTEL station
            LLE(count,3)=snoTELstations(j,3);                                           % Set elevation = to that of the snoTEL station
            LLE(count,4)=i;
            LLE(count,5)=j;
            ID{count}=GHCNDstations(i,1);                                               % Set ID cell = to that of the GHCND station
            ID1{count}=snoTELstations(j,4);  
        end                                                                             % End if statment
    end                                                                                 % End j for statment
end                                                                                     % End i for statment

clearvars -except LLE ID ID1                                                            % Clear all variables except LLE ID
save gaugeInfo.mat                                                                      % Write this to a matlab file

ID(:,2)=cellstr(LLE(:,1));                                                              % Add variables to cellstr
ID(:,3)=cellstr(LLE(:,2));                                                              % Add variables to cellstr
ID(:,4)=cellstr(LLE(:,3));                                                              % Add variables to cellstr
T=cell2table(ID);                                                                       % Convert cellstr to a table
T.Properties.VariableNames{1} = 'ID';                                                   % Write headers to the table
T.Properties.VariableNames{2} = 'lat';                                                  % Write headers to the table
T.Properties.VariableNames{3} = 'lon';                                                  % Write headers to the table
T.Properties.VariableNames{4} = 'elevation';                                            % Write headers to the table
writetable(T,'ghcnd-stations_snoTEL.csv')                                               % Write table to .csv file
