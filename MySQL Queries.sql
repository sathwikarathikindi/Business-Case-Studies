
                    /*updated*/

use zomato_analysis;
drop table emp;
drop table dept;

/* Create the Dept Table as below */
CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    DNAME VARCHAR(20),
    LOC VARCHAR(20)
);

/* inserting an values into department table */

INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');
select * from dept;

/* 1.	Create the Employee Table as per the Below Data Provided */
CREATE TABLE EMP (
    EMPNO INT PRIMARY KEY,
    ENAME VARCHAR(20) NOT NULL,
    JOB VARCHAR(20) DEFAULT 'CLERK',
    MGR INT,
    HIREDATE DATE,
    SAL DECIMAL(10,2) CHECK (SAL > 0),
    COMM DECIMAL(10,2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);


INSERT INTO EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);


select * from emp;

/* 3.	List the Names and salary of the employee whose salary is greater than 1000 */
SELECT ENAME, SAL
FROM EMP
WHERE SAL > 1000;

/* 4.	List the details of the employees who have joined before end of September 81*/
SELECT *
FROM EMP
WHERE HIREDATE < '1981-09-30';

/*5.	List Employee Names having I as second character*/
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '_I%';

/*6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns*/
SELECT ENAME AS Employee_Name,
       SAL AS Salary,
       SAL*0.4 AS Allowance,
       SAL*0.1 AS PF,
       (SAL + SAL*0.4 - SAL*0.1) AS Net_Salary
FROM EMP;

/*7. List Employee Names with designations who does not report to anybody*/
SELECT ENAME, JOB
FROM EMP
WHERE MGR IS NULL;

/*8.	List Empno, Ename and Salary in the ascending order of salary.*/
SELECT EMPNO, ENAME, SAL
FROM EMP
ORDER BY SAL ASC;

/*9.	How many jobs are available in the Organization ?*/
SELECT COUNT(DISTINCT JOB) AS No_of_Jobs
FROM EMP;

/*10.	Determine total payable salary of salesman category*/
SELECT SUM(SAL) AS Total_Payable_Salary
FROM EMP
WHERE JOB = 'SALESMAN';

/*11.	List average monthly salary for each job within each department   */
SELECT DEPTNO, JOB, AVG(SAL) AS Avg_Salary
FROM EMP
GROUP BY DEPTNO, JOB;

/*12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.*/
SELECT E.ENAME, E.SAL, D.DNAME
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO;


/*13.	  Create the Job Grades Table as below*/
drop table job_grades;
CREATE TABLE JOB_GRADES (
    GRADE CHAR(1),
    LOSAL INT,
    HISAL INT
);
INSERT INTO JOB_GRADES VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);
select * from job_grades;

/*14.	Display the last name, salary and  Corresponding Grade.*/
SELECT E.ENAME, E.SAL, G.GRADE
FROM EMP E
JOIN JOB_GRADES G ON E.SAL BETWEEN G.LOSAL AND G.HISAL;

/*15.	Display the Emp name and the Manager name under whom the Employee works in the below format */
SELECT E.ENAME AS "Emp", M.ENAME AS "Mgr"
FROM EMP E
LEFT JOIN EMP M ON E.MGR = M.EMPNO;

/*16.	Display Empname and Total sal where Total Sal (sal + Comm)*/
SELECT ENAME, (SAL + IFNULL(COMM, 0)) AS Total_Salary
FROM EMP;

/*17.	Display Empname and Sal whose empno is a odd number*/
SELECT ENAME, SAL
FROM EMP
WHERE MOD(EMPNO, 2) <> 0;

/*18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department*/
SELECT ENAME,
       RANK() OVER (ORDER BY SAL DESC) AS Org_Rank,
       RANK() OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS Dept_Rank
FROM EMP;

/*19.	Display Top 3 Empnames based on their Salary*/
SELECT ENAME, SAL
FROM EMP
ORDER BY SAL DESC
LIMIT 3;

/*20.	 Display Empname who has highest Salary in Each Department.*/
SELECT DEPTNO, ENAME, SAL
FROM EMP
WHERE (DEPTNO, SAL) IN (
    SELECT DEPTNO, MAX(SAL)
    FROM EMP
    GROUP BY DEPTNO
);

/*1.	Create the Salespeople as below screenshot.*/
drop table orders;
drop table cust;
drop table salespeople;
CREATE TABLE SALESPEOPLE (
    SNUM INT PRIMARY KEY,
    SNAME VARCHAR(50),
    CITY VARCHAR(50),
    COMM DECIMAL(4,2)
);
INSERT INTO SALESPEOPLE VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New york', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);
select * from salespeople;

