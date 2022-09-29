% Mind Wandering MEG experiment
% Extract events, responses and RTs from Presentation logfiles
% combine these data with ERPs

% J.Simola March 2021 

clc;
clear all;
close all;

fpath = '/Users/jsimola/Documents/Opetus/Kogn_neuro_harjoituskurssi/DATA/logs_noTP/';
opath = '/Users/jsimola/Documents/Opetus/Kogn_neuro_harjoituskurssi/DATA/analysed/';

% Read files
tDir = dir(fpath);
count = 1;
for n = 1:length(tDir)
    if ~(strcmp(tDir(n).name, '.') || strcmp(tDir(n).name, '..'))
        aFilename = tDir(n).name;
        [~, ~, aExtension] = fileparts(aFilename);
        
        if strcmp(aExtension, '.log')
            tFiles{count} = aFilename;
            tSubjects{count} = aFilename(4:5);
            count = count + 1;
        end
    end
end




% Process log-data
for aSubject = 1:length(tSubjects)
    
fname2 = sprintf('%s%s', fpath, tFiles{aSubject});

trial = [];
type = [];
code = [];
rt = []; 

[trial,type,code,rt,dur] = textread(fname2,'%*s %d %s %s %*d %d %*d %f %*[^\n]','headerlines',5); 

% Choose relevant events
Events = {'NT_easy','Targ_easy_LEFT','Targ_easy_RIGHT','6','7','NT_diff','Targ_diff_LEFT','Targ_diff_RIGHT'}; 
L = cellfun(@(c)strcmp(c,Events),code,'UniformOutput',false); % find rows with chosen events

for n = 1:length(L); idxZero(n) = all(L{n} == 0); end;
idxEvents = find(idxZero == 0);

trial = trial(idxEvents);
type = type(idxEvents);
code = code(idxEvents);
rt = rt(idxEvents);

% Resp accuracy
resp_code = [];
for n = 1:length(code)-1
    resp_code(1) = -2;
    if (strcmp(code{n},'Targ_easy_LEFT')) && (strcmp(code{n+1},'6'))
        resp_code(n+1) = 1; % hit
    elseif (strcmp(code{n},'Targ_diff_LEFT')) && (strcmp(code{n+1},'6'))
        resp_code(n+1) = 1; % hit
    elseif (strcmp(code{n},'Targ_easy_RIGHT')) && (strcmp(code{n+1},'7'))
        resp_code(n+1) = 1; % hit
    elseif (strcmp(code{n},'Targ_diff_RIGHT')) && (strcmp(code{n+1},'7'))
        resp_code(n+1) = 1; % hit
    elseif (strcmp(code{n},'Targ_easy_LEFT')) && (strcmp(code{n+1},'7'))
        resp_code(n+1) = 0; % miss
    elseif (strcmp(code{n},'Targ_diff_LEFT')) && (strcmp(code{n+1},'7'))
        resp_code(n+1) = 0; % miss
    elseif (strcmp(code{n},'Targ_easy_RIGHT')) && (strcmp(code{n+1},'6'))
        resp_code(n+1) = 0; % miss
    elseif (strcmp(code{n},'Targ_diff_RIGHT')) && (strcmp(code{n+1},'0'))
        resp_code(n+1) = 0; % miss    
    else
        resp_code(n+1) = -2; % other trials
    end
end

% Write file
fname = sprintf('%slogs_noTP_n28_MW_%s.txt', opath, tSubjects{aSubject});
fileID = fopen(fname,'wt');
fprintf(fileID,'%5s %5s %5s %5s\n', 'subj', 'code', 'resp_code', 'RT');

for n = 1:length(trial)
    fprintf(fileID,'%5d %5s %5d %5d\n', str2num(tSubjects{aSubject}), code{n}, resp_code(n), rt(n));
end

fclose(fileID);
end