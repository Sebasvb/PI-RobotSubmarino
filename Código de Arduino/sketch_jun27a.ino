// Librerías necesarias
#include <SoftwareSerial.h>
#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"

///////////////////////////////////   CONFIGURACIÓN /////////////////////////////

// La dirección I2C por defecto es 0x68
MPU6050 accelgyro(0x69); 


//Variables globales
int16_t ax, ay, az, gx, gy, gz; //AceleraФciones y giros en cada eje

int i=0;
String dataString;

String DataSensores;

SoftwareSerial BTserial(10, 11); // RX | TX

// Factores de conversion
const float accScale = 2.0 * 9.81 / 32768.0;
const float gyroScale = 250.0 / 32768.0;

///////////////////////////////////   SETUP   ////////////////////////////////////
void setup() {
  
  Wire.begin(); //Inicializa libreria Wire
  Serial.begin(9600); //Inicializa comunicación serial
  BTserial.begin(9600);
  accelgyro.initialize(); //Inicializa dispositivo
  accelgyro.setXAccelOffset(-1567);
  accelgyro.setYAccelOffset(-1045);
  accelgyro.setZAccelOffset(1877);                                                                                                 
  accelgyro.setXGyroOffset(-642); 
  accelgyro.setYGyroOffset(10); 
  accelgyro.setZGyroOffset(0);
  delay(1000);
}

///////////////////////////////////   LOOP   ////////////////////////////////////
void loop() {
    
    lectura_sensores();
    ventana();
    mostrar_pantalla();
    delay(2);

    DataSensores= String(ax*accScale) + "," + String(ay*accScale) + "," + String(az*accScale) + "," + String(gx*gyroScale) + "," + String(gy*gyroScale) + "," + String(gz*gyroScale) ;
    BTserial.print(DataSensores);
}

///////////////////////////////////   FUNCIONES  ////////////////////////////////////
void lectura_sensores(){

    // Leemos lecturas del dispositivo
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  }
  
void ventana(){
  
  //Los valores entre -200 y +200 son considerados nulos
  if(ax>(-200) && ax<(200))
    ax=0;
  if(ay>(-200) && ay<(200))
    ay=0;
  if(az>(-200) && az<(200))
    az=0;
  if(gx>(-150) && gx<(150))
    gx=0;
  if(gy>(-150) && gy<(150))
    gy=0;
  if(gz>(-150) && gz<(150))
    gz=0;
    
}

void mostrar_pantalla(){ //Se muestran por pantalla los valores de las aceleraciones, tiempo de lectura y giros

    Serial.print(ax*accScale);
    Serial.print("\t");
    Serial.print(ay*accScale);
    Serial.print("\t");
    Serial.print(az*accScale);
    Serial.print("\t");
    Serial.print(gx*gyroScale);
    Serial.print("\t");
    Serial.print(gy*gyroScale);
    Serial.print("\t");
    Serial.println(gz*gyroScale);
    delay(2000);
}
