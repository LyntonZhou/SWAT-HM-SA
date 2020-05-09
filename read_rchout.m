% This function reads basins.rch output file
function [swat_out]=read_rchout(out,IPRINT,ICALIB,out_id,outlet,n_DayinMonth,n_DayinYear, nOutlets)
%% This cell should be coordinated with the cio m-file
if out_id(1)==1; out_id(2)=1; end
if out_id(12)==1; out_id(5)=1; out_id(9)=1; end
if out_id(13)==1; out_id(4)=1; out_id(6)=1; out_id(7)=1; out_id(8)=1; end
if out_id(14)==1; out_id(10)=1; out_id(11)=1; end
if out_id(15)==1; out_id(4)=1; out_id(7)=1; end
if out_id(16)==1; out_id(6)=1; out_id(8)=1; end

% if calibration of sediements,nutrient, or pesticides is based on
% concentrations, out_id will be 1 since SF will be needed to compute conc.
if ICALIB(1)==1 && out_id(3)~=0; out_id(2)=1; end % Sediment
if ICALIB(2)==1 && any(out_id(4:9))~=0; out_id(2)=1; end % N and P
if ICALIB(3)==1 && any(out_id(10:11))~=0; out_id(2)=1; end % Pesticides
%%
RCH=out(:,1);
if all(RCH==0)
    nRep = size(out,1)/nOutlets;
    RCH = repmat([1:nOutlets]', nRep, 1);
end
area=out(outlet,4)*100; % outlet watershed area in ha

if IPRINT==1 % Daily outputs
    outputs=out(RCH(:)==outlet,5:end)/area;
elseif IPRINT==0  % Monthly outputs
    MON=out(:,3);
    str = 1:size(MON, 1);
    str = str(MON(:)>12);
    out(str(end)+1:end,:) = [];
    RCH(str(end)+1:end,:) = [];
    MON(str(end)+1:end,:) = [];
    outputs=out(RCH(:)==outlet & MON(:)<=12,5:end)/area;
    
%     outputs=outputs(1:end-1,:);
elseif IPRINT==2 % Yearly outputs
    outputs=out(RCH(:)==outlet,5:end)/area; % outputs=outputs(1:end-1,:);
end
% Find index of outputs of interest as defined in out_id
index=find(out_id(2:11)==1);
   
swatout(1:size(outputs,1),1:10)=-999.99;
L=0;
for i=1:length(index)
    L=L+1;
    if index(i)== 1 % Flow in cubic meter per second
        swatout(:,index(i))=outputs(:,L)*area;
        nanflow=swatout(:,1); nanflow(nanflow(:)==0)=NaN;
    elseif index(i)== 2 % Sediment
        if ICALIB(1)== 0; % Sediment outputs in tons per hectar
            swatout(:,index(i))=outputs(:,L); 
        else % Sediment outputs in mg/l (ppm)
            sed_conc=(outputs(:,L)*area*10^6)./(nanflow*86400);
            sed_conc(isnan(sed_conc(:)))=0;
            if IPRINT == 0
                sed_conc = sed_conc./n_DayinMonth';
            elseif IPRINT == 2
                sed_conc = sed_conc./n_DayinYear';
            end
            swatout(:,index(i))=sed_conc;
        end
    elseif index(i)==3 || index(i)==4 || index(i)==5 || index(i)==6 || index(i)==7 || index(i)==8 
        % N and P
        if ICALIB(2)==0; % N and P outputs in kg per hectar
            swatout(:,index(i))=outputs(:,L);
        else % N and P outputs in mg/l (ppm) [average daily]
            clear conc
            conc=(outputs(:,L)*area*10^3)./(nanflow*86400);
            conc(isnan(conc(:)))=0;
            if IPRINT == 0
                conc = conc./n_DayinMonth';
            elseif IPRINT == 2
                conc = conc./n_DayinYear';
            end
            swatout(:,index(i))=conc;
        end        
    elseif index(i)==9 || index(i)==10 % Pesticides
        if ICALIB(3)==0; % Pesticide outputs in mg/ha
            swatout(:,index(i))=outputs(:,L); 
        else % Pesticide outputs in mu.g/l (ppb)[average daily]
            clear conc
            conc = (outputs(:,L)*area)./(nanflow*86400);
            conc(isnan(conc(:)))=0;
            if IPRINT == 0
                conc = conc./n_DayinMonth';
            elseif IPRINT == 2
                conc = conc./n_DayinYear';
            end
            swatout(:,index(i))=conc;  
        end
    end
end
    
tp=swatout(:,4)+swatout(:,8); tp=max(tp,-999.99);
tn=swatout(:,3)+swatout(:,5)+swatout(:,6)+swatout(:,7); tn=max(tn,-999.99);
tpst=swatout(:,9)+swatout(:,10); tpst=max(tpst,-999.99);
tkn=swatout(:,3)+swatout(:,6); tkn=max(tkn,-999.99);
no2no3=swatout(:,5)+swatout(:,7); no2no3=max(no2no3,-999.99);

swat_out=[swatout,tp,tn,tpst,tkn,no2no3];
return;