void setup(){
  size(200, 200); 
}

void draw(){
  background(0);
  stroke(255);
  RGBtoHSL();

}

/************FUNCIONES ADICIONALES******************/
void RGBtoHSL() {
  float R = 24;
  float G = 98;
  float B = 118;
  
  R = R-0.02; //Se restan pequeñas fracciones para no tener el caso RGB 255 en cada canal
  G = G-0.015;//esto permite que las ecuaciones Matiz y saturacion se cumplan 
  B = B-0.005;
  
  float saturacion = 0.0;
  float matiz = 0.0;
  float Rh, Gh, Bh;
  Rh = R/255;
  Gh = G/255;
  Bh = B/255;
  
  float[] valoresRGB = { Rh, Gh, Bh};  // arreglo de datos con punto flotante
  float colorMax = max(valoresRGB); // Obtenemos el valor maximo del arreglo
  float colorMin = min(valoresRGB); // Obtenemos el valor maximo del arreglo
  
  float luminancia = (colorMax+colorMin)/2; // 1=100%
  
/**************  RGB-CMY **************/
  float C,M,A;
  C = 1 - Rh; //Cian
  M = 1 - Gh;  //Magenta
  A = 1 - Bh;  //Amarillo
  
/************** Se decide la ecuacion para el ajuste de Saturacion **************/   
    if(luminancia < 0.5){
      saturacion = (colorMax - colorMin)/(colorMax + colorMin);
    }
    if(luminancia > 0.5){
      saturacion = (colorMax - colorMin)/(2.0 - colorMax + colorMin);
    }

/************** Se decide la ecuacion para el ajuste de la matiz **************/    
    if(R>G && R>B){
      println("R es Mayor");
      matiz = (Gh-Bh)/(colorMax-colorMin);
      //println(matiz);
     } 
    if(G>R && G>B){
      println("G es mayor");
      matiz = 2.0 + (Bh-Rh)/(colorMax-colorMin);
     // println(matiz);
    }
    if(B>R && B>G){
      println("B es Mayor");
      matiz = 4.0 + (Rh-Gh)/(colorMax-colorMin);
    }
/************** Se decide la ecuacion para el ajuste de posicion XYZ **************/     
    if(Rh > 0.04045){
      Rh = pow(((Rh + 0.055) / 1.055 ), 2.4); //float b = pow( 3, 5);  // Sets 'b' to 3*3*3*3*3 = 243
    }else{                   
      Rh = Rh / 12.92;
    }
    if(Gh > 0.04045){
      Gh = pow(((Gh + 0.055) / 1.055 ),2.4);
    }else{
      Gh = Gh / 12.92;
    }
    if(Bh > 0.04045){
      Bh = pow(((Bh + 0.055 ) / 1.055 ),2.4);
    }else{
      Bh = Bh / 12.92;
    }
  Rh = Rh * 100;
  Gh = Gh * 100;
  Bh = Bh * 100;
  float X,Y,Z;
  X = Rh * 0.4124 + Gh * 0.3576 + Bh * 0.1805;
  Y = Rh * 0.2126 + Gh * 0.7152 + Bh * 0.0722;
  Z = Rh * 0.0193 + Gh * 0.1192 + Bh * 0.9505;
  
   /*Me gustaria fragmentar el cod en pequeños arreglos*/
  float anguloMatiz = matiz * 60 ; // Convierte a grados
  //println(R,G,B,Rh,Gh,Bh,colorMax,colorMin, matiz, anguloMatiz);  
  
  float pi=3.141592654;
  float anguloRadian=(pi/180)*anguloMatiz; // convierte angulos a radianes
  trazoAngular(100, 100, anguloRadian, 70);  //posicion x, posicion y, anguloRadian en radianes, magnitud
  println("CMY");
  println(C,M,A);
  println("HSL");
  println(anguloMatiz,saturacion,luminancia);
  println("XYZ");
  println(X,Y,Z); 
}

void trazoAngular(int x, int y, float anguloRadian, float length){
  strokeWeight(3); // Añade un grosor al trazo
  line(x, y, x+cos(anguloRadian)*length, y-sin(anguloRadian)*length); //line(x1, y1, x2, y2)
}