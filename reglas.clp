;;; Modulos

;;;modulo MAIN
(defmodule MAIN (export ?ALL))

;;;modulo de recopilacion de los datos del usuario
(defmodule recopilacion-usuario
	(import MAIN ?ALL)
	(export ?ALL)
)

;;;modulo de recopilacion de las preferencias del usuario
(defmodule recopilacion-preferencias
	(import MAIN ?ALL)
	(import recopilacion-usuario deftemplate ?ALL)
	(export ?ALL)
)

;;;modulo para procesar los datos y elegir las viviendas
(defmodule procesado
	(import MAIN ?ALL)
	(import recopilacion-usuario deftemplate ?ALL)
	(import recopilacion-preferencias deftemplate ?ALL)
	(export ?ALL)
)

;;;modulo para hacer operaciones extra a las viviendas que han sobrevivido a la criba
(defmodule generacion_sol
	(import MAIN ?ALL)
	(export ?ALL)
)

;;;modulo para mostrar los resultados al usuario
(defmodule mostrar_resultados
	(import MAIN ?ALL)
	(export ?ALL)
)


;;; Declaracion de messages ---------------------------

;;;defmessage-handler para imprimir la informacion de una vivienda
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
(format t "Banyos: %g %n" ?self:Banyos)
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
(if (eq ?self:Seguridad TRUE)then (format t "Con seguridad %n")
else (format t "Sin seguridad %n"))
(printout t crlf)
(if (eq ?self:Reformada TRUE)then (format t "Reformada recientemente %n")
else (format t "No reformada recientemente %n"))
(printout t crlf)
(if (eq ?self:Ascensor TRUE)then (format t "Con ascensor %n")
else (format t "Sin ascensor %n"))
(printout t crlf)
(if (eq ?self:TV TRUE)then (format t "Con TV %n")
else (format t "Sin TV %n"))
(printout t crlf)
(if (eq ?self:WIFI TRUE)then (format t "Con WIFI %n")
else (format t "Sin WIFI %n"))
(printout t crlf)
(if (eq ?self:Accesible TRUE)then (format t "Con accesibilidad %n")
else (format t "Sin accesibilidad %n"))
(printout t crlf)
(if (eq ?self:Fumadores TRUE)then (format t "Apto para fumadores %n")
else (format t "No apto para fumadores %n"))
(printout t crlf)
(if (eq ?self:Portero TRUE)then (format t "Con portero %n")
else (format t "Sin portero %n"))
(printout t crlf)
(printout t "Servicios cerca:" crlf)
(progn$ (?serv_cerca ?self:servicio_cerca)
		(printout t (send ?serv_cerca get-Nombre_ser) crlf)
)
(printout t crlf)
(printout t "Servicios a media distancia:" crlf)
(progn$ (?serv_media ?self:servicio_media)
		(printout t (send ?serv_media get-Nombre_ser) crlf)
)
(printout t crlf)
(if (eq ?self:Sol_man TRUE)then (format t "Con sol por la manyana %n")
else (format t "Sin sol por la manana %n"))
(printout t crlf)
(if (eq ?self:Sol_tarde TRUE)then (format t "Con sol por la tarde %n")
else (format t "Sin sol por la tarde %n"))
(printout t crlf)
(printout t "-----------------------------------" crlf)
)

;;;defmessage-handler para imprimir recomendaciones
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
   ?answer
)

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

;;;Funcion que calcula la distancia entre dos puntos
(deffunction MAIN::euclidean (?x ?y ?m ?n)
	(bind ?res (sqrt (+ (**(- ?x ?m) 2) (**(- ?y ?n) 2) )))
	?res
)


;;; Templates

;;;Template para los datos del usuario
(deftemplate MAIN::Usuario
	(slot nombre (type STRING))
	(slot edad (type INTEGER)(default -1))
	;tipologia del solicitante: familia,pareja o gruppo
	(slot tipo (type SYMBOL)(default desconocido))
  (slot tam_familia_grupo (type INTEGER)(default -1))
	(slot posee_vehiculo (type SYMBOL)(default desconocido))
	;;coordenadas
	(slot coorX (type INTEGER) (default -1))
	(slot coorY (type INTEGER) (default -1))
)

;;;Template para las preferencias del usuario
(deftemplate MAIN::preferencias_usuario
	(slot precio_maximo (type INTEGER)(default -1))
	(slot precio_estricto (type SYMBOL)(default desconocido))
	(slot num_dormitorios_dobles (type INTEGER)(default -1))
	(slot num_banyos (type INTEGER)(default -1))
	(slot precio_minimo (type INTEGER)(default -1))
	(multislot distancia_servicio (type SYMBOL))
	(multislot preferencias_vivienda (type SYMBOL))
)

;;;Template para una lista de recomendaciones sin orden
(deftemplate MAIN::lista-rec-desordenada
	(multislot recomendaciones (type INSTANCE))
)

