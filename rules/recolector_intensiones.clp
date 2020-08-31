; ==============
; Soltar la lata
; ==============
(defrule soltar
  (ubicacion (objeto robot) (x 3) (y 3))
  ?h <- (tengo-lata)
  ?h1 <- (deposito-vacio)
  =>
  (retract ?h ?h1)
  (assert (ubicacion (objeto lata) (x 3) (y 3)))
)

;; ==============
;; Agente Entorno
;; ==============

; =================================
; Producir la percepción de la lata
; =================================
(defrule veo-la-lata
  (declare (salience 10000))
  (ubicacion (objeto robot) (x ?i) (y ?j))
  (ubicacion (objeto lata) (x ?i) (y ?j))
  =>
  (assert (veo-lata))
)

; ==============================================
; Simular la acción coger la lata para el agente
; ==============================================
(defrule simular-coger-lata
  ?h <- (veo-lata)
  ?h2 <- (accion (tipo coger-lata))
  ?h3 <- (ubicacion (objeto lata) (x ?i) (y ?j))
  =>
  (retract ?h ?h2 ?h3)
  (assert (tengo-lata))
)

; =====================
; Simular el movimiento
; =====================
(defrule movimiento-derecho
  ?h <- (ubicacion (objeto robot) (x ?i) (y ?j))
  ?h2 <- (accion (tipo derecha))
  =>
  (retract ?h2)
  (modify ?h (y (+ ?j 1)))
)

(defrule movimiento-izquierdo
  ?h <- (ubicacion (objeto robot) (x ?i) (y ?j))
  ?h2 <- (accion (tipo izquierda))
  =>
  (retract ?h2)
  (modify ?h (y (- ?j 1)))
)

(defrule movimiento-arriba
  ?h <- (ubicacion (objeto robot) (x ?i) (y ?j))
  ?h2 <- (accion (tipo arriba))
  =>
  (retract ?h2)
  (modify ?h (x (- ?i 1)))
)

(defrule movimiento-abajo
  ?h <- (ubicacion (objeto robot) (x ?i) (y ?j))
  ?h2 <- (accion (tipo abajo))
  =>
  (retract ?h2)
  (modify ?h (x (+ ?i 1)))
)

; ==================================
; Reglas cuando no la tiene ni la ve
; ==================================
(defrule explorar-derecha
  (or 
    (ubicacion (objeto robot) (x 1) (y 1))
    (ubicacion (objeto robot) (x 1) (y 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo derecha)))
)

(defrule explorar-abajo
  (or 
    (ubicacion (objeto robot) (x 1) (y 3))
    (ubicacion (objeto robot) (x 2) (y 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo abajo)))
)

(defrule explorar-izquierda
  (or 
    (ubicacion (objeto robot) (x 2) (y 3))
    (ubicacion (objeto robot) (x 3) (y 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo izquierda)))
)

(defrule explorar-arriba
  (or 
    (ubicacion (objeto robot) (x 3) (y 1))
    (ubicacion (objeto robot) (x 2) (y 1))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo arriba)))
)