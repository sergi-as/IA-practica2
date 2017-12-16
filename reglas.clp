;;; Modulos
(defmodule MAIN (export ?ALL))

;;; Modulos de recopilacion de los datos del usuario
(defmodule recopilacion-usuario
	(import MAIN ?ALL)
	(export ?ALL)
)
(defmodule recopilacion-preferencias
	(import MAIN ?ALL)
	(import recopilacion-usuario deftemplate ?ALL)
	(export ?ALL)
)
;;;modulo para procesar los datos  y elegir las viviendas
(defmodule procesado
	(import MAIN ?ALL)
	(import recopilacion-usuario deftemplate ?ALL)
	(import recopilacion-preferencias deftemplate ?ALL)
	(export ?ALL)
)
;;modulo para hacer operaciones extra a las viviendas que han sobrevivido a la criba
(defmodule generacion_sol
	(import MAIN ?ALL)
	(export ?ALL)
)
(defmodule mostrar_resultados
	(import MAIN ?ALL)
	(export ?ALL)
)

;;; Se crea una clase para las recomendaciones para poder hacer listas de recomendaciones y tratarlas mejor
;peta si lo defino en este arcvhio,esta en el .pont
;(defclass Recomendacion
;	(is-a USER)
;	(role concrete)
;	(slot contenido
;		(type INSTANCE)
;		(create-accessor read-write))
;	(slot puntuacion
;		(type INTEGER)
;		(create-accessor read-write))
;	(multislot justificaciones
;		(type STRING)
;		(create-accessor read-write))
;)
;;; Declaracion de messages ---------------------------

;; Imprime los datos de un contenido
(defmessage-handler MAIN::Vivienda imprimir ()
(printout t "-----------------------------------" crlf)
(format t "Vivienda con ID: %s %n" ?self:Id)
(printout t crlf)
(format t "Precio mensual: %g %n" ?self:Precio_mensual)
(printout t crlf)
(format t "Tipo de piso: %s %n" ?self:Tipo)
(printout t crlf)
(format t "Altura del piso: %s %n" ?self:Altura_piso)
(printout t crlf)
(format t "Dormitorios simples: %g %n" ?self:Dormi_simple)
(printout t crlf)
(format t "Dormitorios dobles: %g %n" ?self:Dormi_doble)
(printout t crlf)
(format t "Superficie: %g %n" ?self:Superficie)
(printout t crlf)
(if (eq ?self:vistas TRUE)then (format t "Con vistas %n")
else (format t "Sin vistas %n"))
(printout t crlf)
(if (eq ?self:Piscina TRUE)then (format t "Con piscina %n")
else (format t "Sin piscina %n"))
(printout t crlf)
(if (eq ?self:Terraza TRUE)then (format t "Con terraza %n")
else (format t "Sin terraza %n"))
(printout t crlf)
(if (eq ?self:Amueblada TRUE)then (format t "Amueblada %n")
else (format t "Sin muebles %n"))
(printout t crlf)
(if (eq ?self:Garaje TRUE)then (format t "Con garaje %n")
else (format t "Sin garaje %n"))
(printout t crlf)
(if (eq ?self:Balcon TRUE)then (format t "Con balcon %n")
else (format t "Sin balcon %n"))
(printout t crlf)
(if (eq ?self:Calefaccion TRUE)then (format t "Con calefaccion %n")
else (format t "Sin calefaccion %n"))
(printout t crlf)
(if (eq ?self:Aire TRUE)then (format t "Con aire acondicionado %n")
else (format t "Sin aire acondicionado %n"))
(printout t crlf)
(if (eq ?self:Electrodomesticos TRUE)then (format t "Con electrodomesticos %n")
else (format t "Sin electrodomesticos %n"))
(printout t crlf)
(if (eq ?self:Mascotas TRUE)then (format t "Apto para mascotas %n")
else (format t "No apto para mascotas %n"))
(printout t crlf)
(printout t "Servicios cerca:" crlf)
(progn$ (?serv_cerca ?self:servicio_cerca)
		(printout t (send ?serv_cerca get-Nombre_ser) crlf)
)
(printout t "Servicios a media distancia:" crlf)
(progn$ (?serv_media ?self:servicio_media)
		(printout t (send ?serv_media get-Nombre_ser) crlf)
)
(if (eq ?self:Sol_man TRUE)then (format t "Con sol por la manana %n")
else (format t "Sin sol por la manana %n"))
(printout t crlf)
(if (eq ?self:Sol_tarde TRUE)then (format t "Con sol por la tarde %n")
else (format t "Sin sol por la tarde %n"))
(printout t crlf)
;;regla de coordenadas falta
(printout t "-----------------------------------" crlf)
)

(defmessage-handler MAIN::Recomendacion imprimir ()
 (printout t (send ?self:contenido imprimir))
 (printout t "-----------------------------------" crlf)
 (format t "Nivel de recomendacion: %d %n" ?self:puntuacion)
 (printout t "Justificacion de la eleccion: " crlf)
	 (progn$ (?curr-just ?self:justificaciones)
	 (printout t ?curr-just crlf)
 )
 (printout t crlf)
 (printout t "-----------------------------------" crlf)
)

