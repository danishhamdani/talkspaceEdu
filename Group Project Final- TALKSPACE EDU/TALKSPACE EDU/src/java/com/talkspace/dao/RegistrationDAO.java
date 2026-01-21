/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkspace.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Counselor;
import model.DBConnection;
import model.Student;

/**
 *
 * @author NITRO V15
 */
public class RegistrationDAO {
    
   public boolean registerStudent(Student student) {
        String sql = "INSERT INTO Student (studentName, studentEmail, studentPassword, student_reg_id, department) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.connect(); 
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setString(1, student.getName());
            pst.setString(2, student.getEmail());
            pst.setString(3, student.getPassword());
            pst.setString(4, student.getRegId());
            pst.setString(5, student.getDepartment());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Registration Error (Student): " + e.getMessage());
            return false;
        }
    }

   
    public boolean registerCounselor(Counselor counselor) {
        String sql = "INSERT INTO Counselor (counselorName, counselorEmail, counselorPassword, counselor_reg_id, specialization) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.connect(); 
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setString(1, counselor.getName());
            pst.setString(2, counselor.getEmail());
            pst.setString(3, counselor.getPassword());
            pst.setString(4, counselor.getRegId());
            pst.setString(5, counselor.getSpecialization());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Registration Error (Counselor): " + e.getMessage());
            return false;
        }
    }
    
    public String checkLogin(String email, String password) {
    try (Connection conn = DBConnection.connect()) {
      
        PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM Student WHERE studentEmail=? AND studentPassword=?");
        ps1.setString(1, email);
        ps1.setString(2, password);
        if (ps1.executeQuery().next()) return "student";

        
        PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM Counselor WHERE counselorEmail=? AND counselorPassword=?");
        ps2.setString(1, email);
        ps2.setString(2, password);
        if (ps2.executeQuery().next()) return "counselor";
        
    } catch (Exception e) { e.printStackTrace(); }
    return null; 
}
    
    public Student getStudentByEmail(String email) {
    Student s = null;
    try (Connection conn = DBConnection.connect()) {
        String sql = "SELECT * FROM Student WHERE studentEmail = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            s = new Student();
            s.setId(rs.getInt("STUDENT_ID"));
            s.setName(rs.getString("studentName"));
            s.setEmail(rs.getString("studentEmail"));
            s.setRegId(rs.getString("student_reg_id"));
            s.setDepartment(rs.getString("department"));
        }
    } catch (Exception e) { e.printStackTrace(); }
    return s;
    }

public Counselor getCounselorByEmail(String email) {
    Counselor c = null;
    String sql = "SELECT * FROM Counselor WHERE counselorEmail = ?";
    
    try (Connection conn = DBConnection.connect();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            c = new Counselor();
            c.setId(rs.getInt("COUNSELOR_ID"));
            c.setName(rs.getString("counselorName"));
            c.setEmail(rs.getString("counselorEmail"));
            c.setRegId(rs.getString("counselor_reg_id"));
            c.setSpecialization(rs.getString("specialization"));
        }
    } catch (SQLException e) {
        System.out.println("DAO Error (Get Counselor): " + e.getMessage());
    }
    return c;
}
    

public boolean updateUser(String id, String name, String email, String regId, String extra, String role) {
    String sql;
    if ("student".equalsIgnoreCase(role)) {
        sql = "UPDATE Student SET studentName=?, studentEmail=?, student_reg_id=?, department=? WHERE STUDENT_ID=?";
    } else {

        sql = "UPDATE Counselor SET counselorName=?, counselorEmail=?, counselor_reg_id=?, specialization=? WHERE COUNSELOR_ID=?";
    }

    try (Connection con = DBConnection.connect();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, name); 
        ps.setString(2, email); 
        ps.setString(3, regId);
        ps.setString(4, extra); 
        ps.setString(5, id);   
        
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}
