% % % % % % % % % % % % % % % % 
% %  MAKE QC RESULTS PLOTS % %
% % % % % % % % % % % % % % % % 

%Create mat files that store the results for Nans and the correlation
%statistics for different variables
cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/GF/ML_prcp')       % change directory (cd) into folder with precipitation (prcp) machine learning results
resultsCheck                                                                % run script that iterates through station results and calcualtes the # of nans and statistics for (measured vs. gap-filled time-series) 
cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc')    % cd into folder where QC results will be stored for plotting    
save prcp.mat                                                               % save a prcp .mat file with results for # of nans and (measured vs. gap-filled statistics)
clearvars                                                                   % clear variables out of the workspace

cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/GF/ML_tmax')       % cd into directory with temperature maximum (tmax) machine learning results
resultsCheck                                                                % run script that iterates through station results and calcualtes the # of nans and statistics for (measured vs. gap-filled time-series)
cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc')    % cd into folder where QC results will be stored for plotting
save tmax.mat                                                               % save a tmax .mat file with results for # of nans and (measured vs. gap-filled statistics)
clearvars                                                                   % clear variables out of the workspace

cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/GF/ML_tmin')       % cd into directory with temperature minimum machine learning results
resultsCheck                                                                % run script that iterates through station results and calcualtes the # of nans and statistics for (measured vs. gap-filled time-series)
cd('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc')    % cd into folder where QC results will be stored for plotting
save tmin.mat                                                               % save a tmin .mat file with results for # of nans and (measured vs. gap-filled statistics)

% Bring all the data into the workspace
check_tmin=check;                                                           % create variable with measured vs. gap-filled statistics for tmin
nan_tmin=Nanp;
mfill_tmin=mfill;
mobs_tmin=mobs;
% create variable that shows the number of nans that result from the QC at each station for tmin
load('tmax.mat')                                                            % load results for tmax into the workspace
check_tmax=check;                                                           % create variable with measured vs. gap-filled statistics for tmin
nan_tmax=Nanp;
mfill_tmax=mfill;
mobs_tmax=mobs;
% create variable that shows the number of nans that result from the QC at each station for tmax
load('prcp.mat')                                                            % load results for prcp into the workspace
check_prcp=check;                                                           % create variable with measured vs. gap-filled statistics for tmin
nan_prcp=Nanp;  
mfill_prcp=mfill;
mobs_prcp=mobs;
% create variable that shows the number of nans that result from the QC at each station for prcp

clearvars -except check_tmin nan_tmin check_tmax nan_tmax check_prcp nan_prcp mobs_prcp mobs_tmin mobs_tmax mfill_prcp mfill_tmin mfill_tmax% clear unneeded variables from the workspace

% Make a plot with 6 sub-plots
subplot(2,3,1)
plot(check_prcp,'.','color',[0,0,0])
ylabel('KGE','FontSize',12)
ylim([0.0 1.05])
xlim([1 601])
title('precipitation','FontSize',12)

subplot(2,3,2)
plot(check_tmax,'.','color',[0,0,0])
xlabel('station number','FontSize',12)
ylim([0.0 1.05])
xlim([1 601])
title('T min','FontSize',12)

subplot(2,3,3)
plot(check_tmin,'.','color',[0,0,0])
ylim([0.0 1.05])
xlim([1 601])
title('T max','FontSize',12)

subplot(2,3,4)
plot(nan_prcp,'.','color',[0,0,0])
xlim([1 601])
ylabel('number of nans','FontSize',12)

subplot(2,3,5)
plot(nan_tmin,'.','color',[0,0,0])
xlim([1 601])
xlabel('station number','FontSize',12)

subplot(2,3,6)
xlim([1 601])
plot(nan_tmax,'.','color',[0,0,0])

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [8.5 5];

print(fig,'QC_fig30_bcqc','-dpdf','-fillpage')

% xlabel('Temperature','FontSize',12)
% ylim([0.05 1.05])
% xlim([1 601])
% title('T min','FontSize',12)
