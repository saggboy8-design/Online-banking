package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Account {

    private int id;
    private int userId;
    private String accountNumber;
    private BigDecimal balance;
    private String accountType;   // SAVINGS | CURRENT
    private String kycStatus;     // PENDING | APPROVED | REJECTED
    private Integer approvedBy;
    private String approvedByName;
    private LocalDateTime createdAt;

    // joined fields
    private String ownerFullName;
    private String ownerEmail;
    private String ownerPhone;

    public Account() {}

    public int getId()                            { return id; }
    public void setId(int id)                    { this.id = id; }

    public int getUserId()                        { return userId; }
    public void setUserId(int userId)            { this.userId = userId; }

    public String getAccountNumber()              { return accountNumber; }
    public void setAccountNumber(String n)       { this.accountNumber = n; }

    public BigDecimal getBalance()                { return balance; }
    public void setBalance(BigDecimal b)         { this.balance = b; }

    public String getAccountType()                { return accountType; }
    public void setAccountType(String t)         { this.accountType = t; }

    public String getKycStatus()                  { return kycStatus; }
    public void setKycStatus(String k)           { this.kycStatus = k; }

    public Integer getApprovedBy()                { return approvedBy; }
    public void setApprovedBy(Integer a)         { this.approvedBy = a; }

    public String getApprovedByName()             { return approvedByName; }
    public void setApprovedByName(String n)      { this.approvedByName = n; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)    { this.createdAt = t; }

    public String getOwnerFullName()              { return ownerFullName; }
    public void setOwnerFullName(String n)       { this.ownerFullName = n; }

    public String getOwnerEmail()                 { return ownerEmail; }
    public void setOwnerEmail(String e)          { this.ownerEmail = e; }

    public String getOwnerPhone()                 { return ownerPhone; }
    public void setOwnerPhone(String p)          { this.ownerPhone = p; }
}