;;;NOSE QUE TIPO METERLE
;(defmessage-handler MAIN::TIPO imprimir ()
;	(printout t "============================================" crlf)
;	(progn$ (?rec ?self:recomendaciones)
;		(printout t (send ?rec imprimir))
;	)
;	(printout t "============================================" crlf)
;)

;;; Declaracion de clases propias



;;; Funciones para preguntar
;;; Pregunta general
(deffunction MAIN::pregunta-general (?pregunta)
	(format t "%s" ?pregunta)
	(bind ?respuesta (read))
	?respuesta
)

;;; Obtiene una respuesta de entre un conjunto de respuestas posibles
(deffunction MAIN::pregunta-opciones (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
   )
   ?answer)

	 ;;; Funcion para hacer una pregunta no-numerica-univalor
	 (deffunction pregunta-datos (?pregunta)
	     (format t "%s " ?pregunta)
	 	(bind ?respuesta (read))
	 	(while (not (lexemep ?respuesta)) do
	 		(format t "%s " ?pregunta)
	 		(bind ?respuesta (read))
	     )
	 	?respuesta
	 )

	 ;;; Funcion para hacer una pregunta numerica-univalor
	 (deffunction MAIN::pregunta-numerica (?pregunta ?rangini ?rangfi)
	 	(format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi)
	 	(bind ?respuesta (read))
	 	(while (not(and(>= ?respuesta ?rangini)(<= ?respuesta ?rangfi))) do
	 		(format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi)
	 		(bind ?respuesta (read))
	 	)
	 	?respuesta
	 )

	 ;;; Funcion para hacer una pregunta multi-respuesta con indices
	 (deffunction MAIN::pregunta-multirespuesta (?pregunta $?valores-posibles)
	     (bind ?linea (format nil "%s" ?pregunta))
	     (printout t ?linea crlf)
	     (progn$ (?var ?valores-posibles)
	             (bind ?linea (format nil "  %d. %s" ?var-index ?var))
	             (printout t ?linea crlf)
	     )
	     (format t "%s" "Indica los numeros referentes a las preferencias separados por un espacio: ")
	     (bind ?resp (readline))
	     (bind ?numeros (str-explode ?resp))
	     (bind $?lista (create$))
	     (progn$ (?var ?numeros)
	         (if (and (integerp ?var) (and (>= ?var 0) (<= ?var (length$ ?valores-posibles))))
	             then
	                 (if (not (member$ ?var ?lista))
	                     then (bind ?lista (insert$ ?lista (+ (length$ ?lista) 1) ?var))
	                 )
	         )
	     )
	     (if (or(member$ 0 ?lista)(= (length$ ?lista) 0)) then (bind ?lista (create$ )))
	     ;(if (member$ 0 ?lista) then (bind ?lista (create$ 0)))
	     ?lista
	 )

	 ;;; Funcion para hacer pregunta con indice de respuestas posibles
	 (deffunction MAIN::pregunta-indice (?pregunta $?valores-posibles)
	     (bind ?linea (format nil "%s" ?pregunta))
	     (printout t ?linea crlf)
	     (progn$ (?var ?valores-posibles)
	             (bind ?linea (format nil "  %d. %s" ?var-index ?var))
	             (printout t ?linea crlf)
	     )
	     (bind ?respuesta (pregunta-numerica "Escoge una opcion:" 1 (length$ ?valores-posibles)))
	 	?respuesta
	 )



;;; Funcion para hacer una pregunta de tipo si/no
(deffunction MAIN::pregunta-si-no (?question)
   (bind ?response (pregunta-opciones ?question si no))
   (if (or (eq ?response si) (eq ?response s))
       then TRUE
       else FALSE)
)

(deffunction MAIN::euclidean (?x ?y ?m ?n)
	(bind ?res (sqrt (+ (**(- ?x ?m) 2) (**(- ?y ?n) 2) )))
	?res
)
;;; Templates
(deftemplate MAIN::Usuario
	(slot nombre (type STRING))
	(slot sexo (type SYMBOL)(default desconocido))
	(slot edad (type INTEGER)(default -1))
	;tipologia del solicitante: familia,pareja o gruppo
	(slot tipo (type SYMBOL)(default desconocido))
  (slot tam_familia_grupo (type INTEGER)(default -1))
	(slot posee_vehiculo (type SYMBOL)(default desconocido))
	;;coordenadas
	(slot coorX (type INTEGER) (default -1))
	(slot coorY (type INTEGER) (default -1))
)
(deftemplate MAIN::preferencias_usuario
	(slot precio_maximo (type INTEGER)(default -1))
	(slot precio_estricto (type SYMBOL)(default desconocido))
	(slot num_dormitorios_dobles (type INTEGER)(default -1))
	(slot precio_minimo (type INTEGER)(default -1))
	(multislot distancia_servicio (type SYMBOL))
	(multislot preferencias_vivienda (type SYMBOL))
	(slot tipo_vivienda (type SYMBOL))
	(slot altura_vivienda (type SYMBOL))
)

;;; Template para una lista de recomendaciones sin orden
(deftemplate MAIN::lista-rec-desordenada
	(multislot recomendaciones (type INSTANCE))
)

;;; Template para una lista de recomendaciones con orden
(deftemplate MAIN::lista-rec-ordenada
	(multislot recomendaciones (type INSTANCE))
)

(deftemplate MAIN::Poco_Recomendables
	(multislot recomendaciones (type INSTANCE))
)

