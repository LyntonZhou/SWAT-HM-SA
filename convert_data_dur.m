function new_data = convert_data_dur(daily_data, R_date_F, R_date_L, duration)

% this m-file converts daily data to half_monthly, monthly ,seasonly,annually data
% R_date_F and R_date_L are the First and Last date of the reported data
%  
% duration = {'half_month' or 'month' or 'season' or 'year'}

count = 1;
[y,m,dd] = datevec(R_date_L);

if m==2
    if ((dd==28 && mod(y,4)~=0) || dd==29 )
        R_date_L=R_date_L+1;
    end
elseif (m==1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12 )
    if dd==31 
        R_date_L=R_date_L+1;
    end  
else    
    if dd==30 
        R_date_L=R_date_L+1;
    end   
end  

switch duration
     case {'month'}
        for p=R_date_F:R_date_L
            [y,m,dd] = datevec(p);
           if ( m==2  && mod(y,4)~=0)
                if (dd == 1 && (R_date_L-p >= 27))
                    L(count)= (p - R_date_F);
                    count = count+1;
                    F(count) = (p - R_date_F)+1;
                elseif (dd == 1 && (R_date_L-p < 27))
                 L(count)= (p - R_date_F);              
                end
           elseif ( m==2  && mod(y,4)==0)   
                if (dd == 1 && (R_date_L-p >= 28))
                    L(count)= (p - R_date_F);
                    count = count+1;
                    F(count) = (p - R_date_F)+1;
                elseif (dd == 1 && (R_date_L-p < 28))
                    L(count)= (p - R_date_F);              
                end
           elseif (m==1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12 )
                if (dd == 1 && (R_date_L-p >= 30))
                    L(count)= (p - R_date_F);
                    count = count+1;
                    F(count) = (p - R_date_F)+1;
                elseif (dd == 1 && (R_date_L-p < 30))
                    L(count)= (p - R_date_F);              
                end
           else
               if (dd == 1 && (R_date_L-p >= 29))
                    L(count)= (p - R_date_F);
                    count = count+1;
                    F(count) = (p - R_date_F)+1;
                elseif (dd == 1 && (R_date_L-p < 29))
                    L(count)= (p - R_date_F);             
               end
           end    
        end
        
        for i=1:(count-1)
            new_data(i)=mean(daily_data(F(i+1):L(i+1),:));
        end

        

    case {'year'}
        for p=R_date_F:R_date_L
            [y,m,dd] = datevec(p);  

            if ((m == 1 ) && (dd ==1 )&& (R_date_L-p >= 364))
            L(count)= (p - R_date_F);
            count = count+1;
            F(count) = (p - R_date_F)+1;
            elseif ((m == 1 ) && (dd ==1 )&& (R_date_L-p < 364))
            L(count)= (p - R_date_F); 
            end
        end  
        for i=1:(count-1)
            new_data(i)=mean(daily_data(F(i+1):L(i+1)));
        end
end
new_data = new_data';
return
