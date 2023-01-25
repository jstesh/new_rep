clear, clc

m = 1;
k = 1;
g = 10;
betta = 1;
N = 21;
a = -1;
b = 1;
dt = 0.1;
t_max = 1000;
t = t_max/dt;
len = (b-a)/(N-1);

%X = a:len:b;
X = linspace(a,b,N)
y = @(x) 127*x^2 - 127;

a_x = zeros(N, 1);
a_y = zeros(N, 1);

v_x = zeros(N, 1);
v_y = zeros(N, 1);

u_x = zeros(N, 1);
u_y = zeros(N, 1);

for i = 1:N
    u_x(i)= X(i);
    u_y(i)= y(X(i));
end

l0 = sqrt((u_x(2)-u_x(1))^2+(u_y(2)-u_y(1))^2)/2;


figure
h = animatedline(u_x, u_y, "Color", "red", "Marker", "o")
grid on

%приводим в павновесное состояние
for tau = 0:t
    for i = 2:N-1
        l_left = sqrt((u_x(i)- u_x(i-1))^2+(u_y(i)- u_y(i-1))^2);
        l_right = sqrt((u_x(i+1)- u_x(i))^2+(u_y(i+1)- u_y(i))^2);
        
        if l_right < l0
            FR = 0;
        else
            FR = l_right - l0;
        end 
        
        if l_left < l0
            FL = 0;
        else
            FL = l_left - l0;
        end
          a_x(i) = (k/m)*(FR*(u_x(i+1)-u_x(i))/l_right - FL*(u_x(i) - u_x(i-1))/l_left)-betta*v_x(i);
          a_y(i) = ((k/m)*(FR*(u_y(i+1)-u_y(i))/l_right - FL*(u_y(i) - u_y(i-1)) /l_left)- g)-betta*v_y(i);
          v_x(i) = v_x(i)+ a_x(i)*dt;
          v_y(i) = v_y(i)+ a_y(i)*dt;
  end
   for i = 2:N
       u_x(i) = u_x(i) + v_x(i)*dt;
       u_y(i) = u_y(i) + v_y(i)*dt;
   end
    
   addpoints(h, u_x, u_y);
   drawnow limitrate
   clearpoints(h);
end   
u_x
u_y
a1 = 0;
v =0;
u = 0;
dtt = 0;
tau1 = [];
dy = [];
l0 = sqrt((u_x(2)-u_x(1))^2+(u_y(2)-u_y(1))^2)/2;
figure
h = animatedline(u_x, u_y, "Color", "red", "Marker", "o")
grid on
xlim([-2,2])

%отпускаем конец
for tau = 0:t
    dy(tau+1) =8;
    for i = 2:N-1
        l_left = sqrt((u_x(i)- u_x(i-1))^2+(u_y(i)- u_y(i-1))^2);
        l_right = sqrt((u_x(i+1)- u_x(i))^2+(u_y(i+1)- u_y(i))^2);
        
        if l_right < l0
            FR = 0;
        else
            FR = l_right - l0;
        end 
        
        if l_left < l0
            FL = 0;
        else
            FL = l_left - l0;
        end
          a_x(i) = (k/m)*(FR*(u_x(i+1)-u_x(i))/l_right - FL*(u_x(i) - u_x(i-1))/l_left)-betta*v_x(i);
          a_y(i) = ((k/m)*(FR*(u_y(i+1)-u_y(i))/l_right - FL*(u_y(i) - u_y(i-1)) /l_left)- g)-betta*v_y(i);
          v_x(i) = v_x(i)+ a_x(i)*dt;
          v_y(i) = v_y(i)+ a_y(i)*dt;
    end
    
       l_left2 = sqrt((u_x(N)- u_x(N-1))^2+(u_y(N)- u_y(N-1))^2);

        if l_left2 < l0
            FL = 0;
        else
            FL = l_left2 - l0;
        end
          a_x(N) = (k/m)*(-FL*(u_x(N) - u_x(N-1))/l_left2)-betta*v_x(N);
          a_y(N) = ((k/m)*(-FL*(u_y(N) - u_y(N-1)) /l_left2)-g) - betta*v_y(N);
          v_x(N) = v_x(N)+ a_x(N)*dt;
          v_y(N) = v_y(N)+ a_y(N)*dt;
          
   %ускорение твердого тела
   
   for i = 2:N
       u_x(i) = u_x(i) + v_x(i)*dt;
       u_y(i) = u_y(i) + v_y(i)*dt;
   end
   a1 = a1 - g - betta*v;
   v = v + a1*dt;
   u = u+v*dt;
   dtt = dtt+dt;
   
   dy(tau+1) = u_y(N) - u;
   u_y(N);
   u;
   tau1(tau+1) = dtt;
    
   addpoints(h, u_x, u_y);
   drawnow limitrate
   clearpoints(h);
end  
 %dy
figure
plot(tau1, dy)
grid on




