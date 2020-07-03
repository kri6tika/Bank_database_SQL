use bank_database;
CREATE TABLE emp (
  emp_id INT PRIMARY KEY ,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
  );
# Super_id is the id of an employee's supervisor.

CREATE TABLE bankbranch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  manager_id INT,
  mananger_start_date DATE,
  FOREIGN KEY(manager_id) REFERENCES emp(emp_id) ON DELETE SET NULL
);

Alter table emp 
add FOREIGN KEY(branch_id) 
REFERENCES bankbranch(branch_id) ON DELETE SET NULL;

 Alter table emp
 add FOREIGN KEY(super_id) 
 REFERENCES emp(emp_id) ON DELETE SET NULL;
 
 CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES bankbranch(branch_id) ON DELETE SET NULL
);

CREATE TABLE workswith (
  emp_id INT,
  client_id INT,
  loan_amount float8,
  deposit float8,
  PRIMARY KEY(emp_id, client_id), #combination of employee and client must be unique.
  FOREIGN KEY(emp_id) REFERENCES emp(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branchsupplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY (branch_id , supplier_name),
    FOREIGN KEY (branch_id)
        REFERENCES bankbranch (branch_id)
        ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------

-- Patparganj Branch
INSERT INTO emp VALUES(15,"Ramesh","Joshi","1972-05-06","M",15000,null,null);
INSERT INTO bankbranch VALUES(1001,'patparganj',15,'2010-05-17');
UPDATE emp
SET branch_id = 1001
WHERE emp_id= 15;
INSERT INTO emp VALUES(17,"Ram","Nath","1992-09-08","T",27000,15,1001);

-- Vikas marg Branch
INSERT INTO emp VALUES(16,"Geeta","Devi","1982-04-07","F",20000,15,null);
INSERT INTO bankbranch VALUES(1002,'vikas marg',16,'2015-06-25');
UPDATE emp
SET branch_id = 1002
WHERE emp_id= 16;
INSERT INTO emp VALUES(21,"Depali","Rana","1982-03-12","F",35000,16,1002);

-- Janak puri Branch
INSERT INTO emp VALUES(19,"Monika","Gupta","1989-07-10","F",18000,15,null);
INSERT INTO bankbranch VALUES(1003,'Janak puri',19,'2017-03-07');
UPDATE emp
SET branch_id = 1003
WHERE emp_id = 19;
INSERT INTO emp VALUES(22,"Rahul","Batra","1984-06-14","M",30000,19,1003);

-- Sonipath Branch
INSERT INTO emp VALUES(20,"Diksha","Aneja","1988-08-16","F",32000,15,null);
INSERT INTO bankbranch VALUES(1004,'Sonipath',22,'2013-11-20');
UPDATE emp
SET branch_id = 1004
WHERE emp_id = 20;
INSERT INTO emp VALUES(23,"Sunny","saha","1985-12-23","T",25000,20,1004);


-- BRANCH SUPPLIER
INSERT INTO branchsupplier VALUES(1001, 'Hammer Mill', 'Paper');
INSERT INTO branchsupplier VALUES(1001, 'Uni-ball', 'Writing Utensils');
INSERT INTO branchsupplier VALUES(1002, 'Patriot Paper', 'Paper');
INSERT INTO branchsupplier VALUES(1002, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branchsupplier VALUES(1003, 'Uni-ball', 'Writing Utensils');
INSERT INTO branchsupplier VALUES(1003, 'Hammer Mill', 'Paper');
INSERT INTO branchsupplier VALUES(1004, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 1002);
INSERT INTO client VALUES(401, 'Nikhil Chaturvedi',1002);
INSERT INTO client VALUES(402, 'Suresh Raina', 1003);
INSERT INTO client VALUES(403, 'Kamal Dev', 1003);
INSERT INTO client VALUES(404, 'Virat kohli', 1001);
INSERT INTO client VALUES(405, 'Akshay kumar', 1001);
INSERT INTO client VALUES(406, 'Govinda', 1004);

-- WORKS_WITH
INSERT INTO workswith VALUES(17, 400, 50000.5,12578.9);
INSERT INTO workswith VALUES(17, 401, 267000,10000);
INSERT INTO workswith VALUES(21, 402, 22500,10000);
INSERT INTO workswith VALUES(21, 403, 5000,25003.6);
INSERT INTO workswith VALUES(22, 403, 12000,3499.8);
INSERT INTO workswith VALUES(22, 404, 33000,7866.5);
INSERT INTO workswith VALUES(23, 405, 26000,12200);
INSERT INTO workswith VALUES(23, 406, 15000,6574.8);
INSERT INTO workswith VALUES(23, 406, 130000,7786.5);

-- Find all employees ordered by salary
SELECT *
from emp
ORDER BY salary DESC;

-- Find all employees ordered by sex then name
SELECT *
from emp
ORDER BY sex, first_name;

-- Find out the gender diversity of this bank
SELECT COUNT(sex), sex
FROM emp
GROUP BY sex;

-- Find all male employees at branch 1
SELECT *
FROM emp
WHERE sex = 'M' and branch_id = 1001;

-- Find all employee's id's and names who were born after 1982
SELECT emp_id, first_name, last_name, birth_day
FROM emp
WHERE birth_day >= 1982-01-01;


-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM emp;


-- Find the total loan provided by each employee
SELECT SUM(loan_amount), emp_id
FROM workswith
GROUP BY emp_id;

-- Find any branch suppliers who are in the Paper business
SELECT *
FROM branchsupplier
WHERE supplier_name LIKE '% Paper%';

-- Find a list of all clients & branch suppliers' names
SELECT client.client_name AS clients, client.branch_id AS Branch_ID
FROM client
UNION
SELECT branchsupplier.supplier_name, branchsupplier.branch_id
FROM branchsupplier;

#JOIN
SELECT emp.emp_id, emp.first_name, bankbranch.branch_name
FROM emp
RIGHT JOIN bankbranch    
ON emp.emp_id = bankbranch.manager_id;

-- Find the emp_id and the names of all employees who have sold over 50,000 amount of loan
SELECT workswith.emp_id, loan_amount
FROM workswith
WHERE (workswith.loan_amount > 100000);

SELECT emp.first_name, emp.last_name
FROM emp
WHERE emp.emp_id IN (SELECT workswith.emp_id
                          FROM workswith
                          WHERE workswith.loan_amount > 100000
                          );

                        
-- Find all clients who are handles by the branch that Monika Gupta with manager_id=19 manages
SELECT client.client_id, client.client_name
FROM client
WHERE client.branch_id = (SELECT bankbranch.branch_id
                          FROM bankbranch
                          WHERE bankbranch.manager_id = 19);


