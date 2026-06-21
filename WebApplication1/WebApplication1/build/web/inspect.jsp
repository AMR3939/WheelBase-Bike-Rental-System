<%@ page import="java.sql.*, java.util.*" %>
<%
    String bikeId = request.getParameter("bike_id");

    if (bikeId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

            String bikeDetailsQuery = "SELECT * FROM bikes WHERE bike_id = ?";
            PreparedStatement pst = con.prepareStatement(bikeDetailsQuery);
            pst.setString(1, bikeId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String brand = rs.getString("brand");
                String model = rs.getString("model");
                String registrationNo = rs.getString("registration_no");
                String color = rs.getString("color");
                String dailyRate = rs.getString("daily_rate");
                String isAvailable = rs.getString("is_available");

                String bikeDetails = "<h3>Bike Details:</h3>"
                                   + "<p>Brand: " + brand + "</p>"
                                   + "<p>Model: " + model + "</p>"
                                   + "<p>Registration Number: " + registrationNo + "</p>"
                                   + "<p>Color: " + color + "</p>"
                                   + "<p>Daily Rate: " + dailyRate + "</p>"
                                   + "<p>Availability: " + isAvailable + "</p>";

                request.setAttribute("bikeDetails", bikeDetails);
            } else {
                request.setAttribute("bikeDetails", "<p>Bike not found</p>");
            }

            con.close();
        } catch (Exception e) {
            request.setAttribute("bikeDetails", "<p>Error: " + e.getMessage() + "</p>");
        }
    }

    request.getRequestDispatcher("Maintennce_Staff.jsp").forward(request, response);
%>
