
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Security Check
    if (session.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String role = (String) session.getAttribute("role");
    String name = (String) session.getAttribute("name"); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TALKSPACE EDU - View Profile</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
<style>
/* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}*/

 body 
        { font-family: 'Poppins', sans-serif;
          background-color: #121212;
          color: #e0e0e0;
          margin: 0;
          padding: 0; 
        }
        .main 
        { margin-left: 220px;
          width: calc(100% - 220px);
        }
        .main h2
        {padding-top: 10px;
         text-align: center;
         text-align: center;
        }
        .sidebar 
        { font-family: 'Poppins', sans-serif;
          width: 220px; 
          background: #161618;
          height: 100vh;
          color: #dddddd;
          padding-top: 30px;
          position: fixed;
          border-right: 1px solid #212121; 
        }

        .sidebar h2 
        { text-align: center;
          font-weight: 600;
          letter-spacing: 1px;
          padding-top: 10px;
        }

        .sidebar a 
        { display: block;
          padding: 14px 22px;
          text-decoration: none;
          font-weight: 600;
          font-size: 15px;
          color: #dddddd;
          transition: 0.3s;
          border-left: 3px solid transparent;
        }

        .sidebar a:hover 
        { background: #212121;
          border-left-color: #8A9A5B;
        }

        .navbar 
        { text-align: center;
          font-size: 28px;
          font-weight: 700;
          padding: 20px 0;
          color: #ffffff;
          background-color: #1e1e1e;
          border-bottom: 4px solid #333; 
        }
  
/* ===== Container ===== */
        .container {
            
            max-width: 600px;
            margin: auto;
            padding: 30px 40px;
        }


        .profile-box {
            background: #212121;
            padding: 26px;
            border-radius: 12px;
            border: 1px solid #242526;
            line-height: 1.8;
            box-shadow: 0 8px 20px rgba(0,0,0,0.35);
        }

        .profile-box h3 {
            margin-bottom: 18px;
            font-size: 20px;
            letter-spacing: 0.5px;
            color: #ffffff;
        }

        /* ===== Profile Items ===== */
        .item {
            margin: 20px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #2f2f2f;
        }

        .item:last-child {
            border-bottom: none;
        }

        .item label {
            font-weight: bold;
            color: #bfbfbf;
            font-size: 15px;
        }

        .item p {
            margin-top: 6px;
            color: #e1e1e1;
        }

        /* ===== Update Button ===== */
        .update-btn {
            display: block;
            margin-top: 20px;
            background: linear-gradient(135deg, #7e8078, #5f615a);
            color: #ffffff;
            padding: 12px;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s ease;
        }

        .update-btn:hover {
            background: linear-gradient(135deg, #8f9189, #6b6d66);
            box-shadow: 0 6px 16px rgba(0,0,0,0.4);
            
        .container .success-msg {
            background: rgba(231, 84, 128, 0.15); /* soft pink background */
            color: #E75480;
            padding: 14px;
            margin-bottom: 18px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            border: 1px solid #E75480;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        }
</style>
</head>

<body>
<div class="sidebar">
        <h2>Menu</h2>
        <br>
        <a href="dashboard.jsp">Dashboard</a>
        
        
        <% if ("Counselor".equalsIgnoreCase(role)) { %>
            <a href="manageRequests.jsp">Manage Requests</a>
        <% } %>

        <% if ("Student".equalsIgnoreCase(role)) { %>
            <a href="appointment.jsp">Book Appointment</a>
        <% } %>

        <a href="ProfileServlet">Profile</a>
        <a href="LogoutServlet">Logout</a> 
    </div>  

    
        <div class="main">
        <div class="navbar">Student Counseling Appointment System</div>

  
    
        <div class="container">
            <c:if test="${param.updated == 'true'}">
                <div class="success-msg" style="color: #E75480;">
                   Profile saved successfully!
                </div>
             </c:if>
            <div class="profile-box">
                <h3>Your Information</h3>

                <div class="item">
                    <label>Full Name:</label>
                    <p>${user.name}</p>
                </div>

                <div class="item">
                    <label>Email:</label>
                    <p>${user.email}</p>
                </div>

                <div class="item">
                    <label>Role:</label>
                    <p style="text-transform: capitalize;">${role}</p>
                </div>

                <div class="item">
                    <label style="text-transform: capitalize;">${role} ID:</label>
                    <p>${user.regId}</p>
                </div>

                <div class="item">
            <c:choose>
                <c:when test="${role eq 'student' || role eq 'Student'}">
                    <label>Department:</label>
                    <p style="text-transform: capitalize;">${user.department}</p>
                </c:when>
                <c:otherwise>
                    <label>Specialization:</label>
                    <p style="text-transform: capitalize;">${user.specialization}</p>
                </c:otherwise>
            </c:choose>
        </div>
            </div>
                <a class="update-btn" href="ProfileServlet?action=edit">Update Profile</a>
        </div>
        </div>
                
<script>
    setTimeout(() => {
        const msg = document.querySelector('.success-msg');
        if (msg) msg.style.display = 'none';
    }, 3000);
</script>
</body>
</html>
