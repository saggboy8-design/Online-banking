package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {

    private int id;
    private int accountId;
    private String transactionType;
    private BigDecimal amount;
    private BigDecimal fee;
    private BigDecimal balanceAfter;
    private String description;
    private String referenceNumber;
    private String status;
    private Integer reversedBy;
    private LocalDateTime createdAt;

    // joined
    private String accountNumber;
    private String ownerName;

    public Transaction() {}

    public int getId()                             { return id; }
    public void setId(int id)                     { this.id = id; }

    public int getAccountId()                      { return accountId; }
    public void setAccountId(int a)               { this.accountId = a; }

    public String getTransactionType()             { return transactionType; }
    public void setTransactionType(String t)      { this.transactionType = t; }

    public BigDecimal getAmount()                  { return amount; }
    public void setAmount(BigDecimal a)           { this.amount = a; }

    public BigDecimal getFee()                     { return fee; }
    public void setFee(BigDecimal f)              { this.fee = f; }

    public BigDecimal getBalanceAfter()            { return balanceAfter; }
    public void setBalanceAfter(BigDecimal b)     { this.balanceAfter = b; }

    public String getDescription()                 { return description; }
    public void setDescription(String d)          { this.description = d; }

    public String getReferenceNumber()             { return referenceNumber; }
    public void setReferenceNumber(String r)      { this.referenceNumber = r; }

    public String getStatus()                      { return status; }
    public void setStatus(String s)               { this.status = s; }

    public Integer getReversedBy()                 { return reversedBy; }
    public void setReversedBy(Integer r)          { this.reversedBy = r; }

    public LocalDateTime getCreatedAt()            { return createdAt; }
    public void setCreatedAt(LocalDateTime t)     { this.createdAt = t; }

    public String getAccountNumber()               { return accountNumber; }
    public void setAccountNumber(String n)        { this.accountNumber = n; }

    public String getOwnerName()                   { return ownerName; }
    public void setOwnerName(String n)            { this.ownerName = n; }
}