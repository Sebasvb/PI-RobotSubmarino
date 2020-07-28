%% Curso: Proyecto Interdisciplinario -  UTEC
%  Autor: Elvis Jara Alegria
%  Fecha: 11 de Junio del 2020



% NN with RBF to estimate the orientation
clear all;close all;clc;
load('data.mat')

figure;
subplot(411);plot(m3(1,:));title('magnetometro en x');
subplot(412);plot(m3(2,:));title('magnetometro en y');
subplot(413);plot(m3(3,:));title('magnetometro en z');
%subplot(414);plot(y);title('salida')

%(6:end)
X = m3([1 2],:)./20;            % solo las medidas respecto al eje x y y.
%s = (y - min(y))/360 -0.5;      % escalamos los datos
s = sind(y');
subplot(414);plot(s);title('salida')


error_minimo = 100;             % esta variable se irá actualizando conforme... 
                                % el algoritmo encuentre nuevos mínimos

%**************************************************************************
for Nr = 2:100                  % Probamos incrementando las neuronas 
    
    
    centroX = rand(1,Nr)*(max(X(1,:))-min(X(1,:))) + min(X(1,:));
    centroY = rand(1,Nr)*(max(X(2,:))-min(X(2,:))) + min(X(2,:));
    
    centros = [centroX; centroY];

    %radios = r*ones(length(centro));
    r = 0.05;   % 0.05
    R = [r 0; 0 r];

    h = @(x,c) exp((-(x-c)'*inv(R)*(x-c))); % gaussiana x y c: vectores columna

    for N=1:length(s)
        for m=1:Nr
            H(N,m) = h(X(:,N),centros(:,m));
        end
    end

    %% Estimación de los pesos w

    w = inv(H'*H)*H'*s; % pinv(H)*s

    ye = zeros(size(s));
    for i=1:Nr
        ye = ye + w(i).*H(:,i);
    end


    %% Errors

    error = norm(ye - s)^2/length(s);


   if error < error_minimo
        error_minimo = error;
        w_best = w;
        H_best = H;
        Nr_best = Nr;   
        centros_best = centros;
    end
    clear 'ye'    
end
%**************************************************************************

disp(strcat('Best result using ',num2str(Nr_best),' neurons'))
disp(strcat('trainning error:',num2str(error_minimo)))

ye = zeros(size(s));
for i=1:Nr_best
    ye = ye + w_best(i).*H_best(:,i);
end

%% Plot de resultados
%yee = 360*(ye + 0.5) + min(y);
yee = ye;

figure;
subplot(211);plot(s,'LineWidth',2);grid on;
title('measured orientation');
xlabel('sample');ylabel('orientation(°)')
subplot(212);plot(yee,'LineWidth',2);grid on;
title('estimated orientation');
xlabel('sample');ylabel('orientation(°)')
%title('Modeling using a neural network with RBF');

figure;
plot(centros_best(1,:),centros_best(2,:),'*');title(centros)
xlabel('x_1');ylabel('x_2');title('centers of the RBFs');

% theta_modelo = 80; 
% theta_deseado = 80;

