function [JitMagX, JitMagY, JitMaxX, JitMaxY, JitSTDVX, JitSTDVY] = jitterMag(data)

angleX = data(:,5);
angleY = data(:,6);

% calculate jitter magnitudes for angle X and Y
movavgX = movmean(angleX, 1000); % moving average with subsets of 1000
movavgY = movmean(angleY, 1000);

magnitudeX = zeros(length(angleX),1);
magnitudeY = zeros(length(angleY),1);

for i = 1:length(angleX)
    magnitudeX(i) = abs(angleX(i)-movavgX(i));
    magnitudeY(i) = abs(angleY(i)-movavgY(i));
end

% return the average magnitude of jitter
JitMagX = sum(magnitudeX)/length(angleX); 
JitMagY = sum(magnitudeY)/length(angleY);

% return max jitter
JitMaxX = max(magnitudeX);
JitMaxY = max(magnitudeY);

% return standard deviation
JitSTDVX = std(magnitudeX);
JitSTDVY = std(magnitudeY);

end