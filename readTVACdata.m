clear
clc
close all
tic

% set file path
filedir = '/Volumes/EMIT/EMIT_instrument/TVac_0/TRIOPTICS/'; % remote EMIT drive on Lena's mac
filePattern = fullfile(filedir, '*.csv'); % read in all csv files in TRIOPTICS folder
JitterLog = readcell([filedir 'TVAC0_JitterLog.xlsx']);
phase = 'Transition to Cold'; % user input phase

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
JitMaxX = zeros(length(files),1);
JitMaxY = zeros(length(files),1);
JitSTDVX = zeros(length(files),1);
JitSTDVY = zeros(length(files),1);

updateStr = ''; %For progress update text
for i = 1:length(files)
    data = readmatrix([filedir files{i}],'VariableNamingRule','Preserve'); % read in data from each csv
    [JitMagX(i), JitMagY(i), JitMaxX(i), JitMaxY(i), JitSTDVX(i), JitSTDVY(i)] = jitterMag(data);  
    
    percentDone = 100*i/(length(files));
    msg = sprintf('Percent Completion: %0.1f\n',percentDone);
	fprintf([updateStr msg])
    updateStr = repmat(sprintf('\b'),1,length(msg)); %Deletes previous msg so that only current msg is visible

end

% compute averages
avgMagX = sum(JitMagX)/length(JitMagX);
avgMagY = sum(JitMagY)/length(JitMagY);
avgMaxX = sum(JitMaxX)/length(JitMaxX);
avgMaxY = sum(JitMaxY)/length(JitMaxY);
avgSTDVX = sum(JitSTDVX)/length(JitSTDVX);
avgSTDVY = sum(JitSTDVY)/length(JitSTDVY);

%%
%----------- make Histogram -----------------
close all
clc

% -------- magnitude of Jitter---------------
figure()
nbins = 20;
t = tiledlayout(3,2);
title(t, append('Characterization of Jitter in Phase: ', phase),'FontWeight','Bold');
subtitle(t, [num2str(length(files)),' Data Acquisitions']);
nexttile
h1 = histogram(JitMagX, nbins);
xlabel('Avg Magnitude [\murad]');
ylabel('Frequency');
title('Avg Magnitude, Angle X');
% subtitle(['Avg Mag per Phase: ', num2str(avgMagX),', Avg Max per Acquisition: ',num2str(avgMaxX),', Avg STDev per Aquisition: ',num2str(avgSTDVX)]);
grid on

nexttile
h2 = histogram(JitMagY, nbins);
xlabel('Avg Magnitude [\murad]');
ylabel('Frequency');
title('Avg Magnitude, Angle Y');
% subtitle(['Avg Mag per Phase: ', num2str(avgMagY),', Avg Max per Acquisition: ',num2str(avgMaxY),', Avg STDev per Aquisition: ',num2str(avgSTDVY)]);
grid on

% -------- Average Max Jitter -------
nexttile
h3 = histogram(JitMaxX, nbins, 'FaceColor','red');
xlabel('Max Magnitude [\murad]');
ylabel('Frequency');
title('Maximum Jitter, Angle X');
grid on

nexttile
h4 = histogram(JitMaxY, nbins, 'FaceColor','red');
xlabel('Max Magnitude [\murad]');
ylabel('Frequency');
title('Maximum Jitter, Angle Y');
grid on

% ---------- standard deviation ---------
nexttile
h5 = histogram(JitSTDVX, nbins, 'FaceColor','magenta');
xlabel('Standard Deviation [\murad]');
ylabel('Frequency');
title('Standard Deviation of Magnitude, Angle X');
grid on

nexttile
h6 = histogram(JitSTDVY, nbins, 'FaceColor','magenta');
xlabel('Standard Deviation [\murad]');
ylabel('Frequency');
title('Standard Deviation of Magnitude, Angle Y');
grid on

fprintf(['Mean X mag: ', num2str(mean(JitMagX)),'\n']);
fprintf(['Mean Y mag: ', num2str(mean(JitMagY)),'\n']);

toc