;;;Template para una lista de recomendaciones ordenada por puntuacion
(deftemplate MAIN::lista-rec-ordenada
	(multislot recomendaciones (type INSTANCE))
)

;;;Template para las recomendaciones que forman parte del grupo poco recomendables
(deftemplate MAIN::Poco_Recomendables
	(multislot recomendaciones (type INSTANCE))
)

;;;Template para las recomendaciones que forman parte del grupo recomendables
(deftemplate MAIN::Recomendables
	(multislot recomendaciones (type INSTANCE))
)

;;;Template para las recomendaciones que forman parte del grupo altamente recomendables
(deftemplate MAIN::Altamente_Recomendables
	(multislot recomendaciones (type INSTANCE))
)

;;; Reglas

;;;Regla para inicializar
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

;; Regla para fijar los servicios cercanos y a media distancia a las viviendas
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
	(if (<= ?euc 500) then
		(send ?viv put-servicio_cerca $?scer ?ser)
		else (if (<= ?euc 1000) then
			(send ?viv put-servicio_media $?smed ?ser)
		)
	)
	(bind $?servicios2 (send ?viv get-servicio_cerca))
)

;;;Regla que establece el nombre del usuario
(defrule recopilacion-usuario::preguntaNombre "Establece el nombre del usuario"
  (not (Usuario))
  =>
  (bind ?name (pregunta-general "Cual es su nombre? "))
	(assert (Usuario (nombre ?name)))
  )

;;;Regla que establece la edad del usuario
(defrule recopilacion-usuario::establecer-edad "Establece la edad del usuario"
	?g <- (Usuario (edad ?edad))
	(test (< ?edad 0))
	=>
	(bind ?edad (pregunta-numerica "¿Cual es su edad? " 1 110))
	(modify ?g (edad ?edad))
)

