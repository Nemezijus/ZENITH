function trigger_check(dirloc)
%trigger_check - scans through the dirloc for csv files, reads the
%'Trigger' Column and reports whether and which files have bad trigger
%column

disp(['checking directory: ', dirloc]);
files = dir(dirloc);
files = files(3:end);
dirs = files([files.isdir]);
for idir = 1:numel(dirs)
    trigger_check([dirs(idir).folder, '\', dirs(idir).name]);
end
files = files(~[files.isdir]);

for ifile = 1:numel(files)
    cfile = [files(ifile).folder,'\', files(ifile).name];
    [a,b,c] = fileparts(cfile);
    if strcmp(c,'.csv')
        goodfile = [a,'\',b,c];
        report = trigger_scan(goodfile);
        if ~report
            disp(['bad trigger at: ',goodfile]);
        end
    end
end

function report = trigger_scan(floc)
report = 1;%good
fid = fopen(floc);
T = textscan(fid,'%s','Delimiter',{'/n'},'CollectOutput',1);
T = T{1,1};
fclose(fid);
T_names = T(1);
T_names = strsplit(T_names{:},';');
if numel(T) > 1
    T_data = T(2:end);
    T_data = datamatrix(T_data);
else
    T_data = [];
end
T = T_data;
szT = size(T);
T_names = T_names(1:szT(2));
trigger_filter = ismember(T_names, 'Trigger');

Ttrigger = T(:,trigger_filter);
if sum(Ttrigger) == 0 || sum(Ttrigger) == numel(Ttrigger)
    report = 0;%bad
end


function M = datamatrix(T)
nT = cellfun(@(s) replace(strsplit(s, ';'),',','.'), T, 'UniformOutput', false);
le = cellfun(@(s) numel(s),nT);
if le(end) ~= le(end-1)
    nT = nT(1:end-1);
end
T = vertcat(nT{:});
M = str2double(T);