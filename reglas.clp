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


(deffunction MAIN::euclidean (?x ?y ?m ?n)
	(bind ?res (sqrt (+ (**(- ?x ?m) 2) (**(- ?y ?n) 2) )))
	?res
)

;;; Funcion para hacer una pregunta de tipo si/no
(deffunction MAIN::pregunta-si-no (?question)
   (bind ?response (pregunta-opciones ?question si no))
   (if (or (eq ?response si) (eq ?response s))
       then TRUE
       else FALSE)
)
;;; Templates
(deftemplate MAIN::Usuario
	(slot nombre (type STRING))
	(slot sexo (type SYMBOL) (default desconocido))
	(slot edad (type INTEGER) (default -1))
	(slot familia (type SYMBOL) (default desconocido))
  (slot tamFamilia (type INTEGER)(default -1))
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
(defrule recopilacion-usuario::preguntaNombre
  (not (Usuario))
  =>
  (bind ?name (pregunta-general "Cual es su nombre?"))
	(assert (Usuario (nombre ?name)))

  )
