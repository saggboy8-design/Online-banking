package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Loan {

    private int id;
    private int accountId;
    private BigDecimal amount;
    private String purpose;
    private int durationMonths;
    private BigDecimal interestRate;
    private BigDecimal monthlyEmi;
    private BigDecimal totalPayable;
    private BigDecimal outstandingBalance;
    private String status;            // PENDING | APPROVED | REJECTED | DISBURSED
    private Integer managerId;
    private String managerName;
    private String rejectionReason;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;

    // joined
    private String accountNumber;
    private String ownerName;
    private String ownerEmail;
    private String ownerPhone;
    private String ownerNationalId;

    public Loan() {}

    public int getId()                              { return id; }
    public void setId(int id)                      { this.id = id; }

    public int getAccountId()                       { return accountId; }
    public void setAccountId(int a)                { this.accountId = a; }

    public BigDecimal getAmount()                   { return amount; }
    public void setAmount(BigDecimal a)            { this.amount = a; }

    public String getPurpose()                      { return purpose; }
    public void setPurpose(String p)               { this.purpose = p; }

    public int getDurationMonths()                  { return durationMonths; }
    public void setDurationMonths(int d)           { this.durationMonths = d; }

    public BigDecimal getInterestRate()             { return interestRate; }
    public void setInterestRate(BigDecimal r)      { this.interestRate = r; }

    public BigDecimal getMonthlyEmi()               { return monthlyEmi; }
    public void setMonthlyEmi(BigDecimal m)        { this.monthlyEmi = m; }

    public BigDecimal getTotalPayable()             { return totalPayable; }
    public void setTotalPayable(BigDecimal t)      { this.totalPayable = t; }

    public BigDecimal getOutstandingBalance()       { return outstandingBalance; }
    public void setOutstandingBalance(BigDecimal o){ this.outstandingBalance = o; }

    public String getStatus()                       { return status; }
    public void setStatus(String s)                { this.status = s; }

    public Integer getManagerId()                   { return managerId; }
    public void setManagerId(Integer m)            { this.managerId = m; }

    public String getManagerName()                  { return managerName; }
    public void setManagerName(String m)           { this.managerName = m; }

    public String getRejectionReason()              { return rejectionReason; }
    public void setRejectionReason(String r)       { this.rejectionReason = r; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime t)      { this.createdAt = t; }

    public LocalDateTime getApprovedAt()            { return approvedAt; }
    public void setApprovedAt(LocalDateTime t)     { this.approvedAt = t; }

    public String getAccountNumber()                { return accountNumber; }
    public void setAccountNumber(String n)         { this.accountNumber = n; }

    public String getOwnerName()                    { return ownerName; }
    public void setOwnerName(String n)             { this.ownerName = n; }

    public String getOwnerEmail()                   { return ownerEmail; }
    public void setOwnerEmail(String e)            { this.ownerEmail = e; }

    public String getOwnerPhone()                   { return ownerPhone; }
    public void setOwnerPhone(String p)            { this.ownerPhone = p; }

    public String getOwnerNationalId()              { return ownerNationalId; }
    public void setOwnerNationalId(String n)       { this.ownerNationalId = n; }
}