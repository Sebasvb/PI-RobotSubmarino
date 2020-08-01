clear all,
close all
clc,
load("MobileSensorData/Final .mat"),
posX = Orientation.X.';
posY = Orientation.Y.';
posZ = Orientation.Z;
%varpos = mean([cov(posX),cov(posY),cov(posZ)]);
varpos = cov(posY);
varP = 1e+2;
GX=0; GX=0; GZ=0;
PX=0; PY=0; PZ=0;
Xp = 0; XpY = 0;
Xe = posX(1); XeY = posY(1);
%Karman process
%subplot(2,1,2)
for(i= 1:length(posX))
[PX,GX,Xe,Xp] = KalmaFilterF(posX(i), PX, 5, varpos,Xe,Xp);
[PY,GY,XeY,XpY] = KalmaFilterF(posY(i), PY, 5, varpos,XeY,XpY);
Xe_i(i)=Xe;
XeY_i(i)=XeY;
% subplot(2,2,1)
% plot(posX(1:i)), hold on,
% axis([0 213 20 120])
% title('Muestreo de la orientación en X')
% subplot(2,2,3)
% plot(Xe_i), hold on,
% title('Resultado del filtro de Kalman')
% axis([0 213 20 120])
subplot(2,1,1)
plot(posY(1:i)), hold on,
subplot(2,1,2)
plot(XeY_i), hold on,
pause(0.1)
end