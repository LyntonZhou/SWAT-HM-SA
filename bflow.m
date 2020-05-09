% Calling Arnold et al. flow separation model to find baseflow to total
% flow ratio
function [bfr_diff]=bflow(osf_select,ssf_select,path)
Main_path = cd;
cd(path);
% Write the bflow input file "bflow_in.flw"
ndays=size(osf_select,1);
bfdates=1:ndays;

fid1=fopen('bflow_in.flw','w');
for i=1:ndays; fprintf(fid1,'%12i%12.5f\n',bfdates(i),osf_select(i));end
fclose(fid1);
dos('bflow.exe');
[bfr_obs1,bfr_obs2]= textread('baseflow.dat', '%*s%n%n%*[^\n]','headerlines',3);
bfr_obs=(bfr_obs1+bfr_obs2)/2;
fid2=fopen('bflow_in.flw','w');
for i=1:ndays; fprintf(fid2,'%12i%12.5f\n',bfdates(i),ssf_select(i));end
fclose(fid2);
dos('bflow.exe');
[bfr_sim1,bfr_sim2]= textread('baseflow.dat', '%*s%n%n%*[^\n]','headerlines',3);
bfr_sim=(bfr_sim1+bfr_sim2)/2;
bfr_diff=(bfr_obs-bfr_sim)/bfr_obs*100;
cd(Main_path);