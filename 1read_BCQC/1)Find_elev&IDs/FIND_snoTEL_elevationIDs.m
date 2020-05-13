% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % This script performs a search using Lat and Lons from the snoTEL % %
% % and a data file downloaded from GHCND's website to find snoTEL   % %
% % data files within the GHCND database                             % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

cd '/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/1)Find_elev&IDs';                          % Change directory into the right folder

load('/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/1)Find_elev&IDs/LLES_snoTEL.mat');       % Load a matrix with all the snotel IDs LLEs and ELEV
load('/Users/cjh458/Desktop/BCQC_QC/1read_BCQC/1)Find_elev&IDs/LIST_BCQC.mat');         % Load a matrix with all the BCQC file names

for i=1:length(LISTbcqc)                                                                % iterate through bcqc stations
    for j=1:length(LLES)                                                                % iterate through ghcnd stations
        
        latlon=char(LISTbcqc{i});                                                       % Create char var from cell list
        lat1=num2str(latlon(6:10));                                                     % set lat == to length
        lon1=num2str(latlon(15:21));                                                    % set lon == to length
        
        lat2=sprintf('%2.2f',(LLES(j,1)));                                              % sprintf a string of disired percision for lat
        lon2=sprintf('%4.2f',(LLES(j,2)));                                              % sprintf a string of disired percision for lon
        
        str1=strcmp(lat1,lat2);                                                         % compare the lat strings
        str2=strcmp(lon1,lon2);                                                         % compare the lon strings
        
        if (str1==1) && (str2==1)                                                       % If both of these information fields are correct, create a new entry into LLE file                         
            
            LLE(i,1)=LLES(j,1);                                                         % Set LLE equal to the lat of station data
            LLE(i,2)=LLES(j,2);                                                         % Set LLE equal to the lon of station data
            LLE(i,3)=LLES(j,3);                                                         % Set LLE equal to the elev of snoTEL data
            LLE(i,4)=LLES(j,4);                                                         % Set LLE equal to the elev of snoTEL data
            
        end    
    end
end
 
% clearvars -except ID1 LLE                                                               % Add variables to cellstr
T=array2table(LLE);                                                                       % Convert cellstr to a table
T.Properties.VariableNames{1} = 'lat';                                                   % Write headers to the table
T.Properties.VariableNames{2} = 'lon';                                                  % Write headers to the table
T.Properties.VariableNames{3} = 'elev';                                                  % Write headers to the table
T.Properties.VariableNames{4} = 'sid';                                                  % Write headers to the table
writetable(T,'LIST_LLES.csv')                                                           % Write table to .csv file

clearvars -except LLE
LLES=LLE;
clear LLE
save LLES_bcqc.mat