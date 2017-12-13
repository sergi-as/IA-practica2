
;;; Se crea una clase para las recomendaciones para poder hacer listas de recomendaciones y tratarlas mejor
  (defclass Recomendacion
			(is-a USER)
			(role concrete)
			(slot contenido
				(type INSTANCE)
				(create-accessor read-write))
			(slot puntuacion
				(type INTEGER)
				(default 100)
				(create-accessor read-write))
			(multislot justificaciones
				(type STRING)
				(create-accessor read-write))
		)

    (defclass Poco_Recomendables
        (is-a Recomendacion)
        (role concrete)
    )

    (defclass Recomendables
        (is-a Recomendacion)
        (role concrete)
    )

    (defclass Altamente_Recomendables
        (is-a Recomendacion)
        (role concrete)
    )
