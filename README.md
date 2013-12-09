-------------------------------------
DISEÑO DE CIRCUITOS INTEGRADOS
-------------------------------------

	Implementación del videojuego Space Invaders en Spartan 3E Starter Board
	Otoño 2013

-------------------------------------
AUTORES
-------------------------------------

	David Estévez Fernández
	Sergio Vilches Expósito

-------------------------------------
RESUMEN DE FUNCIONALIDAD EXTRA
-------------------------------------
	Multijugador 
	Mandos independientes
	Indicadores gráficos de puntuación de cada jugador en pantalla	
	Sintetizador de sonido digital
	8 niveles de juego
	Velocidad variable de invasores
	3 tipos de invasores
	Indicador de nivel por medio de LEDs de la placa

-------------------------------------
CONTROL DE VERSIONES
-------------------------------------

	El código de esta práctica está publicado en github. Desde esta web puede accederse a un historial completo de la escritura del código.

	https://github.com/David-Estevez/spaceinvaders

-------------------------------------
ACERCA DEL IDIOMA USADO EN EL CÓDIGO
-------------------------------------

	Ya que los lenguajes de programación están diseñados en inglés y al haber estudiado el resto del grado en bilingüe, nos parece más coherente escribir en este idioma (además de evitar problemas de compatibilidad de caracteres). Por ello, tanto el código como los comentarios están escritos en inglés.

-------------------------------------
TIMING REPORT
-------------------------------------

	Minimum period:  18.284ns{1}   (Maximum frequency:  54.693MHz) 

	Maximum Data Path: soundCard/step_3 to soundCard/Mmult_clkCycles_mult00002_0 

	Nota: La frecuencia máxima viene limitada por la siguiente línea de código, perteneciente a toneGenerator.vhd
		
		clkCycles <= 50 * (startPeriod + deltaPeriod * step);

	Como puede verse, estas dos multiplicaciones se ejecutan en un sólo ciclo, limitando la velocidad del sistema. En el caso de que fuese necesario, se podría dividir esta operación en dos (o más) ciclos, ya que sólo necesita refrescarse cada milisegundo, aproximadamente.


-------------------------------------
AREA REPORT
-------------------------------------

	Logic Utilization:
	  Number of Slice Flip Flops:           504 out of   9,312    5%
	  Number of 4 input LUTs:             1,317 out of   9,312   14%
	Logic Distribution:
	  Number of occupied Slices:            844 out of   4,656   18%
	    Number of Slices containing only related logic:     844 out of     844 100%
	    Number of Slices containing unrelated logic:          0 out of     844   0%
	      *See NOTES below for an explanation of the effects of unrelated logic.
	  Total Number of 4 input LUTs:       1,588 out of   9,312   17%
	    Number used as logic:             1,317
	    Number used as a route-thru:        271

	  The Slice Logic Distribution report is not meaningful if the design is
	  over-mapped for a non-slice resource or if Placement fails.

	  Number of bonded IOBs:                 25 out of     232   10%
	  Number of BUFGMUXs:                     1 out of      24    4%
	  Number of MULT18X18SIOs:                3 out of      20   15%

	Average Fanout of Non-Clock Nets:                3.30


-------------------------------------
EXPLICACIÓN DE LOS WARNINGS
-------------------------------------

	Al sintetizar, ISE muestra varios warnings, que en este caso informan de optimizaciones que se van a llevar a cabo en la implementación. 

	A continuación se muestran los tipos de warnings que aparecen junto con una corta explicación:

	WARNING:Xst:643 - The result of a 22x7-bit multiplication is partially used. Only the 20 least significant bits are used. If you are doing this on purpose, you may safely ignore this warning. Otherwise, make sure you are not losing information, leading to unexpected circuit behavior.

		Como indica el mensaje, sólo una parte del resultado de la multiplicación se está usando. Es un warning de optimización.

	WARNING:Xst:646 - Signal <xxx> is assigned but never used. This unconnected signal will be trimmed during the optimization process.
		
		Un bit de un bus nunca cambia y va a ser reemplazada por una constante en la implementación final. Es un warning de optimización.

	WARNING:Xst:647 - Input <xxx<n>> is never used. This port will be preserved and left unconnected if it belongs to a top-level block or it belongs to a sub-block and the hierarchy of this sub-block is preserved.

		Un bit de un bus no provoca ningún cambio en la entidad. Es un warning de optimización.

	WARNING:Xst:1293 - FF/Latch <0> has a constant value of 0 in block <endPeriod>. This FF/Latch will be trimmed during the optimization process.
		
		Un biestable (señal asignada dentro de un proceso síncrono) nunca cambia de valor, por lo que el sintetizador lo substituye por una señal constante. Es  un warning de optimización.

	WARNING:Xst:2677 - Node <X_n> of sequential type is unconnected in block <vgaController>.
		
		Similar a WARNING:Xst:646: Un bit de un bus no se usa en un proceso.

