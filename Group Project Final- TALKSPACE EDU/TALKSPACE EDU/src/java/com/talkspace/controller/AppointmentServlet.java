package com.talkspace.controller;

import model.Appointment; 
import com.talkspace.dao.AppointmentDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    
    private AppointmentDAO dao = new AppointmentDAO();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    HttpSession session = request.getSession();
    Integer counselorId = (Integer) session.getAttribute("counselor_id");

    if (counselorId == null) {
        response.getWriter().write("[]");
        return;
    }

    AppointmentDAO dao = new AppointmentDAO();
    List<String[]> list = dao.getAppointmentsForCounselor(counselorId);
    
    response.setContentType("application/json");
    StringBuilder json = new StringBuilder("[");
    for (int i = 0; i < list.size(); i++) {
        String[] a = list.get(i);
        // Mapping: id, studentName, date, start, end, status
        json.append(String.format("{\"id\":\"%s\",\"studentName\":\"%s\",\"date\":\"%s\",\"start\":\"%s\",\"end\":\"%s\",\"status\":\"%s\"}", 
            a[0], a[1], a[2], a[3], a[4], a[5]));
        if (i < list.size() - 1) json.append(",");
    }
    json.append("]");
    response.getWriter().write(json.toString());
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            dao.updateStatus(Integer.parseInt(request.getParameter("id")), request.getParameter("status"));
        } 
        else if ("delete".equals(action)) {
            dao.deleteAppointment(Integer.parseInt(request.getParameter("id")));
        }
        else {
            // Student Booking Flow
            HttpSession session = request.getSession();
            Integer studentId = (Integer) session.getAttribute("student_id");

            try {
                Appointment appt = new Appointment();
                appt.setStudentId(studentId);
                appt.setCounselorId(Integer.parseInt(request.getParameter("counselorId")));
                appt.setApptDate(request.getParameter("apptDate"));
                appt.setStartTime(request.getParameter("startTime"));
                appt.setEndTime(request.getParameter("endTime"));
                appt.setPurpose(request.getParameter("purpose"));

                boolean success = dao.insertAppointment(appt);
                response.sendRedirect("appointment.jsp?msg=" + (success ? "success" : "failed"));
            } catch (Exception e) {
                response.sendRedirect("appointment.jsp?msg=error");
            }
        }
    }
}