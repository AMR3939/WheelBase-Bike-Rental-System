<%@ page import="java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Form Submission Result</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #1c1c1c;
            color: #fff;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #333;
            padding: 20px;
            border-radius: 5px;
        }
        h2 {
            color: #ff6600;
            margin-bottom: 20px;
        }
        p {
            margin-bottom: 15px;
        }
        a {
            color: #ff6600;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Thank you for contacting us!</h2>
        <%
            // Retrieving form data from request parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String message = request.getParameter("message");

            // Output the submitted information
            if (name != null && email != null && message != null) {
        %>
            <p><strong>Name:</strong> <%= name %></p>
            <p><strong>Email:</strong> <%= email %></p>
            <p><strong>Message:</strong> <%= message %></p>
            <p>We will get back to you soon.</p>
        <%
            } else {
        %>
            <p>Sorry, there was an issue processing your form submission.</p>
        <%
            }
        %>
        <a href="index.html">Back to Home</a>
    </div>
</body>
</html>
