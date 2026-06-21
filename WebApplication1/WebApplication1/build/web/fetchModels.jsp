<%@ page import="java.sql.*" %>
<%
    String brand = request.getParameter("brand");
    if (brand != null && !brand.isEmpty()) {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
        PreparedStatement ps = conn.prepareStatement("SELECT model, daily_rate FROM bikes WHERE brand = ?");
        ps.setString(1, brand);
        ResultSet rs = ps.executeQuery();
%>
        <label for="model_name" style="display: block; margin-bottom: 5px;">Select Model:</label>
        <select id="model_name" 
                onchange="document.getElementById('dailyRate').value = this.options[this.selectedIndex].getAttribute('data-daily-rate'); calculateCost()"
                style="width: 100%; padding: 8px; background: #243b55; color: white; border: 1px solid #3498db; border-radius: 4px;">
            <option value="">Select Model</option>
            <%
                while (rs.next()) {
                    String model = rs.getString("model");
                    String dailyRate = rs.getString("daily_rate");
            %>
                <option value="<%= model %>" data-daily-rate="<%= dailyRate %>"><%= model %></option>
            <%
                }
                rs.close();
                ps.close();
                conn.close();
            %>
        </select>
<%
    }
%>