function f1 = mybutter(sig, cutoff, freq, pole, special)sig = double(sig);if nargin < 5	special = 'low';endif nargin < 4	pole = 2;endif nargin < 3	freq = 1000;endfreq = freq ./ 2;[b a] = butter(pole, cutoff/freq, special);f1 = filtfilt(b,a,sig);