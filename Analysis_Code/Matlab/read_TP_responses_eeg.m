% Mind Wandering EEG experiment
% Extract responses to thought probe questions from Presentation logfiles

% J.Simola November 2019 - edits March 2021

clc;
clear all;
close all;

run = 1; % change!!

fpath = '/Users/jsimola/Documents/Opetus/Kogn_neuro_harjoituskurssi/DATA/logs_TP1/'; % Remember to change the filename too!
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
    
S = str2num(tSubjects{aSubject});    
    
fname2 = sprintf('%s%s', fpath, tFiles{aSubject});

[trial,type,code,rt] = textread(fname2,'%*s %d %s %s %*d %d %*[^\n]','headerlines',5); 

% Find thought probes 
ind_Q = [];
ind_Q_comb = [];

ind_Q{1} = strcmp(code,'Q1_focused_EASY');
ind_Q{2} = strcmp(code,'Q2_people_EASY');
ind_Q{3} = strcmp(code,'Q3_emotion_EASY');
ind_Q{4} = strcmp(code,'Q4_past_EASY');
ind_Q{5} = strcmp(code,'Q5_myself_EASY');
ind_Q{6} = strcmp(code,'Q6_future_EASY');
ind_Q{7} = strcmp(code,'Q7_words_EASY');
ind_Q{8} = strcmp(code,'Q8_images_EASY');
ind_Q{9} = strcmp(code,'Q9_vague_EASY');
ind_Q{10} = strcmp(code,'Q10_intrusive_EASY');

ind_Q{11} = strcmp(code,'Q1_focused_DIFF');
ind_Q{12} = strcmp(code,'Q2_people_DIFF');
ind_Q{13} = strcmp(code,'Q3_emotion_DIFF');
ind_Q{14} = strcmp(code,'Q4_past_DIFF');
ind_Q{15} = strcmp(code,'Q5_myself_DIFF');
ind_Q{16} = strcmp(code,'Q6_future_DIFF');
ind_Q{17} = strcmp(code,'Q7_words_DIFF');
ind_Q{18} = strcmp(code,'Q8_images_DIFF');
ind_Q{19} = strcmp(code,'Q9_vague_DIFF');
ind_Q{20} = strcmp(code,'Q10_intrusive_DIFF');


% combine conditions
ind_Q_comb{1} = or(ind_Q{1},ind_Q{11});
ind_Q_comb{2} = or(ind_Q{2},ind_Q{12});
ind_Q_comb{3} = or(ind_Q{3},ind_Q{13});
ind_Q_comb{4} = or(ind_Q{4},ind_Q{14});
ind_Q_comb{5} = or(ind_Q{5},ind_Q{15});
ind_Q_comb{6} = or(ind_Q{6},ind_Q{16});
ind_Q_comb{7} = or(ind_Q{7},ind_Q{17});
ind_Q_comb{8} = or(ind_Q{8},ind_Q{18});
ind_Q_comb{9} = or(ind_Q{9},ind_Q{19});
ind_Q_comb{10} = or(ind_Q{10},ind_Q{20});


% question trials
trial_Q = [];
code_Q = [];

for n=1:10
    trial_Q{n} = trial(ind_Q_comb{n}); 
    code_Q{n} = code(ind_Q_comb{n}); % check
end


% Match target events and responses by trial

ind_resp = [];
resp_code = [];
RT = [];
trial_port_input = [];
tr_with_resp_Q = [];
missed_Q = [];
missed = 0;
ind_missed = [];

ind_resp = strcmp(type,'Response');
resp_code1 = code(ind_resp); 
for n=1:length(resp_code1); resp_code(n) = str2num(resp_code1{n}); end; % convert to numeric

RT = rt(ind_resp);
trial_port_input = trial(ind_resp);

for n=1:10
    tr_with_resp_Q{n} = ismember(trial_Q{n}, trial_port_input);
    responded_trials_Q{n} = trial_Q{n}(tr_with_resp_Q{n});
    missed_Q{n} = length(trial_Q{n}) - length(responded_trials_Q{n});
    
    m = cell2mat(missed_Q);
    missed = sum(m);
    
    if missed_Q{n} ~= 0
        ind_missed{n} = ~ismember(trial_Q{n},responded_trials_Q{n});       
    end
end

% Match response codes by trials and collect responses by conditions
trials_respCodes_RTs = [trial_port_input, resp_code', RT];


% Analyse thought probes

resp_Q = [];
responses_Q = [];
RTs_Q = [];

for quest = 1:10
    for n = 1:length(responded_trials_Q{quest})
        
        resp_Q{quest}{n} = trials_respCodes_RTs(trials_respCodes_RTs(:,1) == responded_trials_Q{quest}(n),:);
        
        responses_Q{quest}(n) = resp_Q{quest}{n}(1,2);
        RTs_Q{quest}(n) = resp_Q{quest}{n}(1,3);
        
    end
end

% Check if responses are missing

if missed ~= 0
    for quest = 1:length(ind_missed)
        if ~isempty(ind_missed{quest}) % KORJAA TÄMÄ kohta!!
            
            pad = find(ind_missed{quest} == 1);
            tmp = responses_Q{quest}(pad:end);
            tmp_rt = RTs_Q{quest}(pad:end);
            responses_Q{quest}(pad) = NaN;
            RTs_Q{quest}(pad) = NaN;
            
            
            responses_Q{quest}(pad+1:end+1) = tmp;
            RTs_Q{quest}(pad+1:end+1) = tmp_rt;
        end
    end
end

% create resp matrix

res = [];
rts = [];
s = [];
r = [];

for quest = 1:10
    res(:,quest) = responses_Q{quest}';
    rts(:,quest) = RTs_Q{quest}';
    
    for j = 1:length(responses_Q{quest})
        s(j) = S; % subject
        r(j) = run; % run
    end
end

subjData = [s' r' res rts];

TP_Data{aSubject} = subjData;

fprintf('\nParticipant %d done!\n', S); 

end

allsubj_TP_data = cat(1, TP_Data{:});

% Write results to a file 
results_fname = 'TP_responses_TP1.txt';
filename = fullfile(opath, results_fname);
fid = fopen(filename, 'wt');
fprintf(fid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n', 'subj', 'run', 'Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7', 'Q8', 'Q9', 'Q10', 'RT_Q1', 'RT_Q2', 'RT_Q3', 'RT_Q4', 'RT_Q5', 'RT_Q6', 'RT_Q7', 'RT_Q8', 'RT_Q9', 'RT_Q10');
fclose(fid);
dlmwrite(filename,allsubj_TP_data,'delimiter','\t','precision',['%10.',num2str(12),'f'],'-append');


