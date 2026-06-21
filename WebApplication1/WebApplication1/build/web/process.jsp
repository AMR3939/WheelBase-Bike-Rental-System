<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
    String pickupDateTime = request.getParameter("pickupDateTime");
    String dropoffDateTime = request.getParameter("dropoffDateTime");

    if (pickupDateTime != null) {
        LocalDateTime pickupTime = LocalDateTime.parse(pickupDateTime);
        // Retrieve available vehicles for the selected pickup date and time
        List<String> availableVehicles = getAvailableVehicles(pickupTime);
%>
        <h2>Available Vehicles for Pickup</h2>
        <ul>
            <% for (String vehicle : availableVehicles) { %>
                <li><%= vehicle %></li>
            <% } %>
        </ul>
<%
    } else if (dropoffDateTime != null) {
        LocalDateTime dropoffTime = LocalDateTime.parse(dropoffDateTime);
        // Retrieve available vehicles for the selected dropoff date and time
        List<String> availableVehicles = getAvailableVehicles(dropoffTime);
%>
        <h2>Available Vehicles for Dropoff</h2>
        <ul>
            <% for (String vehicle : availableVehicles) { %>
                <li><%= vehicle %></li>
            <% } %>
        </ul>
<%
    }
%>
<%!
    // Helper method to retrieve available vehicles from the database
    private List<String> getAvailableVehicles(LocalDateTime dateTime) {
        List<String> vehicles = new ArrayList<>();

        // Replace with your actual database connection details
        String url = "jdbc:mysql://localhost:3306/bike";
        String username = "root";
        String password = "admin";

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Establish a connection to the database
            Connection conn = DriverManager.getConnection(url, username, password);

            // Prepare the SQL query to retrieve available vehicles
            String query = "SELECT model FROM bikes WHERE availability_start <= ? AND availability_end >= ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, dateTime.toString());
            stmt.setString(2, dateTime.toString());

            // Execute the query and retrieve the results
            ResultSet rs = stmt.executeQuery();

            // Process the result set and add available vehicles to the list
            while (rs.next()) {
                String vehicle = rs.getString("model");
                vehicles.add(vehicle);
            }

            // Close the result set, statement, and connection
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return vehicles;
    }
%>