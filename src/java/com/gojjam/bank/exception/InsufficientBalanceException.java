package com.gojjam.bank.exception;

public class InsufficientBalanceException extends BankingException {

    public InsufficientBalanceException() {
        super("Transaction failed due to insufficient balance.");
    }
}