<%@page import="java.sql.*" %>
<%@page import="java.io.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Webpage</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        /* General styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: linear-gradient(to bottom right, #141e30, #243b55);
            display: flex;
            flex-direction: column;
            color: #ffffff;
            height: 100vh;
        }
        h1 {
            color: #ffffff;
            text-align: center;
            margin-bottom: 20px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
            animation: glow 2s ease-in-out infinite alternate;
        }

        /* Header and navigation styles */
        header {
            background-color: #243b55;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar {
            display: flex;
            gap: 15px;
        }
        .navbar a {
            color: #b0c4de;
            text-decoration: none;
            font-size: 16px;
        }
        .navbar a:hover {
            color: #e74c3c;
        }

        /* Sidebar styles */
        .sidebar {
            background-color: #1a2d4a;
            padding: 15px;
            width: 250px;
            position: absolute;
            top: 70px;
            bottom: 0;
            left: 0;
            overflow-y: auto;
            box-shadow: 4px 0 8px rgba(0, 0, 0, 0.3);
        }

        .button {
            display: inline-block;
            padding: 10px 15px;
            margin-top: 10px;
            background-color: #3498db;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
        }
        .button:hover {
            background-color: #2980b9;
        }

        /* Profile dropdown styles */
        .profile-dropdown {
            position: absolute;
            top: 20px;
            right: 20px;
            color: #ffffff;
            font-size: 14px;
            cursor: pointer;
        }
        .profile-menu {
            display: none;
            position: absolute;
            top: 50px;
            right: 20px;
            background-color: #1a2d4a;
            border: 1px solid #243b55;
            border-radius: 8px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            padding: 10px;
            width: 200px;
        }
        .profile-menu p, .profile-menu button, .profile-menu a {
            color: #b0c4de;
            margin: 5px 0;
            text-align: left;
            width: 100%;
        }
        
        /* Main content styles */
        .main-content {
            margin-left: 270px; /* Space for sidebar */
            padding: 20px;
        }
    </style>
