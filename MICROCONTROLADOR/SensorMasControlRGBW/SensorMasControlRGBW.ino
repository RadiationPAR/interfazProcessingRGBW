/*
Conexiones Pines
---------------
LED
pinR      10
pinG      13
pinB      14
pinW      9

Sensor    LaunchPad   Comment
VCC       3V3
GND       GND
S0        31          Selección para salida de escalado de frecuencia
S1        32          Selección para salida de escalado de frecuencia
S2        33          Selección del tipo de fotodiodo
S3        34          Selección del tipo de fotodiodo
OE        39          habilitación de salida (active low)
OUT       40          Salida-->Onda Cuadrada

 
Opciones seleccionables
------------------
S0    S1    Escalado de frecuencia de salida
L     L     Apagado
L     H     2%
H     L     20%    
H     H     100%

Nota: De acuerdo con la hoja de datos, las salidas a escala reducida se pueden usar cuando
un contador de frecuencia más lenta está disponible. Las funciones PulseIn() maneja un
escalado de frecuencia fijado en un 20%.

s2    S3    Tipo de fotodiodo seleccionado
L     L     Rojo
L     H     Azul
H     L     Sin filtro 
H     H     Verde 

*/

// Declaracion de pines en el Tiva
int S0 = 31;
int S1 = 32;
int S2 = 33;
int S3 = 34;
int OEPin = 39;
int outPin = 40;

  int pinR = 23; ///
  int pinG = 24;
  int pinB = 25;
  int pinW = 26;

//Los pines a continuacion deben evaluarse
int ledRojo = 5;
int ledVerde = 6;
int ledAzul = 7;


// constantes - ajustables si se presentan lecturas pobres debido a ruido generado por otras fuentes de luz
const int Rc = 100;                      //Responsividad relativa clara
const int Rr = 99;                       // Responsividad relativa roja
const int Rg = 65;                       // Responsividad relativa verde 
const int Rb = 70;                       // Responsividad relativa azul

void setup()
{
  Serial.begin(9600);
  pinMode(pinR, OUTPUT); // rojo
  pinMode(pinG, OUTPUT); // verde
  pinMode(pinB, OUTPUT); // azul
  pinMode(pinW, OUTPUT); // blanco
  
  pinMode(outPin, INPUT);               
  pinMode(OEPin, OUTPUT);
  digitalWrite(OEPin, LOW);              // Habilida el escalado de frecuencia
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  digitalWrite(S0, HIGH);                // configura el escalado de frecuencia
  digitalWrite(S1, LOW);                 
  pinMode(S2, OUTPUT);            
  pinMode(S3, OUTPUT);            
  pinMode(ledRojo, OUTPUT);              // Configura 3 leds RGB con el proposito de generar el color visto por el sensor 
  pinMode(ledVerde, OUTPUT);          
  pinMode(ledVerde, OUTPUT);             
}

void loop()
{
 
  digitalWrite(S2, HIGH);                // Se configura para tomar lectura sin filtro
  digitalWrite(S3, LOW);
  int cPulse = pulseIn(outPin, LOW);     // realiza la lectura
  Serial.print("C pulse = ");
  Serial.println(cPulse);            
  int Ac = cPulse * Rc;                  // ajusta la lectura con el valor de responsividad relativa clara
  
  digitalWrite(S2, LOW);                 // Se configura para tomar lectura filtro rojo
  digitalWrite(S3, LOW);
  int rPulse = pulseIn(outPin, LOW);     // realiza la lectura  
  Serial.print("R pulse = ");
  Serial.println(rPulse);
  int Ar = rPulse * Rr;                  // ajusta la lectura con el valor de responsividad relativa roja
  int Cr = Ar - Ac;                      // aplica correccion para su lectura clara
  
  digitalWrite(S2, HIGH);                // Se configura para tomar lectura filtro verde
  digitalWrite(S3, HIGH);
  int gPulse = pulseIn(outPin, LOW);     // realiza lectura
  Serial.print("G pulse = ");
  Serial.println(gPulse);
  int Ag = gPulse * Rg;                  // ajusta la lectura con el valor de responsividad relativa verde                 
  int Cg = Ag - Ac;                      // aplica correccion para su lectura clara
    
  digitalWrite(S2, LOW);                 // Se configura para tomar lectura filtro azul
  digitalWrite(S3, HIGH);
  int bPulse = pulseIn(outPin, LOW);     // realiza lectura
  Serial.print("B pulse = ");
  Serial.println(bPulse);
  int Ab = bPulse * Rb;                  // ajusta la lectura con el valor de responsividad relativa azul
  int Cb = Ab - Ac;                      // aplica correccion para su lectura clara

//-------------- Manejo de PWM por puerto serial ----------------
 
  switch(leerPuerto())
      {
       
          Serial.println(leerPuerto());
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
  //-------------- Encuentra composicion relativa de los colores en pasos de 0 a 255 ----------------
  int r;
  int g;
  int b;
  if (Cr < Cg && Cg < Cb)        //  orden del color RGB
  {
    r = 255;
    g = 128 * Cr / Cg;
    b = 16 * Cr / Cb;
  }
  else if (Cr < Cb && Cb < Cg)    //  orden del color RGB
  {
    r = 255;
    b = 128 * Cr / Cb;
    g = 16 * Cr / Cg;
  }
  else if (Cg < Cr && Cr < Cb)    //  orden del color RGB
  {
    g = 255;
    r = 128 * Cg / Cr;
    b = 16 * Cg / Cb;
  }
  else if (Cg < Cb && Cb < Cr)    //  orden del color RGB
  {
    g = 255;
    b = 128 * Cg / Cb;
    r = 16 * Cg / Cr;
  }  
  else if (Cb < Cr && Cr < Cg)    //   orden del color RGB
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
  
  /*----------- Salidas -----------*/
  Serial.println("");
  Serial.print("rojo = "); Serial.println(r);
  Serial.print("verde = "); Serial.println(g);
  Serial.print("azul = "); Serial.println(b); 
  Serial.println(""); 
  analogWrite(ledRojo, r);
  analogWrite(ledVerde, g);
  analogWrite(ledVerde, b);
  delay(1000);  
}

 // Funcion para leer el puerto serial
    int leerPuerto()
    {
      while (Serial.available()<=0) {
      }
      return Serial.read();
    }
