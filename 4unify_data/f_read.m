function [datai,qfrawi,qfi,mfi]=f_read(filei,sourcei,date)
datai=nan*zeros(length(date),5);
qfrawi=nan*zeros(length(date),5);
qfi=nan*zeros(length(date),5);
mfi=zeros(length(date),1); % measurement flag

% data
load(filei,'data');
date0=data(:,1);
[ind1,ind2]=ismember(date0,date);
ind2(ind2==0)=[];
datai(ind2,1:5)=data(ind1,2:6);

mfi(ind1)=1; % this is from measurement
% quality flags in our framework
load(filei,'Qflag_prcp1','Qflag_prcp2','Qflag_tmax','Qflag_tmin');

% if ~strcmp(sourcei,'GS')
%     Qflag_prcp2(Qflag_prcp2==34)=0;
% end

tempind=Qflag_prcp1>0;
Qflag_prcp1(~tempind)=Qflag_prcp2(~tempind); 
qfi(ind2,1)=Qflag_prcp1(ind1);
qfi(ind2,2)=Qflag_tmin(ind1);
qfi(ind2,3)=Qflag_tmax(ind1);

% quality flags from raw data
qfraw=f_read_ghcn(filei);
qfrawi(ind2,:)=qfraw(ind1,:);
end


function qfrawi=f_read_ghcn(filei)
load(filei,'mqsflag');
qfrawi=nan*zeros(size(mqsflag{1})); 
for i=1:length(mqsflag)
    qfrawi(:,i)=int16(mqsflag{i}(:,2));
end
qfrawi(qfrawi==32)=0; % space is used in ghcd-d for good stations. here we use 0.
end
