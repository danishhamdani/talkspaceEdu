package com.talkspace.controller;

import com.talkspace.dao.RegistrationDAO;
import model.Student;
import model.Counselor;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        RegistrationDAO dao = new RegistrationDAO();
        String role = dao.checkLogin(email, pass);
        
        
        if (role != null) {
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("role", role);
            session.setAttribute("loginSuccess", "Welcome back");
            
            
            if ("student".equalsIgnoreCase(role)) {
                Student s = dao.getStudentByEmail(email);
                if (s != null) {
                    session.setAttribute("student_id", s.getId());
                     session.setAttribute("name", s.getName());
                }
            } else if ("counselor".equalsIgnoreCase(role)) {
                
                Counselor c = dao.getCounselorByEmail(email);
                if (c != null) {
                    
                    session.setAttribute("counselor_id", c.getId());
                    session.setAttribute("name", c.getName());
                }
            }
            
            response.sendRedirect("dashboard.jsp");
        } else {
            response.sendRedirect("index.html?error=invalid");
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Controller for TALKSPACE EDU";
    }
}