</head>
<body>
    <!-- Header with navigation -->
    <header>
        <h1>Customer Webpage</h1>
        <div class="navbar">
            <a href="#home">Home</a>
            <a href="history.jsp">History of Services</a>

        </div>
    </header>

    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Image Gallery Button -->
        <h3>Image Gallery</h3>
        <a href="gallery.jsp" target="_blank" class="button">View Gallery</a>

        <!-- Calculator for day-wise amount -->
        <div class="calculator" style="margin-top: 20px; padding: 15px; background: rgba(255, 255, 255, 0.1); border-radius: 8px;">
            <h3 style="color: #3498db; margin-bottom: 15px;">Calculate Rental Cost</h3>
            
            <!-- Brand Name Dropdown -->
            <div style="margin-bottom: 15px;">
                <label for="brand_name" style="display: block; margin-bottom: 5px;">Select Brand:</label>
                <select id="brand_name" onchange="fetchModels()" style="width: 100%; padding: 8px; background: #243b55; color: white; border: 1px solid #3498db; border-radius: 4px;">
                    <option value="">Select Brand</option>
                    <% 
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT brand FROM bikes");
                        while (rs.next()) {
                            String brand = rs.getString("brand");
                    %>
                        <option value="<%= brand %>"><%= brand %></option>
                    <% 
                        } 
                        rs.close();
                        stmt.close();
                        conn.close();
                    %>
                </select>
            </div>

            <!-- Model Name Dropdown Container -->
            <div id="modelContainer" style="margin-bottom: 15px;">
                <!-- This will be filled dynamically -->
            </div>

            <!-- Number of Days Input -->
            <div style="margin-bottom: 15px;">
                <label for="days" style="display: block; margin-bottom: 5px;">Number of days:</label>
                <input type="number" id="days" placeholder="Enter days" oninput="calculateCost()" style="width: 100%; padding: 6px; background: #243b55; color: white; border: 1px solid #3498db; border-radius: 4px;">
            </div>

            <!-- Hidden field for daily rate -->
            <input type="hidden" id="dailyRate" value="0">

            <!-- Display Total Amount -->
            <div class="result" style="background: #3498db; padding: 10px; border-radius: 4px; text-align: center; margin-top: 15px;">
                <p style="margin: 0; color: white;">Total Amount: Rs <span id="totalAmount">0.00</span></p>
            </div>
        </div>

        <!-- Customer Support Section -->
        <div class="support">
            <h3>Customer Support</h3>
            <p>For assistance, call us at:</p>
            <p><strong>1-800-555-BIKE</strong></p>
            <p>or email: support@bikerentals.com</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Profile dropdown section -->
        <div class="profile-dropdown" onclick="toggleProfileMenu()">Profile</div>
        <div class="profile-menu" id="profileMenu">
            <p><strong>Username:</strong> <%= session.getAttribute("username") %></p>
            <p><strong>Full Name:</strong> <%= session.getAttribute("full_name") %></p>
            <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
            <p><strong>Phone Number:</strong> <%= session.getAttribute("phone") %></p>
            <button onclick="toggleChangePassword()">Change Password</button>
            <a href="logout.jsp">LogOut</a>
            <!-- Change Password Form -->
            <div id="changePasswordForm" style="display:none;">
                <form action="changePassword.jsp" method="post">
                    <input type="password" name="existingPassword" placeholder="Existing Password" required><br>
                    <input type="password" name="newPassword" placeholder="New Password" required><br>
                    <input type="submit" value="Submit">
                </form>
            </div>
        </div>

        <!-- Existing Booking Form -->
        <form action="query.jsp" method="post" onsubmit="return confirmBooking();">
            <label for="pickupDateTime">Schedule Pickup:</label>
            <input type="datetime-local" id="pickupDateTime" name="pickupDateTime" required>
            <label for="dropoffDateTime">Schedule Dropoff:</label>
            <input type="datetime-local" id="dropoffDateTime" name="dropoffDateTime" required><br><br>
            <input type="hidden" name="username" value="<%= session.getAttribute("username") %>">
            <input type="submit" name="submit" value="pickup">
        </form>
    </div>
            
           

    <!-- JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
        const pickupInput = document.getElementById("pickupDateTime");
        const dropoffInput = document.getElementById("dropoffDateTime");

        function setMinDateTime() {
            const now = new Date();
            const localDateTime = now.toISOString().slice(0, 16); // Get current date & time in required format
            pickupInput.min = localDateTime;
            dropoffInput.min = localDateTime;
        }

        function validateDates() {
            const pickupValue = new Date(pickupInput.value);
            const dropoffValue = new Date(dropoffInput.value);

            if (pickupValue < new Date()) {
                alert("Pickup time cannot be in the past!");
                pickupInput.value = "";
            }

            if (dropoffValue < pickupValue) {
                alert("Drop-off time cannot be earlier than pickup!");
                dropoffInput.value = "";
            }
        }

        pickupInput.addEventListener("change", validateDates);
        dropoffInput.addEventListener("change", validateDates);
        setMinDateTime(); // Set initial min date
    });
        // Toggle profile menu
        function toggleProfileMenu() {
            const profileMenu = document.getElementById('profileMenu');
            profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
        }

        // Toggle password form
        function toggleChangePassword() {
            const changePasswordForm = document.getElementById('changePasswordForm');
            changePasswordForm.style.display = changePasswordForm.style.display === 'block' ? 'none' : 'block';
        }

        // Day-wise calculator
        function fetchModels() {
            const brand = document.getElementById('brand_name').value;
            if (brand) {
                // Create an XMLHttpRequest object
                const xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        document.getElementById('modelContainer').innerHTML = this.responseText;
                        calculateCost(); // Recalculate cost when models are loaded
                    }
                };
                // Make the AJAX request to fetchModels.jsp
                xhr.open('GET', 'fetchModels.jsp?brand=' + encodeURIComponent(brand), true);
                xhr.send();
            } else {
                document.getElementById('modelContainer').innerHTML = '';
                document.getElementById('dailyRate').value = '0';
                calculateCost();
            }
        }

        function calculateCost() {
            const days = document.getElementById('days').value || 0;
            const dailyRate = document.getElementById('dailyRate').value || 0;
            const totalAmount = (days * dailyRate).toFixed(2);
            document.getElementById('totalAmount').textContent = totalAmount;
        }
    </script>
</body>
</html>