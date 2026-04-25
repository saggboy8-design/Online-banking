package com.gojjam.bank.model;

public class ExternalBank {

    private int id;
    private String bankName;
    private String bankCode;
    private String swiftCode;
    private String country;
    private boolean active;

    public ExternalBank() {}

    public int getId()               { return id; }
    public void setId(int id)       { this.id = id; }

    public String getBankName()      { return bankName; }
    public void setBankName(String b){ this.bankName = b; }

    public String getBankCode()      { return bankCode; }
    public void setBankCode(String b){ this.bankCode = b; }

    public String getSwiftCode()     { return swiftCode; }
    public void setSwiftCode(String s){ this.swiftCode = s; }

    public String getCountry()       { return country; }
    public void setCountry(String c) { this.country = c; }

    public boolean isActive()        { return active; }
    public void setActive(boolean a) { this.active = a; }
}