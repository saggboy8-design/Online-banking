-- ============================================================
-- Gojjam International Bank – Database Schema
-- Engine: MySQL InnoDB | Isolation: REPEATABLE READ
-- ============================================================

CREATE DATABASE IF NOT EXISTS gojjam_bank
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gojjam_bank;

SET FOREIGN_KEY_CHECKS = 0;

-- ─────────────────────────────────────────────────────────────
-- ROLES
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roles (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    role_name ENUM('CUSTOMER','MANAGER','ADMIN') NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO roles (role_name) VALUES ('CUSTOMER'),('MANAGER'),('ADMIN')
ON DUPLICATE KEY UPDATE role_name = VALUES(role_name);

-- ─────────────────────────────────────────────────────────────
-- USERS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    username         VARCHAR(150) NOT NULL UNIQUE,
    password_hash    VARCHAR(255) NOT NULL,
    full_name        VARCHAR(200) NOT NULL,
    email            VARCHAR(150) NOT NULL UNIQUE,
    phone            VARCHAR(20)  NOT NULL,
    date_of_birth    DATE         NOT NULL,
    national_id_number VARCHAR(50) NOT NULL UNIQUE,
    role_id          INT          NOT NULL,
    status           ENUM('ACTIVE','LOCKED','PENDING','REJECTED') DEFAULT 'PENDING',
    is_session_active BOOLEAN     DEFAULT FALSE,
    current_session_id VARCHAR(255),
    created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email    (email),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- ACCOUNTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS accounts (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT            NOT NULL UNIQUE,
    account_number VARCHAR(20)    NOT NULL UNIQUE,
    balance        DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    account_type   ENUM('SAVINGS','CURRENT') DEFAULT 'SAVINGS',
    kyc_status     ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
    approved_by    INT,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_account_number (account_number),
    INDEX idx_user_id        (user_id),
    FOREIGN KEY (user_id)     REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TRANSACTIONS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS transactions (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT            NOT NULL,
    transaction_type ENUM('DEPOSIT','WITHDRAWAL','TRANSFER_IN','TRANSFER_OUT',
                          'BILL_PAYMENT','LOAN_CREDIT','REVERSAL','SCHEDULED') NOT NULL,
    amount           DECIMAL(15,2)  NOT NULL,
    fee              DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    balance_after    DECIMAL(15,2)  NOT NULL,
    description      VARCHAR(500),
    reference_number VARCHAR(60)    UNIQUE,
    status           ENUM('PENDING','SUCCESS','FAILED','REVERSED') DEFAULT 'SUCCESS',
    reversed_by      INT,
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_account_id       (account_id),
    INDEX idx_transaction_date (created_at),
    FOREIGN KEY (account_id)  REFERENCES accounts(id)     ON DELETE RESTRICT,
    FOREIGN KEY (reversed_by) REFERENCES users(id)        ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- DEPOSITS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS deposits (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT            NOT NULL,
    deposit_type     ENUM('INTERNAL','EXTERNAL','INTERNATIONAL') NOT NULL,
    amount           DECIMAL(15,2)  NOT NULL,
    fee              DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    source_name      VARCHAR(200),
    source_account   VARCHAR(50),
    swift_code       VARCHAR(20),
    bank_name        VARCHAR(200),
    country          VARCHAR(100),
    iban             VARCHAR(50),
    beneficiary_name VARCHAR(200),
    status           ENUM('PENDING','SUCCESS','REJECTED') DEFAULT 'PENDING',
    manager_id       INT,
    notes            VARCHAR(500),
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id)  REFERENCES accounts(id) ON DELETE RESTRICT,
    FOREIGN KEY (manager_id)  REFERENCES users(id)    ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TRANSFERS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS transfers (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    sender_account_id  INT            NOT NULL,
    receiver_account   VARCHAR(50)    NOT NULL,
    transfer_type      ENUM('INTERNAL','EXTERNAL','INTERNATIONAL') NOT NULL,
    amount             DECIMAL(15,2)  NOT NULL,
    fee                DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    description        VARCHAR(500),
    swift_code         VARCHAR(20),
    bank_name          VARCHAR(200),
    country            VARCHAR(100),
    beneficiary_name   VARCHAR(200),
    status             ENUM('PENDING','SUCCESS','FAILED','REJECTED') DEFAULT 'PENDING',
    manager_id         INT,
    created_at         TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_account_id) REFERENCES accounts(id) ON DELETE RESTRICT,
    FOREIGN KEY (manager_id)        REFERENCES users(id)    ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- LOANS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loans (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT            NOT NULL,
    amount           DECIMAL(15,2)  NOT NULL,
    purpose          VARCHAR(500)   NOT NULL,
    duration_months  INT            NOT NULL,
    interest_rate    DECIMAL(5,2)   NOT NULL DEFAULT 12.50,
    monthly_emi      DECIMAL(15,2),
    total_payable    DECIMAL(15,2),
    outstanding_balance DECIMAL(15,2),
    status           ENUM('PENDING','APPROVED','REJECTED','DISBURSED') DEFAULT 'PENDING',
    manager_id       INT,
    rejection_reason VARCHAR(500),
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    approved_at      TIMESTAMP      NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE RESTRICT,
    FOREIGN KEY (manager_id) REFERENCES users(id)    ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- COMPLAINTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS complaints (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT         NOT NULL,
    category     VARCHAR(100) NOT NULL,
    description  TEXT        NOT NULL,
    status       ENUM('OPEN','IN_PROGRESS','RESOLVED','CLOSED') DEFAULT 'OPEN',
    response     TEXT,
    responded_by INT,
    created_at   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)      REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (responded_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- AUDIT LOGS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_logs (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    action      VARCHAR(1000) NOT NULL,
    ip_address  VARCHAR(50),
    old_value   TEXT,
    new_value   TEXT,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id   (user_id),
    INDEX idx_created   (created_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- SCHEDULED PAYMENTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS scheduled_payments (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT            NOT NULL,
    payment_type     ENUM('ELECTRICITY','WATER','INTERNET','MOBILE','SCHOOL_FEES','TRANSFER') NOT NULL,
    amount           DECIMAL(15,2)  NOT NULL,
    fee              DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    recipient        VARCHAR(200)   NOT NULL,
    reference_number VARCHAR(100),
    frequency        ENUM('ONE_TIME','WEEKLY','MONTHLY') NOT NULL,
    scheduled_date   DATETIME       NOT NULL,
    next_execution   DATETIME,
    last_executed    DATETIME,
    status           ENUM('PENDING','SUCCESS','FAILED','CANCELLED') DEFAULT 'PENDING',
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- EXTERNAL BANKS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS external_banks (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    bank_name  VARCHAR(200) NOT NULL,
    bank_code  VARCHAR(50)  NOT NULL UNIQUE,
    swift_code VARCHAR(20),
    country    VARCHAR(100) NOT NULL,
    is_active  BOOLEAN      DEFAULT TRUE,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- BILL PAYMENTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bill_payments (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT            NOT NULL,
    bill_type        ENUM('ELECTRICITY','WATER','INTERNET','MOBILE','SCHOOL_FEES') NOT NULL,
    amount           DECIMAL(15,2)  NOT NULL,
    fee              DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    reference_number VARCHAR(100)   NOT NULL,
    provider_name    VARCHAR(200)   NOT NULL,
    status           ENUM('PENDING','SUCCESS','FAILED') DEFAULT 'SUCCESS',
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- LOGIN ATTEMPTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS login_attempts (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(150) NOT NULL,
    ip_address   VARCHAR(50),
    success      BOOLEAN      NOT NULL DEFAULT FALSE,
    attempt_time TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username_time (username, attempt_time)
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- PASSWORD RESET ATTEMPTS
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS password_reset_attempts (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(150) NOT NULL,
    ip_address   VARCHAR(50),
    success      BOOLEAN      DEFAULT FALSE,
    attempt_time TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- SYSTEM CONFIG
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS system_config (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    config_key   VARCHAR(100) NOT NULL UNIQUE,
    config_value VARCHAR(500) NOT NULL,
    description  VARCHAR(500),
    updated_by   INT,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ─────────────────────────────────────────────────────────────
-- SEED: System Config
-- ─────────────────────────────────────────────────────────────
INSERT INTO system_config (config_key, config_value, description) VALUES
('internal_transfer_fee',      '25.00',    'Fee for internal transfers (ETB)'),
('external_transfer_fee',      '75.00',    'Fee for external bank transfers (ETB)'),
('international_transfer_fee', '200.00',   'Fee for SWIFT/international transfers (ETB)'),
('bill_payment_fee',           '10.00',    'Fee for bill payments (ETB)'),
('loan_interest_rate',         '12.50',    'Annual loan interest rate (%)'),
('max_transfer_limit',         '500000.00','Maximum single transfer limit (ETB)'),
('max_daily_transactions',     '20',       'Maximum transactions per day per account'),
('internal_deposit_fee',       '0.00',     'Fee for internal deposits (ETB)'),
('external_deposit_fee',       '50.00',    'Fee for external deposits (ETB)')
ON DUPLICATE KEY UPDATE config_value = VALUES(config_value);

-- ─────────────────────────────────────────────────────────────
-- SEED: External Banks
-- ─────────────────────────────────────────────────────────────
INSERT INTO external_banks (bank_name, bank_code, swift_code, country) VALUES
('Commercial Bank of Ethiopia', 'CBE', 'CBETETAA', 'Ethiopia'),
('Awash International Bank',    'AIB', 'AWINETAA', 'Ethiopia'),
('Dashen Bank',                 'DSH', 'DASHETAA', 'Ethiopia'),
('Abyssinia Bank',              'ABY', 'ABYSETAA', 'Ethiopia')
ON DUPLICATE KEY UPDATE bank_name = VALUES(bank_name);

-- ─────────────────────────────────────────────────────────────
-- SEED: Default Users
-- IMPORTANT: Run sql/HashGenerator.java first, then replace the
-- hash placeholders below with the generated BCrypt hashes.
-- ─────────────────────────────────────────────────────────────

-- Admin user (password: admin123)
INSERT INTO users (username, password_hash, full_name, email, phone,
                   date_of_birth, national_id_number, role_id, status)
VALUES (
    'admin@gmail.com',
    '$2a$10$h07KsKaVWpC0gCk4f..oQuGIbBOqJbySpVPoWu/7c4jtRhA1wRNOi',
    'System Administrator',
    'admin@gojjambank.com',
    '+251911000001',
    '1985-01-15',
    'ETH-ADMIN-0001',
    (SELECT id FROM roles WHERE role_name='ADMIN'),
    'ACTIVE'
) ON DUPLICATE KEY UPDATE status='ACTIVE';

-- Manager user (password: manager123)
INSERT INTO users (username, password_hash, full_name, email, phone,
                   date_of_birth, national_id_number, role_id, status)
VALUES (
    'manager@gmail.com',
    '$2a$10$u/Zn29vI4rL4SPIWWuh6QOApxq8LWUWBcqHH3T.KTj44.d8oI/DZe',
    'Branch Manager',
    'manager@gojjambank.com',
    '+251911000002',
    '1988-06-20',
    'ETH-MGR-0001',
    (SELECT id FROM roles WHERE role_name='MANAGER'),
    'ACTIVE'
) ON DUPLICATE KEY UPDATE status='ACTIVE';

-- Customer user (password: customer123)
INSERT INTO users (username, password_hash, full_name, email, phone,
                   date_of_birth, national_id_number, role_id, status)
VALUES (
    'customer@gmail.com',
    '$2a$10$WWQtrEPfr0tNaywEJ3lfYOT5EbqfpsJx43SSfBgo0r6/yvvN2Y9LG',
    'Test Customer',
    'customer@gojjambank.com',
    '+251911000003',
    '1995-03-10',
    'ETH-CUST-0001',
    (SELECT id FROM roles WHERE role_name='CUSTOMER'),
    'ACTIVE'
) ON DUPLICATE KEY UPDATE status='ACTIVE';

-- Create account for customer
INSERT INTO accounts (user_id, account_number, balance, kyc_status, approved_by)
SELECT u.id, 'ACC1000000001', 10000.00, 'APPROVED',
       (SELECT id FROM users WHERE username='admin@gmail.com')
FROM users u WHERE u.username='customer@gmail.com'
ON DUPLICATE KEY UPDATE balance=balance;