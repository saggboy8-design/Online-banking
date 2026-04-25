package com.gojjam.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Deposit {

    private int id;
    private int accountId;
    private String depositType;      // INTERNAL | EXTERNAL | INTERNATIONAL
    private BigDecimal amount;
    private BigDecimal fee;
    private String sourceName;
    private String sourceAccount;
    private String swiftCode;
    private String bankName;
    private String country;
    private String iban;
    private String beneficiaryName;
    private String status;           // PENDING | SUCCESS | REJECTED
    private Integer managerId;
    private String managerName;
    private String notes;
    private LocalDateTime createdAt;

    // joined
    private String accountNumber;
    private String ownerName;

    public Deposit() {}

    public int getId()                            { return id; }
    public void setId(int id)                    { this.id = id; }

    public int getAccountId()                     { return accountId; }
    public void setAccountId(int a)              { this.accountId = a; }

    public String getDepositType()                { return depositType; }
    public void setDepositType(String t)         { this.depositType = t; }

    public BigDecimal getAmount()                 { return amount; }
    public void setAmount(BigDecimal a)          { this.amount = a; }

    public BigDecimal getFee()                    { return fee; }
    public void setFee(BigDecimal f)             { this.fee = f; }

    public String getSourceName()                 { return sourceName; }
    public void setSourceName(String s)          { this.sourceName = s; }

    public String getSourceAccount()              { return sourceAccount; }
    public void setSourceAccount(String s)       { this.sourceAccount = s; }

    public String getSwiftCode()                  { return swiftCode; }
    public void setSwiftCode(String s)           { this.swiftCode = s; }

    public String getBankName()                   { return bankName; }
    public void setBankName(String b)            { this.bankName = b; }

    public String getCountry()                    { return country; }
    public void setCountry(String c)             { this.country = c; }

    public String getIban()                       { return iban; }
    public void setIban(String i)                { this.iban = i; }

    public String getBeneficiaryName()            { return beneficiaryName; }
    public void setBeneficiaryName(String b)     { this.beneficiaryName = b; }

    public String getStatus()                     { return status; }
    public void setStatus(String s)              { this.status = s; }

    public Integer getManagerId()                 { return managerId; }
    public void setManagerId(Integer m)          { this.managerId = m; }

    public String getManagerName()                { return managerName; }
    public void setManagerName(String m)         { this.managerName = m; }

    public String getNotes()                      { return notes; }
    public void setNotes(String n)               { this.notes = n; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)    { this.createdAt = t; }

    public String getAccountNumber()              { return accountNumber; }
    public void setAccountNumber(String n)       { this.accountNumber = n; }

    public String getOwnerName()                  { return ownerName; }
    public void setOwnerName(String n)           { this.ownerName = n; }
}