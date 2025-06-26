-- PL/SQL Stored Procedures Exercises
-- Bank Management System - Procedure Implementations

-- Table structures
/*
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    balance NUMBER(15,2),
    is_vip CHAR(1) DEFAULT 'N'
);

CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    account_type VARCHAR2(20), -- 'SAVINGS', 'CHECKING', 'LOAN'
    balance NUMBER(15,2),
    interest_rate NUMBER(5,2),
    created_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department VARCHAR2(50),
    salary NUMBER(15,2),
    hire_date DATE
);

CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    from_account_id NUMBER,
    to_account_id NUMBER,
    amount NUMBER(15,2),
    transaction_date DATE DEFAULT SYSDATE,
    transaction_type VARCHAR2(20), -- 'TRANSFER', 'DEPOSIT', 'WITHDRAWAL'
    description VARCHAR2(200)
);
*/

-- Process monthly interest for all savings accounts
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
AS
    CURSOR c_savings_accounts IS
        SELECT account_id, customer_id, balance, interest_rate
        FROM accounts
        WHERE account_type = 'SAVINGS'
        AND balance > 0;
    
    v_account_id accounts.account_id%TYPE;
    v_customer_id accounts.customer_id%TYPE;
    v_current_balance accounts.balance%TYPE;
    v_interest_rate accounts.interest_rate%TYPE;
    v_interest_amount NUMBER(15,2);
    v_new_balance NUMBER(15,2);
    v_accounts_processed NUMBER := 0;
    v_total_interest_paid NUMBER(15,2) := 0;
    v_monthly_interest_rate CONSTANT NUMBER := 0.01; -- 1% monthly interest
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Monthly Interest Processing');
    DBMS_OUTPUT.PUT_LINE('Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    FOR rec IN c_savings_accounts LOOP
        v_account_id := rec.account_id;
        v_customer_id := rec.customer_id;
        v_current_balance := rec.balance;
        v_interest_rate := NVL(rec.interest_rate, v_monthly_interest_rate);
        
        v_interest_amount := v_current_balance * v_interest_rate;
        v_new_balance := v_current_balance + v_interest_amount;
        
        UPDATE accounts 
        SET balance = v_new_balance
        WHERE account_id = v_account_id;
        
        INSERT INTO transactions (
            transaction_id,
            to_account_id,
            amount,
            transaction_type,
            description
        ) VALUES (
            transactions_seq.NEXTVAL,
            v_account_id,
            v_interest_amount,
            'DEPOSIT',
            'Monthly interest - ' || TO_CHAR(SYSDATE, 'MON-YYYY')
        );
        
        DBMS_OUTPUT.PUT_LINE('Account ' || v_account_id || ': $' || TO_CHAR(v_current_balance, '999,999,999.99') || 
                           ' -> $' || TO_CHAR(v_new_balance, '999,999,999.99'));
        
        v_accounts_processed := v_accounts_processed + 1;
        v_total_interest_paid := v_total_interest_paid + v_interest_amount;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Accounts processed: ' || v_accounts_processed);
    DBMS_OUTPUT.PUT_LINE('Total interest: $' || TO_CHAR(v_total_interest_paid, '999,999,999.99'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END ProcessMonthlyInterest;
/

-- Update employee bonus based on performance
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department IN VARCHAR2,
    p_bonus_percentage IN NUMBER
)
AS
    CURSOR c_department_employees IS
        SELECT employee_id, name, salary
        FROM employees
        WHERE UPPER(department) = UPPER(p_department);
    
    v_employee_id employees.employee_id%TYPE;
    v_employee_name employees.name%TYPE;
    v_current_salary employees.salary%TYPE;
    v_bonus_amount NUMBER(15,2);
    v_new_salary NUMBER(15,2);
    v_employees_updated NUMBER := 0;
    v_total_bonus_paid NUMBER(15,2) := 0;
    
BEGIN
    IF p_department IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Department cannot be null');
    END IF;
    
    IF p_bonus_percentage IS NULL OR p_bonus_percentage < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Bonus percentage must be positive');
    END IF;
    
    IF p_bonus_percentage > 100 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Bonus percentage cannot exceed 100%');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Employee Bonus Update');
    DBMS_OUTPUT.PUT_LINE('Department: ' || UPPER(p_department) || ' Bonus: ' || p_bonus_percentage || '%');
    
    FOR rec IN c_department_employees LOOP
        v_employee_id := rec.employee_id;
        v_employee_name := rec.name;
        v_current_salary := rec.salary;
        
        v_bonus_amount := v_current_salary * (p_bonus_percentage / 100);
        v_new_salary := v_current_salary + v_bonus_amount;
        
        UPDATE employees 
        SET salary = v_new_salary
        WHERE employee_id = v_employee_id;
        
        DBMS_OUTPUT.PUT_LINE(v_employee_name || ': $' || TO_CHAR(v_current_salary, '999,999,999.99') || 
                           ' -> $' || TO_CHAR(v_new_salary, '999,999,999.99'));
        
        v_employees_updated := v_employees_updated + 1;
        v_total_bonus_paid := v_total_bonus_paid + v_bonus_amount;
    END LOOP;
    
    IF v_employees_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found in department: ' || p_department);
        RETURN;
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Employees updated: ' || v_employees_updated);
    DBMS_OUTPUT.PUT_LINE('Total bonus: $' || TO_CHAR(v_total_bonus_paid, '999,999,999.99'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END UpdateEmployeeBonus;
/

-- Transfer funds between accounts
CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from_account_id IN NUMBER,
    p_to_account_id IN NUMBER,
    p_amount IN NUMBER
)
AS
    v_from_balance accounts.balance%TYPE;
    v_to_balance accounts.balance%TYPE;
    v_from_customer_id accounts.customer_id%TYPE;
    v_to_customer_id accounts.customer_id%TYPE;
    v_transaction_id NUMBER;
    
BEGIN
    IF p_from_account_id IS NULL OR p_to_account_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Account IDs cannot be null');
    END IF;
    
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Transfer amount must be positive');
    END IF;
    
    IF p_from_account_id = p_to_account_id THEN
        RAISE_APPLICATION_ERROR(-20006, 'Cannot transfer to same account');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Fund Transfer Processing');
    DBMS_OUTPUT.PUT_LINE('From: ' || p_from_account_id || ' To: ' || p_to_account_id || 
                        ' Amount: $' || TO_CHAR(p_amount, '999,999,999.99'));
    
    BEGIN
        SELECT balance, customer_id
        INTO v_from_balance, v_from_customer_id
        FROM accounts
        WHERE account_id = p_from_account_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Source account not found');
    END;
    
    BEGIN
        SELECT balance, customer_id
        INTO v_to_balance, v_to_customer_id
        FROM accounts
        WHERE account_id = p_to_account_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20008, 'Destination account not found');
    END;
    
    IF v_from_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20009, 'Insufficient funds');
    END IF;
    
    UPDATE accounts 
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;
    
    UPDATE accounts 
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;
    
    SELECT NVL(MAX(transaction_id), 0) + 1 
    INTO v_transaction_id 
    FROM transactions;
    
    INSERT INTO transactions (
        transaction_id,
        from_account_id,
        to_account_id,
        amount,
        transaction_type,
        description
    ) VALUES (
        v_transaction_id,
        p_from_account_id,
        p_to_account_id,
        p_amount,
        'TRANSFER',
        'Transfer from ' || p_from_account_id || ' to ' || p_to_account_id
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Transfer successful. Transaction ID: ' || v_transaction_id);
    DBMS_OUTPUT.PUT_LINE('New balances - From: $' || TO_CHAR(v_from_balance - p_amount, '999,999,999.99') || 
                        ' To: $' || TO_CHAR(v_to_balance + p_amount, '999,999,999.99'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END TransferFunds;
/

-- Display account balance
CREATE OR REPLACE PROCEDURE CheckAccountBalance(
    p_account_id IN NUMBER
)
AS
    v_balance accounts.balance%TYPE;
    v_customer_id accounts.customer_id%TYPE;
    v_account_type accounts.account_type%TYPE;
    v_customer_name customers.name%TYPE;
    
BEGIN
    SELECT a.balance, a.customer_id, a.account_type, c.name
    INTO v_balance, v_customer_id, v_account_type, v_customer_name
    FROM accounts a
    JOIN customers c ON a.customer_id = c.customer_id
    WHERE a.account_id = p_account_id;
    
    DBMS_OUTPUT.PUT_LINE('Account Balance Inquiry');
    DBMS_OUTPUT.PUT_LINE('Account: ' || p_account_id || ' Customer: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('Type: ' || v_account_type || ' Balance: $' || TO_CHAR(v_balance, '999,999,999.99'));
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Account not found: ' || p_account_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END CheckAccountBalance;
/

-- Display transaction history
CREATE OR REPLACE PROCEDURE GetTransactionHistory(
    p_account_id IN NUMBER,
    p_days_back IN NUMBER DEFAULT 30
)
AS
    CURSOR c_transactions IS
        SELECT transaction_id, from_account_id, to_account_id, amount, 
               transaction_date, transaction_type, description
        FROM transactions
        WHERE (from_account_id = p_account_id OR to_account_id = p_account_id)
        AND transaction_date >= SYSDATE - p_days_back
        ORDER BY transaction_date DESC;
    
    v_transaction_count NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Transaction History - Account: ' || p_account_id);
    
    FOR rec IN c_transactions LOOP
        v_transaction_count := v_transaction_count + 1;
        
        DBMS_OUTPUT.PUT_LINE(v_transaction_count || '. ID: ' || rec.transaction_id || 
                           ' Date: ' || TO_CHAR(rec.transaction_date, 'DD-MON-YY'));
        DBMS_OUTPUT.PUT_LINE('   Type: ' || rec.transaction_type || 
                           ' Amount: $' || TO_CHAR(rec.amount, '999,999,999.99'));
        
        IF rec.from_account_id = p_account_id THEN
            DBMS_OUTPUT.PUT_LINE('   Direction: OUT to ' || rec.to_account_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('   Direction: IN from ' || rec.from_account_id);
        END IF;
    END LOOP;
    
    IF v_transaction_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total transactions: ' || v_transaction_count);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END GetTransactionHistory;
/

-- Example usage scripts (commented out - uncomment to test)
/*
EXEC ProcessMonthlyInterest;
EXEC UpdateEmployeeBonus('IT', 5.0);
EXEC UpdateEmployeeBonus('Sales', 3.5);
EXEC TransferFunds(101, 102, 500.00);
EXEC CheckAccountBalance(101);
EXEC GetTransactionHistory(101, 30);
*/ 