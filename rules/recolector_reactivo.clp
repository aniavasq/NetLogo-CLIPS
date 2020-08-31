(deftemplate ubicacion
  (slot objeto
    (allowed-values robot lata)
  )
  (slot i (default 1))
  (slot j (default 1))
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
  (ubicacion (objeto robot) (i ?i&1|2|3) (j ?j&:(neq ?j 3)))
  (tengo-lata)
  =>
  (assert (accion (tipo derecha)))
)

(defrule tiene-lata-abajo
  (ubicacion (objeto robot) (i ?i&:(neq ?i 3)) (j 3))
  (tengo-lata)
  =>
  (assert (accion (tipo abajo)))
)

; ========================
; Reglas cuando ve la lata
; ========================
(defrule coger-lata
  (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (ubicacion (objeto lata) (i ?i) (j ?j))
  (not (ubicacion (objeto robot) (i 3) (j 3)))
  ?h <- (veo-lata)
  =>
  (assert (accion (tipo coger-lata)))
)

; ==============
; Soltar la lata
; ==============
(defrule soltar
  (ubicacion (objeto robot) (i 3) (j 3))
  ?h <- (tengo-lata)
  =>
  (retract ?h)
  (assert (ubicacion (objeto lata) (i 3) (j 3)))
)

; ==================================
; Reglas cuando no la tiene ni la ve
; ==================================
(defrule explorar-derecha
  (or 
    (ubicacion (objeto robot) (i 1) (j 1))
    (ubicacion (objeto robot) (i 1) (j 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo derecha)))
)

(defrule explorar-abajo
  (or 
    (ubicacion (objeto robot) (i 1) (j 3))
    (ubicacion (objeto robot) (i 2) (j 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo abajo)))
)

(defrule explorar-izquierda
  (or 
    (ubicacion (objeto robot) (i 2) (j 3))
    (ubicacion (objeto robot) (i 3) (j 2))
  )
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion (tipo izquierda)))
)

(defrule explorar-arriba
  (or 
    (ubicacion (objeto robot) (i 3) (j 1))
    (ubicacion (objeto robot) (i 2) (j 1))
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
  (ubicacion (objeto robot) (i ?i) (j ?j))
  (ubicacion (objeto lata) (i ?i) (j ?j))
  =>
  (assert (veo-lata))
)

; ==============================================
; Simular la acción coger la lata para el agente
; ==============================================
(defrule simular-coger-lata
  ?h <- (veo-lata)
  ?h2 <- (accion (tipo coger-lata))
  ?h3 <- (ubicacion (objeto lata) (i ?i) (j ?j))
  =>
  (retract ?h ?h2 ?h3)
  (assert (tengo-lata))
)

; =====================
; Simular el movimiento
; =====================
(defrule movimiento-derecho
  ?h <- (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (accion (tipo derecha))
  =>
  (retract ?h2)
  (modify ?h (j (+ ?j 1)))
)

(defrule movimiento-izquierdo
  ?h <- (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (accion (tipo izquierda))
  =>
  (retract ?h2)
  (modify ?h (j (- ?j 1)))
)

(defrule movimiento-arriba
  ?h <- (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (accion (tipo arriba))
  =>
  (retract ?h2)
  (modify ?h (i (- ?i 1)))
)

(defrule movimiento-abajo
  ?h <- (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (accion (tipo abajo))
  =>
  (retract ?h2)
  (modify ?h (i (+ ?i 1)))
)

(defrule soltar-lata
  ?h <- (ubicacion (objeto robot) (i ?i) (j ?j))
  ?h2 <- (tengo-lata)
  ?h3 <- (accion (tipo soltar))
  =>
  (retract ?h2 ?h3)
  (assert (ubicacion (objeto lata) (i ?i) (j ?j)))
)

; ==============
; Imprimir EXITO
; ==============
(defrule exito
  (ubicacion (objeto lata) (i 3) (j 3))
  =>
  (assert (accion (tipo detener)))
)