(deftemplate MAIN::Recomendables
	(multislot recomendaciones (type INSTANCE))
)

(deftemplate MAIN::Altamente_Recomendables
	(multislot recomendaciones (type INSTANCE))
)

;;; Reglas
(defrule MAIN::initialRule "Regla inicial"
   	(declare (salience 10))
   	=>
   	(printout t"----------------------------------------------------------" crlf)
     	(printout t"          Busqueda de piso                              " crlf)
   	(printout t"----------------------------------------------------------" crlf)
     	(printout t crlf)
   	(printout t"¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle un piso adecuada a sus preferencias." crlf)
   	(printout t crlf)
    (focus recopilacion-usuario)

		;; para debugar la parte de proceso

		;(assert (Usuario (nombre "hola") (tipo pareja) (tam_familia_grupo 2) (coorX 1200) (coorY 400)))
		;(assert (Usuario (nombre "hola") (tipo pareja) (tam_familia_grupo 2) (posee_vehiculo FALSE) ))
		;;(focus recopilacion-preferencias)
		;(assert (preferencias_usuario (precio_maximo 10000) (num_dormitorios_dobles 1) (precio_estricto TRUE) (distancia_servicio Bus colegio) ) )
		;(focus procesado)
)
;; Reglas set distancia, necesito una por cada tipo de servicio
(defrule MAIN::setDistance "Primera regla que se ejecuta"
	(declare (salience 20))
	?viv <- (object (is-a Vivienda) (Id ?i) (Coord_viv ?c1))
	?ser <- (object (is-a Servicio) (Nombre_ser ?nser)(Coord_serv ?c2))
	=>
	(bind ?x (send ?c1 get-X))
	(bind ?y (send ?c1 get-Y))
	(bind ?m (send ?c2 get-X))
	(bind ?n (send ?c2 get-Y))
	(bind ?euc (euclidean ?x ?y ?m ?n))
	(bind $?scer (send ?viv get-servicio_cerca))
	(bind $?smed (send ?viv get-servicio_media))
	;;(printout t "encontrada pareja vivienda " ?i " servicio " ?nser " distancia : " ?euc crlf )
	(if (<= ?euc 500) then
		(send ?viv put-servicio_cerca $?scer ?ser)

		else (if (<= ?euc 1000) then
			(send ?viv put-servicio_media $?smed ?ser)
		)
	)
	;para mostrar los servicios cerca ;;;;;; p 27 como iterar multislot
	(bind $?servicios2 (send ?viv get-servicio_cerca))
	;(printout t "servicios actuales " (length$ $?servicios2) crlf)
	;(if (>=(length$ $?servicios2) 1) then
	;	(printout t "por ejemplo,el servicio en la posicion 1 " (send (nth$ 1  $?servicios2)  get-Nombre_ser)  crlf)
	;)
)

(defrule recopilacion-usuario::preguntaNombre "Establece el nombre del usuario"
  (not (Usuario))
  =>
  (bind ?name (pregunta-general "Cual es su nombre? "))
	(assert (Usuario (nombre ?name)))
  )

(defrule recopilacion-usuario::establecer-edad "Establece la edad del usuario"
	?g <- (Usuario (edad ?edad))
	(test (< ?edad 0))
	=>
	(bind ?edad (pregunta-numerica "¿Cual es su edad? " 1 110))
	(modify ?g (edad ?edad))
)

;Nose como hacerlo con lo de los symbols
(defrule recopilacion-usuario::establecer-sexo "Establece el sexo del usuario"
	?g <- (Usuario (sexo ?sexo))
	(test (eq ?sexo desconocido))
	=>
	(bind ?sexo (pregunta-opciones "Cual es tu sexo? (hombre o mujer) "  hombre mujer ))
	(modify ?g (sexo ?sexo))
)
;;;;;;;;;;;;;;;;;;;;;;
;TODO preguntar si la familia espera hijos
;;;;;;;;;;;;;;;;;;;;;;
(defrule recopilacion-usuario::establecer-tipo "establece la tipologia de la familia"
	?g <-(Usuario (tipo ?tipo))
	(test (eq ?tipo desconocido))
	=>
	(bind ?i (pregunta-indice "De que tipo es el grupo para el que busca piso " (create$ "Pareja" "Familia" "Grupo" "Individuo")))
	;;(printout t "valor elegido " ?i crlf)
	(if (eq ?i 1)then
		(modify ?g (tipo pareja) (tam_familia_grupo 2))
	)
	else (if (eq ?i 2)then
		(modify ?g (tipo familia))
	)
	else (if (eq ?i 3)then
		(modify ?g (tipo grupo))
	)
	else (if (eq ?i 4)then
		(modify ?g (tipo individuo) (tam_familia_grupo 1))
	)
)

(defrule recopilacion-usuario::establecer-tam_familia_grupo "Establece el tamanyo de la familia del usuario"
	?g <- (Usuario (tam_familia_grupo ?tam_familia_grupo))
	(test (< ?tam_familia_grupo 0))
	=>
	(bind ?tam_familia_grupo (pregunta-numerica "¿Cual es el tamanyo de su familia o grupo ? (incluyendose a usted) " 1 50))
	(modify ?g (tam_familia_grupo ?tam_familia_grupo))
)

