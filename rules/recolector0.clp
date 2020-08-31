;(assert (lata 2 2))
;(assert (lugar 1 1))

;; ============
;; Agente Robot
;; ============

; ======================================================
; Reglas para cuando tiene la lata: va hacia la papelera
; ======================================================
(defrule tiene-lata-derecha
  (lugar ?i&1|2|3 ?j&:(neq ?j 3))
  (tengo-lata)
  =>
  (assert (accion derecha))
)

(defrule tiene-lata-abajo
  (lugar ?i&:(neq ?i 3) 3)
  (tengo-lata)
  =>
  (assert (accion abajo))
)

; ========================
; Reglas cuando ve la lata
; ========================
(defrule coger-lata
  (lugar ?i ?j)
  ?h2 <- (lata ?i ?j)
  (not (lugar 3 3))
  ?h <- (veo-lata)
  =>
  (assert (accion coger-lata))
)

; ==============
; Soltar la lata
; ==============
(defrule soltar
  (lugar 3 3)
  ?h <- (tengo-lata)
  =>
  (retract ?h)
  (assert (lata 3 3))
)

; ==================================
; Reglas cuando no la tiene ni la ve
; ==================================
(defrule explorar-derecha
  (or (lugar 1 1)
  (lugar 1 2))
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion derecha))
)

(defrule explorar-abajo
  (or (lugar 1 3)
  (lugar 2 2))
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion abajo))
)

(defrule explorar-izquierda
  (or (lugar 2 3)
  (lugar 3 2))
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion izquierda))
)

(defrule explorar-arriba
  (or (lugar 3 1)
  (lugar 2 1))
  (not (veo-lata))
  (not (tengo-lata))
  =>
  (assert (accion arriba))
)

;; ==============
;; Agente Entorno
;; ==============

; =================================
; Producir la percepción de la lata
; =================================
(defrule veo-la-lata
  (declare (salience 10000))
  (lugar ?i ?j)
  (lata ?i ?j)
  =>
  (assert (veo-lata))
)

; ==============================================
; Simular la acción coger la lata para el agente
; ==============================================
(defrule simular-coger-lata
  ?h <- (veo-lata)
  ?h2 <- (accion coger-lata)
  ?h3 <- (lata ?i ?j)
  =>
  (retract ?h ?h2 ?h3)
  (assert (tengo-lata))
)

; =====================
; Simular el movimiento
; =====================
(defrule movimiento-derecho
  ?h <- (lugar ?i ?j)
  ?h2 <- (accion derecha)
  =>
  (retract ?h ?h2)
  (assert (lugar ?i (+ ?j 1)))
)

(defrule movimiento-izquierdo
  ?h <- (lugar ?i ?j)
  ?h2 <- (accion izquierda)
  =>
  (retract ?h ?h2)
  (assert (lugar ?i (- ?j 1)))
)

(defrule movimiento-arriba
  ?h <- (lugar ?i ?j)
  ?h2 <- (accion arriba)
  =>
  (retract ?h ?h2)
  (assert (lugar (- ?i 1) ?j))
)

(defrule movimiento-abajo
  ?h <- (lugar ?i ?j)
  ?h2 <- (accion abajo)
  =>
  (assert (lugar (+ ?i 1) ?j))
  (retract ?h ?h2)
)

(defrule soltar-lata
  ?h <- (lugar ?i ?j)
  ?h2 <- (tengo-lata)
  ?h3 <- (accion soltar)
  =>
  (assert (lata ?i ?j))
  (retract ?h2 ?h3)
)

; ==============
; Imprimir EXITO
; ==============
(defrule exito
  (lata 3 3)
  =>
  (printout t "exito" crlf)
)