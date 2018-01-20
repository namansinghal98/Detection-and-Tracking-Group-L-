% FILE: pfdans.m
% Use this function to give probability of detection for prob of false alarm and signal to noise ratio 

function pfdans(pfa,snr)


		global temp % Make alpha global to pass it to funtion1.
		threshold = sqrt(-2*(log(pfa))) ;
		temp = 10.^((snr+3) / 20);
		pd = 1 - quad('function1', 0, threshold, [1e-1 1.e-3])