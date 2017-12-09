;;; Modulos
(defmodule MAIN (export ?ALL))

;;; Modulo de recopilacion de los datos del usuario
(defmodule recopilacion-usuario
	(import MAIN ?ALL)
	(export ?ALL)
)


;;; Funciones para preguntar
;;; Pregunta general
(deffunction pregunta-general (?pregunta)
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
	(slot sexo (type SYMBOL)(allowed-symbols masculino femenino desconocido)(default desconocido))
	(slot edad (type INTEGER)(default -1))
	;;;Falta poner los tipos que puede incluir el SYMBOL
	(slot familia (type SYMBOL)(default desconocido))
  (slot tamFamilia (type INTEGER)(default -1))
	(slot trabaja_estudia_ciudad (type SYMBOL)(allowed-symbols si no)(default si))
	(slot posee_coche (type SYMBOL)(allowed-symbols si no)(default no))
)
(deftemplate MAIN::preferencias_usuario
	(slot precio_maximo (type INTEGER)(default -1))
	(slot precio_estricto (type SYMBOL)(allowed-values FALSE TRUE)(default FALSE))
	(slot num_dormitorios (type INTEGER)(default -1))
	(slot tam_dormitorios (type INTEGER)(default -1))
	(slot precio_minimo (type INTEGER)(default -1))
	;;;Restricción especíﬁca o preferencia sobre la distancia a algún tipo de servicio(colegios cerca,transporte público cerca, ...)
	(slot pref_transp_publico (type SYMBOL)(allowed-symbols si no)(default no))
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
  (bind ?name (pregunta-general "Cual es su nombre?"))
	(assert (Usuario (nombre ?name)))
  )

(defrule recopilacion-usuario::establecer-edad "Establece la edad del usuario"
	?g <- (Usuario (edad ?edad))
	(test (< ?edad 0))
	=>
	(bind ?edad (pregunta-numerica "¿Cual es su edad? " 1 110))
	(modify ?g (edad ?edad))
)

(defrule recopilacion-usuario::establecer-tamFamilia "Establece el tamanyo de la familia del usuario"
	?g <- (Usuario (tamFamilia ?tamFamilia))
	(test (< ?tamFamilia 0))
	=>
	(bind ?tamFamilia (pregunta-numerica "¿Cual es el tamanyo de su familia? " 1 50))
	(modify ?g (tamFamilia ?tamFamilia))
)

(defrule recopilacion-usuario::establecer-preciomaximo "Establece el precio maximo a gastar del usuario"
	?g <- (preferencias_usuario (precio_maximo ?precio_maximo))
	(test (< ?precio_maximo 0))
	=>
	(bind ?precio_maximo (pregunta-numerica "¿Cual es el precio maximo que quiere gastar? " 1 999999999))
	(modify ?g (precio_maximo ?precio_maximo))
)

(defrule recopilacion-usuario::establecer-precio_estricto "Establece si el precio maximo a gastar del usuario es estricto o no"
	?g <- (preferencias_usuario (precio_estricto ?precio_estricto))
	(test (eq ?precio_estricto FALSE))
	=>
	(bind ?precio_maximo (pregunta-si-no "¿El precio es estrico? "))
	(modify ?g (precio_estricto ?precio_estricto))
)

(defrule recopilacion-usuario::establecer-num_dormitorios "Establece el numero de dormitorios deseado por el usuario"
	?g <- (preferencias_usuario (num_dormitorios ?num_dormitorios))
	(test (< ?num_dormitorios 0))
	=>
	(bind ?num_dormitorios (pregunta-numerica "¿Cual es el numero de dormitorios deseado? " 1 20))
	(modify ?g (num_dormitorios ?num_dormitorios))
)

(defrule recopilacion-usuario::establecer-tam_dormitorios "Establece el tamanyo de los dormitorios deseado por el usuario"
	?g <- (preferencias_usuario (tam_dormitorios ?tam_dormitorios))
	(test (< ?tam_dormitorios 0))
	=>
	(bind ?tam_dormitorios (pregunta-numerica "¿Cual es el tamanyo de los dormitorios deseado? " 1 20))
	(modify ?g (tam_dormitorios ?tam_dormitorios))
)

(defrule recopilacion-usuario::establecer-precio_minimo "Establece el precio minimo a partir del cual el usuario piensa que la vivienda es adecuada"
	?g <- (preferencias_usuario (precio_minimo ?precio_minimo))
	(test (< ?precio_minimo 0))
	=>
	(bind ?precio_minimo (pregunta-numerica "¿Cual es el precio minimo a gastar? " 1 999999999))
	(modify ?g (precio_minimo ?precio_minimo))
)

;Nose como hacerlo con lo de los symbols
(defrule recopilacion-usuario::establecer-sexo "Establece el sexo del usuario"
?g <- (Usuario (sexo ?sexo))
(test (eq ?sexo desconocido))
=>
(bind ?formatos (create$ "masculino" "femenino"))
(bind ?sexo (pregunta-indice "Cual es tu sexo?" ?formatos))
(modify ?g (sexo ?sexo))
)
