
function pd_plot(pfa)

if ((pfa<0)|(pfa>1)|~isnumeric(pfa))  
   error('Error. Input must be valid')
end

figure(1); cla;
    [snr, pd] = pd1graph(pfa);
    plot(snr,pd,'DisplayName',num2str(pfa))
    
    grid on;
    legend('show')
title('Probability-Of-Detention vs. Signal-To-Noise-Ratio(db)');
axis([0 18 0.01 100]);