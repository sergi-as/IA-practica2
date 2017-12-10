;;; Modulos
(defmodule MAIN (export ?ALL))

;;; Modulo de recopilacion de los datos del usuario
(defmodule recopilacion-usuario
	(import MAIN ?ALL)
	(export ?ALL)
)
(defmodule recopilacion-preferencias
	(import MAIN ?ALL)
	(import recopilacion-usuario deftemplate ?ALL)
	(export ?ALL)
)


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
	(slot trabaja_estudia_ciudad (type SYMBOL)(default desconocido))
	(slot posee_vehiculo (type SYMBOL)(default desconocido))
)
(deftemplate MAIN::preferencias_usuario
	(slot precio_maximo (type INTEGER)(default -1))
	(slot precio_estricto (type SYMBOL)(default desconocido))
	(slot num_dormitorios_dobles (type INTEGER)(default -1))
	(slot precio_minimo (type INTEGER)(default -1))
	(multislot distancia_servicio (type SYMBOL))
	(slot pref_transp_publico (type SYMBOL)(default desconocido))
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
	(printout t "encontrada pareja vivienda " ?i " servicio " ?nser " distancia : " ?euc crlf )
	(if (<= ?euc 500) then
		(send ?viv put-servicio_cerca $?scer ?ser)
	)
	else (if (<= ?euc 1000) then
		(send ?viv put-servicio_media $smed ?ser)
	)
	;para mostrar los servicios cerca ;;;;;; p 27 como iterar multislot
	(bind $?servicios2 (send ?viv get-servicio_cerca))
	(printout t "servicios actuales " (length$ $?servicios2) crlf)
	(if (>=(length$ $?servicios2) 1) then
		(printout t "por ejemplo,el servicio en la posicion 1 " (send (nth$ 1  $?servicios2)  get-Nombre_ser)  crlf)
	)
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

(defrule recopilacion-usuario::establecer-tipo "establece la tipologia de la familia"
	?g <-(Usuario (tipo ?tipo))
	(test (eq ?tipo desconocido))
	=>
	(bind ?i (pregunta-indice "De que tipo es el grupo para el que busca piso " (create$ "Pareja" "Familia" "Grupo" "Individuo")))
	(printout t "valor elegido " ?i crlf)
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
	?g <- (Usuario (trabaja_estudia_ciudad ?t))
	(test (eq ?t desconocido))
	=>
	(bind ?t (pregunta-si-no "Estudia y/o trabaja en esta ciudad? " ))
	(modify ?g (trabaja_estudia_ciudad ?t))
)

(defrule recopilacion-usuario::establecer-vehiculo "Establece si el usuario dispone de vehiculo"
	?g <- (Usuario (posee_vehiculo ?v))
	(test (eq ?v desconocido))
	=>
	(bind ?v (pregunta-si-no "Dispone de vehiculo propio? " ))
	(modify ?g (posee_vehiculo ?v))
)


(defrule recopilacion-usuario::establecer-preciomaximo "Establece el precio maximo a gastar del usuario"
	(not (preferencias_usuario))
	=>
	(bind ?precio_maximo (pregunta-numerica "¿Cual es el precio maximo que quiere gastar? " 1 999999999))
	(assert (preferencias_usuario (precio_maximo ?precio_maximo)))
)

(defrule recopilacion-usuario::establecer-precio_estricto "Establece si el precio maximo a gastar del usuario es estricto o no"
	?g <- (preferencias_usuario (precio_estricto ?precio_estricto))
	(test (eq ?precio_estricto desconocido))
	=>
	(bind ?precio_estricto (pregunta-si-no "¿El precio es estricto? "))
	(modify ?g (precio_estricto ?precio_estricto))
)

(defrule recopilacion-usuario::establecer-num_dormitorios_dobles "Establece el numero de dormitorios dobles deseado por el usuario"
	?g <- (preferencias_usuario (num_dormitorios_dobles ?num_dormitorios_dobles))
	(test (< ?num_dormitorios_dobles 0))
	=>
	(bind ?num_dormitorios_dobles (pregunta-numerica "¿Cual es el numero de dormitorios dobles deseado? " 1 20))
	(modify ?g (num_dormitorios_dobles ?num_dormitorios_dobles))
)

;(defrule recopilacion-usuario::establecer-tam_dormitorios "Establece el tamanyo de los dormitorios deseado por el usuario"
;	?g <- (preferencias_usuario (tam_dormitorios ?tam_dormitorios))
;	(test (< ?tam_dormitorios 0))
;	=>
;	(bind ?tam_dormitorios (pregunta-numerica "¿Cual es el tamanyo de los dormitorios deseado? " 1 20))
;	(modify ?g (tam_dormitorios ?tam_dormitorios))
;)

(defrule recopilacion-usuario::establecer-precio_minimo "Establece el precio minimo a partir del cual el usuario piensa que la vivienda es adecuada"
	?g <- (preferencias_usuario (precio_minimo ?precio_minimo))
	(test (< ?precio_minimo 0))
	=>
	(bind ?precio_minimo (pregunta-numerica "¿Cual es el precio minimo a gastar? " 1 999999999))
	(modify ?g (precio_minimo ?precio_minimo))
)

(defrule recopilacion-usuario::establecer-distancia_servicio "Establece los servicios que el usuario quiere que esten cerca"
	?g <- (preferencias_usuario)
	=>
	(bind $?serviciospref (create$ ))
	(bind ?respuesta (pregunta-si-no "Deseas tener un centro de salud cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) centrosalud)))

	(bind ?respuesta (pregunta-si-no "Deseas tener un colegio cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) colegio)))

	(bind ?respuesta (pregunta-si-no "Deseas tener un estadio de deportes cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) estadiodeportes)))

	(bind ?respuesta (pregunta-si-no "Deseas tener un hipermercado cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) hipermercado)))

	(bind ?respuesta (pregunta-si-no "Deseas tener una zona de ocio nocturna cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) ocionocturno)))

	(bind ?respuesta (pregunta-si-no "Deseas tener un supermercado cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) supermercado)))

	(bind ?respuesta (pregunta-si-no "Deseas tener transporte publico cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) transportepublico)))

	(bind ?respuesta (pregunta-si-no "Deseas tener una zona comercial cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) zonacomercial)))

	(bind ?respuesta (pregunta-si-no "Deseas tener una zona verde cerca?" ))
	(if (eq ?respuesta si) then (bind $?serviciospref(insert$ $?serviciospref (+ (length$ $?serviciospref) 1) zonaverde)))

	(modify ?g (distancia_servicio $?serviciospref))
)

(defrule recopilacion-usuario::establecer-pref_transp_publico "Establece si el usuario prefiere utilizar el transporte publico"
	?g <- (preferencias_usuario (pref_transp_publico ?pref_transp_publico))
	(test (eq ?pref_transp_publico desconocido))
	=>
	(bind ?pref_transp_publico (pregunta-si-no "¿Prefieres utilizar el transporte publico? "))
	(modify ?g (pref_transp_publico ?pref_transp_publico))
)
