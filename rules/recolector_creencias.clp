;(assert (ubicacion (objeto robot) (x 1) (y 1)))
;(assert (ubicacion (objeto lata) (x 2) (y 2)))

(deftemplate ubicacion
  (slot objeto
    (allowed-values robot lata)
  )
  (slot x (default 1))
  (slot y (default 1))
)

(deftemplate accion
  (slot tipo
    (allowed-values derecha izquierda abajo arriba coger-lata soltar detener)
  )
)

(deffacts inicio
  (deposito-vacio)
  (ubicacion (objeto robot) (x 1) (y 1))
  (ubicacion (objeto lata) (x 2) (y 2))
)

; (load "recolector_creencias.clp")
; (load "recolector_deseos.clp")
; (load "recolector_intensiones.clp")