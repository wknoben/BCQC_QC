function RFscd=f_MLfill(xdata,ydata,xcomb,varvv)
% scd estimate
numcomb=size(xcomb,1);
nday=length(ydata);
RFdata=nan*zeros(nday,numcomb); % col: combinations
RFkge=nan*zeros(numcomb,2); % train validation test kge

for i=1:numcomb % combination loop
    combi=xcomb(i,:); combi(isnan(combi))=[];
    if isempty(combi); continue; end
    %%%% insert control procedure -C.Hart
    len=length(combi)-size(xdata,2); % Calculate the difference in length between these two time-series
    if len>0   %if the length of combi is longer than xdatai
        lencombi=length(combi);
        for ii=1:len %iterate through the length of the time differnece between combi and xdatai
            combi(lencombi-(ii-1))=[]; %remove the extra vaules from combi
        end %end for loop
    end  %end if loop
    xdatai=xdata(:,combi);
    inputi=[xdatai,ydata];
    [indin,~]=find(isnan(inputi));
    inputi(indin,:)=[];
    
    % Random Forest estimate
    try
        [RFdata(:,i),RFkge(i,1),RFkge(i,2)]=ff_RandomForest(inputi(:,1:end-1),inputi(:,end),xdatai,varvv);
    catch
    end
end

% generate final estimate
RFscd=f_FinalEstimate(RFdata,RFkge);
end
