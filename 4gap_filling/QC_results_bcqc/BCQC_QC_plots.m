% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Make plots for a presentation about snoTEL data QC 05-21-20202  % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

load('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc/time.mat') % load a vector with a timestamp for the period
load('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc/STATIONS.mat') % load QC output data.

for i = 1:length(time1)         %% CHOP up output from MetSim time into components and create a date-time string
    
    time=char(time1{i});
    year=str2num(time(1:4));
    month=str2num(time(6:7));
    day=str2num(time(9:10));
    dates(i)=datetime(year,month,day);
    
end


formatOut = 'yyyy/mm/dd';       %% format what this string will look like on the plot

% % % % % % % % % % % % % % % % % % % % PLOT WITH FADING COLORS FOR NEAREST STATIONS
figure;
hold all
N=20
for i = 1:20
    h = zeros(N,1) + 1;     % Constant hue = 100%
    s = linspace(1,0,N)';   % Variable saturation
    v = zeros(N,1) + 1;     % Constant value
    rgb = hsv2rgb([h,s,v]);
end
rgb(:,1)=[];
rgb(:,3)=1;
for i=20:-1:1
    plot(dates,data_stn_negg(:,i),'color',rgb(i,:),'LineWidth',1);
end

plot(dates,data_stngg,'-','LineWidth',1.1,'color','black');
ylabel('T max °C','FontSize',12)
xlabel('date','FontSize',12)
legend({'Nearest stations','Station of interest'},'Location','northwest','NumColumns',1)

print('QC_EXfig1_bcqc','-dpdf')

% % % % % % % % % % % % % % % % % % % % % COMPARISION LINE PLOT

load('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc/Tmax_1.mat') % load a vector with a timestamp for the period
line=-15:0.05:20;
line1=-15:0.05:20;
figure;
hold all
plot(line,line1,'-','LineWidth',1.1,'color','black');
plot(VarFill_RF,data_stngg,'b.','MarkerSize',10);
ylabel('random forest','FontSize',12)
xlabel('snoTEL data','FontSize',12)
title('T max °C','FontSize',14)

print('QC_Linefig1_bcqc','-dpdf')

load('/Users/cjh458/Desktop/BCQC_QC/4gap_filling/QC_results_bcqc/mean_data.mat') % load QC output data.

% % % % % % % % % % % % % % % % % % % % PLOT SHOWING DISTRIBUTIONS OF MEAN ERRORS

subplot(3,1,1)

plot(