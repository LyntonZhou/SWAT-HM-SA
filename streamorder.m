function streamorder(fig_filename)
%% file names
temp_route_file = 'temp_route.txt';
temp_add_file   = 'temp_add.txt';

%% load "route" and "add" data from fig.fig
fid_r       = fopen(fig_filename, 'r');
fid_route_w = fopen(temp_route_file, 'w');
fid_add_w   = fopen(temp_add_file, 'w');
L = 0;
while feof(fid_r) == 0
    L = L+1;
    line = fgets(fid_r);
    if isequal(strtok(line), 'route')
        fprintf(fid_route_w, '%s', line(17:end));
    elseif isequal(strtok(line), 'add')
        fprintf(fid_add_w, '%s', line(17:end));
    end
end
fclose(fid_r); fclose(fid_route_w); fclose(fid_add_w);
route_data = load(temp_route_file);
add_data   = load(temp_add_file);
delete (temp_route_file,temp_add_file);
%% segment-from-to matrix
n_rch       = max(route_data(:,2));
tree_tbl    = [(1:n_rch)', (1:n_rch)', zeros(n_rch,1)];
add_data(add_data(:,2) == add_data(:,3),:) = [];

% change the name of the first-order segment's node
list_to_remove = [];
for i=1:size(route_data,1)
    if route_data(i,2) == route_data(i,3)
        old_name = route_data(i,1);
        new_name = route_data(i,2);
        route_data(route_data == old_name) = new_name;
        add_data(add_data == old_name)     = new_name;
        list_to_remove = [list_to_remove i]; %#ok<AGROW>
    elseif route_data(i,1)> n_rch
        old_name = route_data(i,1);
        new_name = route_data(i,2);
        route_data(i,1) = new_name;
        route_data(route_data == old_name) = new_name;
        add_data(add_data == old_name) = new_name;
    end
end

for i=1:size(add_data,1)
    if add_data(i,1)>n_rch
        old_name = add_data(i,1);
        new_name = add_data(i,2);
        route_data(route_data == old_name) = new_name;
        add_data(add_data == old_name)     = new_name;
    end
end
route_data(list_to_remove,:) = [];
route_data(:,1) = route_data(:,2);
all_data = [route_data; add_data];
all_data(all_data(:,2) == all_data(:,3),:) = [];
[sorted_all, indx] = sort(all_data);
all_data = all_data(indx(:,3),:);
all_data = all_data(:,[1 3 2]);
all_data(:,1) = all_data(:,2);
all_data(all_data(:,1)>n_rch,:) = [];

%% last outlet
last_outlet_pos = route_data(end,1);
last_outlet_cnc = [last_outlet_pos last_outlet_pos 0];
shift_part      = all_data(last_outlet_pos:end,:);

tree_tbl        =[all_data(1:last_outlet_pos-1,:);...
                  last_outlet_cnc;...
                  shift_part];


col1 = all_data(:,1);
col2 = all_data(:,2);
col3 = all_data(:,3);
conections{n_rch,1} = {};
% last_outlet = tree_tbl(tree_tbl(:,3)==0,1);

for i=1:n_rch
    upstream_cnctn = (col3 == i);
    conections{i,1} = col2(upstream_cnctn);
end

%% find orders
orders = zeros(n_rch,1);
% 1st-order
for i=1:n_rch
    if isempty(conections{i,1})
        orders(i) = 1;
    end
end
str = (1:n_rch)';
not_cmplt_orders = str(orders==0);

L = 0;
while any(orders==0)
    if L < size(not_cmplt_orders,1)
        L = L+1;
    else
        L = 1;  
    end
    ups = conections{not_cmplt_orders(L)};
    all_up_is_cmplt = 1;
    max_upper_order = [];
    for j=1:size(ups,1)
        if orders(ups(j))== 0
            all_up_is_cmplt = 0;
        else
            max_upper_order = [max_upper_order, orders(ups(j))];
        end
    end
    if all_up_is_cmplt
        possible_order      = max_upper_order(max_upper_order == max(max_upper_order));
        if size(possible_order,2)==1
            orders(not_cmplt_orders(L)) = max(possible_order);
        else
            orders(not_cmplt_orders(L)) = max(possible_order)+1;
        end
        not_cmplt_orders(L) = [];
    end
end
strOrders = [str, orders];

save('stream_order.mat', 'strOrders');