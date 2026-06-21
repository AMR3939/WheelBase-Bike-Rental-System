<%@page import="java.sql.*" %>
<%@page import="java.io.*,java.util.*"%>

<%
    String act = request.getParameter("submit");
    if(act != null && act.equals("Login")) 
    {
        try 
        {
            String name = request.getParameter("textname");
            String psswd = request.getParameter("textpsswd");
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
            String query = "SELECT * FROM user WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, name);
            pst.setString(2, psswd);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
            String userRoleFromDB = rs.getString("user_role");
            String fullname = rs.getString("full_name");
            String value = rs.getString("user_role");
            int userId = rs.getInt("u_id");  // Get the user ID from the result set
            session.setAttribute("username", name);
            session.setAttribute("full_name", fullname);
            session.setAttribute("userId", userId);  // Store the user ID in the session

            if (value.equals("Maintenance_Staff") && userRoleFromDB.equals("Maintenance_Staff"))
                response.sendRedirect("Maintenance_Staff.jsp");
            else if (value.equals("customer") && userRoleFromDB.equals("customer"))
                response.sendRedirect("customer.jsp");
            else if (value.equals("Business") && userRoleFromDB.equals("Business"))
                response.sendRedirect("Business_Owner.jsp");
            else if (value.equals("admin") && userRoleFromDB.equals("admin"))
                response.sendRedirect("admin.jsp");
            else
                out.println("<h2>Wrong user role</h2><a href=\"login.html\"><h3>Click here!</a> to try again</h3>");
        }
            else
                out.println("<h2>Wrong username or password</h2><a href=\"login.html\"><h3>Click here!</a> to try again</h3>");
            con.close();
        } 
        catch (Exception e) 
        {
            out.println("Error: " + e.getMessage());
        }
    } 
else if (act != null && act.equals("SignUp"))
{
    try
    {
        String value = request.getParameter("user");
        String name = request.getParameter("textname");
        String psswd = request.getParameter("textpsswd");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

        // Insert into the user table
        String loginQuery = "INSERT INTO user (username, password, full_name, phone_number, address, email, user_role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement loginPst = con.prepareStatement(loginQuery, Statement.RETURN_GENERATED_KEYS);

        loginPst.setString(1, name);
        loginPst.setString(2, psswd);
        loginPst.setString(3, fullname);
        loginPst.setString(4, phone);
        loginPst.setString(5, address);
        loginPst.setString(6, email);
        loginPst.setString(7, value);

        loginPst.executeUpdate();

        // Get the generated user_id
        ResultSet rs = loginPst.getGeneratedKeys();
        int userId = -1;
        if (rs.next())
            userId = rs.getInt(1);

        if (userId != -1)
        {
            out.println("<h2>Registered successfully!</h2><a href=\"login.html\"><h3>Click here!</a><h3>");
        }
        else
        {
            out.println("<h2>Error registering user.</h2><a href=\"login.html\"><h3>Click here!</a> to try again!</h3>");
        }

        con.close();
    }
    catch (Exception e)
    {
        out.println("Error: " + e.getMessage());
    }
}
    
