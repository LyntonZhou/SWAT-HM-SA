% Re-constructing the output values from uaout.txt
clear all
close all
fclose all
clc

obs=textread('D:\Mazdak\ST_JOSEPH\UA_model3\obs_daily33.prn','','headerlines',1);
index_obs=find(obs(:,9)~=-99);
obs_select=obs(obs(:,9)~=-99,9);

bfr=load('D:\Mazdak\ST_JOSEPH\UA_model3\bfr.txt');

outputs=load('D:\Mazdak\ST_JOSEPH\UA_model3\uaout.txt');

n_sampling=size(outputs,1);
n_col=size(outputs,2);

L=0;
for i=1:n_sampling
    L=L+1; clear outs;
    for j=1:13
        outs(:,j)=outputs(i,(j-1)*n_col/13+1:j*n_col/13);    
        swat_out{L}=outs;
    end
end

for i=1:n_sampling
    select1=swat_out{i};
    array_all(i,:)=select1(:,6);
end
% plot behavior and nonbehavior regions
% figure(1)
% h1=area(array_all');
% set(h1,'EdgeColor',[0 0 0])
% set(h1,'FaceColor',[0 0 0])
% hold on

error_stats=textread('N:\research\projects\StjosephEWS\UA_model3\error_stats.txt','','headerlines',1);
index_b=find(error_stats(:,3)>0 & error_stats(:,18)>0);

for i=1:length(index_b)
    clear select2
    select2=swat_out{index_b(i)};
    array_b(i,:)=select2(:,6);
end
% h2=area(array_b');
% set(h2,'EdgeColor',[1 0 0])
% set(h2,'FaceColor',[1 0 0])

% plot behavior region, best simulation and observed values
index_best=find(error_stats(:,18)==max(error_stats(:,18)));
array_best=array_all(index_best(1),:);

% figure(2)
% h2=area(array_b');
% set(h2,'EdgeColor',[1 0 1])
% set(h2,'FaceColor',[1 0 1])
% hold on
subplot(2,2,1)
plot(array_best,'-k','LineWidth',2)
hold on
plot(index_obs,obs_select,'ob')

subplot(2,2,2)
plot(obs_select,array_best(index_obs(:)),'ok','LineWidth',2)

