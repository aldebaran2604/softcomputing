<html>
   <%@ page import="jess.*" %>
 <jsp:useBean id="engine" class="jess.Rete" scope="request"/>
 <head>
   <title>Hello World!</title>
 </head>
 <body>
   <H1><%
    engine.addOutputRouter("page", out);
    engine.executeCommand("(printout page " + "\"Si funciona!\" crlf)");   
   %></H1>

    <% 
     String sintom1 = request.getParameter("falla1"); 
     String sintom2 = request.getParameter("falla2"); 
     String sintom3 = request.getParameter("falla3");
    %>
    
   <p><%
   
    engine.executeCommand("(reset)");    

    engine.executeCommand("(defrule r1 (falla a) (falla b) (falla c) => (printout page \"...falla fatal\" crlf) )");
    

    engine.executeCommand("(assert (falla " +  sintom1 + "))");
    engine.executeCommand("(assert (falla " +  sintom2 + "))");
    engine.executeCommand("(assert (falla " +  sintom3 + "))");
    
    engine.executeCommand("(run)");


    %></p>
 </body>

</html>
