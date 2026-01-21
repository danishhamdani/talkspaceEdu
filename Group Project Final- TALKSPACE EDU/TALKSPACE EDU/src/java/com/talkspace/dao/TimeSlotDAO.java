/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkspace.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Counselor;
import model.Student;
/**
 *
 * @author Hp VICTUS
 */
public class TimeSlotDAO {

    // Update this to match your actual table: AVAILABILITY
    public boolean addSlot(int counselorId, String date, String start, String end) {
        String sql = "INSERT INTO availability (counselor_id, available_date, start_time, end_time, availability_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, counselorId);
            ps.setDate(2, Date.valueOf(date));
            ps.setTime(3, Time.valueOf(start + ":00"));
            ps.setTime(4, Time.valueOf(end + ":00"));
            ps.setString(5, "Available"); // Default status
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<String[]> getAllSlots() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM availability ORDER BY available_date ASC, start_time ASC";
        
        try (Connection conn = DBConnection.connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("availability_id")),
                    rs.getDate("available_date").toString(),
                    rs.getTime("start_time").toString(),
                    rs.getTime("end_time").toString()
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean deleteSlot(int id) {
        String sql = "DELETE FROM availability WHERE availability_id = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}