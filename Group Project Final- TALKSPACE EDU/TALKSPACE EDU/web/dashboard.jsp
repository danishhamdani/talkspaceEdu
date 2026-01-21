<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>TALKSPACE EDU - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* { margin: 0; padding: 0; box-sizing: border-box; */
        body 
        { font-family: 'Poppins', sans-serif;
          background-color: #121212;
          color: #e0e0e0;
          margin: 0;
          padding: 0; 
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
        
        

        .main 
        { margin-left: 220px;
          width: calc(100% - 220px);
        }
        .main h2
        {padding-top: 10px;
         text-align: center;
         text-align: center;
        }
        header 
        { background: #1a1a1a;
          color: #ffffff;
          padding: 22px;
          text-align: center;
          text-align: center; 
        }
        .container 
        { padding: 25px;
          display: flex;
          gap: 20px;
          flex-wrap: wrap;
          justify-content: center;
        }
        .card 
        { background: #212121;
          padding: 24px
              ; border-radius: 12px;
          border: 1px solid #242526;
          transition: transform 0.2s, background 0.2s;
          width: 30%;
          min-width: 260px;
          line-height: 1.7;
          cursor: pointer; 
        }
        .card h3 
        { margin-bottom: 10px;
          font-size: 18px;
          font-weight: 600;
          letter-spacing: .3px;
        }
        .card p 
        { margin-bottom: 15px;
          color: #cfcfcf; 
          font-size: 14px;
        }
        .card:hover 
        { background: #242526;
          transform: translateY(-5px) scale(1.02); 
        }
        a.btn 
        { display: inline-block;
          margin-top: 12px;
          padding: 10px 16px;
          background: #7e8078;
          color: #ffffff;
          text-decoration: none;
          border-radius: 6px;
          font-size: 15px;
          transition: 0.3s; 
        }
        a.btn:hover 
        { 
            background: #373930; 
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Menu</h2>
        <br>
        <a href="dashboard.jsp">Dashboard</a>
        
        <%-- COUNSELOR ONLY LINKS --%>
        <% if ("Counselor".equalsIgnoreCase(role)) { %>
            <a href="manageRequests.jsp">Manage Requests</a>
        <% } %>

        <%-- STUDENT ONLY LINKS --%>
        <% if ("Student".equalsIgnoreCase(role)) { %>
            <a href="appointment.jsp">Book Appointment</a>
        <% } %>

        <a href="ProfileServlet">Profile</a>
        <a href="LogoutServlet">Logout</a> 
    </div>

    <div class="main">
        <div class="navbar">Student Counseling Appointment System</div>
        <br><h2>Welcome back, <span style="color: #E75480;"><%= (name != null) ? name : role %> </span>!</h2>
        <div class="container">
            
            <%-- CARD 1: ONLY FOR COUNSELORS --%>
            <% if ("Counselor".equalsIgnoreCase(role)) { %>
            <div class="card" onclick="window.location.href='manageRequests.jsp'">
                <h3>Student Requests</h3>
                <p>View, Approve, or Reschedule counseling sessions from students.</p>
                <a class="btn" href="manageRequests.jsp">Manage Requests</a>
            </div>
            <% } %>

            <%-- CARD 2: ONLY FOR STUDENTS --%>
            <% if ("Student".equalsIgnoreCase(role)) { %>
            <div class="card" onclick="window.location.href='appointment.jsp'">
                <h3>Appointments</h3>
                <p>Book a new session or check your current schedule status.</p>
                <a class="btn" href="appointment.jsp">Go to Appointments</a>
            </div>
            <% } %>

            <%-- CARD 3: FOR EVERYONE --%>
            <div class="card" onclick="window.location.href='ProfileServlet'">
                <h3>Profile</h3>
                <p>Manage your account settings and personal information.</p>
                <a class="btn" href="ProfileServlet">View Profile</a>
            </div>

        </div>
    </div>

</body>
</html>