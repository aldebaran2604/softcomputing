<%-- 
    Document   : index
    Created on : 25-jul-2017, 0:31:14
    Author     : aldebaran
--%>

<%@page import="jess.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="engine" class="jess.Rete" scope="request"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%
            engine.addOutputRouter("page", out);
            engine.executeCommand("(reset)");
            engine.executeCommand("(deftemplate customer (slot customer-id) (multislot name) (multislot address))");
            engine.executeCommand("(deftemplate product (slot part-number) (slot name) (slot category) (slot price))");
            engine.executeCommand("(deftemplate order (slot order-number) (slot customer-id))");
            engine.executeCommand("(deftemplate line-item (slot order-number) (slot part-number) (slot customer-id) (slot quantity (default 1)))");
            engine.executeCommand("(deftemplate recommend (slot order-number) (multislot because) (slot type) (slot part-number))");
            engine.executeCommand("(facts)");
            engine.executeCommand("(run)");
        %>
    </body>
</html>
