-----------------------------------------------------------
-- Inner / outer queries (joins by WHERE and joins by FROM)
-----------------------------------------------------------
SELECT e.ENAME, e.JOB, e.SAL, d.LOC
FROM EMP e, (select * from DEPT where LOC = 'DALLAS') d -- inner query
WHERE e.DEPTNO = d.DEPTNO; -- outer query

-----------------------------------------------------------
-- Inner joins --> classical and new syntax
-----------------------------------------------------------
-- Classic inner join
SELECT * 
FROM emp e, dept d 
WHERE e.deptno = d.deptno;
-- New inner join syntax - SQL standard not only Oracle
SELECT * 
FROM emp e INNER JOIN dept d 
ON e.deptno = d.deptno;

-----------------------------------------------------------
-- Outer joins --> right and left joins
-----------------------------------------------------------
-- Right joins
SELECT * FROM dept
SELECT *
FROM emp e RIGHT JOIN dept d 
ON e.deptno = d.deptno;

-- Left joins
SELECT *
FROM emp e LEFT OUTER JOIN dept d 
ON e.deptno = d.deptno;

-- Classic outer join
SELECT * 
FROM emp e, dept d 
WHERE e.deptno(+) = d.deptno; -- (+) = outer right join operator

SELECT *
FROM emp e, dept d 
WHERE e.deptno = d.deptno(+); -- (+) = outer right join operator / this operator only works in oracle SQL

-- Full outer joins
SELECT * 
FROM emp e FULL OUTER JOIN dept d 
ON e.deptno = d.deptno;

-- Outer join using the subqueries / nested queries
SELECT *
FROM (select * from emp where job = 'SALESMAN') e FULL OUTER JOIN (select * from dept) d 
ON e.deptno = d.deptno;

-- Exercise
SELECT e.empno as empno, e.ename as ename, e.job as job, e.mgr as mgr, e.hiredate as hiredate, e.sal as sal, e.comm as comm, e.deptno as deptno, d.deptno as deptno, d.dname as dname, d.loc as loc
FROM (select * from dept) d LEFT OUTER JOIN (select * from emp where job = 'SALESMAN') e
ON e.deptno = d.deptno;

SELECT e.*, d.*
FROM (select * from dept) d LEFT OUTER JOIN (select * from emp where job = 'SALESMAN') e
ON e.deptno = d.deptno;

-----------------------------------------------------------------------------------------
-- Self joins --> where the same data exists in the same table but means different things
-----------------------------------------------------------------------------------------
SELECT * FROM emp
SELECT *
FROM emp INNER JOIN emp
ON EMPNO = MGR;

SELECT *
FROM emp e, (select empno, ename from emp) d
WHERE e.mgr = d.empno;

SELECT e.empno, e.ename, e.mgr, d.empno, d.ename
FROM emp e LEFT JOIN (select * from emp) d
ON e.mgr = d.empno;

-------------------------------------------------------------------------------------------------------------------------
-- Cross joins (cartesion product, no join) 
-- un join intre doua tabele fara o conditie dupa care sa se faca join-ul (fiecare rand din emp cu fiecare rand din dept)
-------------------------------------------------------------------------------------------------------------------------
SELECT * FROM emp, dept;

SELECT *
FROM emp JOIN dept
ON 1=1;

SELECT *
FROM emp CROSS JOIN dept;

---------------------------------------------------------------------------------------------------------------------------------------------
-- Natural joins
-- un join care nu are nevoie de conditie pentru ca ia automat daca primary key-ul unui tabel exista ca foreign key in cel de-al doilea tabel
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM EMP;

-- in acest caz a luat automat dupa deptno care e primary key in dept si foreign key in emp
SELECT *
FROM emp NATURAL JOIN dept;

-- natural join cu join using
SELECT *
FROM emp JOIN dept
USING (deptno); -- un natural join caruia poti sa ii alegi key-ul pentru care sa il foloseasca

SELECT *
FROM emp JOIN dept
USING (col1, col2); -- pentru cazul in care key-ul are nume diferita in tabela 1 fata de tabela 2

----------------------------------------------------------------------------
-- Equijoins -> un inner join al carei conditii este o egalitate
-- Non-equijoins -> un join care are ca si conditie o relatie de inegalitate
----------------------------------------------------------------------------
-- Equijoin
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp JOIN dept
ON emp.deptno = dept.deptno;

-- Non-equijoin
CREATE TABLE job_grade
(Grade_level varchar(2) not null,
lowest_sal number not null,
highest_sal number not null);
