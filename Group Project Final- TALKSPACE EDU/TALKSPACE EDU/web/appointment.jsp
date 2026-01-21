<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    if (session.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String role = (String) session.getAttribute("role");
    String name = (String) session.getAttribute("name"); 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TALKSPACE EDU - Book Appointment </title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>

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
        .navbar 
        { text-align: center;
          font-size: 28px;
          font-weight: 700;
          padding: 20px 0;
          color: #ffffff;
          background-color: #1e1e1e;
          border-bottom: 4px solid #333;
        }
        .container 
        { max-width: 800px;
          margin: 60px auto;
          background: #1e1e1e;
          padding: 30px 40px;
          border-radius: 12px;
          box-shadow: 0 6px 20px rgba(0,0,0,0.5); 
        }
        .sidebar 
        { width: 220px; 
          background: #161618;
          height: 100vh; color: #dddddd;
          padding-top: 30px; position: fixed;
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
          font-size: 15px;
          color: #dddddd;
          transition: 0.3s;
          border-left: 3px solid transparent;
        }
        .sidebar a:hover 
        { background: #212121;
          border-left-color: #8A9A5B;
        }
        
        h1 
        { font-size: 28px;
          font-weight: 600;
          margin-bottom: 20px;
          text-align: center;
          color: #e0e0e0; 
        }
        label 
        { display: block;
          margin-top: 10px;
          font-weight: 500;
        }
        input, select, button 
        { width: 100%;
          padding: 12px;
          margin-top: 5px;
          margin-bottom: 15px;
          border-radius: 6px;
          border: 1px solid #333;
          background-color: #2a2a2a;
          color: #e0e0e0;
          font-size: 14px; 
        }
        button 
        { background-color: #E75480;
          color: #fff;
          border: none;
          cursor: pointer;
          font-weight: 600; 
          transition: 0.3s; 
          margin-top: 10px; 
        }
        button:hover 
        { 
            background-color: #d64673;
        }
        table 
        { width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }
        th, td 
        { padding: 12px;
          border: 1px solid #333;
          text-align: left;
        }
        th 
        { background-color: #2a2a2a;
          color: #E75480;
        }
        tr:nth-child(even) 
        { 
            background-color: #252525;
        }
        a 
        { color: #E75480;
          font-weight: 600;
          text-decoration: none;
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
    
    <div class="container">
        <% if(request.getParameter("msg") != null) { 
            String msg = request.getParameter("msg");
            String color = msg.equals("success") ? "#8A9A5B" : "#E75480";
        %>
            <p style="color: <%= color %>; text-align: center; font-weight: bold;">
                <%= msg.equals("success") ? "Appointment requested successfully!" : "Error processing request." %>
            </p>
        <% } %>

        <h1>Book an Appointment</h1>
        <form action="AppointmentServlet" method="POST">
            <input type="hidden" name="action" value="student_book">
            <label>Select Counselor</label>
            <select name="counselorId" required>
                <option value="">-- Choose a Counselor --</option>
                <% 
                   try {
                       String url = "jdbc:derby://localhost:1527/counselingDB";
                       Connection conn = DriverManager.getConnection(url, "app", "app");
                       Statement st = conn.createStatement();
                       ResultSet rs = st.executeQuery("SELECT counselor_id, counselorname FROM counselor");
                       while(rs.next()) {
                %>
                    <option value="<%= rs.getInt("counselor_id") %>"><%= rs.getString("counselorname") %></option>
                <% } rs.close(); %>
            </select>

            <label>Preferred Date</label>
            <input type="date" name="apptDate" required>

            <label>Start Time</label>
            <input type="time" name="startTime" required>

            <label>End Time</label>
            <input type="time" name="endTime" required>

            <label>Purpose</label>
            <input type="text" name="purpose" placeholder="e.g., Stress Management" required>
            <button type="submit">Send Request</button>
        </form>

        <hr style="border: 0; border-top: 1px solid #333; margin: 40px 0;">

        <h1>Your Scheduled Appointments</h1>
        <table>
            <thead>
                <tr>
                    <th>Counselor</th>
                    <th>Date & Time</th>
                    <th>Purpose</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Integer sId = (Integer) session.getAttribute("student_id");
                    if (sId != null) {
                        String query = "SELECT c.counselorname, a.appt_date, a.start_time, a.purpose, a.appointment_status " +
                                       "FROM appointment a " +
                                       "JOIN counselor c ON a.counselor_id = c.counselor_id " +
                                       "WHERE a.student_id = " + sId;
                        ResultSet rsAppt = st.executeQuery(query);
                        while(rsAppt.next()) {
                            String status = rsAppt.getString("appointment_status");
                            
                            // Updated Color Logic for Reschedule
                            String sColor = "#E75480"; // Default Pink
                            if ("Approved".equals(status)) {
                                sColor = "#8A9A5B"; // Green
                            } else if ("Pending".equals(status)) {
                                sColor = "orange";
                            } else if ("Reschedule".equals(status)) {
                                sColor = "#3498db"; // Blue for Reschedule
                            }
                %>
                    <tr>
                        <td><%= rsAppt.getString("counselorname") %></td>
                        <td><%= rsAppt.getString("appt_date") %> (<%= rsAppt.getString("start_time") %>)</td>
                        <td><%= rsAppt.getString("purpose") %></td>
                        <td style="color: <%= sColor %>; font-weight: bold;"><%= status %></td>
                    </tr>
                <% } rsAppt.close(); st.close(); conn.close(); 
                    } } catch(Exception e) { out.println(e.getMessage()); } %>
            </tbody>
        </table>
        <div style="text-align: center; margin-top: 20px;"><a href="dashboard.jsp">← Back to Dashboard</a></div>
    </div>
        </div>
</body>
</html>