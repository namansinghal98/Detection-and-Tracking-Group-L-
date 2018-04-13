function pd_graphcustom()

pfa = [1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-8,1e-10,1e-12,1e-14,1e-16,1e-20];
figure(1); cla;

for R = 1:12
    hold on
    [snr, pd] = pd1graph(pfa(1,R));
    
      for i = 1:size(pd,2)
          if pd(i)<=20
            pd(i)=2*log2(pd(i)+1);
          elseif pd(i)<=80
            pd(i)= (pd(i)-20)/(60)*log2(21)+2*log2(21);
          elseif pd(i)>80
              pd(i)= 5*log2(21)-2*log2(100-pd(i)+1);
          end
     end
    
    plot(snr,pd,'DisplayName',num2str(pfa(1,R)))
end
    grid on;
    
   
    yy = [0,2*log2(1+0.01),2*log2(1+0.05),2*log2(1+0.5),2*log2(1+1),2*log2(1+2),2*log2(1+5),2*log2(1+10),2*log2(1+20),(30+100)/60*log2(21),(40+100)/60*log2(21),(50+100)/60*log2(21),(60+100)/60*log2(21),(70+100)/60*log2(21),(80+100)/60*log2(21),5*log2(21)-2*log2(100-90),5*log2(21)-2*log2(100-95),5*log2(21)-2*log2(101-98),5*log2(21)-2*log2(101-99),5*log2(21)-2*log2(101-99.5),5*log2(21)-2*log2(101-99.9),5*log2(21)];
    
    
    yticks(yy);
    for i = 1:size(yy,2)
         if yy(i)<=2*log2(21)
            yy(i)=2^(yy(i)/2)-1;
         elseif yy(i)<=3*log2(21)
             yy(i)= (yy(i)- 2*log2(21))/log2(21)*60 +20;
          elseif yy(i)>3*log2(21)
              yy(i)= 101 -2^((5*log2(21) - yy(i))/2);
         end
    end
    
    yticklabels(yy);
    legend('show')
    xticks(0:18);

title('Probability-Of-Detention vs. Signal-To-Noise-Ratio(db)');
axis([0 18 0 5*log2(21)]);