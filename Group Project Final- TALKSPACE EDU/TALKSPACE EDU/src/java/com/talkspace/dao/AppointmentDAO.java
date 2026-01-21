package com.talkspace.dao;

import model.Appointment;
import model.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean insertAppointment(Appointment appt) {
        boolean result = false;
        String query = "INSERT INTO appointment (student_id, counselor_id, appointment_status, purpose, appt_date, start_time, end_time) VALUES (?, ?, 'Pending', ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.connect(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, appt.getStudentId());
            ps.setInt(2, appt.getCounselorId());
            ps.setString(3, appt.getPurpose());
            ps.setString(4, appt.getApptDate());  
            ps.setString(5, appt.getStartTime()); 
            ps.setString(6, appt.getEndTime());   

            int row = ps.executeUpdate();
            if (row > 0) {
                result = true;
            }
            
        } catch (SQLException e) {
            System.out.println("DAO Error (Insert Appointment): " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    
    public List<String[]> getAppointmentsForCounselor(int counselorId) {
    List<String[]> list = new ArrayList<>();
    String query = "SELECT a.appointment_id, s.studentname, a.appt_date, a.start_time, a.end_time, a.appointment_status " +
                   "FROM appointment a " +
                   "LEFT JOIN student s ON a.student_id = s.student_id " +
                   "WHERE a.counselor_id = ? ORDER BY a.appt_date ASC";

    try (Connection con = DBConnection.connect();
         PreparedStatement ps = con.prepareStatement(query)) {
        
        ps.setInt(1, counselorId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new String[]{
                String.valueOf(rs.getInt("appointment_id")),
                rs.getString("studentname") != null ? rs.getString("studentname") : "Unknown",
                rs.getString("appt_date"),
                rs.getString("start_time"),
                rs.getString("end_time"),
                rs.getString("appointment_status")
            });
        }
    } catch (SQLException e) {
        System.out.println("DAO Error: " + e.getMessage());
    }
    return list;
}

    public boolean updateStatus(int apptId, String status) {
        String query = "UPDATE appointment SET appointment_status = ? WHERE appointment_id = ?";
        try (Connection con = DBConnection.connect();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, apptId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAppointment(int apptId) {
        String query = "DELETE FROM appointment WHERE appointment_id = ?";
        try (Connection con = DBConnection.connect();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, apptId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}