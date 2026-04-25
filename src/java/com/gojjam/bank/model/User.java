package com.gojjam.bank.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class User {

    private int id;
    private String username;
    private String passwordHash;
    private String fullName;
    private String email;
    private String phone;
    private LocalDate dateOfBirth;
    private String nationalIdNumber;
    private int roleId;
    private String roleName;
    private String status;          // ACTIVE | LOCKED | PENDING | REJECTED
    private boolean sessionActive;
    private String currentSessionId;
    private LocalDateTime createdAt;

    public User() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int id)                  { this.id = id; }

    public String getUsername()                 { return username; }
    public void setUsername(String username)   { this.username = username; }

    public String getPasswordHash()             { return passwordHash; }
    public void setPasswordHash(String h)      { this.passwordHash = h; }

    public String getFullName()                 { return fullName; }
    public void setFullName(String fullName)   { this.fullName = fullName; }

    public String getEmail()                    { return email; }
    public void setEmail(String email)         { this.email = email; }

    public String getPhone()                    { return phone; }
    public void setPhone(String phone)         { this.phone = phone; }

    public LocalDate getDateOfBirth()           { return dateOfBirth; }
    public void setDateOfBirth(LocalDate d)    { this.dateOfBirth = d; }

    public String getNationalIdNumber()         { return nationalIdNumber; }
    public void setNationalIdNumber(String n)  { this.nationalIdNumber = n; }

    public int getRoleId()                      { return roleId; }
    public void setRoleId(int roleId)          { this.roleId = roleId; }

    public String getRoleName()                 { return roleName; }
    public void setRoleName(String roleName)   { this.roleName = roleName; }

    public String getStatus()                   { return status; }
    public void setStatus(String status)       { this.status = status; }

    public boolean isSessionActive()            { return sessionActive; }
    public void setSessionActive(boolean b)    { this.sessionActive = b; }

    public String getCurrentSessionId()         { return currentSessionId; }
    public void setCurrentSessionId(String s)  { this.currentSessionId = s; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime t)  { this.createdAt = t; }
}