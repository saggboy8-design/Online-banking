package com.gojjam.bank.model;

public class SystemConfig {

    private int id;
    private String configKey;
    private String configValue;
    private String description;
    private Integer updatedBy;
    private String updatedByName;

    public SystemConfig() {}

    public int getId()                          { return id; }
    public void setId(int id)                  { this.id = id; }

    public String getConfigKey()                { return configKey; }
    public void setConfigKey(String k)         { this.configKey = k; }

    public String getConfigValue()              { return configValue; }
    public void setConfigValue(String v)       { this.configValue = v; }

    public String getDescription()              { return description; }
    public void setDescription(String d)       { this.description = d; }

    public Integer getUpdatedBy()               { return updatedBy; }
    public void setUpdatedBy(Integer u)        { this.updatedBy = u; }

    public String getUpdatedByName()            { return updatedByName; }
    public void setUpdatedByName(String n)     { this.updatedByName = n; }
}