package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BillPayment {

    private int id;
    private int accountId;
    private String billType;
    private BigDecimal amount;
    private BigDecimal fee;
    private String referenceNumber;
    private String providerName;
    private String status;
    private LocalDateTime createdAt;

    // joined
    private String accountNumber;
    private String ownerName;

    public BillPayment() {}

    public int getId()                           { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getAccountId()                    { return accountId; }
    public void setAccountId(int a)             { this.accountId = a; }

    public String getBillType()                  { return billType; }
    public void setBillType(String b)           { this.billType = b; }

    public BigDecimal getAmount()                { return amount; }
    public void setAmount(BigDecimal a)         { this.amount = a; }

    public BigDecimal getFee()                   { return fee; }
    public void setFee(BigDecimal f)            { this.fee = f; }

    public String getReferenceNumber()           { return referenceNumber; }
    public void setReferenceNumber(String r)    { this.referenceNumber = r; }

    public String getProviderName()              { return providerName; }
    public void setProviderName(String p)       { this.providerName = p; }

    public String getStatus()                    { return status; }
    public void setStatus(String s)             { this.status = s; }

    public LocalDateTime getCreatedAt()          { return createdAt; }
    public void setCreatedAt(LocalDateTime t)   { this.createdAt = t; }

    public String getAccountNumber()             { return accountNumber; }
    public void setAccountNumber(String n)      { this.accountNumber = n; }

    public String getOwnerName()                 { return ownerName; }
    public void setOwnerName(String n)          { this.ownerName = n; }
}