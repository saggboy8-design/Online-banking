package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transfer {

    private int id;
    private int senderAccountId;
    private String receiverAccount;
    private String transferType;     // INTERNAL | EXTERNAL | INTERNATIONAL
    private BigDecimal amount;
    private BigDecimal fee;
    private String description;
    private String swiftCode;
    private String bankName;
    private String country;
    private String beneficiaryName;
    private String status;           // PENDING | SUCCESS | FAILED | REJECTED
    private Integer managerId;
    private String managerName;
    private LocalDateTime createdAt;

    // joined
    private String senderAccountNumber;
    private String senderName;

    public Transfer() {}

    public int getId()                            { return id; }
    public void setId(int id)                    { this.id = id; }

    public int getSenderAccountId()               { return senderAccountId; }
    public void setSenderAccountId(int s)        { this.senderAccountId = s; }

    public String getReceiverAccount()            { return receiverAccount; }
    public void setReceiverAccount(String r)     { this.receiverAccount = r; }

    public String getTransferType()               { return transferType; }
    public void setTransferType(String t)        { this.transferType = t; }

    public BigDecimal getAmount()                 { return amount; }
    public void setAmount(BigDecimal a)          { this.amount = a; }

    public BigDecimal getFee()                    { return fee; }
    public void setFee(BigDecimal f)             { this.fee = f; }

    public String getDescription()                { return description; }
    public void setDescription(String d)         { this.description = d; }

    public String getSwiftCode()                  { return swiftCode; }
    public void setSwiftCode(String s)           { this.swiftCode = s; }

    public String getBankName()                   { return bankName; }
    public void setBankName(String b)            { this.bankName = b; }

    public String getCountry()                    { return country; }
    public void setCountry(String c)             { this.country = c; }

    public String getBeneficiaryName()            { return beneficiaryName; }
    public void setBeneficiaryName(String b)     { this.beneficiaryName = b; }

    public String getStatus()                     { return status; }
    public void setStatus(String s)              { this.status = s; }

    public Integer getManagerId()                 { return managerId; }
    public void setManagerId(Integer m)          { this.managerId = m; }

    public String getManagerName()                { return managerName; }
    public void setManagerName(String m)         { this.managerName = m; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)    { this.createdAt = t; }

    public String getSenderAccountNumber()        { return senderAccountNumber; }
    public void setSenderAccountNumber(String n) { this.senderAccountNumber = n; }

    public String getSenderName()                 { return senderName; }
    public void setSenderName(String n)          { this.senderName = n; }
}