(defrule recopilacion-usuario::establecer-ocupacion "Establece si el usuario estudia o trabaja"
	?g <- (Usuario (coorX ?t))
	(not (preguntacoord done))
	(test (eq ?t -1))
	=>
	(bind ?e (pregunta-si-no "Estudia y/o trabaja en esta ciudad? " ))
	(if (eq ?e TRUE) then
	(assert (preguntacoord ask))
	)
	else (assert (preguntacoord done))
)

(defrule recopilacion-usuario::pregunta-coord "si trabaja o estudia en la ciudad se pregunta donde"
	?g <- (Usuario (coorX ?x)(coorY ?y))
	?t <- (preguntacoord ask)
	=>
	(bind ?x (pregunta-numerica "Escriba la coordenada x " 0 10000))
	(bind ?y (pregunta-numerica "Escriba la coordenada y " 0 10000))
	(modify ?g (coorX ?x)(coorY ?y) )
	(retract ?t)
	(assert (preguntacoord done))
)

(defrule recopilacion-usuario::establecer-vehiculo "Establece si el usuario dispone de vehiculo"
	?g <- (Usuario (posee_vehiculo ?v))
	(test (eq ?v desconocido))
	=>
	(bind ?v (pregunta-si-no "Dispone de vehiculo propio? " ))
	(modify ?g (posee_vehiculo ?v))
)
(defrule recopilacion-usuario::inicia-prefernecias "Cambia de modulo para preguntar por preferencias"
	(declare (salience -10))
	=>
	(focus recopilacion-preferencias)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; reglas preferencias
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule recopilacion-preferencias::establecer-preciomaximo "Establece el precio maximo a gastar del usuario"
	(not (preferencias_usuario))
	=>
	(bind ?precio_maximo (pregunta-numerica "¿Cual es el precio maximo que quiere gastar? " 1 999999999))
	(assert (preferencias_usuario (precio_maximo ?precio_maximo)))
	(assert (servicios_pref ask))
	(assert (preferencias_viv ask))
	(assert (tipo_viv ask))
)

(defrule recopilacion-preferencias::establecer-precio_estricto "Establece si el precio maximo a gastar del usuario es estricto o no"
	?g <- (preferencias_usuario (precio_estricto ?precio_estricto))
	(test (eq ?precio_estricto desconocido))
	=>
	(bind ?precio_estricto (pregunta-si-no "¿El precio es estricto? "))
	(modify ?g (precio_estricto ?precio_estricto))
)

(defrule recopilacion-preferencias::establecer-num_dormitorios_dobles "Establece el numero de dormitorios dobles deseado por el usuario"
	?g <- (preferencias_usuario (num_dormitorios_dobles ?num_dormitorios_dobles))
	(test (< ?num_dormitorios_dobles 0))
	=>
	(bind ?num_dormitorios_dobles (pregunta-numerica "¿Cual es el numero de dormitorios dobles deseado? " 0 20))
	(modify ?g (num_dormitorios_dobles ?num_dormitorios_dobles))
)

;(defrule recopilacion-preferencias::establecer-tam_dormitorios "Establece el tamanyo de los dormitorios deseado por el usuario"
;	?g <- (preferencias_usuario (tam_dormitorios ?tam_dormitorios))
;	(test (< ?tam_dormitorios 0))
;	=>
;	(bind ?tam_dormitorios (pregunta-numerica "¿Cual es el tamanyo de los dormitorios deseado? " 1 20))
;	(modify ?g (tam_dormitorios ?tam_dormitorios))
;)

(defrule recopilacion-preferencias::establecer-precio_minimo "Establece el precio minimo a partir del cual el usuario piensa que la vivienda es adecuada"
	?g <- (preferencias_usuario (precio_minimo ?precio_minimo))
	(test (< ?precio_minimo 0))
	=>
	(bind ?precio_minimo (pregunta-numerica "¿Cual es el precio minimo a gastar? " 1 999999999))
	(modify ?g (precio_minimo ?precio_minimo))
)

(defrule recopilacion-preferencias::establecer-distancia_servicio "Establece los servicios que el usuario quiere que esten cerca"
    ?hecho <- (servicios_pref ask)
	?pref <- (preferencias_usuario)
	=>
	(bind $?nom-servicios (create$ Bus Metro colegio Centro_de_salud Estadio_de_deportes Ocio_nocturno Supermercado Zona_comercial Zona_verde))
	(bind $?escogido (pregunta-multirespuesta "Escoja los servicios que tienen que estar cerca (o 0 en el caso que no haya ninguno): " $?nom-servicios))
	(assert (servicios_pref TRUE))
    (bind $?respuesta (create$ ))
	(loop-for-count (?i 1 (length$ $?escogido)) do
		(bind ?curr-index (nth$ ?i $?escogido))
        (if (= ?curr-index 0) then (assert (servicios_pref FALSE)))
		(bind ?curr-servicio (nth$ ?curr-index $?nom-servicios))
		(bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-servicio))
	)
	(retract ?hecho)
    (modify ?pref (distancia_servicio $?respuesta))
)

