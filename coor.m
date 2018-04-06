function sig_d = coor
global n;
rho = zeros([1 n-1]);
for k = 0:+1:n-2
    c = corr_coef(imread(strcat('test_',int2str(k),'.png')),imread(strcat('test_',int2str(k+1),'.png')));
    rho(k+1) = c;
end
g = sort(rho,'descend');
y = g(1);
x = g(2);
z = g(3);
k = find(rho==y);
alpha_1 = z-x;
alpha_2 = 2*(2*y-x-z);
vari = 0.01;
Intensity_location = imread(strcat('test_',int2str(k),'.png'));
K = gpt_contrast(Intensity_location);
[m1, m2] = size(Intensity_location);
m = m1*m2;
sig_d = sqrt(2*(2*K*vari.^2+m*vari.^4)/(K.^2*(alpha_2.^2+12*alpha_1.^2)));