  int pinR = 23; ///
  int pinG = 24;
  int pinB = 25;
  int pinW = 26; ///
   
    void setup()
    {
      Serial.begin(9600);
      // output pins
      pinMode(pinR, OUTPUT); // rojo
      pinMode(pinG, OUTPUT); // verde
      pinMode(pinB, OUTPUT); // azul
      pinMode(pinW, OUTPUT); // blanco
    }
    
    void loop()
    {
      escribeSerialRGBWpc();
      delay(10);
      leerSerialPWM();
    }
    
    void leerSerialPWM(){
      Serial.println(100);
    }
    
    void escribeSerialRGBWpc(){
      switch(leerPuerto())
      {
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
    int leerPuerto()
    {
      while (Serial.available()<=0) {
      }
      return Serial.read();
    }

