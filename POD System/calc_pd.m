% FILE: pfdans.m
% Use this function to give probability of detection for prob of false alarm and signal to noise ratio 

function pd = calc_pd(pfa,snr)

if ((pfa<0)|(pfa>1)|(snr <0)|~isnumeric(pfa)|~isnumeric(snr))  
   error('Error. Input must be valid')
end

		global temp % Make alpha global to pass it to funtion1.
		threshold = sqrt(-2*(log(pfa))) ;
		temp = 10.^((snr+3) / 20);
		pd = 1 - quad('function1', 0, threshold);