else if (act != null && act.equals("add_admin"))       //Add Admin from business owner page
{
    try
    {
        String value = request.getParameter("user");
        String name = request.getParameter("textname");
        String psswd = request.getParameter("textpsswd");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

        // Insert into the user table
        String loginQuery = "INSERT INTO user (username, password, full_name, phone_number, address, email, user_role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement loginPst = con.prepareStatement(loginQuery, Statement.RETURN_GENERATED_KEYS);

        loginPst.setString(1, name);
        loginPst.setString(2, psswd);
        loginPst.setString(3, fullname);
        loginPst.setString(4, phone);
        loginPst.setString(5, address);
        loginPst.setString(6, email);
        loginPst.setString(7, value);

        loginPst.executeUpdate();

        // Get the generated user_id
        ResultSet rs = loginPst.getGeneratedKeys();
        int userId = -1;
        if (rs.next())
            userId = rs.getInt(1);

        if (userId != -1)
        {
            out.println("<h2>Registered successfully!</h2><a href=\"Business_Owner.jsp\"><h3>Click here!</a><h3>");
        }
        else
        {
            out.println("<h2>Error registering user.</h2><a href=\"Business_Owner.jsp\"><h3>Click here!</a> to try again!</h3>");
        }

        con.close();
    }
    catch (Exception e)
    {
        out.println("Error: " + e.getMessage());
    }
}

    else if (act != null && act.equals("add_staff"))       //Add Staff from business owner page
    {
        try
        {
            String value = request.getParameter("user");
            String name = request.getParameter("textname");
            String psswd = request.getParameter("textpsswd");
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String email = request.getParameter("email");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

            // Insert into the user table
            String loginQuery = "INSERT INTO user (username, password, full_name, phone_number, address, email, user_role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement loginPst = con.prepareStatement(loginQuery, Statement.RETURN_GENERATED_KEYS);

            loginPst.setString(1, name);
            loginPst.setString(2, psswd);
            loginPst.setString(3, fullname);
            loginPst.setString(4, phone);
            loginPst.setString(5, address);
            loginPst.setString(6, email);
            loginPst.setString(7, value);

            loginPst.executeUpdate();

            // Get the generated user_id
            ResultSet rs = loginPst.getGeneratedKeys();
            int userId = -1;
            if (rs.next())
                userId = rs.getInt(1);

            if (userId != -1)
            {
                out.println("<h2>Registered successfully!</h2><a href=\"Business_Owner.jsp\"><h3>Click here!</a><h3>");
            }
            else
            {
                out.println("<h2>Error registering user.</h2><a href=\"Business_Owner.jsp\"><h3>Click here!</a> to try again!</h3>");
            }

            con.close();
        }
        catch (Exception e)
        {
            out.println("Error: " + e.getMessage());
        }
    }


   else if (act != null && act.equals("pickup")) {
        try {
            String pickupDateTime = request.getParameter("pickupDateTime");
            String dropoffDateTime = request.getParameter("dropoffDateTime");
            String username = request.getParameter("username");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

            // Insert data into the pickup table
            String pickupQuery = "INSERT INTO pickup (pickupDateTime, dropoffDateTime, username) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(pickupQuery);

            pst.setString(1, pickupDateTime);
            pst.setString(2, dropoffDateTime);              
            pst.setString(3, username);              
            pst.executeUpdate();

            // Store dates in session for later use
            session.setAttribute("pickupDateTime", pickupDateTime);
            session.setAttribute("dropoffDateTime", dropoffDateTime);

            out.println("<h1 style='font-family: Arial, sans-serif; font-size: 28px; color: #2ecc71; text-align: center; padding: 20px; margin: 20px auto; background: linear-gradient(to right, #f1f9f1, #e8f5e9); border-radius: 10px; box-shadow: 0 4px 15px rgba(46, 204, 113, 0.2); text-transform: uppercase; letter-spacing: 2px; border-left: 5px solid #2ecc71; animation: slideIn 0.5s ease-out;'>Slot booked successfully!</h1>");
            out.println("<script>");
            out.println("setTimeout(function() {");
            out.println("    window.location.href = 'fetchbikes.jsp';");
            out.println("}, 2000);");
            out.println("</script>");
            con.close();
        } 
        catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
   
   else if(act != null && act.equals("Add Item")) {
        try {
            String item = request.getParameter("item");
            String quantity = request.getParameter("quantity");
           
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
        
            String pickupQuery = "INSERT INTO inventory (item, quantity) VALUES (?, ?)";
            PreparedStatement pst = con.prepareStatement(pickupQuery);

            pst.setString(1, item);
            pst.setString(2, quantity);               
            pst.executeUpdate();
            con.close();
            response.sendRedirect("Maintenance_Staff.jsp");
        }
        catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
   }
   
%>