(defrule recopilacion-preferencias::establecer-preferencias_vivienda "Establece los complementos que se quieren para una vivienda"
		?hecho <- (preferencias_viv ask)
		?pref <- (preferencias_usuario)
		=>
		(bind $?nom-preferencias (create$ Terraza Soleado_Tarde Soleado_mañana Piscina Amueblado Vistas Aire_acondicionado Electrodomesticos Calefaccion Balcon Garaje Mascotas))
		(bind $?escogido (pregunta-multirespuesta "Escoja las preferencias que deben estar (o 0 en el caso que no haya ninguna): " $?nom-preferencias))
		(assert (servicios_pref TRUE))
	    (bind $?respuesta (create$ ))
		(loop-for-count (?i 1 (length$ $?escogido)) do
			(bind ?curr-index (nth$ ?i $?escogido))
	        (if (= ?curr-index 0) then (assert (servicios_pref FALSE)))
			(bind ?curr-servicio (nth$ ?curr-index $?nom-preferencias))
			(bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-servicio))
		)
		(retract ?hecho)
	    (modify ?pref (preferencias_vivienda $?respuesta))
)

;(defrule recopilacion-preferencias::establecer-tipo_vivienda "Establece que tipo de vivienda se busca"
;
;)


;(defrule recopilacion-preferencias::establecer-distancia_servicio "Establece los servicios que el usuario quiere que esten cerca"
	;?f <- (falta preferencias)
	;?g <- (preferencias_usuario)
	;=>
	;(bind $?serviciospref (create$ ))
	;(bind ?respuesta (pregunta-si-no "Deseas tener un centro de salud cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) centrosalud)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener un colegio cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) colegio)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener un estadio de deportes cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) estadiodeportes)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener un hipermercado cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) hipermercado)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener una zona de ocio nocturna cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) ocionocturno)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener un supermercado cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) supermercado)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener transporte publico cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) transportepublico)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener una zona comercial cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) zonacomercial)))

	;(bind ?respuesta (pregunta-si-no "Deseas tener una zona verde cerca?" ))
	;(if (eq ?respuesta TRUE) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) zonaverde)))
	;(retract ?f)
	;(modify ?g (distancia_servicio $?serviciospref))
	;(assert (testing))
;)
;(defrule recopilacion-preferencias::testi
;	?t<-(testing)
;	(preferencias_usuario (distancia_servicio $?ds))
;	=>
;	(bind ?i 1)
;		(while (<= ?i (length$ $?ds))
;			do
;			(bind ?sn (nth$ ?i  $?ds ))
;			(printout t "servicio: " ?sn crlf)
;			(bind ?i(+ ?i 1))
;		)
;		(retract ?t)
;)


(defrule recopilacion-preferencias::inicia-procesado "Da por acabada la fase de preguntar al usuario"
	(declare (salience -10))
	=>
	(focus procesado)
)

;;--------------------------------------------
;; Modulo de procesado
;;--------------------------------------------

(defrule procesado::inicio
	(declare (salience 10))
	=>
	(printout t "...Procesando datos..." crlf)
	)

(defrule procesado::anadir-viviendas "se anaden las viviendas a la clase auxiliar"
	(declare (salience 10))
	?viv<-(object (is-a Vivienda))
	=>
	(make-instance (gensym) of Recomendacion (contenido ?viv))
  (assert (fil_precio (send ?viv get-Id)))
	(assert (fil_bajo (send ?viv get-Id)))
	(assert (fil_cap (send ?viv get-Id)))
	)

	(defrule procesado::unifica_filtros "unifiica las variables de filtro para simplificar el codigo posterior"
		(declare (salience 5))
		(not (or (fil_precio ?) (fil_bajo ?) (fil_cap ?)))
		=>
		(assert (fin_fil))

	)

(defrule procesado::fact_trabajo "fact si el usuario trabaja en la ciudad y hay que valorar"
	(declare (salience 10))
	(fin_fil)
	(Usuario (coorX ?x) (coorY ?y))
	(test (!= -1 ?x))
	=>
	(assert (valora_trabajo))
)



(defrule procesado::fact_transporte "si el usuario no tiene coche necesita transporte cerca"
	(declare (salience 10))
	(fin_fil)
	(Usuario (posee_vehiculo ?pv) )
	(object (is-a Recomendacion) (contenido ?c))
	(test (eq ?pv FALSE))
	=>
	(assert (puntua_transporte (send ?c get-Id)))

)

(defrule procesado::fact_cerca_preferencia "crea los facts para los servicios que el usuario quiere cerca"
			(declare (salience 10))
			(fin_fil)
			(preferencias_usuario (distancia_servicio $?servicios))
			(object (is-a Recomendacion) (contenido ?c))
			=>
			(progn$ (?servicio $?servicios)
					;;(printout t "defino fact con " ?servicio (send ?c get-Id) crlf)
					(assert (servicio_pref_puntuacion ?servicio (send ?c get-Id) ))
			)
)

(defrule procesado::fact_puntuacion_edad_tipo "crea los facts para las puntuaciones por edad y tipo de familia"
			(declare (salience 10))
			(fin_fil)
			(object (is-a Recomendacion) (contenido ?c))
			=>
			(assert (puntua_edad_tipo (send ?c get-Id)))
)

(defrule procesado::fact_puntuacion_general "crea facts que puntuan viviendas independientemente del usuario"
	(declare (salience 10))
	(fin_fil)
	(object (is-a Recomendacion) (contenido ?c))
	=>
	(assert (puntua_general (send ?c get-Id)))
)


