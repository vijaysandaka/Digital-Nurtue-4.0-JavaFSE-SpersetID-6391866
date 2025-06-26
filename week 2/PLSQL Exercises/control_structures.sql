-- PL/SQL Control Structures Exercises
-- Bank Management System - Control Flow Examples

-- Sample table structures (for reference)
/*
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    balance NUMBER(15,2),
    is_vip CHAR(1) DEFAULT 'N'
);

CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    loan_amount NUMBER(15,2),
    interest_rate NUMBER(5,2),
    due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
*/

-- Apply discount to loan interest rates for customers above 60
DECLARE
    CURSOR c_senior_customers IS
        SELECT c.customer_id, c.name, c.age, l.loan_id, l.interest_rate
        FROM customers c
        INNER JOIN loans l ON c.customer_id = l.customer_id
        WHERE c.age > 60;
    
    v_customer_id customers.customer_id%TYPE;
    v_customer_name customers.name%TYPE;
    v_age customers.age%TYPE;
    v_loan_id loans.loan_id%TYPE;
    v_current_rate loans.interest_rate%TYPE;
    v_new_rate loans.interest_rate%TYPE;
    v_discount_rate CONSTANT NUMBER := 1.0; -- 1% discount
    v_customers_processed NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Senior Citizen Loan Discount Processing');
    DBMS_OUTPUT.PUT_LINE('Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    FOR rec IN c_senior_customers LOOP
        v_customer_id := rec.customer_id;
        v_customer_name := rec.name;
        v_age := rec.age;
        v_loan_id := rec.loan_id;
        v_current_rate := rec.interest_rate;
        
        v_new_rate := v_current_rate - v_discount_rate;
        
        IF v_new_rate < 0 THEN
            v_new_rate := 0;
        END IF;
        
        UPDATE loans 
        SET interest_rate = v_new_rate
        WHERE loan_id = v_loan_id;
        
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_customer_name || ' (Age: ' || v_age || ')');
        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || v_loan_id || ' Rate: ' || v_current_rate || '% -> ' || v_new_rate || '%');
        
        v_customers_processed := v_customers_processed + 1;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total processed: ' || v_customers_processed);
    DBMS_OUTPUT.PUT_LINE('Completed: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- Promote customers to VIP status based on balance
DECLARE
    CURSOR c_high_balance_customers IS
        SELECT customer_id, name, balance, is_vip
        FROM customers
        WHERE balance > 10000
        AND is_vip = 'N'; -- Only process non-VIP customers
    
    v_customer_id customers.customer_id%TYPE;
    v_customer_name customers.name%TYPE;
    v_balance customers.balance%TYPE;
    v_vip_threshold CONSTANT NUMBER := 10000;
    v_customers_promoted NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('VIP Status Promotion Processing');
    DBMS_OUTPUT.PUT_LINE('Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    FOR rec IN c_high_balance_customers LOOP
        v_customer_id := rec.customer_id;
        v_customer_name := rec.name;
        v_balance := rec.balance;
        
        UPDATE customers 
        SET is_vip = 'Y'
        WHERE customer_id = v_customer_id;
        
        DBMS_OUTPUT.PUT_LINE('Promoted: ' || v_customer_name || ' (Balance: $' || TO_CHAR(v_balance, '999,999,999.99') || ')');
        
        v_customers_promoted := v_customers_promoted + 1;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total promoted: ' || v_customers_promoted);
    DBMS_OUTPUT.PUT_LINE('Completed: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- Send reminders for loans due within next 30 days
DECLARE
    CURSOR c_due_loans IS
        SELECT c.customer_id, c.name, c.age, l.loan_id, l.loan_amount, l.due_date,
               (l.due_date - SYSDATE) AS days_until_due
        FROM customers c
        INNER JOIN loans l ON c.customer_id = l.customer_id
        WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30
        ORDER BY l.due_date;
    
    v_customer_id customers.customer_id%TYPE;
    v_customer_name customers.name%TYPE;
    v_customer_age customers.age%TYPE;
    v_loan_id loans.loan_id%TYPE;
    v_loan_amount loans.loan_amount%TYPE;
    v_due_date loans.due_date%TYPE;
    v_days_until_due NUMBER;
    v_reminders_sent NUMBER := 0;
    v_urgency_level VARCHAR2(10);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Loan Payment Reminder System');
    DBMS_OUTPUT.PUT_LINE('Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    FOR rec IN c_due_loans LOOP
        v_customer_id := rec.customer_id;
        v_customer_name := rec.name;
        v_customer_age := rec.age;
        v_loan_id := rec.loan_id;
        v_loan_amount := rec.loan_amount;
        v_due_date := rec.due_date;
        v_days_until_due := rec.days_until_due;
        
        IF v_days_until_due <= 7 THEN
            v_urgency_level := 'URGENT';
        ELSIF v_days_until_due <= 15 THEN
            v_urgency_level := 'HIGH';
        ELSE
            v_urgency_level := 'MEDIUM';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('REMINDER (' || v_urgency_level || ')');
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_customer_name || ' (Age: ' || v_customer_age || ')');
        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || v_loan_id || ' Amount: $' || TO_CHAR(v_loan_amount, '999,999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Due Date: ' || TO_CHAR(v_due_date, 'DD-MON-YYYY') || ' (' || FLOOR(v_days_until_due) || ' days)');
        DBMS_OUTPUT.PUT_LINE('');
        
        v_reminders_sent := v_reminders_sent + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total reminders sent: ' || v_reminders_sent);
    
    IF v_reminders_sent = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No loans due within 30 days');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- Combined reporting for all control structures
DECLARE
    v_total_senior_customers NUMBER;
    v_total_vip_customers NUMBER;
    v_total_due_loans NUMBER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Bank Summary Report');
    DBMS_OUTPUT.PUT_LINE('Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    SELECT COUNT(DISTINCT c.customer_id)
    INTO v_total_senior_customers
    FROM customers c
    INNER JOIN loans l ON c.customer_id = l.customer_id
    WHERE c.age > 60;
    
    SELECT COUNT(*)
    INTO v_total_vip_customers
    FROM customers
    WHERE is_vip = 'Y';
    
    SELECT COUNT(*)
    INTO v_total_due_loans
    FROM loans
    WHERE due_date BETWEEN SYSDATE AND SYSDATE + 30;
    
    DBMS_OUTPUT.PUT_LINE('Senior customers with loans: ' || v_total_senior_customers);
    DBMS_OUTPUT.PUT_LINE('VIP customers: ' || v_total_vip_customers);
    DBMS_OUTPUT.PUT_LINE('Loans due within 30 days: ' || v_total_due_loans);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/ 