# Funcionamiento de la Práctica 

Se implementó un contador de 10 bits, como salida muestra la cuenta en 10 leds. De manera predeterminada, el contador aumentará su cuenta cada segundo. Al oprimir un botón, el contador cambiará su modo y trabajará en modo descendente. Si el botón vuelve a presionar, entonces el contador regresará al modo ascendente. A su vez, el contador podrá aumentar su velocidad x2, x4 y x8 al oprimir un segundo botón. La velocidad regresará a x1 cuando ésta esté establecida en x8 y el usuario oprima nuevamente el segundo botón.  

   

 
 

# Instalación de software  

- El compilador cruzado gcc-arm-none-eabi. 

- stlink- tools paquete contiene las utilizadas que permiten grabar un microcontrolador de  STM32 libusb-1.0-0-dev. Este paquete contiene los controladores que permiten detectar la conexión con el ST-Link  V2. 

- Instalación del software STM32CubeProg 

 
 

# Alias: 

- alias arm-gcc=arm-none-eabi-gcc 

- alias arm-as=arm-none-eabi-as 

- alias arm-objdump=arm-none-eabi-objdump 

- alias arm-objcopy=arm-none-eabi-objcopy 

 
 

# main.s 

 ## Setup: La configuración de los pines: 

Se configuran los pines de GPIOA: Los pines del 0 al 7 se mueve la dirección base 	registros GPIOA, que funcionaran como 8 salidas, para a completar las 10 salidas de los pines 8 al 15 que se llaman registros altos, en nuestro caso usaremos dos pines más de salida y dos de entrada para los Puhs botton.  

 

- Configuracion de EXTI10_11: 
Carga la base AFIO se selecciona PA 11 y 10 como entradas al igual se carga la base de salida de cargas, se pasan las líneas de evento Rising Trigger PA 11 y 10. Se desenmascarar la solicitud de interrupción de 11 y 10 eor r1, r1. 

 

- Configurar  NVIC para atender EXIT Request: Habilitando las salidas. 

 

- Llamamos a la funcion SysTick_Initialize 

 

- Inicialización de variables: 
Usamos counter que será la única que se almacene en la pila, speed que tendrá a r8 y por último r9 siendo mode.  

 

 

## Loop: Logica del programa  

## Marco de main.s

![image](https://github.com/JessicaLaraC/Laboratorio6/assets/110583656/92c966a5-1ecc-4487-bad9-b6715a270074)

 

# Funciones  

# check_seep.s  
```
   if (speed == 1){
         return 1000
   }else if (speed == 2){
         return 500
   }else if (speed == 3){
         return 250
   }else if (speed == 4 ){
         return125
   }else
      speed = 1;
      return 1000

```
 

# Default_Handler.s  

 

Se implementa un bucle muerto, como contador de interrupciones para el temporizador desde el sistema  
 

# delay.s 

Se implementa con un registro r0 que es el argumento de entrada, que representa la cantidad de retraso en unidades de tiempo establecidas por SysTick_ Handler. La función despliega un ciclo de espera ocupado, que sale cuando la variable TimeDelay ha sido reducida a cero por el controlador de interrupciones SysTick SysTick _ Handler() 

# EXTI15_10_Handler.s 

Indica los vectores que se usaran para la interrupcion de la rutina de servicio de interrupciones correspondientes, almacena la direccion de memoria inial de cada ISR, cada entrada representa una entrada de direccion de memoria cada una ocupa.
1 Activar una interrupción relacionada y el microcontrolador inicia en controlador de interrupcion correspondiente
Habilitación de conjunto de interrupciones 1 ISER 

# output.s

Para emitir el valor del contador como salidas, se modificó poniendo una máscara para nuestro puerto digital de los 10 led, agregamos un registro con la máscara 0x3FF para poder prender los 9 leds. 

# reset_handler.s

Se ejecuta cuando el procesador se reinicia o enciende, llamando a la función principal, llama a la main que copia segmentos de memoria de datos y luego llama a la función de usuario main  

# SysTick_Handler.s 

Controla las interrupciones para el temporizador del sistema, no devuelve ningún valor porque son llamados del hardware además los ISR no tomaran ningún argumento de entrada 

# SysTick_Initialize.s

Configura SysTick para generar interrupciones en un intervalo de tiempo fijo. El parámetro de entrada marca es igual al intervalo de tiempo dividido por el período del reloj. 
# compilacion de sofware
Lectura de la tarjeta de desarrollo blue pill 
Conectar al progrma STM32CubeProg ejecutar los comando de make, make clean para quitar los archivos .o, despues make para crear los archivos. o, en progrma STM32CubeProg cargamos el archivo en binario.
# Circuito

![Untitled Sketch_bb](https://github.com/JessicaLaraC/Laboratorio6/assets/110583656/110a2242-5c9d-4b69-9167-7fe3a4bd9724)

Para la odificacion de del Schmitt Tiger se se utilizo el siguiente esquema:
Se utiliza para eliminar el rebote de los botones.
![descarga (1)](https://github.com/JessicaLaraC/Laboratorio6/assets/110583656/a3a96aab-a04e-4d6d-a9c4-75ec7c06a7f0)

 
