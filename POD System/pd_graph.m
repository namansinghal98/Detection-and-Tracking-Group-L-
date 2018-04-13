% FILE: pd1graph.m
% Use this function to give graph probability of detection vs signal to noise ratio

function pd_graph()

pfa = [1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-8,1e-10,1e-12,1e-14,1e-16,1e-20];

figure(1); cla;
for R = 1:12
    hold on
    [snr, pd] = pd1graph(pfa(1,R));
    plot(snr,pd,'DisplayName',num2str(pfa(1,R)))
end
    grid on;
    legend('show')
title('Probability-Of-Detention vs. Signal-To-Noise-Ratio(db)');
axis([0 18 0.01 100]);