;;;Regla que establece la tipologia del usuario
(defrule recopilacion-usuario::establecer-tipo "establece la tipologia del usuario"
	?g <-(Usuario (tipo ?tipo))
	(test (eq ?tipo desconocido))
	=>
	(bind ?i (pregunta-indice "De que tipo es el grupo para el que busca piso " (create$ "Pareja" "Familia" "Grupo" "Individuo")))
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

;;;Regla que establece el tamanyo de la familia del usuario
(defrule recopilacion-usuario::establecer-tam_familia_grupo "Establece el tamanyo de la familia del usuario"
	?g <- (Usuario (tam_familia_grupo ?tam_familia_grupo))
	(test (< ?tam_familia_grupo 0))
	=>
	(bind ?tam_familia_grupo (pregunta-numerica "¿Cual es el tamanyo de su familia o grupo ? (incluyendose a usted) " 1 50))
	(modify ?g (tam_familia_grupo ?tam_familia_grupo))
)

;;;Regla que establece si el usuario estudia o trabaja
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

;;;Regla para preguntar las coordenadas si el usuario estudia otrabaja en la ciudad
(defrule recopilacion-usuario::pregunta-coord "si trabaja o estudia en la ciudad se pregunta donde"
	?g <- (Usuario (coorX ?x)(coorY ?y))
	?t <- (preguntacoord ask)
	=>
	(bind ?x (pregunta-numerica "Escriba la coordenada x " 0 3000))
	(bind ?y (pregunta-numerica "Escriba la coordenada y " 0 3000))
	(modify ?g (coorX ?x)(coorY ?y) )
	(retract ?t)
	(assert (preguntacoord done))
)

;;;Regla que establece si el usuario dispone de vehiculo
(defrule recopilacion-usuario::establecer-vehiculo "Establece si el usuario dispone de vehiculo"
	?g <- (Usuario (posee_vehiculo ?v))
	(test (eq ?v desconocido))
	=>
	(bind ?v (pregunta-si-no "Dispone de vehiculo propio? " ))
	(modify ?g (posee_vehiculo ?v))
)

;;;Regla para pasar al modulo de recopilacion-preferencias
(defrule recopilacion-usuario::inicia-preferencias "Cambia de modulo para preguntar por preferencias"
	(declare (salience -10))
	=>
	(focus recopilacion-preferencias)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; reglas preferencias
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Regla que establece el precio maximo a gastar del usuario
(defrule recopilacion-preferencias::establecer-preciomaximo "Establece el precio maximo a gastar del usuario"
	(not (preferencias_usuario))
	=>
	(bind ?precio_maximo (pregunta-numerica "¿Cual es el precio maximo que quiere gastar? " 1 999999999))
	(assert (preferencias_usuario (precio_maximo ?precio_maximo)))
	(assert (servicios_pref ask))
	(assert (preferencias_viv ask))
	(assert (tipo_viv ask))
)

;;;Regla que establece si el precio maximo a gastar del usuario es estricto o no
(defrule recopilacion-preferencias::establecer-precio_estricto "Establece si el precio maximo a gastar del usuario es estricto o no"
	?g <- (preferencias_usuario (precio_estricto ?precio_estricto))
	(test (eq ?precio_estricto desconocido))
	=>
	(bind ?precio_estricto (pregunta-si-no "¿El precio es estricto? "))
	(modify ?g (precio_estricto ?precio_estricto))
)

;;;Regla que establece el numero de dormitorios dobles deseado por el usuario
(defrule recopilacion-preferencias::establecer-num_dormitorios_dobles "Establece el numero de dormitorios dobles deseado por el usuario"
	?g <- (preferencias_usuario (num_dormitorios_dobles ?num_dormitorios_dobles))
	(test (< ?num_dormitorios_dobles 0))
	=>
	(bind ?num_dormitorios_dobles (pregunta-numerica "¿Cual es el numero de dormitorios dobles deseado? " 0 20))
	(modify ?g (num_dormitorios_dobles ?num_dormitorios_dobles))
)

;;;Regla que establece el numero de banyos deseado por el usuario
(defrule recopilacion-preferencias::establecer-num_banyos "Establece el numero de banyos deseado por el usuario"
	?g <- (preferencias_usuario (num_banyos ?num_banyos))
	(test (< ?num_banyos 0))
	=>
	(bind ?num_banyos (pregunta-numerica "¿Cual es el numero de banyos deseado? " 0 20))
	(modify ?g (num_banyos ?num_banyos))
)

;;;Regla que establece el precio minimo a partir del cual el usuario piensa que la vivienda es adecuada
(defrule recopilacion-preferencias::establecer-precio_minimo "Establece el precio minimo a partir del cual el usuario piensa que la vivienda es adecuada"
	?g <- (preferencias_usuario (precio_minimo ?precio_minimo))
	(test (< ?precio_minimo 0))
	=>
	(bind ?precio_minimo (pregunta-numerica "¿Cual es el precio minimo a gastar? " 1 999999999))
	(modify ?g (precio_minimo ?precio_minimo))
)

;;;Regla que establece los servicios que el usuario quiere que esten cerca
(defrule recopilacion-preferencias::establecer-distancia_servicio "Establece los servicios que el usuario quiere que esten cerca"
    ?hecho <- (servicios_pref ask)
	?pref <- (preferencias_usuario)
	=>
	(bind $?nom-servicios (create$ Bus Metro Tren colegio Centro_de_salud Estadio_de_deportes Ocio_nocturno Supermercado Zona_comercial Zona_verde Restaurante Iglesia Parque_de_atracciones ))
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

;;;Regla que establece los complementos que el usuario quiere para la vivienda
(defrule recopilacion-preferencias::establecer-preferencias_vivienda "Establece los complementos que se quieren para una vivienda"
		?hecho <- (preferencias_viv ask)
		?pref <- (preferencias_usuario)
		=>
		(bind $?nom-preferencias (create$ Terraza Soleado_Tarde Soleado_manyana Piscina Amueblado Vistas Aire_acondicionado Electrodomesticos Calefaccion Balcon Garaje Mascotas Seguridad Reformada Ascensor TV WIFI Accesible Fumadores Portero))
		(bind $?escogido (pregunta-multirespuesta "Escoja las preferencias que deben estar (o 0 en el caso que no haya ninguna): " $?nom-preferencias))
		(assert (preferencias_viv TRUE))
	    (bind $?respuesta (create$ ))
		(loop-for-count (?i 1 (length$ $?escogido)) do
			(bind ?curr-index (nth$ ?i $?escogido))
	        (if (= ?curr-index 0) then (assert (preferencias_viv FALSE)))
			(bind ?curr-pref (nth$ ?curr-index $?nom-preferencias))
			(bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-pref))
		)
		(retract ?hecho)
	    (modify ?pref (preferencias_vivienda $?respuesta))
)

;;;Regla para pasar al modulo de procesado
(defrule recopilacion-preferencias::inicia-procesado "Da por acabada la fase de preguntar al usuario"
	(declare (salience -10))
	=>
	(focus procesado)
)


;;--------------------------------------------
;; Modulo de procesado
;;--------------------------------------------

;;;Regla que inicia el modulo de procesado
(defrule procesado::inicio
	(declare (salience 10))
	=>
	(printout t "...Procesando datos..." crlf)
)

;;;Regla que añade viviendas a la clase auxiliar
(defrule procesado::anadir-viviendas "se anaden las viviendas a la clase auxiliar"
	(declare (salience 10))
	?viv<-(object (is-a Vivienda))
	=>
	(make-instance (gensym) of Recomendacion (contenido ?viv))
  (assert (fil_precio (send ?viv get-Id)))
	(assert (fil_bajo (send ?viv get-Id)))
	(assert (fil_cap (send ?viv get-Id)))
)

;;;Regla que unifica las variables de filtro para simplificar el codigo siguiente
(defrule procesado::unifica_filtros "unifica las variables de filtro para simplificar el codigo posterior"
	(declare (salience 5))
	(not (or (fil_precio ) (fil_bajo ) (fil_cap )))
	=>
	(assert (fin_fil))
)

;;;Regla que crea el hecho que valora si el usuario trabaja o estudia
(defrule procesado::fact_trabajo "fact si el usuario trabaja en la ciudad y hay que valorar"
	(declare (salience 10))
	(fin_fil)
	(Usuario (coorX ?x) (coorY ?y))
	(test (!= -1 ?x))
	=>
	(assert (valora_trabajo))
)

;;;Regla que crea el hecho que valora si hay transportes cerca si el usuario no tiene coche y trabaja o estudia
(defrule procesado::fact_transporte "si el usuario no tiene coche necesita transporte cerca"
	(declare (salience 10))
	(fin_fil)
	(Usuario (posee_vehiculo ?pv) )
	(object (is-a Recomendacion) (contenido ?c))
	(test (eq ?pv FALSE))
	=>
	(assert (puntua_transporte (send ?c get-Id)))

)

;;;Regla que crea los hechos que valoran las preferencias respecto a los servicios cerca del usuario
(defrule procesado::fact_cerca_preferencia "crea los facts para los servicios que el usuario quiere cerca"
			(declare (salience 10))
			(fin_fil)
			(preferencias_usuario (distancia_servicio $?servicios))
			(object (is-a Recomendacion) (contenido ?c))
			=>
			(progn$ (?servicio $?servicios)
					(assert (servicio_pref_puntuacion ?servicio (send ?c get-Id) ))
			)
)

;;;Regla que crea los hechos que puntuan extras a las viviendas en funcion de la edad y tipo de usuario
(defrule procesado::fact_puntuacion_edad_tipo "crea los facts para las puntuaciones por edad y tipo de familia"
			(declare (salience 10))
			(fin_fil)
			(object (is-a Recomendacion) (contenido ?c))
			=>
			(assert (puntua_edad_tipo (send ?c get-Id)))
)

;;;Regla que crea los hechos que puntuan extras a las viviendas
(defrule procesado::fact_puntuacion_general "crea facts que puntuan viviendas independientemente del usuario"
	(declare (salience 10))
	(fin_fil)
	(object (is-a Recomendacion) (contenido ?c))
	=>
	(assert (puntua_general (send ?c get-Id)))
)

;;;Regla que crea los hechos que puntuan viviendas segun los criterios del usuario
(defrule procesado::fact_puntuacion_usuario "crea facts que puntuan viviendas dependiendo de los criterios del usuario"
 	(declare (salience 10))
 	(fin_fil)
 	(preferencias_usuario (preferencias_vivienda $?preferencias))
 	(object (is-a Recomendacion) (contenido ?c))
 	=>
 	(progn$ (?preferencia $?preferencias)
 			(assert (vivienda_pref_puntuacion ?preferencia (send ?c get-Id)))
 	)
 )

;;;Regla que crea los hechos para el numero de banyos
(defrule procesado::fact_puntuacion_banyo "Crea los facts para el numero de banyos"
	(declare (salience 10))
	(fin_fil)
	(object (is-a Recomendacion) (contenido ?c))
	=>
	(assert (puntua_banyo (send ?c get-Id)))
)

;;;Regla que elimina los pisos con precio mayor al precio maximo introducido por el usuario
;;; si el precio no es estricto se da un margen de superacion
(defrule procesado::filtra_precio "Se eliminan los pisos con precio mayor al permitido"
	;;aqui supongo que precio no fijo es +20%
	(preferencias_usuario (precio_maximo ?pm) (precio_estricto ?pe) )
	?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j))
	?f<-(fil_precio ?id)
	(test (eq ?id (send ?c get-Id)) )
		=>
		(bind ?precio (send ?c get-Precio_mensual ))
		(if (> ?precio ?pm) then
			(if (eq ?pe TRUE) then
				(send ?viv delete)
				(printout t "eliminada vivienda,demasiado cara: "(send ?c get-Id) crlf)
					else (if (<= ?precio (* 1.2 ?pm)) then
						(assert (precio_puntuacion (send ?c get-Id) ))
						else
						  (printout t "eliminada vivienda,demasiado cara: "(send ?c get-Id) crlf)
							(send ?viv delete)
					)
			)
		)
		(retract ?f)
	)

