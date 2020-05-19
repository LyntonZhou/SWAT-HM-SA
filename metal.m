function metal(par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)

file_read = [sensin_path '\metal.dat'];
file_write = [out_data_path '\metal.dat'];
delete(file_write);
fid1=fopen(file_read, 'r');
fid2=fopen(file_write, 'w');

delimiter= '';
formatSpec = '%3d%10s%3d%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%f%[^\n\r]';
dataArray = textscan(fid1, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
dataArray([1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) = cellfun(@(x) num2cell(x), dataArray([1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]), 'UniformOutput', false);
mataldat_par = [dataArray{1:end-1}];
fclose(fid1);

mataldat_parNEW = mataldat_par;

if par_f(strcmp(symbol, 'METAL_KD1'))==1
    mataldat_parNEW{4} = par_value(x, mataldat_par{4}, alter_m, lba, uba, symbol, 'METAL_KD1');
end

if par_f(strcmp(symbol, 'METAL_KD2'))==1
    mataldat_parNEW{5} = par_value(x, mataldat_par{5}, alter_m, lba, uba, symbol, 'METAL_KD2');
end

if par_f(strcmp(symbol, 'METAL_KD3'))==1
    mataldat_parNEW{6} = par_value(x, mataldat_par{6}, alter_m, lba, uba, symbol, 'METAL_KD3');
end

if par_f(strcmp(symbol, 'METAL_KS1'))==1
    mataldat_parNEW{7} = par_value(x, mataldat_par{7}, alter_m, lba, uba, symbol, 'METAL_KS1');
end

if par_f(strcmp(symbol, 'METAL_KS2'))==1
    mataldat_parNEW{8} = par_value(x, mataldat_par{8}, alter_m, lba, uba, symbol, 'METAL_KS2');
end

if par_f(strcmp(symbol, 'METAL_KW'))==1
    mataldat_parNEW{10} = par_value(x, mataldat_par{10}, alter_m, lba, uba, symbol, 'METAL_KW');
end

if par_f(strcmp(symbol, 'METAL_KU'))==1
    mataldat_parNEW{11} = par_value(x, mataldat_par{11}, alter_m, lba, uba, symbol, 'METAL_KU');
end

fprintf(fid2, formatSpec, mataldat_parNEW{1:15});
fclose(fid2);

return;