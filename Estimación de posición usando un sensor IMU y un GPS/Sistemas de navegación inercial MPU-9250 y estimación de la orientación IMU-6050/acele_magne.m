clear all,
close all,
clc,
%%
%load("MobileSensorData/Final .mat"),
posX = Acceleration.X.';
posY = Acceleration.Y.';
posZ = Acceleration.Z.';
magX = MagneticField.X.';
magY = MagneticField.Y.';
magZ = MagneticField.Z.';
%%
%varpos = mean([cov(posX),cov(posY),cov(posZ)]);
varpos = 0.07;
PX=0; PY=0; PZ=0;
Xp = 0; XpY = 0; XpZ = 0;
Xe = posX(1); XeY = posY(1); XeZ = posZ(1);
Q = zeros(1,length(posX)+1);
Q_p = zeros(1,length(posX)+1);
%Karman process
x=0:1:120;
%subplot(2,1,2)
for(i= 1:length(posY))
    [PX,GX,Xe,Xp] = KalmaFilterF(posX(i), PX, 0.07, varpos,Xe,Xp);
    [PY,GY,XeY,XpY] = KalmaFilterF(posY(i), PY, 0.07, varpos,XeY,XpY);
    [PZ,GZ,XeZ,XpZ] = KalmaFilterF(posZ(i), PZ, 0.07, varpos,XeZ,XpZ);
    Xe_i(i)=Xe;
    XeY_i(i)=XeY;
    XeZ_i(i)=XeZ;
    Q(i+1)=Q(i)+0.1/2*(posX(i)+posX(i+1));
    Q_p(i+1)=Q_p(i)+0.1/2*(Q(i)+Q(i+1));
    subplot(3,1,1)
    plot(posX(1:i),'g'), hold on,
    plot(Xe_i,'r'), hold on,
    title('Aceleración en X'), ylabel('Magnitud')
    subplot(3,1,2)
    plot(posY(1:i),'g'), hold on,
    plot(XeY_i,'r'), hold on,
    title('Aceleración en Y'), ylabel('Magnitud')
    subplot(3,1,3)
    plot(posZ(1:i),'g'), hold on,
    plot(XeZ_i,'r'), hold on,
    title('Aceleración en Z'), ylabel('Magnitud')
    pause(0.1)
end
%% Calculo de orientación por acelerómetro
for(i= 1:length(posY))
    y(i) = (atan2(XeY_i(i),XeZ_i(i)))*180/pi;
    xAA(i) = (atan(Xe_i(i)/XeZ_i(i)))*180/pi;
    z(i) = (atan2(XeY_i(i),Xe_i(i)))*180/pi;
    x(i) =  atan(Xe_i(i)/(sqrt(XeY_i(i)^2+XeZ_i(i)^2)));
    x2(i) = atan(posX(i)/(sqrt((posY(i))^2+(posZ(i))^2)))*180/pi;
    x3(i) = atan((sqrt((posX(i))^2+(posY(i))^2))/posZ(i))*180/pi;
    x4(i) = atan((sqrt((Xe_i(i))^2+(XeY_i(i))^2))/XeZ_i(i))*180/pi;
end
figure,
subplot(3,1,1)
% plot(y)
subplot(3,1,2)
plot(xAA)
figure,
plot(x3)
subplot(3,1,3)
plot(z)
%% Calculo de orientación por magnetometro
for(i= 1:length(posY))
    xm(i) = ((atan2(-magY(i),-magX(i))))*180/pi+90;
    ym(i) = ((atan2(-magY(i),-magX(i))))*180/pi+90;
end
figure,
plot(xm)