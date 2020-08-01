%seguimiento de imágenes
%vidDevice=imaq.VideoDevice('winvideo',1, 'YUY2_640X480','ROI', [1 1 640 480],'ReturnedColorSpace','rgb');
%vidInfo=imaqhwinfo(vidDevice);

vid= videoinput('winvideo',1); %capturar los fotogramas del video
%preview(vid)
%pause(1)
%%img*getsnapshot(vid);
%%delete(vid);
%%imshow(img)
%videoFileReader=VideoReader('MULTITUD.avi');
%myVideo=VideoWriter('DETECCION_EN_MULTITUD.avi');

%depVideoPlayer=vision.DeployableVideoPlayer;
%faceDetector=vision.CascadeObjectDetector();
%open(myVideo)


set(vid,'FramesPerTrigger',Inf); %propiedades del objeto de video
set(vid,'ReturnedColorspace','rgb')
vid.FrameGrabInterval=5; %Especifica la ferecuencia con la que desea adquirir el marco de la secuencia de video
start(vid) %inicia la adquisicion de video
%%
while(vid.FramesAcquired<=200) %bucle que se detiene 
    data= getsnapshot(vid); %obtener la instantanea del fotograma actual
    %para el seguimiento de objetos rojos hay que subtraer el componente
    %rojo de la imgen en escala de grises
    diff_im= imsubtract(data(:,:,3), rgb2gray(data)); %z =insubtract (X,Y) resta cada elemento en la matriz y
    % del elemento correspondiente e la matriz X y devuelve ladiferencia en
    % el elemento correspondiente de la matriz de salida Z
    diff_im= medfilt2(diff_im, [3 3]); %usa un filtro medio para filtrar el ruido
    diff_im= im2bw(diff_im,0.1); %convierte una imagen escala de grises a imagen binaria se indica la luminancia de 0 a 1
    diff_im= bwareaopen(diff_im, 300); % quita los pixeles menores a 300 px
    
    %% etiqueta todos los componentes conectados en la imagen.
    bw= bwlabel(diff_im, 8); %devuelve una matriz de etiqueta, donde el 8 especifica la conectividad. default
    %obtenemos un conjunto de propiedades para cada region etiquetada
    imagen= regionprops(bw,'BoundingBox','Centroid');%se obtiene las dimensiones se encierra en un rectangulo y setoma el centro
    imshow(data)
    hold on
    %%este es un bucle para unir los objetos rojos en una caja rectangular
    for object= 1:length(imagen)
        bb=imagen(object).BoundingBox;
        bc=imagen(object).Centroid; %encuentra el centro del objeto encerrado
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2) %encierra la imagen bb de color rojo y de grosor tipo 2
        %plot(bc(1),bc(2))
        plot(bc(1),bc(2), 'y+')%el signo + estara de color amarillo
        a=text(bc(1),bc(2),strcat('X: ',num2str(round(bc(1))),'  Y: ',num2str(round(bc(2))))); %colocamos los ejes x y
        set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'Color','yellow');
    end
    
    hold off
end
%%
stop(vid); %para la adquisicion de video
flushdata(vid); %Vaciar todos los datos de imagen almacenados en el bufer de memoria
clear all
clc
%3 nota azul 0.1
%1 rojo 0.2 o 0.18 0.3

