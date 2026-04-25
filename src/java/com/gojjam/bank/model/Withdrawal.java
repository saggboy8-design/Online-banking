package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Withdrawal {

    private int id;
    private int accountId;
    private BigDecimal amount;
    private BigDecimal fee;
    private String withdrawalMethod;  // BANK_COUNTER | MOBILE_MONEY | ATM_REQUEST
    private String reason;
    private String status;            // PENDING | SUCCESS | REJECTED | FAILED
    private Integer managerId;
    private String managerName;
    private String managerNote;
    private String referenceNumber;
    private LocalDateTime createdAt;

    // joined
    private String accountNumber;
    private String ownerName;
    private String ownerPhone;
    private String ownerEmail;

    public Withdrawal() {}

    public int getId()                           { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getAccountId()                    { return accountId; }
    public void setAccountId(int a)             { this.accountId = a; }

    public BigDecimal getAmount()                { return amount; }
    public void setAmount(BigDecimal a)         { this.amount = a; }

    public BigDecimal getFee()                   { return fee; }
    public void setFee(BigDecimal f)            { this.fee = f; }

    public String getWithdrawalMethod()          { return withdrawalMethod; }
    public void setWithdrawalMethod(String m)   { this.withdrawalMethod = m; }

    public String getReason()                    { return reason; }
    public void setReason(String r)             { this.reason = r; }

    public String getStatus()                    { return status; }
    public void setStatus(String s)             { this.status = s; }

    public Integer getManagerId()                { return managerId; }
    public void setManagerId(Integer m)         { this.managerId = m; }

    public String getManagerName()               { return managerName; }
    public void setManagerName(String m)        { this.managerName = m; }

    public String getManagerNote()               { return managerNote; }
    public void setManagerNote(String n)        { this.managerNote = n; }

    public String getReferenceNumber()           { return referenceNumber; }
    public void setReferenceNumber(String r)    { this.referenceNumber = r; }

    public LocalDateTime getCreatedAt()          { return createdAt; }
    public void setCreatedAt(LocalDateTime t)   { this.createdAt = t; }

    public String getAccountNumber()             { return accountNumber; }
    public void setAccountNumber(String n)      { this.accountNumber = n; }

    public String getOwnerName()                 { return ownerName; }
    public void setOwnerName(String n)          { this.ownerName = n; }

    public String getOwnerPhone()                { return ownerPhone; }
    public void setOwnerPhone(String p)         { this.ownerPhone = p; }

    public String getOwnerEmail()                { return ownerEmail; }
    public void setOwnerEmail(String e)         { this.ownerEmail = e; }
}