(defrule procesado::filtra_precio "Se eliminan los pisos con precio mayor al permitido"
	;;aqui supongo que precio no fijo es +50%
	(preferencias_usuario (precio_maximo ?pm) (precio_estricto ?pe) )
	?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j))
	?f<-(fil_precio ?id)
	(test (eq ?id (send ?c get-Id)) )
		=>
		(bind ?precio (send ?c get-Precio_mensual ))
		(if (> ?precio ?pm) then
			(if (eq ?pe TRUE) then
				(send ?viv delete)
				(printout t "eliminada vivienda: "(send ?c get-Id) crlf)
					else (if (<= ?precio (* 1.2 ?pm)) then
						(assert (precio_puntuacion (send ?c get-Id) ))
						else
							(send ?viv delete)
					)
			)
		)
		(retract ?f)
	)

(defrule procesado::filtra_preciobajo "Se eliminan los pisos con precio menor al minimo"
		(preferencias_usuario (precio_minimo ?pm) )
		?viv<-(object (is-a Recomendacion) (contenido ?c))
		?f<-(fil_bajo ?id)
		(test (eq ?id (send ?c get-Id)) )
			=>
			(bind ?precio (send ?c get-Precio_mensual ))
			(if (< ?precio ?pm) then
				(send ?viv delete)
				(printout t "eliminada vivienda: "(send ?c get-Id) crlf)
			)
			(retract ?f)
		)

(defrule procesado::filtra_capacidad "Se eliminan los pisos con capacidad menor a las personas que van a vivir"
;tambien elimina viviendas que no cumplan la exigencia de dormitorios dobles y puntua si tienen mas de los necesarios
			(Usuario (tam_familia_grupo ?t) )
			(preferencias_usuario (num_dormitorios_dobles ?dd))
			?viv<-(object (is-a Recomendacion) (contenido ?c))
			 ?f<- (fil_cap ?id)
			 (test (eq ?id (send ?c get-Id)) )
				=>
				(bind ?capacidad (+ (send ?c get-Dormi_simple ) (* 2 (send ?c get-Dormi_doble ) ) ) )
				(if (or (< ?capacidad ?t) (< (send ?c get-Dormi_doble ) ?dd )) then
					(send ?viv delete)
					(printout t "eliminada vivienda: "(send ?c get-Id) crlf)
					else (if (> ?capacidad ?t) then
								(assert (pdorm_extra (send ?c get-Id) ))
							 )
				)
				(retract ?f)
			)

(defrule procesado::puntua_capacidad "se suman puntos si el piso tiene capacidad extra"
	?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) )
	 ?f<- (pdorm_extra ?id)
	 (test (eq ?id (send ?c get-Id)) )
	 =>
	 (send ?viv put-justificaciones $?j "+ La vivienda dispone de dormitorios extra")
	 (send ?viv put-puntuacion (+ ?p 2 ) )
	 (retract ?f)
)

(defrule procesado::puntua_precio "si hace falta quitar puntos por precio"
			(preferencias_usuario (precio_maximo ?pm) (precio_estricto ?pe) )
			?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j) (fallos ?fe))
			?f <-(precio_puntuacion ?id)
			(test (eq ?id (send ?c get-Id)) )
			=>
			(bind ?precio (send ?c get-Precio_mensual ))
			;si el precio esta entre pm y 1.5* pm, entonces se resta puntuacion
			(send ?viv put-justificaciones $?j "-	El precio es alto")
			(send ?viv put-puntuacion (- ?p 7) )
			(send ?viv put-fallos (+ ?fe 1))
			(retract ?f)
)



(defrule procesado::transporte_cerca "si el usuario trabaja/estudia y no tiene coche hace falta transporte cerca"
	?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j) (fallos ?fe))
	?f<-(puntua_transporte ?id)
	(test (eq ?id (send ?c get-Id)))
	=>
	(bind ?found FALSE)
	(progn$ (?ser (send ?c get-servicio_cerca))
		(if (or (eq (class ?ser) Bus) (eq (class ?ser) Metro) ) then
			(bind ?found TRUE)
		 )
	)
	(if ?found then
		(send ?viv put-justificaciones $?j "+ Transporte publico cerca para trabajar/estudiar")
		(send ?viv put-puntuacion (+ ?p 7) )
		else
		(send ?viv put-justificaciones $?j "- No hay transporte publico cerca para trabajar/estudiar")
		(send ?viv put-puntuacion (- ?p 7) )
		(send ?viv put-fallos (+ ?fe 1))
	)
	(retract ?f)
)