;;;Regla que elimina los pisos con precio menor al minimo introducido por el usuario
(defrule procesado::filtra_preciobajo "Se eliminan los pisos con precio menor al minimo"
		(preferencias_usuario (precio_minimo ?pm) )
		?viv<-(object (is-a Recomendacion) (contenido ?c))
		?f<-(fil_bajo ?id)
		(test (eq ?id (send ?c get-Id)) )
			=>
			(bind ?precio (send ?c get-Precio_mensual ))
			(if (< ?precio ?pm) then
				(send ?viv delete)
				(printout t "eliminada vivienda,demasiado barata: "(send ?c get-Id) crlf)
			)
			(retract ?f)
		)

;;;Regla que elimina los pisos con capacidad menor a las personas que van a vivir
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
					(printout t "eliminada vivienda,falta capacidad: "(send ?c get-Id) crlf)
					else (if (> ?capacidad ?t) then
								(assert (pdorm_extra (send ?c get-Id) ))
							 )
				)
				(retract ?f)
			)

;;;Regla que valora si la vivienda tiene capacidad extra, es decir, si tiene mas dormitorios
(defrule procesado::puntua_capacidad "se suman puntos si el piso tiene capacidad extra"
	?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) )
	 ?f<- (pdorm_extra ?id)
	 (test (eq ?id (send ?c get-Id)) )
	 =>
	 (send ?viv put-justificaciones $?j "+ La vivienda dispone de dormitorios extra")
	 (send ?viv put-puntuacion (+ ?p 2 ) )
	 (retract ?f)
)

