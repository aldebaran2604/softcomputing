<%@page import="jess.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="engine" class="jess.Rete" scope="request"/>
<%
    engine.addOutputRouter("page", out);
    if (
        request.getParameter("Products")!=null
        && request.getParameter("Customers")!=null
        && request.getParameter("ListOrders")!=null
        && request.getParameter("OrdersData")!=null
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
    engine.executeCommand("(defrule prods-bought "+
   "(order (order-number ?order)) "+
   "(line-item (order-number ?order) (part-number ?part)) "+
   "(product (part-number ?part) (name ?pn)) "+
   "=> "+
   "(printout page ?pn \" was bought <br>\" crlf))");
    engine.executeCommand("(facts)");
    engine.executeCommand("(run)");
    }
%>
