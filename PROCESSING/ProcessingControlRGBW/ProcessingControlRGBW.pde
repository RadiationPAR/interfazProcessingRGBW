/*
 ***********************************************************************
 *              LIBRERIAS y CONSTANTES
 ***********************************************************************
 */
 
import controlP5.*;//Graficos interactivos
import processing.serial.*;//Lectura y escritura serial

/*Variables previstas para graficos interactivos*/
ControlP5 interfaz;
Slider2D sliderOnda;
sliderV sliderV1, sliderV2, sliderV3, sliderV4;

/*Definicion de variables para escribir datos PWM al TIVA*/
Serial puertoSerial;
int R; //Tono rojo
int G; //Tono verde
int B; //Tono azul
int W; //Brillo

/* Tipo de datos para almacenar imágenes .gif, .jpg, .tga, .png */
PImage img, img2, img3;


void setup() {
  size(1350, 800); //Define un tamaño para la interfaz
  img = loadImage("imagenes/tux.png");
  img2 = loadImage("imagenes/cromatico.jpg");
  img3 = loadImage("imagenes/espectrovisible.png");

  // Comprueba disponibilidad de puerto serial en la maquina  
  println("Puerto Serial disponible.");
  println("Dispositivo: "+Serial.list()[0]);
  puertoSerial = new Serial(this, Serial.list()[0], 9600);//9600 es el baudrate o tasa de baudios

  // Creamos 4 Sliders
  // sliderVx = new sliderV(ubicacion x, ubicacion y, ancho, largo, color);
  sliderV1 = new sliderV(50, 200, 90, 255, #FF0000); 
  sliderV2 = new sliderV(150, 100, 90, 255, #03FF00);
  sliderV3 = new sliderV(250, 100, 90, 255, #009BFF);
  sliderV4 = new sliderV(350, 200, 90, 255, #FFFFFF);

  //Graficamos puntero pantalla azul
  interfaz = new ControlP5(this);//this es el contexto actual (programa)
  sliderOnda = interfaz.addSlider2D("onda")
    .setPosition(600, 240)//x,y
    .setSize(200, 200)//ancho,largo
    .setMinMax(0, 0, 100, 100) //Define valores minimos y maximos de amplitud y frecuencia
    .setValue(40, 50); // Asigna unos valores iniciales para amplitud y frecuencia
  //.disableCrosshair();
  smooth();//Dibuja todas las geometrias en el lienzo de la interfaz grafica
}

/* Funcion para incrustar imagenes, dibujar sliders y visualizador de onda.*/
void draw() {
  background(0); //Color de fondo 0=negro
  image(img, 1200, 500);// img ,posicion x, posicion y
  image(img2, 100, 400);
  image(img3, 600, 40);

  sliderV1.render();//Renderiza slider
  sliderV2.render();
  sliderV3.render();
  sliderV4.render();

  // Escribe por puerto Serial caracteres ascci (0-255)
  puertoSerial.write('R');
  puertoSerial.write((sliderV1.p)*70/100); //Se acondiciona para operacion al 70%
  puertoSerial.write('G');
  puertoSerial.write(sliderV2.p);
  puertoSerial.write('B');
  puertoSerial.write(sliderV3.p);
  puertoSerial.write('W');
  puertoSerial.write(sliderV4.p);

  //Grafica visualizador de onda
  pushMatrix();
  translate(820, 340);//Define posicion
  noStroke();
  fill(50);//Color de llenado
  rect(0, -100, 500, 200);
  strokeWeight(1);
  line(0, 0, 200, 0);
  stroke(225);

  for (int i=1; i<500; i++) {//Define tamaño max de la onda comprendida entre -PI,PI
    float y0 = cos(map(i-1, 0, sliderOnda.getArrayValue()[0], -PI, PI)) * sliderOnda.getArrayValue()[1]; 
    float y1 = cos(map(i, 0, sliderOnda.getArrayValue()[0], -PI, PI)) * sliderOnda.getArrayValue()[1];
    line((i-1), y0, i, y1);
  }
  popMatrix();

  //Recibir datos por puerto serial de una variable  
  // if(puertoSerial.available() > 0) // si hay algún dato disponible en el puerto
  // {
  // valor=puertoSerial.read();//Lee el dato y lo almacena en la variable "valor"
  // }
  //Visualizamos datos con un texto
  fill(255);
  text("LECTURA DE DATOS", 490, 480);
  text("Control rojo   =", 490, 500);
  text(sliderV1.texto, 620, 500);
  text("Control verde =", 490, 520);
  text(sliderV2.texto, 620, 520);
  text("Control azul   =", 490, 540);
  text(sliderV3.texto, 620, 540);
  text("Control brillo =", 490, 560);
  text(sliderV4.texto, 620, 560);
  text("SENSADO", 490, 600);
  text("R =", 490, 620);
  text(R, 540, 620);
  text("G =", 490, 640);
  text(R, 540, 640);
  text("B =", 490, 660);
  text(R, 540, 660);
}


/* Clase Slider */
class sliderV {
  int x, y, w, h, p;//h=alto,p=rango,porcentaje
  color col;
  boolean slide;
  String texto;

  sliderV (int _x, int _y, int _w, int _h, color _col) {
    x = _x;//Posicion X
    y = _y;//Posicion y
    w = _w;//Ancho
    h = _h;//Alto
    p = 60;//Valor (0-255) del PWM inicial (porcentaje)
    col = _col;//Color
    slide = true;
    texto = "";
  }

  void render() {
    fill(col);
    rect(x-1, y-4, w, h+10);
    noStroke();
    fill(100,100,100,100);//Rojo,Verde,Azul,Alfa
    rect(x, h-p+y-5, w-2, 13);
    fill(255);
    textSize(11);
    int porcentaje = p * 100 / 255;
    texto = str(porcentaje) + " %";
    text(texto, x+2, h-p+y+6);

    if (slide==true && mousePressed==true && mouseX < x+w && mouseX > x) {
      if ((mouseY<=y+h+150) && (mouseY>=y-150)) {
        p = h-(mouseY-y);
        if (p<0) {
          p=0;
        } else if (p>h) {
          p=h;
        }
      }
    }
    textSize(25);
    fill(255);
    text("COMBINATORIAS RGBW", 100, 70); 
    textSize(16);
    String creditos = "Este obra está bajo una licencia de Creative Commons Reconocimiento-NoComercial 4.0 Internacional";
    fill(255);
    text(creditos, 820, 520, 400, 400);
  }
}

void keyPressed() //Cuando se pulse una tecla
{

  if (key=='s' || key=='S')
  {
    exit();//Salimos del programa
  }
}