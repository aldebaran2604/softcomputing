

(deftemplate customer
  (slot customer-id)
  (multislot name)
  (multislot address)
)

(deftemplate product
  (slot part-number)
  (slot name)
  (slot category)
  (slot price)
)

(deftemplate order
  (slot order-number)
  (slot customer-id)
)

(deftemplate line-item
  (slot order-number)
  (slot part-number)
  (slot customer-id)
  (slot quantity (default 1)))

(deftemplate recommend
  (slot order-number)
  (multislot because)
  (slot type)
  (slot part-number)
)

