function GaugeValid=f_ScreenGauge(Infile_inventory,Infile_station,Outfile_station,BasicInfo,Overwrite)
fprintf('Extracting valid gauges...\n');
if exist(Outfile_station,'file')&&Overwrite~=1
    load(Outfile_station,'GaugeValid');
else
    DataAll=importdata(Infile_inventory);  %Infile_inventory
    Gperiod=DataAll.data;
    Ginfo=DataAll.textdata; % ID
    clear DataAll
    
    % Note: the order of processing is important
    % for each station, find the variables belonging to BasicInfo.VarRead
    indno=~ismember(Ginfo(:,4),BasicInfo.VarRead);
    Ginfo(indno,:)=[];
    Gperiod(indno,:)=[];
    
    % period range. delete all stations that cannot meet the requirement of
    % least gauge number
    basicyear=BasicInfo.period_range(1):BasicInfo.period_range(2);
    period_len=zeros(size(Gperiod,1),1);
    for i=1:size(Gperiod,1)
        tempi=Gperiod(i,1):Gperiod(i,2);
        period_len(i)=sum(ismember(tempi,basicyear));
        if mod(i,1000)==0
           fprintf('%d\n',i); 
        end
    end
    ind1=period_len<BasicInfo.period_len(1)|period_len>BasicInfo.period_len(2);
    Gperiod(ind1,:)=[];
    Ginfo(ind1,:)=[];

    % delete repeated stations variables    
    [~,Gind]=unique(Ginfo(:,1));
    Ginfo=Ginfo(Gind,:);  % overwrite
    Gperiod=Gperiod(Gind,:);  
    % lat/lon range or mask range
    snum=size(Ginfo,1); % sample number
    latlon=zeros(snum,2);
    for i=1:snum
        lati=str2double(Ginfo{i,2});
        loni=str2double(Ginfo{i,3});
        latlon(i,1)=lati;
        latlon(i,2)=loni;
    end
    if BasicInfo.seflag==1    
        ind2=(latlon(:,1)>=BasicInfo.lat_range(1)&latlon(:,1)<=BasicInfo.lat_range(2)&...
            latlon(:,2)>=BasicInfo.lon_range(1)&latlon(:,2)<=BasicInfo.lon_range(2));
    elseif BasicInfo.seflag==2
        mask=BasicInfo.mask;
        row=floor((mask.yll2-latlon(:,1))/mask.cellsize)+1;
        col=floor((latlon(:,2)-mask.xll)/mask.cellsize)+1;
        ind21=(row<1|row>mask.nrows|col<1|col>mask.ncols);
        Gperiod(ind21,:)=[];
        Ginfo(ind21,:)=[];
        latlon(ind21,:)=[];
        row(ind21)=[];
        col(ind21)=[];       
        indtemp=sub2ind([mask.nrows,mask.ncols],row,col);
        ind2=isnan(mask.mask(indtemp));
    else
        error('Wrong SR.seflag');
    end
    Gperiod(ind2,:)=[];
    Ginfo(ind2,:)=[];
    latlon(ind2,:)=[];
    
    % read the elevation of those stations
    Ginfo2=cell(200000,2); % for Infile_station 
    fid=fopen(Infile_station,'r');
    flag=1;
    while ~feof(fid)
       li=fgetl(fid);
       Ginfo2{flag,1}=li(1:11);
       Ginfo2{flag,2}=li(31:37);
       flag=flag+1;
    end
    fclose(fid);
    if flag<=200000
        Ginfo2(flag:end,:)=[];
    end
    [ind1,ind2]=ismember(Ginfo2(:,1),Ginfo(:,1));
    ind2(ind2==0)=[];
    Ele=nan*zeros(size(latlon,1),1);
    Ele(ind2)=str2double(Ginfo2(ind1,2));
    
    % output gauge infomation
    GaugeValid.ID=Ginfo(:,1);
    GaugeValid.lle=[latlon,Ele];
    GaugeValid.period=Gperiod;
    GaugeValid.SR=BasicInfo;
    save(Outfile_station,'GaugeValid')
end
end