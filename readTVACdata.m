clear
clc
close all
tic

filedir = '/Volumes/EMIT/EMIT_instrument/TVac_0/TRIOPTICS/'; % remote EMIT drive on Lena's mac
filePattern = fullfile(filedir, '*.csv'); % read in all csv files in TRIOPTICS folder
JitterLog = readcell([filedir 'TVAC0_JitterLog.xlsx']);
phase = 'Ramp to Bakeout'; % user input phase

% grab all filenames corresponding to phase
allphases = JitterLog(:,2);
JitLogIndex = ismember(allphases, phase);
JitLogPhase = JitterLog(JitLogIndex,:);

% eliminate rows with manual adjustments
[rowsJit, ~] = size(JitLogPhase);
i = 1;
while i<=rowsJit
    str1 = JitLogPhase{i,8};
    str2 = JitLogPhase{i,10};
    if contains(str1, 'Y') == 1 | contains(str2, 'Y') == 1
        JitLogPhase(i,:) = [];
    else
        i = i+1;
        [rowsJit, ~] = size(JitLogPhase);
    end
end

% read in data from filename corresponding to phase
files = string(JitLogPhase(:,9));

% return Jitter Magnitude for each acquistion
JitMagX = zeros(length(files),1);
JitMagY = zeros(length(files),1);

for i = 1:length(files)
    data = readmatrix([filedir files{i}],'VariableNamingRule','Preserve'); % read in data from each csv
    [JitMagX(i), JitMagY(i)] = jitterMag(data);    
end

% make Histogram
figure()
nbins = 50;
t = tiledlayout(1,2);
title(t, append('Magnitude of Jitter in Phase: ', phase),'FontWeight','Bold');
subtitle(t, [num2str(length(files)),' Data Acquisitions']);
nexttile
h1 = histogram(JitMagX, nbins);
xlabel('Jitter Magnitude [\murad]');
ylabel('Frequency');
title('Angle X');
grid on

nexttile
h2 = histogram(JitMagY, nbins);
xlabel('Jitter Magnitude [\murad]');
ylabel('Frequency');
title('Angle Y');
grid on

% add number of acquisitions

toc
