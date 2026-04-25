package com.gojjam.bank.model;

import java.time.LocalDateTime;

public class AuditLog {

    private long id;
    private Integer userId;
    private String userFullName;
    private String action;
    private String ipAddress;
    private String oldValue;
    private String newValue;
    private LocalDateTime createdAt;

    public AuditLog() {}

    public long getId()                         { return id; }
    public void setId(long id)                 { this.id = id; }

    public Integer getUserId()                  { return userId; }
    public void setUserId(Integer u)           { this.userId = u; }

    public String getUserFullName()             { return userFullName; }
    public void setUserFullName(String n)      { this.userFullName = n; }

    public String getAction()                   { return action; }
    public void setAction(String a)            { this.action = a; }

    public String getIpAddress()                { return ipAddress; }
    public void setIpAddress(String ip)        { this.ipAddress = ip; }

    public String getOldValue()                 { return oldValue; }
    public void setOldValue(String o)          { this.oldValue = o; }

    public String getNewValue()                 { return newValue; }
    public void setNewValue(String n)          { this.newValue = n; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime t)  { this.createdAt = t; }
}