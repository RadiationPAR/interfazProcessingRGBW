# SISTEMA DE MEDICIÓN Y MONITOREO PARA EL ESTUDIO DEL EFECTO DE LA RADIACIÓN PAR EN LAS PLANTAS

Esta investigación plantea el desarrollo de un mecanismo de observación de la respuesta  fisiológica  de las plantas presentes en la industria hortícola regional, en especial de la fotosíntesis, a partir del diseño de un sistema de iluminación basado en un estudio previo de sistemas de iluminación artificial y la actual migración a sistemas de iluminación con tecnología LED y OLED cuyo espectro de radiación esta dado en una banda especifica lo que proporciona un menor gasto de potencia, y facilita irradiar la planta con la parte del espectro especifico que ella necesita. Habitualmente  los vegetales utilizan la luz desde los 400nm hasta los 700 nm para la fotosíntesis (conocida como radiación PAR, radiación fotosintéticamente activa -Photosynthetic Active Radiation- o luz de crecimiento), variando el efecto de la longitud de onda según las horas del día y los estadios de crecimiento de la planta. (Grupo de investigación GIR-TADRUS. ETSI agrarias, 2010)

# Materiales
### Microcontrolador Tiva C Series 
![Energia LaunchPad](http://energia.nu/img/StellarPadLM4F120H5QR-V1.0.jpg "MSP-EXP430G2 LaunchPad") 
### Sensor TCS3220 y Led RGB 100W
![Sensor TCS3220](http://i68.tinypic.com/352npd3.png "Sensor TCS3220")
![Caracteristicas TCS3220](http://i63.tinypic.com/11c4m04.png "Caracteristicas TCS3220")

# Diseño esquematico y PCB
### Circuito de Potencia
![PCB](https://lh3.googleusercontent.com/-dSbxB3geZaU/V4xXMiXsHOI/AAAAAAAABeY/f4gfbdVW0fwslsUZJuilaUOww0KNgf91QCL0B/w996-h560-no/tesis.png "PCB")
### Circuito de Control
![PCB2](http://i65.tinypic.com/b5ln5f.jpg "PCB2")

# Interfaz con Processing desde una Raspberry
![Processing](http://i65.tinypic.com/14d3hh1.png "Interfaz")
![Processing](http://i66.tinypic.com/2dmf3hc.png "Interfaz")

Para el desarrollo de la interfaz se implemento la libreria "ControlP5"  
Para configurarle en una **raspberry** debe ejecutar los siguientes comandos:  
1. cd interfazProcessingRGBW/PROCESSING/controlP5-2.2.5/controlP5/library  
2. cp controlP5.jar /usr/local/lib/processing-3.2.3/core/library  

### Desarrolladores ###
* Diego Javier Mena @ingelectronicadj 
* Jeisson Eduardo Forero

### Grupo de investigación LASER ###
