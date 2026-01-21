<%-- 
    Document   : edit_profile
    Created on : Jan 13, 2026, 2:51:41 PM
    Author     : NITRO V15
--%>

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
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
<title>TALKSPACE EDU - Profile</title>

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

        /* ===== Container ===== */
        .container {
            padding: 30px 40px;
            max-width: 600px;
            margin: auto;
        }

        /* ===== Form Card ===== */
        form {
            background: #212121;
            padding: 26px;
            border-radius: 12px;
            border: 1px solid #242526;
            line-height: 1.7;
            box-shadow: 0 8px 20px rgba(0,0,0,0.35);
        }

        /* ===== Labels ===== */
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            font-size: 15px;
            color: #e3e3e3;
        }

        /* ===== Inputs ===== */
        input, select {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: 1px solid #161618;
            border-radius: 8px;
            background: #161618;
            color: #dddddd;
            font-size: 14px;
            transition: 0.25s ease;
        }

        input::placeholder {
            color: #9a9a9a;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #7e8078;
            box-shadow: 0 0 8px rgba(126,128,120,0.35);
            background: #181818;
        }

        /* ===== Button ===== */
        .button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background: linear-gradient(135deg, #7e8078, #5f615a);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .button:hover {
            background: linear-gradient(135deg, #8f9189, #6b6d66);
            box-shadow: 0 6px 16px rgba(0,0,0,0.4);
        }

        /* Keep spacing clean */
        form > *:not(:last-child) {
            margin-bottom: 2px;
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
    <form action="ProfileServlet" method="post">
        <input type="hidden" name="id" value="${user.id}" >

    <label for="name">Full Name:</label>
    <input type="text" id="name" name="name" value="${user.name}" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" value="${user.email}" required>

    <label>Role:</label>
    <p style="text-transform: capitalize; margin-bottom: 15px;">${role}</p>

    <label for="regid" style="text-transform: capitalize;">${role} ID:</label>
    <input type="text" id="regid" name="regId" value="${user.regId}">

       <c:choose>
    
    <c:when test="${role == 'student'}">
        <label for="department">Department:</label>
        <select id="department" name="extraInfo" required>
            <option value="" disabled ${user.department == null ? 'selected' : ''}>Select Department</option>
            <option value="Computer Science" ${user.department == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
            <option value="Information Technology" ${user.department == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
            <option value="Software Engineering" ${user.department == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
            <option value="Data Science" ${user.department == 'Data Science' ? 'selected' : ''}>Data Science</option>
            <option value="Business Administration" ${user.department == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
            <option value="Accounting" ${user.department == 'Accounting' ? 'selected' : ''}>Accounting</option>
            <option value="Engineering" ${user.department == 'Engineering' ? 'selected' : ''}>Engineering</option>
        </select>
    </c:when>

  
    <c:otherwise>
        <label for="specialization">Specialization:</label>
        <select id="specialization" name="extraInfo" required>
            <option value="" disabled ${user.specialization == null ? 'selected' : ''}>Select Specialization</option>
            <option value="Academic Counseling" ${user.specialization == 'Academic Counseling' ? 'selected' : ''}>Academic Counseling</option>
            <option value="Career Counseling" ${user.specialization == 'Career Counseling' ? 'selected' : ''}>Career Counseling</option>
            <option value="Mental Health Counseling" ${user.specialization == 'Mental Health Counseling' ? 'selected' : ''}>Mental Health Counseling</option>
            <option value="Stress Management" ${user.specialization == 'Stress Management' ? 'selected' : ''}>Stress Management</option>
            <option value="Relationship Counseling" ${user.specialization == 'Relationship Counseling' ? 'selected' : ''}>Relationship Counseling</option>
            <option value="Personal Development" ${user.specialization == 'Personal Development' ? 'selected' : ''}>Personal Development</option>
            <option value="Crisis Intervention" ${user.specialization == 'Crisis Intervention' ? 'selected' : ''}>Crisis Intervention</option>
        </select>
    </c:otherwise>
</c:choose>

    <input type="submit" class="button" value="Update">
    </form>
</div>
        </div>
</body>
</html>

