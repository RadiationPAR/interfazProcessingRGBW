  int pinR = 10; ///
  int pinG = 13;
  int pinB = 14;
  int pinW = 9; ///
   
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
    }
    
    // lee el puerto serial
    int leerPuerto()
    {
      while (Serial.available()<=0) {
      }
      return Serial.read();
    }
