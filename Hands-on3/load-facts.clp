

(deffacts products 
 	(product (name CD-Writer) (category storage) (part-number 1234) (price 199.99))
 	(product (name Amplifier) (category electronics) (part-number 2341) (price 399.99))
 	(product (name "Rubber duck") (category mechanics) (part-number 3412) (price 99.99))
)

(deffacts customers
  (customer (customer-id 101) (name joe) (address bla bla bla))
  (customer (customer-id 102) (name mary) (address bla bla bla))
  (customer (customer-id 103) (name bob) (address bla bla bla))
)  	 


(deffacts orders 
	(order (order-number 300) (customer-id 101))
	(order (order-number 301) (customer-id 102))
)

(deffacts items-list
	(line-item (order-number 300) (customer-id 101) (part-number 1234))
	(line-item (order-number 301) (customer-id 102) (part-number 2341) (quantity 10))
 
)

(reset)


