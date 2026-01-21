<%@ page import="java.sql.*, model.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    
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
    <title>TALKSPACE EDU - TimeSlot Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
    body {
        
        margin: 0;
        background-color: #121212;
        font-family: 'Poppins', sans-serif;
        color: #dddddd;
    }

    .sidebar 
        { font-family: 'Poppins', sans-serif;
          width: 220px; 
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
        
        .navbar 
        { text-align: center;
          font-size: 28px;
          font-weight: 700;
          padding: 20px 0;
          color: #ffffff;
          background-color: #1e1e1e;
          border-bottom: 4px solid #333;
        }
    .container {
        max-width: 900px;
        margin: 40px auto;
        background-color: #212121;
        padding: 30px 20px;
        border-radius: 12px;
        box-shadow: 0 5px 12px rgba(0,0,0,0.3);
        border: 1px solid #242526;
    }

    h2, h3 { font-family: 'Poppins', sans-serif; color: #ffffff; margin-bottom: 15px; }

    input {
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #161618;
        background-color: #161618;
        color: #dddddd;
        margin: 8px;
    }
    
    input:focus { outline: none; border-color: #7e8078; }

    button {
        background-color: #7e8078;
        color: white;
        border: none;
        cursor: pointer;
        font-weight: 600;
        padding: 12px 20px;
        border-radius: 8px;
        transition: 0.3s;
    }

    button:hover { background-color: #373930; }

    table { width: 100%; margin-top: 20px; border-collapse: collapse; }

    th { 
        background-color: #1a1a1a; 
        padding: 12px;
        color: #ffffff;
        border-bottom: 2px solid #333;
    }

    td {
        padding: 12px;
        border-bottom: 1px solid #2f2f2f;
        text-align: center;
        color: #ffffff !important; /* Force text color */
    }

    .btn-small { padding: 6px 10px; font-size: 14px; border-radius: 6px; border: none; cursor: pointer; }

    .delete { background-color: #dc3545; color: white; }
    
    /* Specific styling for the table rows to ensure visibility */
    #slotTable tbody tr {
        background-color: #2a2a2a;
    }
    
    #slotTable tbody tr:hover {
        background-color: #333333;
    }
    
    .status-select {
    padding: 8px 12px;
    border-radius: 6px;
    border: 1px solid #444;
    background-color: #161618;
    color: #ffffff;
    font-family: 'Inter', sans-serif;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    outline: none;
    width: 140px;
}

.status-select:hover {
    border-color: #7e8078;
    background-color: #252526;
}

.status-select:focus {
    border-color: #7e8078;
    box-shadow: 0 0 5px rgba(126, 128, 120, 0.3);
}

/* Optional: Subtle background colors for the options themselves */
.status-select option {
    background-color: #1e1e1e;
    color: white;
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
    <h2>Student Appointment Requests</h2>
    <table id="slotTable">
        <thead>
            <tr>
                <th>Student</th>
                <th>Date</th>
                <th>Time</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
        </div>
    </div>

<script>
    const API_URL = "AppointmentServlet";

   async function loadRequests() {
    try {
        const response = await fetch("AppointmentServlet");
        const appointments = await response.json();
        const tbody = document.querySelector("#slotTable tbody");
        let html = "";

        if (appointments.length === 0) {
            html = "<tr><td colspan='5' style='text-align:center;'>No requests found.</td></tr>";
        } else {
            appointments.forEach(a => {
                // Determine text color for the status column
                let statusColor = "#dddddd";
                let borderColor = "#444"; // Default border
                
                if (a.status === 'Approved') { 
                    statusColor = "#8A9A5B"; 
                    borderColor = "#8A9A5B";
                } else if (a.status === 'Pending') { 
                    statusColor = "orange"; 
                    borderColor = "orange";
                } else if (a.status === 'Reschedule') { 
                    statusColor = "#3498db"; 
                    borderColor = "#3498db";
                } else if (a.status === 'Declined') { 
                    statusColor = "#dc3545"; 
                    borderColor = "#dc3545";
                }

                html += "<tr style='background-color: #2a2a2a;'>" +
                            "<td>" + a.studentName + "</td>" +
                            "<td>" + a.date + "</td>" +
                            "<td>" + a.start.substring(0,5) + " - " + a.end.substring(0,5) + "</td>" +
                            "<td style='color: " + statusColor + "; font-weight: bold;'>" + a.status + "</td>" +
                            "<td>" +
                                "<select class='status-select' style='border-color: " + borderColor + "' onchange=\"updateStatus('" + a.id + "', this.value)\">" +
                                    "<option value='Pending' " + (a.status === 'Pending' ? 'selected' : '') + ">Pending</option>" +
                                    "<option value='Approved' " + (a.status === 'Approved' ? 'selected' : '') + ">Approve</option>" +
                                    "<option value='Reschedule' " + (a.status === 'Reschedule' ? 'selected' : '') + ">Reschedule</option>" +
                                    "<option value='Declined' " + (a.status === 'Declined' ? 'selected' : '') + ">Decline</option>" +
                                "</select>" +
                                " <button class='btn-small delete' onclick=\"deleteAppt('" + a.id + "')\" style='margin-left:8px;'>Delete</button>" +
                            "</td>" +
                        "</tr>";
            });
        }
        tbody.innerHTML = html;
    } catch (e) { 
        console.error("Fetch error:", e); 
    }
}

async function updateStatus(id, newStatus) {
    if (!newStatus) return; // Do nothing if default option selected
    
    // Using URL parameters as expected by your Servlet logic
    const url = "AppointmentServlet?action=updateStatus&id=" + id + "&status=" + newStatus;
    
    try {
        const response = await fetch(url, { method: 'POST' });
        if (response.ok) {
            loadRequests(); // Refresh table to show new status and colors
        } else {
            alert("Failed to update status.");
        }
    } catch (e) {
        console.error("Update error:", e);
    }
}

async function deleteAppt(id) {
    if(confirm("Delete this appointment?")) {
        await fetch("AppointmentServlet?action=delete&id=" + id, { method: 'POST' });
        loadRequests();
    }
}
    window.onload = loadRequests;
</script>
</body>
</html>