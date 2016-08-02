/*
Sensor LaunchPadComment
VCC 3V3
GND GND
S0  31 Selección para salida de escalado de frecuencia
S1  32 Selección para salida de escalado de frecuencia
S2  33 Selección del tipo de fotodiodo
S3  34 Selección del tipo de fotodiodo
OE  39 habilitación de salida (active low)
OUT 40 Salida-->Onda Cuadrada

 
Opciones seleccionables
------------------
S0 S1 Escalado de frecuencia de salida
L  L  Apagado
L  H  2%
H  L  20% 
H  H  100%

Nota: De acuerdo con la hoja de datos, las salidas a escala reducida se pueden usar cuando
un contador de frecuencia más lenta está disponible. Las funciones PulseIn() maneja un
escalado de frecuencia fijado en un 20%.

s2 S3 Tipo de fotodiodo seleccionado
L  L  Rojo
L  H  Azul
H  L  Sin filtro
H  H  Verde
*/

/*
 ***********************************************************************
 *              LIBRERIAS y CONSTANTES
 ***********************************************************************
 */

/****Pines Lectura RGBW****/
int pinR = 23;
int pinG = 24;
int pinB = 25;
int pinW = 26;
/****-----------------------****/

/****Pines Lectura RGBW****/
int S0 = 31;
int S1 = 32;
int S2 = 33;
int S3 = 34;
int OEPin = 39;
int outPin = 40;
// constantes - ajustables si se presentan lecturas pobres debido a ruido generado por otras fuentes de luz
const int Rc = 100; //Responsividad relativa clara
const int Rr = 99;  // Responsividad relativa roja
const int Rg = 65;  // Responsividad relativa verde 
const int Rb = 70;  // Responsividad relativa azul
/****-----------------------****/

/*
 ***********************************************************************
 *              SETUP CONFIGURACIÓN INICIAL
 ***********************************************************************
 */
void setup() {
  configurarSerial();
  configurarSalidasPWM();
  configurarPinesSensor();
}

void configurarSerial() {
  Serial.begin(9600);
}

void configurarSalidasPWM() {
  pinMode(pinR, OUTPUT); // rojo
  pinMode(pinG, OUTPUT); // verde
  pinMode(pinB, OUTPUT); // azul
  pinMode(pinW, OUTPUT); // blanco
}

void configurarPinesSensor(){
  pinMode(outPin, INPUT);
  pinMode(OEPin, OUTPUT);
  digitalWrite(OEPin, LOW);// Habilida el escalado de frecuencia
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  digitalWrite(S0, HIGH);// configura el escalado de frecuencia
  digitalWrite(S1, LOW);  
  pinMode(S2, OUTPUT);
  pinMode(S3, OUTPUT);
}


/*
 ***********************************************************************
 *              LOOP BUCLE PRINCIPAL
 ***********************************************************************
 */
void loop() {
  leeSerialRGBW2PC();
  serialSensor();

}

void leeSerialRGBW2PC() {
  switch(leerPuerto()){
   case 'R':
    analogWrite(pinR, leerPuerto());
    break;
   case 'G':
    analogWrite(pinG, leerPuerto());
    break;
   case 'B':
    analogWrite(pinB, leerPuerto());
    break;
   case 'W':
    analogWrite(pinW, leerPuerto());
    break;
  }
}
// lee el puerto serial
int leerPuerto() {
  while (Serial.available()<=0) {}
  return Serial.read();
}

const int nMuestras = 200;
void serialSensor() {
  for (int i=0; i<nMuestras; i++){
    leerDatosSensor(i);
  }
  enviarDatosSensor();
}

struct SensorColor {
  int r[nMuestras];
  int g[nMuestras];
  int b[nMuestras];
  int cPulse[nMuestras];
  int rPulse[nMuestras];
  int gPulse[nMuestras];
  int bPulse[nMuestras];
  float promedio(int arreglo[]){
    float suma = 0;
    for (int x = 0; x < nMuestras; x++){
      suma += arreglo[x];
    }
    suma /= nMuestras;
    return suma;
  }
};