(defrule procesado::puntua_servicios "Se puntua segun los servicios cercanos que hayan"
				;(preferencias_usuario (distancia_servicio $?servicios))
				?ser <-(object (is-a Servicio) )
			  ?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) (fallos ?fe))
				?f <- (servicio_pref_puntuacion ?cls ?id )
				(test (eq ?cls (class ?ser)))
				(test (eq ?id (send ?c get-Id)))
				=>
				(bind ?contador FALSE)
				(progn$ (?media (send ?c get-servicio_media))
					;(printout t "inside progn, about to compare " (class ?ser) " " (class ?cerca) crlf)
					;(printout t "are they equal? " (eq (class ?ser) (class ?cerca)) crlf)

						(if (eq (class ?ser) (class ?media))then
						(bind ?contador TRUE)
						(send ?viv put-puntuacion (+ ?p 5))
						(send ?viv put-justificaciones $?j (str-cat "+ Servicio del tipo " (class ?media) " a distancia media") )
					)
				)
				(progn$ (?cerca (send ?c get-servicio_cerca))
				;	(printout t "inside progn, about to compare " (class ?ser) " " (class ?cerca) crlf)
					;(printout t "are they equal? " (eq (class ?ser) (class ?cerca)) crlf)
					;(printout t "now with id " ?id crlf crlf)
						(if (eq (class ?ser) (class ?cerca))then
						;;(printout t "LIKE WTF " ?id crlf crlf)
						(bind ?contador TRUE)
						(send ?viv put-puntuacion (+ ?p 7))
						(send ?viv put-justificaciones $?j (str-cat "+ Servicio del tipo " (class ?cerca) " cerca") )
					)
				)

				(if (eq ?contador FALSE) then
					(send ?viv put-puntuacion (- ?p 7))
					(send ?viv put-justificaciones $?j (str-cat "- Servicio del tipo " (class ?ser) " lejos") )
					(send ?viv put-fallos (+ ?fe 1))
				)
				(retract ?f)
)




(defrule procesado::trabajo_cerca "Si el usuario trabaja en la ciudad,puntua mejor si esta cerca"
	?fact <-(valora_trabajo)
	(Usuario (coorX ?x) (coorY ?y))
	?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j))
	=>
	(bind ?co (send ?c get-Coord_viv))
  (bind ?euc ( euclidean ?x ?y (send ?co get-X) (send ?co get-Y)  ) )
	(if (<= ?euc 500) then
		(send ?viv put-puntuacion (+ ?p 2))
		(send ?viv put-justificaciones $?j "+ Trabajo/Estudios cerca" )
		else
			(if (<= ?euc 1000) then
				(send ?viv put-puntuacion (+ ?p 1))
				(send ?viv put-justificaciones $?j "+ Trabajo/Estudios distancia media" )
			)
	)
	(retract ?fact)

)

