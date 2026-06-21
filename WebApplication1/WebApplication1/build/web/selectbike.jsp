<%@page import="java.io.IOException"%>
<%
    String bikeId = request.getParameter("bikeId");
    if (bikeId != null) {
        response.sendRedirect("payment.jsp?bikeId=" + bikeId);
    } else {
        out.println("No bike selected.");
    }
%>
