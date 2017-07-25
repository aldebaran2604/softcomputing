<%@page import="jess.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="engine" class="jess.Rete" scope="request"/>
<%
    engine.addOutputRouter("page", out);
    String ProductsID = request.getParameter("ProductsID");
    String ProductsName = request.getParameter("ProductsName");
    String ProductsCategory = request.getParameter("ProductsCategory");
    String ProductsPrice = request.getParameter("ProductsPrice");
    
    engine.executeCommand("(deftemplate product (slot part-number) (slot name) (slot category) (slot price))");
    engine.executeCommand("(deffacts products (product (name \""+ProductsName+"\") (category "+ProductsCategory+") (part-number "+ProductsID+") (price "+ProductsPrice+")))");
    engine.executeCommand("(facts)");
    engine.executeCommand("(run)");
%>