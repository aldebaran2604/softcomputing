
;;Define a rule for finding those customers who have not bought nothing at all... so far
(defrule cust-not-buying
   (and 
     (customer (customer-id ?id) (name ?name))
     (not (order (order-number ?order) (customer-id ?id)))
   )
   =>
   (printout t ?name " no ha comprado ni... nada!" crlf))

;;Define a rule for finding which products have been bought
(defrule prods-bought
   (order (order-number ?order))
   (line-item (order-number ?order) (part-number ?part))
   (product (part-number ?part) (name ?pn))
   =>
   (printout t ?pn " was bought " crlf))


;;Define a rule for finding which products have been bought AND their quantity
(defrule prods-qty-bgt
   (order (order-number ?order))
   (line-item (order-number ?order) (part-number ?part) (quantity ?q))
   (product (part-number ?part) (name ?p) )
   =>
   (printout t ?q " " ?p " was/were bought " crlf))


;;Define a rule for finding customers and their shopping info
(defrule customer-shopping
   (customer (customer-id ?id) (name ?cn))
   (order (order-number ?order) (customer-id ?id))
   (line-item (order-number ?order) (part-number ?part))
   (product (part-number ?part) (name ?pn))
   =>
   (printout t ?cn " bought  " ?pn crlf))

;;Define a rule for finding those customers who bought more than 5 products
(defrule cust-5-prods
   (customer (customer-id ?id) (name ?cn))
   (order (order-number ?order) (customer-id ?id))
   (line-item (order-number ?order) (part-number ?part) {quantity > 5})
   (product (part-number ?part) (name ?pn))
   =>
   (printout t ?cn " bought more than 5 products (" ?pn ")" crlf))


;;(defrule recommend-rubber-duck
;;   (not (and (customer (customer-id ?id))
;;             (order (order-number ?order) (customer-id ?id))
;;             (line-item (order-number ?order) (part-number ?part))
;;             (product (part-number ?part) (name "Rubber duck"))
;;    ))
;;   =>
;;   (printout t "se recomiendo comprar parte:: RuberDuck" crlf))

(defglobal ?*number* = 0)

(
   defrule descuento10 
   (customer (customer-id ?id) (name ?n))
   (order (customer-id ?id) (order-number ?on))
   (line-item (order-number ?on) (quantity ?q) (bind ?*number* ?q))
   =>
   (printout t "Prueba descuento " ?*number* crlf)
)

(printout t "Prueba descuento Nuevo" ?*number* crlf)

;;(
;;   defrule descuento102 
;;   (cantidad {?number > 9})
;;   =>
;;   (printout t "Prueba descuento 10" ?number crlf)
;;)

;;(defrule regla1 
;;      (orden (cliente-id ?id) {cantidad > 9} (total ?t))
;;      =>
;;      (bind ?t (- ?t (* ?t .10)))
;;)
