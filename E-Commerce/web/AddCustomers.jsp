<%@page import="jess.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="engine" class="jess.Rete" scope="request"/>
<%
    engine.addOutputRouter("page", out);
    String CustomersID = request.getParameter("CustomersID");
    String CustomersName = request.getParameter("CustomersName");
    String CustomersAddress = request.getParameter("CustomersAddress");
    engine.executeCommand("(deftemplate customer (slot customer-id) (multislot name) (multislot address))");
    engine.executeCommand("(deffacts customers (customer (customer-id "+CustomersID+") (name \""+CustomersName+"\") (address \""+CustomersAddress+"\")))");
    engine.executeCommand("(facts)");
    engine.executeCommand("(run)");
%>