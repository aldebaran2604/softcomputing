<%@page import="java.util.HashMap"%>
<%@page import="jess.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="engine" class="jess.Rete" scope="request"/>
<%
    engine.addOutputRouter("page", out);
    HashMap hm = new HashMap();
    
    if (
        request.getParameter("Products")!=null
        && request.getParameter("Customers")!=null
        && request.getParameter("ListOrders")!=null
        && request.getParameter("OrdersData")!=null
        && request.getParameter("CustomerID")!=null
        && request.getParameter("OrderID")!=null
        && request.getParameter("Index")!=null
    ) {
        engine.executeCommand("(deftemplate customer (slot customer-id) (multislot name) (multislot address))");
        engine.executeCommand("(deftemplate product (slot part-number) (slot name) (slot category) (slot price))");
        engine.executeCommand("(deftemplate order (slot order-number) (slot customer-id))");
        engine.executeCommand("(deftemplate line-item (slot order-number) (slot part-number) (slot quantity (default 1)))");
        engine.executeCommand("(deftemplate recommend (slot order-number) (multislot because) (slot type) (slot part-number))");
        String[] splitProducts = request.getParameter("Products").toString().split(",");
        String productsFacts = "(deffacts products ";
        for (int p=0; p<splitProducts.length; p++) {
            String[] productData = splitProducts[p].toString().split("\\*");
            productsFacts+=" (product (name "+productData[1]+") (category "+productData[2]+") (part-number "+productData[0]+") (price "+productData[3]+")) ";
        }
        if (splitProducts.length==0) {
            productsFacts+=" (product (name CD-Writer) (category storage) (part-number 1234) (price 199.99)) ";
        }
        productsFacts+=" )";
        String[] splitCustomers = request.getParameter("Customers").toString().split(",");
        String customersFacts = "(deffacts customers ";
        for (int c=0; c<splitCustomers.length; c++) {
            String[] customerData = splitCustomers[c].toString().split("\\*");
            customersFacts+=" (customer (customer-id "+customerData[0]+") (name "+customerData[1]+") (address "+customerData[2]+")) ";
        }
        if (splitCustomers.length==0) {
            customersFacts+=" (customer (customer-id 101) (name joe) (address bla bla bla)) ";
        }
        customersFacts+=" )";
        String[] splitListOrders = request.getParameter("ListOrders").toString().split(",");
        String listaOrdersFacts = "(deffacts orders ";
        for (int l=0; l<splitListOrders.length; l++) {
            String[] listOrder = splitListOrders[l].toString().split("\\*");
            hm.put(listOrder[0], 0);
            listaOrdersFacts+=" (order (order-number "+listOrder[0]+") (customer-id "+listOrder[1]+")) ";
        }
        if (splitListOrders.length==0) {
            listaOrdersFacts+=" (order (order-number 300) (customer-id 101)) ";
        }
        listaOrdersFacts+=" )";
        String[] splitOrdersData = request.getParameter("OrdersData").toString().split("-");
        String ordersDataFacts = "(deffacts items-list ";
        for (int o=0; o<splitOrdersData.length; o++) {
            String[] ordersData = splitOrdersData[o].toString().split(",");
            for (int od=0; od<ordersData.length; od++) {
                String[] order = ordersData[od].toString().split("\\*");
                ordersDataFacts+=" (line-item (order-number "+order[0]+") (part-number "+order[1]+") (quantity "+order[2]+")) ";
                if (hm.get(order[0])!=null) {
                    int auxCount = (int)hm.get(order[0]);
                    auxCount++;
                    hm.remove(order[0]);
                    hm.put(order[0], auxCount);
                }
            }
        }
        if (splitOrdersData.length==0) {
            ordersDataFacts+=" (line-item (order-number 300) (part-number 1234)) ";
        }
        ordersDataFacts+=" )";
        engine.executeCommand(productsFacts);
        engine.executeCommand(customersFacts);
        engine.executeCommand(listaOrdersFacts);
        engine.executeCommand(ordersDataFacts);
        engine.executeCommand("(reset)");
        if (request.getParameter("index").equals("1")) {
            engine.executeCommand("(defglobal ?*contador* = 0)");
            engine.executeCommand("(defglobal ?*total* = 0)");
            engine.executeCommand("( "+
                "defrule descuento10Nuevo2 "+
                "(customer (customer-id ?id) (name ?n) {customer-id == "+request.getParameter("CustomerID")+"}) "+
                "(order (customer-id ?id) (order-number ?on) {order-number == "+request.getParameter("OrderID")+"}) "+
                "(line-item (order-number ?on) (quantity ?q) (part-number ?pn)) "+
                "(product (part-number ?pn) (price ?p)) "+
                "=> "+
                "(bind ?*contador* (+ ?*contador* 1)) "+
                "( "+
                 "if (>= ?q 10) then "+
                      "(bind ?*total* (+ ?*total* (- (* ?p ?q) (* (* ?p ?q) 0.10)))) "+
                 "else "+
                      "(bind ?*total* (+ ?*total* (* ?p ?q))) "+
                ") "+
                "( "+
                 "if (= ?*contador* "+hm.get(request.getParameter("OrderID")) +") then "+
                     "(printout page \"Total de la compra: \" ?*total* crlf) "+
                ")"+
             ") ");
        }
        if (request.getParameter("index").equals("2")) {
            engine.executeCommand("(defrule cust-not-buying "+
                "(and "+
                  "(customer (customer-id ?id) (name ?name) {customer-id == "+request.getParameter("CustomerID")+"}) "+
                  "(not (order (order-number ?order) (customer-id ?id))) "+
                ") "+
                "=> "+
                "(printout page \"Descuento:20\" crlf) "+
             ") ");
        }
        engine.executeCommand("(facts)");
        engine.executeCommand("(run)");
    } else {
        out.print("Texto XD");
    }
%>
