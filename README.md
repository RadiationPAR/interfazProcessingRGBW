# PowerPAR-Led DELMA
---
La formulación de un problema es a menudo más esencial que su solución, que puede ser meramente una materia de destreza experimental o matemática. "La especificación del problema a investigar implica que se ha comprendido plenamente el
tema de la investigación, hasta el punto de poder determinar exactamente los interrogantes principales que plantea y a cuya resolución se debe orientar la investigación." Einstein

## SISTEMA DE MEDICIÓN Y MONITOREO PARA EL ESTUDIO DEL EFECTO DE LA RADIACIÓN PAR EN LAS PLANTAS

Esta investigación discrimina la información científica y tecnológica experimental a la fecha sobre la Radiación Fotosintéticamente Activa (radiación integrada del rango de longitudes de onda que son capaces de producir actividad fotosintética en las plantas y otros organismos fotosintéticos como microalgas y bacterias).

Investigadores de todo el planeta exponen en sus artículos que los vegetales necesitan porciones de luz desde los 400nm hasta los 700 nm; conocer sus umbrales luminicos permitirá conseguir cosechas de gran producción y alta calidad; llevar un historial de datos sobre el efecto de la longitud de onda según las horas del día y los estadios de crecimiento de la planta permitirá a futuro disponer de hojas de datos para realizar agricultura de precisión en su parametro luminico. 

A continuación se plantea el desarrollo de un mecanismo de observación para la respuesta fisiológica del dosel vegetal (en especial de la fotosíntesis), a partir del diseño de un sistema de iluminación artificial basado en un estudio previo de sistemas de iluminación y la actual migración a sistemas de iluminación con tecnología LED y OLED cuyo espectro de radiación esta dado en una banda especifica lo que proporciona un menor gasto de potencia, y facilita irradiar la planta con la parte del espectro especifico que ella necesita según su estadio: germinación, vegetación y floración. 

![RadiacionPAR](https://github.com/RadiationPAR/interfazProcessingRGBW/blob/master/Diagramas/parDELMA.png?raw=true "RadiacionPAR") 

Fabricantes de todo el mundo, ofrecen al mercado diversas lamparas de iluminación y en algunos casos se diseñan enormes arreglos de leds con iluminación fija o invariable garantizando solo su uso para determinado tipo de plantas (C3, C4, CAM) - plantas presentes en la industria hortícola de mayor producción. Los investigadores de diversas tesis de Maestría y Doctorado no realizan un proceso fiable para llevar la trazabilidad de sus datos pero nos ilustran sobre el metodo científico iterado para obtener mejoras en el proceso de crecimiento y floración de diversas genéticas de plantas.  

Esta investigación contempla el desarrollo de un prototipo que permite al usuario manejar: la composición de color (longitud de onda) a irradiar y su potencia a traves de una interfaz de fácil manejo que almacena datos de manera centralizada como lo son: composición RGB (0-255), composición CMY (0 - 255), Matiz (0 - 360), saturación (0.0 - 1.0), luminancia (0.0 - 1.0), posición XYZ del color, longitud de onda y frecuencia.   


# Materiales
---  
## Microcontrolador Tiva C Series  
Se decide implementar este microcontrolador por su fama en internet acerca de la adquisición, procesamiento y almacenamiento de datos; ademas se sirve de una librería para la compresión de algoritmos matemáticos, lo cual resulta bastante interesante y acorde para las conversiones de los diferentes modelos matemáticos de los espacios del color.
![Energia LaunchPad](http://energia.nu/img/StellarPadLM4F120H5QR-V1.0.jpg "MSP-EXP430G2 LaunchPad") 

## Sensor TCS3220 y Led RGB 100W
Se opta por implementar el sensor TCS3220 por su resolución y economía; basicamente entrega una señal cuadrada con ancho de pulso variable de acuerdo a la presencia de una fuente de luz. Se caracteriza el comportamiento del sensor con la hoja de datos del fabricante y datos de pruebas en el laboratorio de ensayos eléctricos de la Universidad Nacional - LABE.  

![Sensor TCS3220](http://i68.tinypic.com/352npd3.png "Sensor TCS3220")
![Caracteristicas TCS3220](http://i63.tinypic.com/11c4m04.png "Caracteristicas TCS3220")  

El led de 100W permite dimensionar espacios de manera modular y cumple con los requisitos mínimos de lumenes para estimular la fotosíntesis en plantas C3, C4 y CAM.


# Diseño esquematico y PCB 
---  
## Circuito de Potencia
![PCB](https://lh3.googleusercontent.com/-dSbxB3geZaU/V4xXMiXsHOI/AAAAAAAABeY/f4gfbdVW0fwslsUZJuilaUOww0KNgf91QCL0B/w996-h560-no/tesis.png "PCB")

## Circuito de Control
![PCB2](http://i65.tinypic.com/b5ln5f.jpg "PCB2")  

---  

# Interfaz de Control con Processing desde una Raspberry
![Processing](http://i65.tinypic.com/14d3hh1.png "Interfaz")
![Processing](http://i66.tinypic.com/2dmf3hc.png "Interfaz")

Para el desarrollo de la interfaz se usa el software libre Processing - ampliamente usado para comunicación entre el usuario y la maquina por el protocolo RS-232 haciendo el llamado de la libreria "ControlP5".  
Para configurarle en una **raspberry** deben ejecutarse los siguientes comandos: 
<pre><code>cd interfazProcessingRGBW/PROCESSING/controlP5-2.2.5/controlP5/library</code></pre>
<pre><code>cp controlP5.jar /usr/local/lib/processing-3.2.3/core/library</code></pre>  
---

## Investigador principal
* Diego Javier Mena - Email: ingelectronicadj@gmail.com

## Apoyo a la investigación
![ApoyoInvest](http://delma.com.co/apoyoInvest.png "apoyo")