struct SensorColor datosSensor;

void enviarDatosSensor() {
  struct SensorColor sensor = datosSensor;
  
  Serial.print("cPulse="+String(sensor.promedio(sensor.cPulse))+"&");
  Serial.print("rPulse="+String(sensor.promedio(sensor.rPulse))+"&");
  Serial.print("gPulse= "+String(sensor.promedio(sensor.gPulse))+"&");
  Serial.print("bPulse="+String(sensor.promedio(sensor.bPulse))+"&");
  Serial.print("r="+String(sensor.promedio(sensor.r))+"&");
  Serial.print("g="+String(sensor.promedio(sensor.g))+"&");
  Serial.print("b="+String(sensor.promedio(sensor.b)));
  Serial.println(""); 
}

void leerDatosSensor(int i) {
  digitalWrite(S2, HIGH);// Se configura para tomar lectura sin filtro
  digitalWrite(S3, LOW);
  int cPulse = pulseIn(outPin, LOW);// realiza la lectura
  int Ac = cPulse * Rc;// ajusta la lectura con el valor de responsividad relativa clara
  
  digitalWrite(S2, LOW);// Se configura para tomar lectura filtro rojo
  digitalWrite(S3, LOW);
  int rPulse = pulseIn(outPin, LOW);// realiza la lectura
  int Ar = rPulse * Rr;// ajusta la lectura con el valor de responsividad relativa roja
  int Cr = Ar - Ac; // aplica correccion para su lectura clara
  
  digitalWrite(S2, HIGH);// Se configura para tomar lectura filtro verde
  digitalWrite(S3, HIGH);
  int gPulse = pulseIn(outPin, LOW);// realiza lectura

  int Ag = gPulse * Rg;// ajusta la lectura con el valor de responsividad relativa verde  
  int Cg = Ag - Ac;// aplica correccion para su lectura clara
 
  digitalWrite(S2, LOW);// Se configura para tomar lectura filtro azul
  digitalWrite(S3, HIGH);
  int bPulse = pulseIn(outPin, LOW);// realiza lectura
  int Ab = bPulse * Rb;// ajusta la lectura con el valor de responsividad relativa azul
  int Cb = Ab - Ac;                      // aplica correccion para su lectura clara
  
  //-------------- Encuentra composicion relativa de los colores en pasos de 0 a 255 ----------------
  int r;
  int g;
  int b;
  if (Cr < Cg && Cg < Cb)//  orden del color RGB
  {
    r = 255;
    g = 128 * Cr / Cg;
    b = 16 * Cr / Cb;
  }
  else if (Cr < Cb && Cb < Cg)//  orden del color RGB
  {
    r = 255;
    b = 128 * Cr / Cb;
    g = 16 * Cr / Cg;
  }
  else if (Cg < Cr && Cr < Cb)//  orden del color RGB
  {
    g = 255;
    r = 128 * Cg / Cr;
    b = 16 * Cg / Cb;
  }
  else if (Cg < Cb && Cb < Cr)//  orden del color RGB
  {
    g = 255;
    b = 128 * Cg / Cb;
    r = 16 * Cg / Cr;
  }  
  else if (Cb < Cr && Cr < Cg)//   orden del color RGB
  {
    b = 255;
    r = 128 * Cb / Cr;
    g = 16 * Cb / Cg;
  }  
  else // (Cb < Cg && Cg < Cr)    //   orden del color RGB
  {
    b = 255;
    g = 128 * Cb / Cg;
    r = 32 * Cb / Cr;
  }  
  
  
  datosSensor.r[i] = r;
  datosSensor.g[i] = g;
  datosSensor.b[i] = b;
  datosSensor.cPulse[i] = cPulse;
  datosSensor.rPulse[i] = rPulse;
  datosSensor.gPulse[i] = gPulse;
  datosSensor.bPulse[i] = bPulse;
}

