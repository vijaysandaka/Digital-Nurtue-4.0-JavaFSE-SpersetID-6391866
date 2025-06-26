# PL/SQL Bank Management System Exercises

This repository contains complete implementations for PL/SQL control structures and stored procedures exercises for a bank management system.

## Files Overview

- **`control_structures.sql`** - Contains all control structure exercises (loops, conditions, cursors)
- **`stored_procedures.sql`** - Contains all stored procedure implementations
- **`README.md`** - This documentation file

## Table Structure

Before running the exercises, you'll need to create the following tables:

```sql
-- Customers table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    balance NUMBER(15,2),
    is_vip CHAR(1) DEFAULT 'N'
);

-- Accounts table  
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    account_type VARCHAR2(20), -- 'SAVINGS', 'CHECKING', 'LOAN'
    balance NUMBER(15,2),
    interest_rate NUMBER(5,2),
    created_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    loan_amount NUMBER(15,2),
    interest_rate NUMBER(5,2),
    due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Employees table
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department VARCHAR2(50),
    salary NUMBER(15,2),
    hire_date DATE
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    from_account_id NUMBER,
    to_account_id NUMBER,
    amount NUMBER(15,2),
    transaction_date DATE DEFAULT SYSDATE,
    transaction_type VARCHAR2(20), -- 'TRANSFER', 'DEPOSIT', 'WITHDRAWAL'
    description VARCHAR2(200)
);

-- Optional: Create sequence for transactions
CREATE SEQUENCE transactions_seq START WITH 1000 INCREMENT BY 1;
```

## Control Structures (`control_structures.sql`)

### Scenario 1: Senior Citizen Loan Discount
- **Purpose**: Apply 1% discount to loan interest rates for customers above 60 years old
- **Features**: 
  - Cursor-based iteration
  - Age validation
  - Interest rate calculation with safety checks
  - Detailed logging and summary reporting

### Scenario 2: VIP Status Promotion
- **Purpose**: Promote customers to VIP status if their balance exceeds $10,000
- **Features**:
  - Conditional processing
  - Balance threshold checking
  - Status update tracking
  - Comprehensive reporting

### Scenario 3: Loan Payment Reminders
- **Purpose**: Generate reminders for loans due within 30 days
- **Features**:
  - Date-based filtering
  - Urgency level classification (URGENT/HIGH/MEDIUM)
  - Personalized reminder messages
  - Summary statistics

### Additional Utility
- **Bank Summary Report**: Provides overview of senior customers, VIP customers, and pending loans

## Stored Procedures (`stored_procedures.sql`)

### 1. ProcessMonthlyInterest
```sql
EXEC ProcessMonthlyInterest;
```
- **Purpose**: Calculate and apply 1% monthly interest to all savings accounts
- **Features**:
  - Automatic interest calculation
  - Transaction logging
  - Balance updates
  - Comprehensive error handling

### 2. UpdateEmployeeBonus
```sql
EXEC UpdateEmployeeBonus('IT', 5.0);        -- 5% bonus to IT department
EXEC UpdateEmployeeBonus('Sales', 3.5);     -- 3.5% bonus to Sales department
```
- **Purpose**: Add performance-based bonus to employee salaries by department
- **Parameters**:
  - `p_department`: Department name (case-insensitive)
  - `p_bonus_percentage`: Bonus percentage (0-100)
- **Features**:
  - Input validation
  - Department-based processing
  - Salary calculation and updates
  - Detailed reporting

### 3. TransferFunds
```sql
EXEC TransferFunds(101, 102, 500.00);       -- Transfer $500 from account 101 to 102
```
- **Purpose**: Transfer money between accounts with validation and logging
- **Parameters**:
  - `p_from_account_id`: Source account ID
  - `p_to_account_id`: Destination account ID  
  - `p_amount`: Transfer amount
- **Features**:
  - Comprehensive input validation
  - Sufficient balance checking
  - Account locking for concurrency
  - Transaction logging
  - Atomic operations with rollback

### Additional Utility Procedures

#### CheckAccountBalance
```sql
EXEC CheckAccountBalance(101);
```
- Display detailed account information and current balance

#### GetTransactionHistory
```sql
EXEC GetTransactionHistory(101, 30);         -- Last 30 days
EXEC GetTransactionHistory(101);             -- Default: last 30 days
```
- Show transaction history for an account

## Usage Instructions

### 1. Setup Database
1. Create the required tables using the SQL DDL provided above
2. Insert sample data for testing
3. Create the transactions sequence (optional, but recommended)

### 2. Running Control Structures
```sql
-- Execute the entire control_structures.sql file in your SQL environment
@control_structures.sql

-- Or run individual blocks by copying and pasting them
```

### 3. Running Stored Procedures
```sql
-- First, create the procedures
@stored_procedures.sql

-- Then execute them
EXEC ProcessMonthlyInterest;
EXEC UpdateEmployeeBonus('IT', 5.0);
EXEC TransferFunds(101, 102, 500.00);
```

## Sample Data for Testing

```sql
-- Sample customers
INSERT INTO customers VALUES (1, 'John Smith', 65, 15000.00, 'N');
INSERT INTO customers VALUES (2, 'Jane Doe', 45, 25000.00, 'N');
INSERT INTO customers VALUES (3, 'Bob Johnson', 70, 8000.00, 'N');

-- Sample accounts
INSERT INTO accounts VALUES (101, 1, 'SAVINGS', 5000.00, 0.01, SYSDATE);
INSERT INTO accounts VALUES (102, 2, 'SAVINGS', 10000.00, 0.01, SYSDATE);
INSERT INTO accounts VALUES (103, 3, 'CHECKING', 3000.00, NULL, SYSDATE);

-- Sample loans
INSERT INTO loans VALUES (201, 1, 50000.00, 5.5, SYSDATE + 15);
INSERT INTO loans VALUES (202, 3, 25000.00, 6.0, SYSDATE + 45);

-- Sample employees
INSERT INTO employees VALUES (301, 'Alice Brown', 'IT', 75000.00, SYSDATE - 365);
INSERT INTO employees VALUES (302, 'Charlie Davis', 'Sales', 65000.00, SYSDATE - 200);
INSERT INTO employees VALUES (303, 'Diana Wilson', 'IT', 80000.00, SYSDATE - 500);
```

## Features Highlights

### Error Handling
- All procedures include comprehensive exception handling
- Automatic rollback on errors
- Descriptive error messages
- Input validation with custom error codes

### Transaction Management
- Proper COMMIT/ROLLBACK usage
- Atomic operations
- Row-level locking where appropriate
- Concurrency-safe implementations

### Reporting
- Detailed processing logs
- Summary statistics
- Formatted output with timestamps
- Professional presentation

### Best Practices
- Use of cursors for efficient data processing
- Anchored data types (`%TYPE`)
- Constants for configuration values
- Proper variable naming conventions
- Comprehensive documentation

## Troubleshooting

### Common Issues
1. **Table doesn't exist**: Ensure all required tables are created
2. **Sequence not found**: Create the transactions_seq sequence or modify the code to use alternative ID generation
3. **No data found**: Insert sample data before testing
4. **Permission errors**: Ensure your database user has necessary privileges

### Prerequisites
- Oracle Database 11g or higher
- DBMS_OUTPUT enabled in your SQL client
- Appropriate database privileges (CREATE, INSERT, UPDATE, DELETE)

## Extending the Code

The provided code serves as a solid foundation and can be extended with:
- Additional business rules
- More sophisticated error handling
- Audit trails
- Performance optimizations
- Additional utility procedures
- Web service integration

Feel free to modify and enhance these procedures according to your specific requirements! 
 