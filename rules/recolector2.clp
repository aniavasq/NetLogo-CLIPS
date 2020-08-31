;(assert (ubicacion (objeto lugar) (pi 1) (pj 1)))
;(assert (ubicacion (objeto lata) (pi 2) (pj 2)))

(deftemplate ubicacion
  (slot objeto
    (allowed-values lugar lata)
  )
  (slot pi (default 1))
  (slot pj (default 1))
)

(deftemplate accion
  (slot tipo
    (allowed-values derecha izquierda abajo arriba coger-lata soltar detener)
  )
)


;; ============
;; Agente Robot
;; ============

; ======================================================
; Reglas para cuando tiene la lata: va hacia la papelera
; ======================================================
(defrule tiene-lata-derecha
  (ubicacion (objeto lugar) (pi ?i&1|2|3) (pj ?j&:(neq ?j 3)))
  (tengo-lata)
  =>
  (assert (accion (tipo derecha)))
)

(defrule tiene-lata-abajo
  (ubicacion (objeto lugar) (pi ?i&:(neq ?i 3)) (pj 3))
  (tengo-lata)
  =>
  (assert (accion (tipo abajo)))
)

; ========================
; Reglas cuando ve la lata
; ========================
(defrule coger-lata
  (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (ubicacion (objeto lata) (pi ?i) (pj ?j))
  (not (ubicacion (objeto lugar) (pi 3) (pj 3)))
  ?h <- (veo-lata)
  =>
  (assert (accion (tipo coger-lata)))
)

; ==============
; Soltar la lata
; ==============
(defrule soltar
  (ubicacion (objeto lugar) (pi 3) (pj 3))
  ?h <- (tengo-lata)
  =>
  (retract ?h)
  (assert (ubicacion (objeto lata) (pi 3) (pj 3)))
)

; ==================================
; Reglas cuando no la tiene ni la ve
; ==================================
(defrule explorar-derecha
  (or 
    (ubicacion (objeto lugar) (pi 1) (pj 1))
    (ubicacion (objeto lugar) (pi 1) (pj 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo derecha)))
)

(defrule explorar-abajo
  (or 
    (ubicacion (objeto lugar) (pi 1) (pj 3))
    (ubicacion (objeto lugar) (pi 2) (pj 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo abajo)))
)

(defrule explorar-izquierda
  (or 
    (ubicacion (objeto lugar) (pi 2) (pj 3))
    (ubicacion (objeto lugar) (pi 3) (pj 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo izquierda)))
)

(defrule explorar-arriba
  (or 
    (ubicacion (objeto lugar) (pi 3) (pj 1))
    (ubicacion (objeto lugar) (pi 2) (pj 1))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo arriba)))
)

;; ==============
;; Agente Entorno
;; ==============

; =================================
; Producir la percepción de la lata
; =================================
(defrule veo-la-lata
  (declare (salience 10000))
  (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  (ubicacion (objeto lata) (pi ?i) (pj ?j))
  =>
  (assert (veo-lata))
)

; ==============================================
; Simular la acción coger la lata para el agente
; ==============================================
(defrule simular-coger-lata
  ?h <- (veo-lata)
  ?h2 <- (accion (tipo coger-lata))
  ?h3 <- (ubicacion (objeto lata) (pi ?i) (pj ?j))
  =>
  (retract ?h ?h2 ?h3)
  (assert (tengo-lata))
)

; =====================
; Simular el movimiento
; =====================
(defrule movimiento-derecho
  ?h <- (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (accion (tipo derecha))
  =>
  (retract ?h2)
  (modify ?h (pj (+ ?j 1)))
)

(defrule movimiento-izquierdo
  ?h <- (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (accion (tipo izquierda))
  =>
  (retract ?h2)
  (modify ?h (pj (- ?j 1)))
)

(defrule movimiento-arriba
  ?h <- (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (accion (tipo arriba))
  =>
  (retract ?h2)
  (modify ?h (pi (- ?i 1)))
)

(defrule movimiento-abajo
  ?h <- (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (accion (tipo abajo))
  =>
  (retract ?h2)
  (modify ?h (pi (+ ?i 1)))
)

(defrule soltar-lata
  ?h <- (ubicacion (objeto lugar) (pi ?i) (pj ?j))
  ?h2 <- (tengo-lata)
  ?h3 <- (accion (tipo soltar))
  =>
  (retract ?h2 ?h3)
  (assert (ubicacion (objeto lata) (pi ?i) (pj ?j)))
)

; ==============
; Imprimir EXITO
; ==============
(defrule exito
  (ubicacion (objeto lata) (pi 3) (pj 3))
  =>
  (assert (accion (tipo detener)))
)