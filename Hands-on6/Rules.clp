(defglobal ?*number* = 0)
(defglobal ?*total* = 0)

;; Regla 1: Si un cliente compra -en su orden- más de 10 artículos, entonces realizar un descuento
;; del 10% al total de la compra.
(
   defrule descuento10 
   (customer (customer-id ?id) (name ?n) {customer-id == 102})
   (order (customer-id ?id) (order-number ?on))
   (line-item (order-number ?on) (quantity ?q) (part-number ?pn))
   (product (part-number ?pn) (price ?p))
   =>
   (bind ?*number* (+ ?*number* ?q))
   (bind ?*total* (+ ?*total* (* ?p ?q)))
   (
   	if (>= ?*number* 10) then
   		(printout t "Descuento aplicado 10% total: " (- ?*total* (* ?*total* 0.10)) " de: " ?*total* crlf)
   )
)

(
   defrule descuento10Nuevo 
   (customer (customer-id ?id) (name ?n) {customer-id == 102})
   (order (customer-id ?id) (order-number ?on))
   (line-item (order-number ?on) (quantity ?q) (part-number ?pn))
   (product (part-number ?pn) (price ?p))
   =>
   (
   	if (>= ?q 10) then
   		(printout t "Descuento aplicado Nuevo 10% total: " (- (* ?p ?q) (* (* ?p ?q) 0.10)) " de: " (* ?p ?q) crlf)
   )
)

;; Para colocar el total de la compra por la orden y el cliente
;; Si algun articulo supera los 10 de cantidad se le realiza un descuento
(defglobal ?*contador* = 0)
(defglobal ?*total* = 0)
(
   defrule descuento10Nuevo2
   (customer (customer-id ?id) (name ?n) {customer-id == 102})
   (order (customer-id ?id) (order-number ?on) {order-number == 100})
   (line-item (order-number ?on) (quantity ?q) (part-number ?pn))
   (product (part-number ?pn) (price ?p))
   =>
   (bind ?*contador* (+ ?*contador* 1))
   (
   	if (>= ?q 10) then
         (bind ?*total* (+ ?*total* (- (* ?p ?q) (* (* ?p ?q) 0.10))))
   	else
         (bind ?*total* (+ ?*total* (* ?p ?q)))
   )
   (
   	if (== ?*contador* 3) then
   		(printout t "Total de la compra: " ?*total* crlf)
   )
)

;; Regla 2: Si un cliente no compra -(no tiene órdenes asociadas)-, entonces llamarle y enviarle un
;; SMS ofreciéndole un 20% de descuento en su próxima compra.
(
	defrule envioDescuento
	(customer (customer-id ?id) (name ?n))
	(not (order (customer-id ?id)))
	=>
	(and
		(assert (llamar-a ?n "36992933"))
		(assert (enviar-sms-a ?n "36992933" "tienes 20% desc, prox compra"))
	)
)

(
	defrule llamadaSMS 
	(llamar-a $?la)
	(enviar-sms-a $?esa)
	=>
	(printout t "Call to: " ?esa crlf)
)

;; Realizar descuento del 20% en la cantidad total de la compra si el comprador
;; es su primera compra
(defrule cust-not-buying
   (and 
     (customer (customer-id ?id) (name ?name) {customer-id == 100})
     (not (order (order-number ?order) (customer-id ?id)))
   )
   =>
   (printout t "20" crlf)
)



;; Regla 3: Si la existencia, en stock, del producto con la clave 101 es menor a 5, entonces solicitar
;; 2 cajas del producto con clave 101 a su proveedor respectivo.
;;(
;;	defrule regla3
;;	(stock (product (clave 101) {existencia < 5} (proveedor ?p)))
;;	=>
;;	(assert (solicitar (cajas 2) (proveedor ?p)))
;;)


;; Regla 4: Si la existencia, en stock, del producto con la clave 2205 es mayor a 100, entonces
;; ofértalo al 25% de descuento.

;;(
;;	defrule regla4 
;;	?producto <- (producto (clave 2205) {existencia > 100} (precio ?p))
;;	=>
;;	(and (retract ?producto) ;;borrar con la función retract el producto con el precio sin descuento
;;	(bind ?p (- ?p (* ?p .25))) ;; realiza el 25% de descuento sobre el precio ?p
;;	(assert (producto (clave 2205) {existencia > 100} (precio ?p))))
;;)