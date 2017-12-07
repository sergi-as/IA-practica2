; Thu Dec 07 17:04:45 CET 2017
;
;+ (version "3.4.8")
;+ (build "Build 629")


(defclass %3ACLIPS_TOP_LEVEL_SLOT_CLASS "Fake class to save top-level slot information"
	(is-a USER)
	(role abstract)
	(single-slot Piscina
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Sol_man
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordY
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Superficie
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Precio_mensual
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Nombre_ser
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Cercano
		(type INSTANCE)
;+		(allowed-classes Servicio)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Nombre
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Tipo
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordenadasX
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordX
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Electrodomesticos
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Balcon
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Dormi_simple
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Garaje
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Altura_piso
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Sol_tarde
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot vivienda_Class6
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Tipo_col
		(type SYMBOL)
		(allowed-values Publico Privado Concertado)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Amueblada
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Dormi_doble
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordenadasY
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Terraza
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(multislot Dormitorios
		(type SYMBOL)
		(allowed-values Simple Doble)
		(create-accessor read-write))
	(single-slot Aire
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Calefaccion
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Mascotas
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write)))

(defclass Vivienda
	(is-a USER)
	(role concrete)
	(single-slot Piscina
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Sol_tarde
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Terraza
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Amueblada
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Tipo
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Dormi_doble
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Sol_man
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Superficie
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Precio_mensual
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Aire
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordenadasX
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Cercano
		(type INSTANCE)
;+		(allowed-classes Servicio)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Electrodomesticos
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Balcon
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Calefaccion
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Dormi_simple
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Garaje
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordenadasY
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Mascotas
		(type SYMBOL)
		(allowed-values FALSE TRUE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot Altura_piso
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write)))

(defclass Persona
	(is-a USER)
	(role concrete))

(defclass Servicio
	(is-a USER)
	(role abstract)
	(single-slot Nombre_ser
		(type STRING)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordX
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot CoordY
		(type FLOAT)
;+		(cardinality 0 1)
		(create-accessor read-write)))

(defclass Transporte_publico
	(is-a Servicio)
	(role concrete))

(defclass Bus
	(is-a Transporte_publico)
	(role concrete))

(defclass Metro
	(is-a Transporte_publico)
	(role concrete))

(defclass colegio
	(is-a Servicio)
	(role concrete)
	(single-slot Tipo_col
		(type SYMBOL)
		(allowed-values Publico Privado Concertado)
;+		(cardinality 0 1)
		(create-accessor read-write)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTANCIAS
(definstances instancias
  ; Thu Dec 07 17:04:45 CET 2017
  ;
  ;+ (version "3.4.8")
  ;+ (build "Build 629")

  ([vivienda_Class10027] of  Vivienda

  	(Aire TRUE)
  	(Amueblada TRUE)
  	(Balcon TRUE)
  	(Cercano [vivienda_Class10029])
  	(CoordenadasX 5.0)
  	(CoordenadasY 10.0)
  	(Dormi_doble 1)
  	(Dormi_simple 2)
  	(Garaje TRUE)
  	(Precio_mensual 1000.0)
  	(Sol_man TRUE)
  	(Sol_tarde TRUE)
  	(Superficie 100.0)
  	(Tipo "unifamiliar"))

  ([vivienda_Class10028] of  Bus

  	(CoordX 214.0)
  	(CoordY 111.1)
  	(Nombre_ser "Carrer x y"))

  ([vivienda_Class10029] of  Metro

  	(CoordX 1341.0)
  	(CoordY 343.0)
  	(Nombre_ser "L1"))

  ([vivienda_Class10030] of  colegio

  	(CoordX 50.0)
  	(CoordY 50.0)
  	(Nombre_ser "Benviure")
  	(Tipo_col Publico))


  )
