/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkspace.controller;

import com.talkspace.dao.TimeSlotDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.List;
import model.DBConnection;
import javax.servlet.http.HttpSession;


/**
 *
 * @author Hp VICTUS
 */
@WebServlet(name = "TimeSlotServlet", urlPatterns = {"/TimeSlotServlet"})
public class TimeSlotServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private TimeSlotDAO dao = new TimeSlotDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    List<String[]> slots = dao.getAllSlots();
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    StringBuilder json = new StringBuilder();
    json.append("[");
    for (int i = 0; i < slots.size(); i++) {
        String[] s = slots.get(i);
        json.append("{");
        json.append("\"id\":\"").append(s[0]).append("\",");
        json.append("\"date\":\"").append(s[1]).append("\",");
        json.append("\"start\":\"").append(s[2]).append("\",");
        json.append("\"end\":\"").append(s[3]).append("\"");
        json.append("}");
        if (i < slots.size() - 1) json.append(",");
    }
    json.append("]");
    
    response.getWriter().write(json.toString());
}

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    HttpSession session = request.getSession();
    Integer counselorId = (Integer) session.getAttribute("counselor_id");

    if (counselorId == null) {
        response.sendRedirect("login.html"); 
        return;
    }

    String action = request.getParameter("action");
    
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deleteSlot(id);
    } else {
        String date = request.getParameter("date");
        String start = request.getParameter("start");
        String end = request.getParameter("end");

        
        dao.addSlot(counselorId, date, start, end);
        response.sendRedirect("timeslot.jsp"); 
    }
}

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}