/*2.Create the Cust Table as below Screenshot */    	
CREATE TABLE CUST (
    CNUM INT PRIMARY KEY,
    CNAME VARCHAR(20),
    CITY VARCHAR(20),
    RATING INT,
    SNUM INT,
    FOREIGN KEY (SNUM) REFERENCES SALESPEOPLE(SNUM)
);
INSERT INTO CUST VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanni', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'San Jose', 200, 1007);
select * from cust;


/*3.	Create orders table as below screenshot.*/
CREATE TABLE ORDERS (
    ONUM INT PRIMARY KEY,
    AMT DECIMAL(10,2),
    ODATE DATE,
    CNUM INT,
    SNUM INT,
    FOREIGN KEY (CNUM) REFERENCES CUST(CNUM),
    FOREIGN KEY (SNUM) REFERENCES SALESPEOPLE(SNUM)
);
INSERT INTO ORDERS VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);
select * from orders;

/*4.	Write a query to match the salespeople to the customers according to the city they are living.*/
SELECT S.SNAME, C.CNAME, S.CITY
FROM SALESPEOPLE S
JOIN CUST C ON S.CITY = C.CITY;

/*5.	Write a query to select the names of customers and the salespersons who are providing service to them.*/
SELECT C.CNAME, S.SNAME
FROM CUST C
JOIN SALESPEOPLE S ON C.SNUM = S.SNUM;

/*6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople*/
SELECT O.ONUM, C.CNAME, S.SNAME
FROM ORDERS O
JOIN CUST C ON O.CNUM = C.CNUM
JOIN SALESPEOPLE S ON O.SNUM = S.SNUM
WHERE C.CITY <> S.CITY;

/*7.	Write a query that lists each order number followed by name of customer who made that order*/
SELECT O.ONUM, C.CNAME
FROM ORDERS O
JOIN CUST C ON O.CNUM = C.CNUM;

/*8.	Write a query that finds all pairs of customers having the same rating………………*/
SELECT A.CNAME AS Customer1, B.CNAME AS Customer2, A.RATING
FROM CUST A
JOIN CUST B ON A.RATING = B.RATING AND A.CNUM < B.CNUM;

/*9.	Write a query to find out all pairs of customers served by a single salesperson………………..*/
SELECT A.CNAME AS Customer1, B.CNAME AS Customer2, A.SNUM
FROM CUST A
JOIN CUST B ON A.SNUM = B.SNUM AND A.CNUM < B.CNUM;

/*10.	Write a query that produces all pairs of salespeople who are living in same city………………..*/
SELECT A.SNAME AS Salesperson1, B.SNAME AS Salesperson2, A.CITY
FROM SALESPEOPLE A
JOIN SALESPEOPLE B ON A.CITY = B.CITY AND A.SNUM < B.SNUM;

/*11.	Write a Query to find all orders credited to the same salesperson who services Customer 2008*/
SELECT *
FROM ORDERS
WHERE SNUM = (SELECT SNUM FROM CUST WHERE CNUM = 2008);

/*12.	Write a Query to find out all orders that are greater than the average for Oct 4th*/
SELECT *
FROM ORDERS
WHERE AMT > (SELECT AVG(AMT) FROM ORDERS WHERE ODATE = '1980-10-04');

/*13.	Write a Query to find all orders attributed to salespeople in London.*/
SELECT O.*
FROM ORDERS O
JOIN SALESPEOPLE S ON O.SNUM = S.SNUM
WHERE S.CITY = 'London';

/*14.	Write a query to find all the customers whose cnum is 1000 above the snum of Serres. */
SELECT *
FROM CUST
WHERE CNUM = (SELECT SNUM + 1000 FROM SALESPEOPLE WHERE SNAME = 'Serres');

/*15.	Write a query to count customers with ratings above San Jose’s average rating.*/
SELECT COUNT(*) AS Cust_Count
FROM CUST
WHERE RATING > (SELECT AVG(RATING) FROM CUST WHERE CITY = 'San Jose');

/*16.	Write a query to show each salesperson with multiple customers.*/
SELECT S.SNAME, COUNT(C.CNUM) AS No_of_Customers
FROM SALESPEOPLE S
JOIN CUST C ON S.SNUM = C.SNUM
GROUP BY S.SNAME
HAVING COUNT(C.CNUM) > 1;














































