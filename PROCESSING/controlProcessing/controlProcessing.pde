import controlP5.*;
ControlP5 cp5;
Slider2D s;
sliderV sV1, sV2, sV3, sV4;
color cor;
import processing.serial.*;
String portname= "/dev/ttyUSB0";
Serial port;
PImage img, img2, img3;
int valor;//Valor de la temperatura

void setup() {
  size(1350, 800);
  img = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/tux.png");
  img2 = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/cromatico.jpg");
  img3 = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/espectrovisible.png");
  println("Available serial ports:");
  println(Serial.list()[0]);
  
  // check on the output monitor wich port is available on your machine
 port = new Serial(this, Serial.list()[0], 9600);
//port= new Serial(this,portname,9600);
  // create 3 instances of the sliderV class
  sV1 = new sliderV(50, 200, 90, 255, #FF0000); //ubicacion x, ubicacion y, ancho, largo
  sV2 = new sliderV(150, 100, 90, 255, #03FF00);
  sV3 = new sliderV(250, 100, 90, 255, #009BFF);
  sV4 = new sliderV(350, 200, 90, 255, #FFFFFF);
  
  cp5 = new ControlP5(this); //graficamos puntero pantalla azul
  s = cp5.addSlider2D("onda")
         .setPosition(600,240)
         .setSize(200,200)
         .setMinMax(0,0,100,100) //Define valores minimos y maximos de amplitud y frecuencia
         .setValue(40,50); // Asigna unos valores iniciales para amplitud y frecuencia
         //.disableCrosshair();
  smooth();
}

/* 
Funcion para dibujar sliders y visualizador de onda
*/
void draw() {
  background(0);
image(img, 1100, 500);
image(img2, 100, 400);
image(img3, 600, 40);
  sV1.render();
  sV2.render();
  sV3.render();
  sV4.render();
 // println();
  // send sync character
  // send the desired value
 port.write('R');
 port.write(sV1.p);
 port.write('G');
  port.write(sV2.p);
  port.write('B');
  port.write(sV3.p);
  port.write('W');
  port.write(sV4.p);
  
  pushMatrix();
  translate(820,340); // Define posicion de visualizador de onda
  noStroke();
  fill(50);
  rect(0, -100, 500,200);
  strokeWeight(1);
  line(0,0,200, 0);
  stroke(255);
  
  for(int i=1;i<500;i++) { //Define tamaño max de la onda comprendida entre -PI,PI
    float y0 = cos(map(i-1,0,s.getArrayValue()[0],-PI,PI)) * s.getArrayValue()[1]; 
    float y1 = cos(map(i,0,s.getArrayValue()[0],-PI,PI)) * s.getArrayValue()[1];
    line((i-1),y0,i,y1);
  }
    popMatrix();
    
  //Recibir datos por puerto serial de una variable (temperatura) 
  if(port.available() > 0) // si hay algún dato disponible en el puerto
   {
     valor=port.read();//Lee el dato y lo almacena en la variable "valor"
   }
   //Visualizamos la temperatura con un texto
   text("Lectura de datos",490,580);
   text("Temperatura =",490,600);
   text(valor, 620, 600);
   text("ºC",647,600);
}


/* 
Slider Class
*/
class sliderV {
  int x, y, w, h, p;
  color cor;
  boolean slide;

    sliderV (int _x, int _y, int _w, int _h, color _cor) {
      x = _x;
      y = _y;
      w = _w;
      h = _h;
      p = 60; //Valor (0-255) del PWM inicial
      cor = _cor;
      slide = true;
    }

    void render() {
      fill(cor);
     // rect(90, 20, 300, 40);
     //fill(255);
      rect(x-1, y-4, w, h+10);
      noStroke();
      fill(100);
      rect(x, h-p+y-5, w-2, 13);
      fill(255);
      textSize(11);
      text(p, x+2, h-p+y+6);
     
      if (slide==true && mousePressed==true && mouseX<x+w && mouseX>x){
       if ((mouseY<=y+h+150) && (mouseY>=y-150)) {
          p = h-(mouseY-y);
          if (p<0) {
            p=0;
          }
          else if (p>h) {
            p=h;
          }
        }
      }
      textSize(25);
      fill(255);
      text("COMBINATORIAS RGBW", 100, 70); 
      textSize(16);
      String s = "Este obra está bajo una licencia de Creative Commons Reconocimiento-NoComercial 4.0 Internacional";
      fill(255);
      text(s, 700, 500, 400, 400);
    }
}

void keyPressed() //Cuando se pulse una tecla
{
  
  if(key=='s' || key=='S')
  {
    exit();//Salimos del programa
  }
}