;;;Regla que valora el precio de una vivienda
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

;;;Regla que valora el haber un transporte cerca si el usuario trabaja o estudia y no tiene coche
(defrule procesado::transporte_cerca "si el usuario trabaja/estudia y no tiene coche hace falta transporte cerca"
	?viv<-(object (is-a Recomendacion) (contenido ?c)(puntuacion ?p) (justificaciones $?j) (fallos ?fe))
	?f<-(puntua_transporte ?id)
	(test (eq ?id (send ?c get-Id)))
	=>
	(bind ?found FALSE)
	(progn$ (?ser (send ?c get-servicio_cerca))
		(if (or (eq (class ?ser) Bus) (eq (class ?ser) Metro) (eq (class ?ser) Tren) ) then
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

;;;Regla que valora las preferencias del usuario respecto los servicios
(defrule procesado::puntua_servicios "Se puntua segun los servicios cercanos que hayan"
				?ser <-(object (is-a Servicio) )
			  ?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) (fallos ?fe))
				?f <- (servicio_pref_puntuacion ?cls ?id )
				(test (eq ?cls (class ?ser)))
				(test (eq ?id (send ?c get-Id)))
				=>
				(bind ?contador FALSE)
				(progn$ (?media (send ?c get-servicio_media))
						(if (eq (class ?ser) (class ?media))then
						(bind ?contador TRUE)
						(send ?viv put-puntuacion (+ ?p 5))
						(send ?viv put-justificaciones $?j (str-cat "+ Servicio del tipo " (class ?media) " a distancia media") )
					)
				)
				(progn$ (?cerca (send ?c get-servicio_cerca))
						(if (eq (class ?ser) (class ?cerca))then
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

;;;Regla que valora si el usuario trabaja o estudia en la ciudad, la distancia a esa vivienda desde el trabajo o lugar estudio
(defrule procesado::trabajo_cerca "Si el usuario trabaja o estudia en la ciudad, puntua mejor si esta cerca"
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

;;;Regla que puntua caracteristicas deducidas a partir de la edad y tipo de usuario
(defrule procesado::puntua_edad_tipo_us "Puntua caracteristicas deducidas por la edad y tipo de familia"
		(Usuario (edad ?e) (tipo ?t))
		?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j))
		?f<- (puntua_edad_tipo ?id)
		(test (eq ?id (send ?c get-Id)))
		=>
		;si es una familia y la vivienda tiene piscina se suman puntos
		(bind $?ljust $?j)
		(bind ?pextra ?p)
		(if (and (send ?c get-Piscina) (eq ?t familia)) then
			(bind ?pextra (+ ?p 2))
			(bind $?ljust $?ljust "+ Piscina para la familia" )
		)

		;Valoracion de servicios cerca
		(progn$ (?ser (send ?c get-servicio_cerca) )
		;si el usuario es joven y tiene servicios de ocio nocturno cerca se suman puntos
			(if (and (eq (class ?c) ocio+nocturno) (<= ?e 30)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Ocio nocturno cerca" )
			)
			;si el usuario es anciano y tiene servicios de ocio nocturno cerca se restan puntos
      (if (and (eq (class ?c) ocio+nocturno) (>= ?e 65)) then
				(bind ?pextra (- ?p 5))
				(bind $?ljust $?ljust "- Servicio molesto: Ocio nocturno cerca" )
			)
			;si el usuario es anciano y tiene una iglesia cerca se suman puntos
			(if (and (eq (class ?c) Iglesia) (>= ?e 65)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Iglesia cerca" )
			)
			;si el usuario es joven y tiene un parque de atracciones cerca se suman puntos
			(if (and (eq (class ?c) Parque+de+atracciones) (<= ?e 30)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Parque de atracciones cerca" )
			)
			;si el usuario es anciano y tiene un estadio de deportes cerca se restan puntos
      (if (and (eq (class ?c) Estadio+de+deportes) (>= ?e 65)) then
				(bind ?pextra (- ?p 5))
				(bind $?ljust $?ljust "- Servicio molesto: Estadio de deportes cerca" )
			)
			;si el usuario no es anciano y tiene un estadio de deportes cerca se suman puntos
      (if (and (eq (class ?c) Estadio+de+deportes) (< ?e 65)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Estadio de deportes cerca" )
			)
			;si el usuario no es anciano y tiene una zona comercial cerca se suman puntos
      (if (and (eq (class ?c) Zona+comercial) (< ?e 65)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Zona comercial cerca" )
			)
			;si el usuario es una familia o pareja y tiene un supermercado o una zona comercial cerca se suman puntos extra
			(if (and (or (eq (class ?c) Supermercado) (eq (class ?c) Zona+comercial) ) (or (eq ?t familia) (eq ?t pareja)))  then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Super/centro comercial cerca" )
			)
			;si el usuario es anciano y tiene un centro de salud cerca se suman puntos
			(if (and (eq (class ?c) Centro+de+salud) (>= ?e 65)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Centro de salud cerca" )
			)
			;si el usuario es una familia y tiene un colegio cerca se suman puntos
			(if (and (eq (class ?c) colegio) (eq ?t familia)) then
				(bind ?pextra (+ ?p 2))
				(bind $?ljust $?ljust "+ Colegio cerca" )
			)
		)

		;Valoracion de servicios a media distancia
		(progn$ (?ser (send ?c get-servicio_media) )
		;si el usuario es joven y tiene servicios de ocio nocturno a media distancia se suman puntos
			(if (and (eq (class ?c) ocio+nocturno) (<= ?e 30)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Ocio nocturno a distancia media" )
			)
			;si el usuario es una familia o pareja y tiene un supermercado o una zona comercial a media distancia se suman puntos extra
			(if (and (or (eq (class ?c) Supermercado) (eq (class ?c) Zona+comercial )) (or (eq ?t familia) (eq ?t pareja))) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Super/centro comercial a distancia media" )
			)
			;si el usuario es anciano y tiene un centro de salud a media distancia se suman puntos
			(if (and (eq (class ?c) Centro+de+salud) (>= ?e 65))then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Centro de salud a distancia media" )
			)
			;si el usuario es una familia y tiene un colegio a media distancia se suman puntos
			(if (and (eq (class ?c) colegio) (eq ?t familia)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Colegio a distancia media" )
			)
			;si el usuario no es anciano y tiene un estadio de deportes a media distancia se suman puntos
      (if (and (eq (class ?c) Estadio+de+deportes) (< ?e 65)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Estadio de deportes a distancia media" )
			)
			;si el usuario no es anciano y tiene una zona comercial a media distancia se suman puntos
      (if (and (eq (class ?c) Zona+comercial) (< ?e 65)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Zona comercial a distancia media" )
			)
			;si el usuario es anciano y tiene una iglesia a media distancia se suman puntos
			(if (and (eq (class ?c) Iglesia) (>= ?e 65)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Iglesia a distancia media" )
			)
			;si el usuario es joven y tiene un parque de atracciones a media distancia se suman puntos
			(if (and (eq (class ?c) Parque+de+atracciones) (<= ?e 30)) then
				(bind ?pextra (+ ?p 1))
				(bind $?ljust $?ljust "+ Parque de atracciones a distancia media" )
			)
		)

		(send ?viv put-puntuacion ?pextra)
		(send ?viv put-justificaciones $?ljust)
		(retract ?f)
)

;;;Regla que puntua las caracteristicas generales de las viviendas
;;;si es un atico, si hay zonas verdes cerca, si hay bastantes servicios cerca o si es una familia y la vivienda es unifamiliar, se dan puntos
(defrule procesado::puntua_car_general "Puntua caracteristicas generales de las viviendas"
		?viv<-(object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j))
		?f<- (puntua_general ?id)
		(test (eq ?id (send ?c get-Id)))
		=>
		(bind $?ljust $?j)
		(bind ?pextra ?p)

		(if (eq (send ?c get-Tipo) familiar) then
 			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Vivienda unifamiliar")
		)
		(if (eq (send ?c get-Altura_piso) atico) then
 			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Vivienda es un atico")
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
		(if (> ?densidad 20) then
			(bind ?pextra (+ ?pextra 2))
			(bind $?ljust $?ljust "+ Bastantes servicios a menos de 1km")
		)
		(send ?viv put-puntuacion ?pextra)
		(send ?viv put-justificaciones $?ljust)
		(retract ?f)
)

;;;Regla que valora las caracteristicas de la vivienda que el usuario ha pedido,
;;;si la vivienda posee una caracteristica se dan puntos, sino se aumenta el valor de fallos
(defrule procesado::puntua_car_usuario "Puntua caracteristicas que el usuario ha pedido"
 	?viv <- (object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) (fallos ?fe))
 	?f <- (vivienda_pref_puntuacion ?preferencia ?id)
 	(test (eq ?id (send ?c get-Id)))
 	=>
 	(bind ?pextra ?p)
 	(bind $?justificacions $?j)
	(bind ?fallos ?fe)
 	(if (eq ?preferencia Terraza)
 		then
 		(if (eq TRUE (send ?c get-Terraza))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Posee Terraza")
 		else
			(bind ?fallos (+ ?fallos 1))
			(bind $?justificacions $?justificacions "- No posee Terraza")
		)
 	else (if (eq ?preferencia Soleado_Tarde)
 		then
 		(if (eq TRUE (send ?c get-Sol_tarde))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Da el sol por la tarde")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No da el sol por la tarde")
			)
 	else (if (eq ?preferencia Soleado_manyana)
 		then
 		(if (eq TRUE (send ?c get-Sol_man))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Da el sol por la manyana")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No da el sol por la manyana")
			)
 	else (if (eq ?preferencia Piscina)
 		then
 		(if (eq TRUE (send ?c get-Piscina))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Tiene piscina")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No tiene piscina")
			)
 	else (if (eq ?preferencia Amueblado)
 		then
 		(if (eq TRUE (send ?c get-Amueblada))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Viene amueblada")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No viene amueblada")
			)
 	else (if (eq ?preferencia Vistas)
 		then
 		(if (eq TRUE (send ?c get-vistas))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Posee vistas")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No posee vistas")
			)
 	else (if (eq ?preferencia Aire_acondicionado)
 		then
 		(if (eq TRUE (send ?c get-Aire))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Tiene aire acondicionado")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No tiene aire acondicionado")
			)
 	else (if (eq ?preferencia Electrodomesticos)
 		then
 		(if (eq TRUE (send ?c get-Electrodomesticos))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Viene con electrodomesticos")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No viene con electrodomesticos")
			)
 	else (if (eq ?preferencia Calefaccion)
 		then
 		(if (eq TRUE (send ?c get-Calefaccion))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Posee calefaccion")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No posee calefaccion")
			)
 	else (if (eq ?preferencia Balcon)
 		then
 		(if (eq TRUE (send ?c get-Balcon))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Posee balcon")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No posee balcon")
			)
 	else (if (eq ?preferencia Garaje)
 		then
 		(if (eq TRUE (send ?c get-Garaje))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Posee garaje")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No posee garaje")
			)
 	else (if (eq ?preferencia Mascotas)
 		then
 		(if (eq TRUE (send ?c get-Mascotas))
 		then
 			(bind ?pextra (+ ?pextra 5))
 			(bind $?justificacions $?justificacions "+ Se pueden tener mascotas")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No se pueden tener mascotas")
			)
  else (if (eq ?preferencia Seguridad)
    then
    (if (eq TRUE (send ?c get-Seguridad))
    then
      (bind ?pextra (+ ?pextra 5))
      (bind $?justificacions $?justificacions "+ Con seguridad")
			else
				(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- Sin seguridad")
			)
  else (if (eq ?preferencia Reformada)
    then
     (if (eq TRUE (send ?c get-Reformada))
    then
     	(bind ?pextra (+ ?pextra 5))
     	(bind $?justificacions $?justificacions "+ Reformada recientemente")
			else
  			(bind ?fallos (+ ?fallos 1))
				(bind $?justificacions $?justificacions "- No reformada recientemente")
  		)
  else (if (eq ?preferencia Ascensor)
		then
       		(if (eq TRUE (send ?c get-Ascensor))
       		then
       			(bind ?pextra (+ ?pextra 5))
       			(bind $?justificacions $?justificacions "+ Con ascensor")
						else
							(bind ?fallos (+ ?fallos 1))
							(bind $?justificacions $?justificacions "- Sin ascensor")
						)
          else (if (eq ?preferencia TV)
         		then
         		(if (eq TRUE (send ?c get-TV))
         		then
         			(bind ?pextra (+ ?pextra 5))
         			(bind $?justificacions $?justificacions "+ Con TV")
							else
								(bind ?fallos (+ ?fallos 1))
								(bind $?justificacions $?justificacions "- Sin TV")
							)
            else (if (eq ?preferencia WIFI)
           		then
           		(if (eq TRUE (send ?c get-WIFI))
           		then
           			(bind ?pextra (+ ?pextra 5))
           			(bind $?justificacions $?justificacions "+ Con WIFI")
								else
									(bind ?fallos (+ ?fallos 1))
									(bind $?justificacions $?justificacions "- Sin WIFI")
								)
              else (if (eq ?preferencia Accesible)
             		then
             		(if (eq TRUE (send ?c get-Accesible))
             		then
             			(bind ?pextra (+ ?pextra 5))
             			(bind $?justificacions $?justificacions "+ Con accesibilidad")
									else
										(bind ?fallos (+ ?fallos 1))
										(bind $?justificacions $?justificacions "- Sin accesibilidad")
									)
                else (if (eq ?preferencia Fumadores)
               		then
               		(if (eq TRUE (send ?c get-Fumadores))
               		then
               			(bind ?pextra (+ ?pextra 5))
               			(bind $?justificacions $?justificacions "+ Se puede fumar")
										else
											(bind ?fallos (+ ?fallos 1))
											(bind $?justificacions $?justificacions "- No se puede fumar")
										)
                  else (if (eq ?preferencia Portero)
                 		then
                 		(if (eq TRUE (send ?c get-Portero))
                 		then
                 			(bind ?pextra (+ ?pextra 5))
                 			(bind $?justificacions $?justificacions "+ Con portero")
											else
												(bind ?fallos (+ ?fallos 1))
												(bind $?justificacions $?justificacions "- Sin portero")
											)
 	))))))))))))))))))))
 	(send ?viv put-puntuacion ?pextra)
 	(send ?viv put-justificaciones $?justificacions)
	(send ?viv put-fallos ?fallos)
 	(retract ?f)
 )

;;;Regla que valora los banyos de una vivienda respecto alq ue el usuario ha pedido
(defrule procesado::puntua_lavabos "puntua si la vivienda tiene suficientes banyos"
	?viv <- (object (is-a Recomendacion) (contenido ?c) (puntuacion ?p) (justificaciones $?j) (fallos ?fe))
	(preferencias_usuario (num_banyos ?num))
	?f <- (puntua_banyo ?id)
	(test (eq ?id (send ?c get-Id)))
	=>
	(bind ?puntuacion ?p)
	(bind $?justificacions $?j)
	(bind ?fallos ?fe)
	(if (<= ?num (send ?c get-Banyos))
	then
		(bind ?puntuacion (+ ?puntuacion 5))
		(bind $?justificacions $?justificacions "+ La vivienda tiene suficientes banyos")
	else
		(bind $?justificacions $?justificacions "- Le faltan banyos")
		(bind ?puntuacion (- ?puntuacion 5))
		(bind ?fallos (+ ?fallos 1))
	)
	(send ?viv put-puntuacion ?puntuacion)
	(send ?viv put-justificaciones $?justificacions)
	(send ?viv put-fallos ?fallos)
	(retract ?f)
)

;;;Regla que cambia de modulo para generar la solucion
(defrule procesado::genera_solucion "cambia de modulo"
	(declare (salience -10))
	=>
	(printout t "...Generando solucion..." crlf)
	(focus generacion_sol)
)


;;--------------------------------------------
;;modulo para generar la solucion
;;--------------------------------------------

;;;Regla que crea una lista de recomendaciones
(defrule generacion_sol::crea-lista-recomendaciones "Se crea una lista de recomendaciones para ordenarlas"
	(not (lista-rec-desordenada))
	=>
	(assert (lista-rec-desordenada))
)

;;;Funcion que obtiene la recomendacion con mas puntuacion de una lista de recomendaciones
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

;;;Regla que añade recomendaciones a una lista desordenada de recomendaciones
(defrule generacion_sol::crea-lista-desordenada "Anade una recomendacion a la lista de recomendaciones"
		(declare (salience 10))
		?rec <- (object (is-a Recomendacion))
		?hecho <- (lista-rec-desordenada (recomendaciones $?lista))
		(test (not (member$ ?rec $?lista)))
			=>
		(modify ?hecho (recomendaciones $?lista ?rec))
	)

;;;Regla que crea una lista ordenada de recomendaciones en funcion de la puntuacion de cada recomendacion de mayor a menor
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

;;;Regla que separa las recomendaciones en las 3 categorias
	(defrule generacion_sol::separa-listas "separa las listas en las 3 categorias"
		(not (solucion_final))
		(lista-rec-ordenada(recomendaciones $?lista))
		=>
		(bind $?poco (create$ ))
		(bind $?norm (create$ ))
		(bind $?mucho (create$ ))
		(bind ?i 1)
		(while (<= ?i (length$ $?lista )) do
			(bind ?rec (nth$ ?i $?lista ))

			(if (and (<= 120 (send ?rec get-puntuacion) ) (>=  3 (send ?rec get-fallos))) then
				(bind $?mucho (insert$ $?mucho (+ (length$ $?mucho) 1) ?rec))

				else
					(if (eq 0 (send ?rec get-fallos))then
						(bind $?norm (insert$ $?norm (+ (length$ $?norm) 1) ?rec))
						else
							(if (>=  3 (send ?rec get-fallos) ) then
								(bind $?poco (insert$ $?poco (+ (length$ $?poco) 1) ?rec))
								else
									(printout t "Vivienda eliminada por tener demasiados fallos" crlf)
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

;;;Regla para pasar a mostrar resultados al usuario
	(defrule generacion_sol::muestra_resultado
		(declare (salience -10))
			=>
		(focus mostrar_resultados)
		)


;;--------------------------------------------
;;modulo final
;;--------------------------------------------

;;;Regla que muestra los resultados por pantalla al usuario, llaman al defmessage imprimir de recomendacion
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
