package com.gojjam.bank.model;

import java.time.LocalDateTime;

public class Complaint {

    private int id;
    private int userId;
    private String userName;
    private String category;
    private String description;
    private String status;        // OPEN | IN_PROGRESS | RESOLVED | CLOSED
    private String response;
    private Integer respondedBy;
    private String respondedByName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Complaint() {}

    public int getId()                              { return id; }
    public void setId(int id)                      { this.id = id; }

    public int getUserId()                          { return userId; }
    public void setUserId(int u)                   { this.userId = u; }

    public String getUserName()                     { return userName; }
    public void setUserName(String u)              { this.userName = u; }

    public String getCategory()                     { return category; }
    public void setCategory(String c)              { this.category = c; }

    public String getDescription()                  { return description; }
    public void setDescription(String d)           { this.description = d; }

    public String getStatus()                       { return status; }
    public void setStatus(String s)                { this.status = s; }

    public String getResponse()                     { return response; }
    public void setResponse(String r)              { this.response = r; }

    public Integer getRespondedBy()                 { return respondedBy; }
    public void setRespondedBy(Integer r)          { this.respondedBy = r; }

    public String getRespondedByName()              { return respondedByName; }
    public void setRespondedByName(String r)       { this.respondedByName = r; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime t)      { this.createdAt = t; }

    public LocalDateTime getUpdatedAt()             { return updatedAt; }
    public void setUpdatedAt(LocalDateTime t)      { this.updatedAt = t; }
}