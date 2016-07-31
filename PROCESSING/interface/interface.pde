/*LIBRERIAS*/
import controlP5.*;
import processing.serial.*;

/*Variables previstas para graficos interactivos*/
ControlP5 cp5;
Slider2D s;
sliderV sV1, sV2, sV3, sV4;
color cor;

/*Definicion de variables para escribir datos PWM al TIVA*/
Serial port;
int R; //Tono rojo
int G; //Tono verde
int B; //Tono azul
int W; //Brillo

/* Tipo de datos para almacenar imágenes .gif, .jpg, .tga, .png */
PImage img, img2, img3;


void setup() {
  size(1350, 800); //Define un tamaño para la interfaz
  img = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/tux.png");
  img2 = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/cromatico.jpg");
  img3 = loadImage("/home/asus/ganttproject/interfazProcessingRGBW/imagenes/espectrovisible.png");
  
// Comprueba disponibilidad de puerto serial en la maquina  
  println("Puerto Serial disponible:");
  println(Serial.list()[0]);
  port = new Serial(this, Serial.list()[0], 9600);
  
  // Creamos 4 Sliders
  //sVx = new sliderV(ubicacion x, ubicacion y, ancho, largo);
  sV1 = new sliderV(50, 200, 90, 255, #FF0000); 
  sV2 = new sliderV(150, 100, 90, 255, #03FF00);
  sV3 = new sliderV(250, 100, 90, 255, #009BFF);
  sV4 = new sliderV(350, 200, 90, 255, #FFFFFF);
  
  //Graficamos puntero pantalla azul
  cp5 = new ControlP5(this); 
  s = cp5.addSlider2D("onda")
         .setPosition(600,240)
         .setSize(200,200)
         .setMinMax(0,0,100,100) //Define valores minimos y maximos de amplitud y frecuencia
         .setValue(40,50); // Asigna unos valores iniciales para amplitud y frecuencia
         //.disableCrosshair();
  smooth();
}

/* Funcion para incrustar imagenes, dibujar sliders y visualizador de onda.*/
void draw() {
  background(0); //Color de fondo
  image(img, 1200, 500); // img ,posicion x, posicion y
  image(img2, 100, 400);
  image(img3, 600, 40);

  sV1.render();
  sV2.render();
  sV3.render();
  sV4.render();

  // Escribe por puerto Serial caracteres ascci (0-255)
 port.write('R');
 port.write((sV1.p)*70/100); //Se acondiciona para operacion al 70%
 delay(15);
if(port.available() > 0) // si hay algún dato disponible en el puerto
  {
     R=port.read();//Lee el dato y lo almacena en la variable "R"
  } 
  delay(15);
  
  port.write('G');
  port.write(sV2.p);
  port.write('B');
  port.write(sV3.p);
  port.write('W');
  port.write(sV4.p);
  
  //Grafico visualizador de onda
  pushMatrix();
  translate(820,340); //Define posicion
  noStroke();
  fill(50);
  rect(0, -100, 500,200);
  strokeWeight(1);
  line(0,0,200, 0);
  stroke(225);
  
  for(int i=1;i<500;i++) { //Define tamaño max de la onda comprendida entre -PI,PI
    float y0 = cos(map(i-1,0,s.getArrayValue()[0],-PI,PI)) * s.getArrayValue()[1]; 
    float y1 = cos(map(i,0,s.getArrayValue()[0],-PI,PI)) * s.getArrayValue()[1];
    line((i-1),y0,i,y1);
  }
    popMatrix();
    
  //Recibir datos por puerto serial de una variable  
 // if(port.available() > 0) // si hay algún dato disponible en el puerto
 // {
    // valor=port.read();//Lee el dato y lo almacena en la variable "valor"
  // }
   //Visualizamos datos con un texto
   fill(255);
   text("LECTURA DE DATOS",490,480);
   text("Control rojo   =",490,500);
   text(sV1.p, 620, 500);
   text(" PWM",647,500);
   text("Control verde =",490,520);
   text(sV2.p, 620, 520);
   text(" PWM",647,520);
   text("Control azul   =",490,540);
   text(sV3.p, 620, 540);
   text(" PWM",647,540);
   text("Control blanco =",490,560);
   text(sV4.p, 620, 560);
   text(" PWM",647,560);
   text("SENSADO",490,600);
   text("R =",490,620);
   text(R, 540, 620);
   text("G =",490,640);
   text(R, 540, 640);
   text("B =",490,660);
   text(R, 540, 660);
}


/* Clase Slider */
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
      text(s, 820, 520, 400, 400);
    }
}

void keyPressed() //Cuando se pulse una tecla
{
  
  if(key=='s' || key=='S')
  {
    exit();//Salimos del programa
  }
}