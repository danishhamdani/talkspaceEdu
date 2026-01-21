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
public class ProfileDAO {
    
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
