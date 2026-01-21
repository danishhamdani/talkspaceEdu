/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkspace.controller;

import com.talkspace.dao.ProfileDAO;
import com.talkspace.dao.RegistrationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Counselor;
import model.Student;

/**
 *
 * @author NITRO V15
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
          
            
           
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");
        if (userEmail != null) {
            userEmail = userEmail.trim(); 
        }
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        

        if (userEmail == null) {
            response.sendRedirect("index.html"); 
            return;
        }

      
        RegistrationDAO dao = new RegistrationDAO();
        
        if ("student".equals(role)) {
            Student s = dao.getStudentByEmail(userEmail);
            request.setAttribute("user", s); // Pass student object to JSP
             session.setAttribute("user", s);
             
            
        } else {
            Counselor c = dao.getCounselorByEmail(userEmail);
            request.setAttribute("user", c);
            session.setAttribute("user", c);
        }

        // 3. Forward to the Profile View (JSP)
        if ("edit".equals(action)) {
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("profile_view.jsp").forward(request, response);
        }
        
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
        
    HttpSession session = request.getSession();
    
    
    String role = (String) session.getAttribute("role");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String regId = request.getParameter("regId");
    String extraInfo = request.getParameter("extraInfo");


    ProfileDAO dao = new ProfileDAO();
    boolean isUpdated = dao.updateUser(id, name, email, regId, extraInfo, role);
   
    
    if (isUpdated) {
        
        session.setAttribute("email", email);
        session.setAttribute("name", name);
        response.sendRedirect("ProfileServlet?updated=true");
    } else {
        response.sendRedirect("ProfileServlet?action=edit&error=true");
    }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
