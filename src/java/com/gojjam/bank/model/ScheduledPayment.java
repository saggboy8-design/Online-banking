package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ScheduledPayment {

    private int id;
    private int accountId;
    private String paymentType;
    private BigDecimal amount;
    private BigDecimal fee;
    private String recipient;
    private String referenceNumber;
    private String frequency;        // ONE_TIME | WEEKLY | MONTHLY
    private LocalDateTime scheduledDate;
    private LocalDateTime nextExecution;
    private LocalDateTime lastExecuted;
    private String status;           // PENDING | SUCCESS | FAILED | CANCELLED
    private LocalDateTime createdAt;

    // joined
    private String accountNumber;
    private String ownerName;

    public ScheduledPayment() {}

    public int getId()                                { return id; }
    public void setId(int id)                        { this.id = id; }

    public int getAccountId()                         { return accountId; }
    public void setAccountId(int a)                  { this.accountId = a; }

    public String getPaymentType()                    { return paymentType; }
    public void setPaymentType(String p)             { this.paymentType = p; }

    public BigDecimal getAmount()                     { return amount; }
    public void setAmount(BigDecimal a)              { this.amount = a; }

    public BigDecimal getFee()                        { return fee; }
    public void setFee(BigDecimal f)                 { this.fee = f; }

    public String getRecipient()                      { return recipient; }
    public void setRecipient(String r)               { this.recipient = r; }

    public String getReferenceNumber()                { return referenceNumber; }
    public void setReferenceNumber(String r)         { this.referenceNumber = r; }

    public String getFrequency()                      { return frequency; }
    public void setFrequency(String f)               { this.frequency = f; }

    public LocalDateTime getScheduledDate()           { return scheduledDate; }
    public void setScheduledDate(LocalDateTime d)    { this.scheduledDate = d; }

    public LocalDateTime getNextExecution()           { return nextExecution; }
    public void setNextExecution(LocalDateTime n)    { this.nextExecution = n; }

    public LocalDateTime getLastExecuted()            { return lastExecuted; }
    public void setLastExecuted(LocalDateTime l)     { this.lastExecuted = l; }

    public String getStatus()                         { return status; }
    public void setStatus(String s)                  { this.status = s; }

    public LocalDateTime getCreatedAt()               { return createdAt; }
    public void setCreatedAt(LocalDateTime t)        { this.createdAt = t; }

    public String getAccountNumber()                  { return accountNumber; }
    public void setAccountNumber(String n)           { this.accountNumber = n; }

    public String getOwnerName()                      { return ownerName; }
    public void setOwnerName(String n)               { this.ownerName = n; }
}