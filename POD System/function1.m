% FILE: function1.m
% Use this function as integrand to evaluate the probability of detection
% It is called from pd1graph which graphs POD vs SNR for fixed Prob of False Alarm
function f = function1(v)
global temp
f = v .* exp(-(v.^2 + temp.^2)/2) .* besseli(0, temp.*v);