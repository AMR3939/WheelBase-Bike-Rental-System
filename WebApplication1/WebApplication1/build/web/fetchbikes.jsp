<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bikes</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        
        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #000000, #434343);
            color: white;
            height: 100vh;
            overflow-x: hidden;
        }

        header {
            width: 100%;
            padding: 20px 0;
            background-color: #1c1c1c;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
        }

        header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #ffffff;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px 0;
            text-align: center;
        }

        .container h2 {
            margin: 20px 0;
            font-size: 28px;
            font-weight: 500;
            color: #ffffff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            overflow: hidden;
        }

        table, th, td {
            border: 1px solid #444;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #333;
            font-weight: 600;
        }

        td {
            background-color: #555;
        }

        button {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 8px 12px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }

        button:hover {
            background-color: #ff1a1a;
        }

        h3 {
            color: red;
        }

    </style>
</head>
<body>
    <header>
        <h1>Bikes</h1>
    </header>
    <div class="container">
        <h2>Discover Our Range of Bikes</h2>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

                // Fetch only available bikes
                String getBikesQuery = "SELECT * FROM bikes WHERE is_available = 'Yes';";
                PreparedStatement getBikeStmt = con.prepareStatement(getBikesQuery);
                ResultSet rs = getBikeStmt.executeQuery();

                out.println("<h3>Refresh or Press F5 to view other options</h3>");
                out.println("<form action='payment.jsp' method='post'>");
                String pickupDateTime = (String)session.getAttribute("pickupDateTime");
                String dropoffDateTime = (String)session.getAttribute("dropoffDateTime");
                out.println("<input type='hidden' name='pickupDateTime' value='" + pickupDateTime + "'/>");
                out.println("<input type='hidden' name='dropoffDateTime' value='" + dropoffDateTime + "'/>");

                out.println("<table>");
                out.println("<tr>");
                out.println("<th>Bike ID</th>");
                out.println("<th>Brand</th>");
                out.println("<th>Model</th>");
                out.println("<th>Color</th>");
                out.println("<th>Daily Rate</th>");
                out.println("<th>Action</th>");
                out.println("</tr>");

                while (rs.next()) {
                    String bikeId = rs.getString("bike_id");
                    String brand = rs.getString("brand");
                    String model = rs.getString("model");
                    String color = rs.getString("color");
                    String dailyRate = rs.getString("daily_rate");

                    out.println("<tr>");
                    out.println("<td>" + bikeId + "</td>");
                    out.println("<td>" + brand + "</td>");
                    out.println("<td>" + model + "</td>");
                    out.println("<td>" + color + "</td>");
                    out.println("<td>" + dailyRate + "</td>");
                    out.println("<td>");
                    out.println("<button type='submit' name='bikeId' value='" + bikeId + "'>Select</button>");
                    out.println("<input type='hidden' name='dailyRate' value='" + dailyRate + "'/>");
                    out.println("</td>");
                    out.println("</tr>");
                }

                out.println("</table>");
                out.println("</form>");

                con.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
