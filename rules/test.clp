(deftemplate t
  (multislot x)
)

(defrule r
  =>
  (assert (t (x 1 2 3)))
)

;(fact-slot-value (nth$ 1 (find-fact ((?p t)) (TRUE))) x)
