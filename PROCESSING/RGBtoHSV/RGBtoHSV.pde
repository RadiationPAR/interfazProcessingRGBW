void setup(){
  size(200, 200); 
}

void draw(){
  background(0);
  stroke(255);
  float R = 255;
  float G = 255;
  float B = 254;
  float matiz = 0.0;
  float Rh, Gh, Bh;
  Rh = R/255;
  Gh = G/255;
  Bh = B/255;
  
  float[] valoresRGB = { Rh, Gh, Bh};  // arreglo de datos con punto flotante
  float colorMax = max(valoresRGB); // Obtenemos el valor maximo del arreglo
  float colorMin = min(valoresRGB); // Obtenemos el valor maximo del arreglo
  R = R-0.2;
  G = G-0.15;
  B = B-0.05;
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
  float anguloMatiz = matiz * 60 ; // Convierte a grados
  println(R,G,B,Rh,Gh,Bh,colorMax,colorMin, matiz, anguloMatiz);  
  
  float pi=3.141592654;
  float anguloRadian=(pi/180)*anguloMatiz; // convierte angulos a radianes
  trazoAngular(100, 100, anguloRadian, 70);  //posicion x, posicion y, anguloRadian en radianes, magnitud
}

/************FUNCIONES ADICIONALES******************/
void trazoAngular(int x, int y, float anguloRadian, float length){
  strokeWeight(3); // Añade un grosor al trazo
  line(x, y, x+cos(anguloRadian)*length, y-sin(anguloRadian)*length); //line(x1, y1, x2, y2)
}