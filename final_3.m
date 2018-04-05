%tracking centroid of images using data available and tracking data of
%previous images

%generation of data
gaus_1
%centroid calculation
i1=imread('test_0.png');
i2=imread('test_1.png') ;   
f=pla(i1);
s=pla(i2);
tl=time;

t=[1,tl,0;0,1,0;1,0,0];

%calculating velocities in both direction
v1=(v)*(x_e-x_s)/dist;
v2=(v)*(y_e-y_s)/dist;

x=[s(1,1);v1;f(1,1)];
p=[tl*tl/2;1;0];
k=0;

%using the given equation to predict the centroid of images 
X=t*x+p*k;
centrex(1,1)=X(1,1);
velx(1,1)=X(2,1);
prevx(1,1)=X(3,1); 
y=[-s(1,2);v2;-f(1,2)];
Y=t*y+p*k;
centrey(1,1)=Y(1,1);
velv(1,1)=Y(2,1);
prevy(1,1)=Y(3,1);
for i=1:n-2
    t=[1,tl,0;0,1,0;1,0,0];
   
    x=[centrex(1,i);v1;prevx(1,i)];
    X=t*x+p*k;
    centrex(1,i+1)=X(1,1);
    velx(1,i+1)=X(2,1);
    prevx(1,i+1)=X(3,1);
    y=[centrey(1,i);v2;prevy(1,i)];
    Y=t*y+p*k;;
    centrey(1,i+1)=Y(1,1);
    velv(1,i+1)=Y(2,1);
    prevy(1,i+1)=Y(3,1);
end
centrex;
centrey;

%storing the predicted centroids in an array
k=pla(imread('test_0.png'));
l=pla(imread('test_1.png'));
a(1,1)=k(1,1);
a(1,2)=l(1,1);
b(1,1)=-k(1,2);
b(1,2)=-l(1,2);
for i=3:(n+1)
    a(1,i)=centrex(1,i-2);
    b(1,i)=centrey(1,i-2);
end
a;
b;
%calculates actual centroid of all the frames 
for i=0:(n-1)
    k=imread(strcat('test_',int2str(i),'.png'));
    c=pla(k);
    r(1,i+1)=c(1,1);
    h(1,i+1)=-c(1,2);
end
r;
h;
%plotting the predicted centroid data
plot(a,b,'o')
hold
%plotting the actual centroid data
plot(r,h,'*')


