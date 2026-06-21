<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
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
            max-width: 600px;
            margin: 20px 0;
            text-align: center;
        }
        .container h2 {
            margin: 20px 0;
            font-size: 28px;
            font-weight: 500;
            color: #ffffff;
        }
        .payment-form {
            margin-top: 20px;
            text-align: center;
        }
        .payment-form input {
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            width: calc(100% - 24px);
            max-width: 300px;
        }
        .payment-form h3 {
            margin-bottom: 20px;
            color: white;
        }
        .date-info {
            margin: 20px 0;
            padding: 15px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
        }
        .rental-days {
            font-weight: bold;
            color: #4caf50;
            margin-top: 10px;
        }
        .submit-button {
            background: linear-gradient(90deg, #444444, #888888);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: background 0.3s, transform 0.3s, box-shadow 0.3s;
        }
        .submit-button:hover {
            background: linear-gradient(90deg, #888888, #444444);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
        }
        .error {
            color: red;
            font-size: 12px;
        }
    </style>
    <script>
        function formatCardNumber(input) {
            input.value = input.value.replace(/\D/g, '')
                .replace(/(.{4})/g, '$1 ').trim();
        }
        
        function validateCardNumber() {
            var cardNumber = document.getElementById("cardNumber");
            var cardError = document.getElementById("cardError");
            var cardPattern = /^\d{4} \d{4} \d{4}$/;
            
            if (!cardPattern.test(cardNumber.value)) {
//                cardError.textContent = "Card number must be 12 digits with spaces after every 4 digits.";
            } else {
                cardError.textContent = "";
            }
        }
        
        function validateCVV() {
            var cvv = document.getElementById("cvv");
            var cvvError = document.getElementById("cvvError");
            var cvvPattern = /^\d{3}$/;
            
            if (!cvvPattern.test(cvv.value)) {
//                cvvError.textContent = "CVV must be exactly 3 digits.";
            } else {
                cvvError.textContent = "";
            }
        }
        
        function calculateDays() {
            // Get the dates from the parameters
            const pickupDate = new Date("<%= request.getParameter("pickupDateTime") %>");
            const dropoffDate = new Date("<%= request.getParameter("dropoffDateTime") %>");
            
            // Calculate the time difference in milliseconds
            const timeDiff = Math.abs(dropoffDate - pickupDate);
            
            // Convert time difference to days
            const days = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
            
            // Update hidden input with calculated days
            document.getElementById("calculatedDays").value = days;
            
            // Display the calculated days
            document.getElementById("rentalDays").textContent = days;
            
            return days;
        }
        
        // Calculate days when the page loads
        window.onload = calculateDays;
    </script>
</head>
<body>
    <%
    // Store bike ID and daily rate in the session for backup
    String bikeId = request.getParameter("bikeId");
    String dailyRate = request.getParameter("dailyRate");
    String pickupDateTime = request.getParameter("pickupDateTime");
    String dropoffDateTime = request.getParameter("dropoffDateTime");
    
    if (bikeId != null) {
        session.setAttribute("bikeId", bikeId);
    }
    if (dailyRate != null) {
        session.setAttribute("dailyRate", dailyRate);
    }
    if (pickupDateTime != null) {
        session.setAttribute("pickupDateTime", pickupDateTime);
    }
    if (dropoffDateTime != null) {
        session.setAttribute("dropoffDateTime", dropoffDateTime);
    }
    
    // Use session values if parameters are not available
    if (bikeId == null) {
        bikeId = (String)session.getAttribute("bikeId");
    }
    if (dailyRate == null) {
        dailyRate = (String)session.getAttribute("dailyRate");
    }
    if (pickupDateTime == null) {
        pickupDateTime = (String)session.getAttribute("pickupDateTime");
    }
    if (dropoffDateTime == null) {
        dropoffDateTime = (String)session.getAttribute("dropoffDateTime");
    }
    %>
    
    <header>
        <h1>Payment</h1>
    </header>
    <div class="container">
        <h2>Enter Your Payment Details</h2>
        
        <div class="date-info">
            <p>Pickup Date: <%= pickupDateTime %></p>
            <p>Drop-off Date: <%= dropoffDateTime %></p>
            <p class="rental-days">Rental Duration: <span id="rentalDays"></span> days</p>
        </div>
        
        <div class="payment-form">
            <form action="processpayment.jsp" method="post">
                <input type="text" id="cardNumber" placeholder="Card number" name="cardNumber" required oninput="formatCardNumber(this); validateCardNumber();" maxlength="14"/>
                <div class="error" id="cardError"></div>
                <br/>
                <input type="text" id="cvv" placeholder="CVV" name="cvv" required oninput="validateCVV();" maxlength="3"/>
                <div class="error" id="cvvError"></div>
                <br/>
                <input type="date" name="expiryDate" required/><br/>
                <!-- Hidden input to store calculated days -->
                <input type="hidden" id="calculatedDays" name="days" value="0"/>
                <!-- Pass all necessary data to processpayment.jsp -->
                <input type="hidden" name="pickupDateTime" value="<%= pickupDateTime %>"/>
                <input type="hidden" name="dropoffDateTime" value="<%= dropoffDateTime %>"/>
                <input type="hidden" name="bikeId" value="<%= bikeId %>"/>
                <input type="hidden" name="dailyRate" value="<%= dailyRate %>"/>
                <button type="submit" class="submit-button">Pay Now</button>
            </form>
        </div>
    </div>
</body>
</html>