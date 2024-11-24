-- Create a table named EMPLOYEE with columns: empId, name, and dept
CREATE TABLE EMPLOYEE (
  empId INTEGER PRIMARY KEY,  -- Primary key to uniquely identify each employee
  name TEXT NOT NULL,         -- Name of the employee (cannot be NULL)
  dept TEXT NOT NULL          -- Department of the employee (cannot be NULL)
);

-- Disable automatic commits to manage transactions manually
SET autocommit = 0;

-- Begin a new transaction
BEGIN;

-- Insert employee records into the EMPLOYEE table
INSERT INTO EMPLOYEE VALUES (0001, 'Clark', 'Sales');      -- Add record for employee Clark in Sales
INSERT INTO EMPLOYEE VALUES (0002, 'Dave', 'Accounting'); -- Add record for employee Dave in Accounting
INSERT INTO EMPLOYEE VALUES (0003, 'Ava', 'Sales');       -- Add record for employee Ava in Sales

-- Commit the transaction to save the inserted data permanently
COMMIT;

-- Retrieve and display all records from the EMPLOYEE table
SELECT * FROM EMPLOYEE;

-- Create a savepoint named sp1 to mark a specific point in the transaction
SAVEPOINT sp1;

-- Delete the record of the employee with empId = 2
DELETE FROM EMPLOYEE WHERE empId = 2;

-- Retrieve and display all records from the EMPLOYEE table after the deletion
SELECT * FROM EMPLOYEE;

-- Roll back the transaction to the savepoint sp1
-- This restores the table to its state before the DELETE operation
ROLLBACK TO sp1;

-- Retrieve and display all records from the EMPLOYEE table after the rollback
SELECT * FROM EMPLOYEE;