(defrule procesado::puntua_edad_tipo_us "Puntua caracteristicas deducidas por la edad y tipo de familia"
		(Usuario (edad ?e) (tipo ?t))
		?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j))
		?f<- (puntua_edad_tipo ?id)
		(test (eq ?id (send ?c get-Id)))
		=>
		;puntuacion de la vivienda en si
		(bind $?ljust $?j)
		(bind ?pextra ?p)
		(if (and (send ?c get-Piscina) (eq ?t familia)) then
			(bind ?pextra (+ ?p 2))
			(bind $?ljust $?ljust "+ Piscina para la familia" )
		)
		;puntuacion de los servicios cercanos
		(progn$ (?ser (send ?c get-servicio_cerca) )
			(if (and (eq (class ?c) ocio+nocturno) (<= ?e 30)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Ocio nocturno cerca" )
			)
			(if (and (or (eq (class ?c) Supermercado) (eq (class ?c) Zona+comercial) ) (or (eq ?t familia) (eq ?t pareja)))  then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Super/centro comercial cerca" )
			)
			(if (and (eq (class ?c) Centro+de+salud) (>= ?e 65)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Centro de salud cerca" )
			)
			(if (and (eq (class ?c) colegio) (eq ?t familia)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Colegio cerca" )
			)

		)
		(progn$ (?ser (send ?c get-servicio_media) )
			(if (and (eq (class ?c) ocio+nocturno) (<= ?e 30)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Ocio nocturno a distancia media" )
			)
			(if (and (or (eq (class ?c) Supermercado) (eq (class ?c) Zona+comercial )) (or (eq ?t familia) (eq ?t pareja))) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Super/centro comercial a distancia media" )
			)
			(if (and (eq (class ?c) Centro+de+salud) (>= ?e 65))then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Centro de salud a distancia media" )
			)
			(if (and (eq (class ?c) colegio) (eq ?t familia)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Colegio a distancia media" )
			)
		)

		(send ?viv put-puntuacion ?pextra)
		(send ?viv put-justificaciones $?ljust)
		(retract ?f)
)

(defrule procesado::puntua_car_general "Puntua caracteristicas generales de las viviendas"
		?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j))
		?f<- (puntua_general ?id)
		(test (eq ?id (send ?c get-Id)))
		=>
		(bind $?ljust $?j)
		(bind ?pextra ?p)
		(if (and (send ?c get-Sol_man) (send ?c get-Sol_tarde)) then
			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Vivienda soleada")
		)
		(if (eq (send ?c get-Tipo) familiar) then
 			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Vivienda unifamiliar")
		)
		(if (eq (send ?c get-Altura_piso) atico) then
 			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Vivienda es un atico")
		)
		(if (send ?c get-Terraza) then
			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Tiene terraza")
		)
		;defino la densidad de servicios como 2*n.servicios cerca + n.servicios media
		(bind ?densidad 0)
		(progn$ (?ser (send ?c get-servicio_cerca))
			(bind ?densidad (+ ?densidad 2))
			(if (eq (class ?ser) Zona+verde) then
				(bind ?pextra (+ ?pextra 2))
				(bind $?ljust $?ljust "+ Zona verde cerca")
			)
		)
		(progn$ (?u (send ?c get-servicio_media)) (bind ?densidad (+ ?densidad 1)))
		;numero arbitrario para la densidad
		(if (>= ?densidad 20) then
			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Bastantes servicios a menos de 1km")
		)
		(send ?viv put-puntuacion ?pextra)
		(send ?viv put-justificaciones $?ljust)
		(retract ?f)
)

(defrule procesado::genera_solucion "cambia de modulo"
	(declare (salience -10))
	=>
	(printout t "...Generando solucion..." crlf)
	(focus generacion_sol)
)



;;--------------------------------------------
;;modulo para generar la solucion
;;--------------------------------------------


(defrule generacion_sol::crea-lista-recomendaciones "Se crea una lista de recomendaciones para ordenarlas"
	(not (lista-rec-desordenada))
	=>
	(assert (lista-rec-desordenada))
)


(deffunction max_punt ($?viviendas_rec)
	(bind ?max -1)
	(bind ?melement nil)
	(progn$ (?cur_recomend $?viviendas_rec)
		(bind ?cur_punt (send ?cur_recomend get-puntuacion))
		(if (> ?cur_punt ?max)
			then
			(bind ?max ?cur_punt)
			(bind ?melement ?cur_recomend)
			)
	)
	?melement
)

(defrule generacion_sol::crea-lista-desordenada "Anade una recomendacion a la lista de recomendaciones"
		(declare (salience 10))
		?rec <- (object (is-a Recomendacion))
		?hecho <- (lista-rec-desordenada (recomendaciones $?lista))
		(test (not (member$ ?rec $?lista)))
			=>
		(modify ?hecho (recomendaciones $?lista ?rec))
	)

	(defrule generacion_sol::crea-lista-ordenada "Se crea una lista ordenada de contenido"
		(not (lista-rec-ordenada))
		(lista-rec-desordenada (recomendaciones $?lista))
		=>
		(bind $?resultado (create$ ))
		(while (not (eq (length$ $?lista) 0))  do
			(bind ?curr-rec (max_punt $?lista))
			(bind $?lista (delete-member$ $?lista ?curr-rec))
		  (bind $?resultado (insert$ $?resultado (+ (length$ $?resultado) 1) ?curr-rec))
		)
		(assert (lista-rec-ordenada (recomendaciones $?resultado)))
	)

	(defrule generacion_sol::separa-listas "separa las listas en las 3 categorias"
		(not (solucion_final))
		(lista-rec-ordenada(recomendaciones $?lista))
		=>
		(bind $?poco (create$ ))
		(bind $?norm (create$ ))
		(bind $?mucho (create$ ))
		; supongo que muy recomendadas es >150, se puede cambiar EZ
		; TODO falta debugar esta regla
		(bind ?i 1)
		(while (<= ?i (length$ $?lista )) do
			(bind ?rec (nth$ ?i $?lista ))

			(if (<= 150 (send ?rec get-puntuacion)) then
				(bind $?mucho (insert$ $?mucho (+ (length$ $?mucho) 1) ?rec))

				else
					(if (eq 0 (send ?rec get-fallos))then
						(bind $?norm (insert$ $?norm (+ (length$ $?norm) 1) ?rec))
						else
							(if (>=  3 (send ?rec get-fallos) ) then
								(bind $?poco (insert$ $?poco (+ (length$ $?poco) 1) ?rec))
								)
					)
			)

			(bind ?i (+ ?i 1))
		)
		(assert (solucion_final))
		(assert (Poco_Recomendables (recomendaciones $?poco)))
		(assert (Recomendables (recomendaciones $?norm)))
		(assert (Altamente_Recomendables (recomendaciones $?mucho)))

	)


	(defrule generacion_sol::muestra_resultado
		(declare (salience -10))
			=>
		(focus mostrar_resultados)
		)



;;--------------------------------------------
;;modulo final
;;--------------------------------------------


(defrule mostrar_resultados::muestra
	(Poco_Recomendables (recomendaciones $?poco))
	(Recomendables (recomendaciones $?norm))
	(Altamente_Recomendables (recomendaciones $?mucho))
	(Usuario (nombre ?nombre))
	(not (final))
		=>
	(printout t "***************************************************" crlf)
	(format t "Estos son los pisos que se adaptan a sus necesidades, %s" ?nombre )
	(printout t crlf)
	(printout t "***************************************************" crlf)
	(printout t "Viviendas que no cumplen todas sus preferencias, pero le podrian interesar: " crlf)
	(printout t "***************************************************" crlf)
	(progn$ (?r $?poco)

		(printout t (send ?r imprimir))
		(printout t crlf)
		(printout t crlf)
	)
	(printout t "***************************************************" crlf)
	(printout t "Viviendas que cumplen todas sus preferencias: " crlf)
	(progn$ (?r $?norm)
		(printout t (send ?r imprimir))
		(printout t crlf)
		(printout t crlf)
	)
	(printout t "***************************************************" crlf)
  (printout t "Viviendas que cumplen todas sus preferencias, y tienen extras que creemos que le interesaran: " crlf)
	(progn$ (?r $?mucho)
		(printout t (send ?r imprimir))
		(printout t crlf)
		(printout t crlf)
	)
	(assert (final))
)
