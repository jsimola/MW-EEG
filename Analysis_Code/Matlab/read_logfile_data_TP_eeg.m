% Mind Wandering EEG experiment
% Extract events and responses to Targets and thought probe questions from Presentation logfiles

% J.Simola November 2019 - edits on March 2021 - edits on March-May 2022


clc;
clear all;
close all;

run = 1; % change

fpath = '/Users/jsimola/Documents/Opetus/Kogn_neuro_harjoituskurssi/DATA/logs_TP1/'; % Change this + filename !!!
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


% Create result file
fname = sprintf('%slogs_TP1.csv', opath);


k = 1;

% Process log-data
for aSubject = 1:length(tSubjects)
    
fname2 = sprintf('%s%s', fpath, tFiles{aSubject});

trial = [];
type = [];
code = [];
rt = []; 
L = [];
idxZero = [];

[trial,type,code,rt,dur] = textread(fname2,'%*s %d %s %s %*d %d %*d %f %*[^\n]','headerlines',5); 


% Choose relevant events
Events = {'NT_easy','Targ_easy_LEFT','Targ_easy_RIGHT','6','7','NT_diff','Targ_diff_LEFT','Targ_diff_RIGHT', 'Q1_focused_EASY', 'Q1_focused_DIFF','1','2','3','4'}; 
L = cellfun(@(c)strcmp(c,Events),code,'UniformOutput',false); % find rows with chosen events

idxEvents = [];
for n = 1:length(L); idxZero(n) = all(L{n} == 0); end;
idxEvents = find(idxZero == 0);

trial = trial(idxEvents);
type = type(idxEvents);
code = code(idxEvents);
rt = rt(idxEvents);


% Resp accuracy
resp_code = [];
code{end+1,1} = 'extra'; % add extra row
trial(end+1) = -2;

for n = 1:length(code)-1
%for n = 1:length(code)
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
    
    elseif (strcmp(code{n},'Targ_diff_RIGHT')) && (strcmp(code{n+1},'6'))
        resp_code(n+1) = 0; % miss
      
    elseif (strcmp(code{n},'Q1_focused_EASY')) 
        resp_code(n+1) = str2num(code{n+1});
        
    elseif (strcmp(code{n},'Q1_focused_DIFF'))
        resp_code(n+1) = str2num(code{n+1});
        
    else
        resp_code(n+1) = -2; % other trials

    end
end

rt = [rt; 0];
respData = [resp_code' rt];
rows = [];
rows = length(code);

% save data 
for n = 1:rows
     
     dataAll{k,1} = str2num(tSubjects{aSubject}); % save to variable
     dataAll{k,2} = trial(n);
     dataAll{k,3} = code{n};
     dataAll{k,4} = respData(n,1);
     dataAll{k,5} = respData(n,2);
     
     k = k + 1;
end


end

% Convert cell to a table and use first row as variable names
T = cell2table(dataAll, "VariableNames",["subj" "trial" "code" "resp_code" "RT"]);
 
% Write the table to a CSV file
writetable(T,fname)


