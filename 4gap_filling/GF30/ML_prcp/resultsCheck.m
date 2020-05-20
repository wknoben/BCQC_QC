Gauge='/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/gaugeInfo1.mat';
load('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc/ts.mat')
%load the output file from GHCN_read_plato.m, which finds valid snotel gauges
%load('/Users/cjh458/Desktop/Guoquiang_WF/2read_GHCND/ghcnd_scripts/GaugeValid1.mat')
load(Gauge)
%change directory into folder containing matlab files with snoTEL data
%cd('/Users/cjh458/Desktop/Guoquiang_WF/3quality_control/ghcnd_QC_TP')


for i=1:length(ts) %iterate through the ID values in this file

    file=strcat(num2str(ts(i)),'.mat'); %Create a file name to open
    if exist(file, 'file') == 2     %check if this file exists
        
        load(file);                 % If so, load file
        check(i,1)=KGEFill_RF(1,1);   % And record the 2 coefficent
        
        if (sum(isnan(data_stngg))<730)     % if there are nans, but they don't take up the entire time-series 
            Nanp(i)=sum(isnan(data_stngg)); % Calculate the number of nans in the time-series
        end
        
        if (sum(isnan(data_stngg))==730)    % if nans do occur throught the entire series
            Nanp(i)=-999;%sum(isnan(data_stngg)); % set == -999
        end
        
        if exist('VarFill_RF','var') ==1    % if some filling has occured
            fill(i,1)=length(VarFill_RF);   % calculate the length of the VarFill_RF variable
        
            mfill(i,1)=mean(fill);
            mobs(i,1)=mean(data_stngg);
        end
        
        
    else
        check(i,1)=-999;    % if the file doesn't exist set ==-999
    end
    
end

