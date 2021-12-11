SELECT EMP.ENAME, EMP.JOB, EMP.SAL, DEPT.LOC
FROM EMP, DEPT
WHERE DEPT.LOC = 'DALLAS'

SELECT EMP.ENAME, EMP.JOB, EMP.SAL, DEPT.LOC
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND DEPT.LOC = 'DALLAS'

SELECT * FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND DEPT.LOC = 'DALLAS'

SELECT * FROM DEPT d, EMP e 
WHERE d.DEPTNO = e.DEPTNO

-- inner query / outer query (joins by WHERE and joins by FROM)
SELECT e.ENAME, e.JOB, e.SAL, d.LOC
FROM EMP e, (select * from DEPT where LOC = 'DALLAS') d -- inner query
WHERE e.DEPTNO = d.DEPTNO -- outer query

-- inner joins
SELECT * -- classic inner join
FROM emp e, dept d 
WHERE e.deptno = d.deptno

SELECT * -- new inner join syntax - SQL standard not only Oracle
FROM emp e INNER JOIN dept d 
ON e.deptno = d.deptno 

-- outer joins
-- right joins
SELECT * FROM dept
SELECT *
FROM emp e RIGHT JOIN dept d 
ON e.deptno = d.deptno

-- left joins
SELECT *
FROM emp e LEFT OUTER JOIN dept d 
ON e.deptno = d.deptno

SELECT * -- classic outer join
FROM emp e, dept d 
WHERE e.deptno(+) = d.deptno -- (+) = outer right join operator

SELECT * -- classic outer join
FROM emp e, dept d 
WHERE e.deptno = d.deptno(+) -- (+) = outer right join operator / this operator only works in oracle SQL

-- full outer joins
SELECT * 
FROM emp e FULL OUTER JOIN dept d 
ON e.deptno = d.deptno

-- outer join using the subqueries / nested queries
SELECT *
FROM (select * from emp where job = 'SALESMAN') e FULL OUTER JOIN (select * from dept) d 
ON e.deptno = d.deptno

-- exercise
SELECT e.empno as empno, e.ename as ename, e.job as job, e.mgr as mgr, e.hiredate as hiredate, e.sal as sal, e.comm as comm, e.deptno as deptno, d.deptno as deptno, d.dname as dname, d.loc as loc
FROM (select * from dept) d LEFT OUTER JOIN (select * from emp where job = 'SALESMAN') e
ON e.deptno = d.deptno

SELECT e.*, d.*
FROM (select * from dept) d LEFT OUTER JOIN (select * from emp where job = 'SALESMAN') e
ON e.deptno = d.deptno


-- exists and not exists
SELECT *
FROM emp e 
WHERE EXISTS (select * from emp where job = 'SALESMAN')

SELECT *
FROM emp e 
WHERE NOT EXISTS (select * from emp where job = 'SALESMAN')

-- selecteaza doar ce exista in tabelul din where exists
SELECT d.*
FROM dept d 
WHERE EXISTS (select * from emp where d.deptno = emp.deptno)
-- selecteaza departamentele unde exista un angajat mapat in tabela de angajati

SELECT d.*
FROM dept d 
WHERE NOT EXISTS (select * from emp where d.deptno = emp.deptno)
-- selecteaza departamentele unde nu exista un angajat mapat in tabela de angajati

-- self join (where the same data exists in the same table but means different things)
SELECT * FROM emp
SELECT *
FROM emp INNER JOIN emp
ON EMPNO = MGR

SELECT *
FROM emp e, (select empno, ename from emp) d
WHERE e.mgr = d.empno

SELECT e.empno, e.ename, e.mgr, d.empno, d.ename
FROM emp e LEFT JOIN (select * from emp) d
ON e.mgr = d.empno

-- cartesian product / cross join / no join = un join intre doua tabele fara o conditie dupa care sa se faca join-ul (fiecare rand din emp cu fiecare rand din dept)
SELECT * FROM emp, dept;

SELECT *
FROM emp JOIN dept
ON 1=1;

SELECT *
FROM emp CROSS JOIN dept;

-- natural join = un join care nu are nevoie de conditie pentru ca ia automat daca primary key-ul unui tabel exista ca foreign key in cel de-al doilea tabel
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

-- equijoin = un inner join al carei conditii este o egalitate
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp JOIN dept
ON emp.deptno = dept.deptno;

-- non-equijoin = un join care are ca si conditie o relatie de inegalitate
CREATE TABLE job_grade
(Grade_level varchar(2) not null,
lowest_sal number not null,
highest_sal number not null);


INSERT ALL
INTO job_grade
VALUES ('A', 0, 1000)
INTO job_grade
VALUES ('B', 1001, 2000)
INTO job_grade
VALUES ('C', 2001, 3000)
INTO job_grade
VALUES ('D', 3001, 4000)
INTO job_grade
VALUES ('E', 4001, 5000)
SELECT * FROM DUAL;

SELECT * FROM job_grade;

SELECT *
FROM emp e JOIN job_grade j
ON e.sal BETWEEN j.lowest_sal AND j.highest_sal;

-- case statement
SELECT * FROM emp;

SELECT ename, job, 
(CASE job
WHEN 'PRESIDENT' THEN 'big shot'
WHEN 'MANAGER' THEN 'decides the pay'
WHEN 'ANALYST' THEN 'good at pay'
WHEN 'CLERK' THEN 'hard working'
ELSE 'no comment'
END) as "COMMENT"
FROM emp;

SELECT ename, 
(CASE WHEN SAL < 2500 THEN 'PLEB' 
ELSE 'EVREU'
END) as "STATUT"
FROM emp;

-- AGGREGATE FUNCTIONS: GROUP BY
-- ANALYTICAL FUNCTIONS: ORDER BY, PARTITION BY
-- Prerequisite
create table bricks (
  brick_id integer,
  colour   varchar2(10),
  shape    varchar2(10),
  weight   integer
);

insert into bricks values ( 1, 'blue', 'cube', 1 );
insert into bricks values ( 2, 'blue', 'pyramid', 2 );
insert into bricks values ( 3, 'red', 'cube', 1 );
insert into bricks values ( 4, 'red', 'cube', 2 );
insert into bricks values ( 5, 'red', 'pyramid', 3 );
insert into bricks values ( 6, 'green', 'pyramid', 1 );

commit;

-- LIVE SQL - Analytic Functions: Databases for Developers
SELECT * FROM bricks;

-- partition count by colour
SELECT b.*,
(select count(*) from bricks where colour = b.colour) as total_bricks_per_colour
FROM bricks b;

-- partition weight by colour
SELECT b.*,
(select sum(weight) from bricks where colour = b.colour) as total_bricks_per_weight
FROM bricks b
ORDER BY BRICK_ID;

-- partition count by shape
SELECT b.*,
(select count(*) from bricks where shape = b.shape) as total_bricks_per_shape
FROM bricks b
ORDER BY BRICK_ID;

-- partition with over clause
SELECT
count(*) over()
FROM bricks b;

SELECT b.*,
count(*) over()
FROM bricks b;

SELECT b.*,
count(*) over(partition by colour) as total_count_by_colour
FROM bricks b;

SELECT b.*,
sum(weight) over(partition by shape) as total_weight_by_shape
FROM bricks b;

-- SQL STATEMENTS
--- DML
---- SELECT
----- FROM clause
----- WHERE clause
----- AND / OR clauses
----- JOIN clauses: INNER, OUTER LEFT, OUTER RIGHT, SELF, NATURAL, CROSS, EQUI, etc.
----- CASE clause
----- Single row functions (SRF): trunc, cat, etc.
----- Aggregate functions (input multiple rows, output one row): count, max, min, sum, avg, GROUP BY ... HAVING, 
----- Analytical functions (input multiple rows, output multiple rows): over, partition by, order by
---- INSERT
---- UPDATE
---- DELETE


select * from bricks;
-- analytical functions cu partition by se foloseste pentru a aplica functii agregate unor grupuri, nu intregului tabel
SELECT b.*,
SUM(weight) OVER (PARTITION BY shape) sum_by_shape,
SUM(weight) OVER (PARTITION BY colour) sum_by_colour,
MAX(weight) OVER (PARTITION BY shape) max_weight_by_shape,
MAX(weight) OVER (PARTITION BY colour) max_weight_by_colour
FROM bricks b;

-- analytical functions cu order by se foloseste pentru a aplica calcula running totals
SELECT b.*,
SUM(weight) OVER (ORDER BY brick_id) running_weight
FROM bricks b; -- calculeaza suma greutatii in la fiecare BRICK ID

SELECT b.*,
COUNT(*) OVER (ORDER BY brick_id) running_count
FROM bricks b; -- calculeaza un contor

SELECT b.*,
SUM(weight) OVER (PARTITION BY colour ORDER BY brick_id) running_weight_per_colour
FROM bricks b; -- imparte tabelul in grupuri de culori si calculeaza running weight-ul pentru fiecare culoare

SELECT b.*,
SUM(weight) OVER (PARTITION BY colour ORDER BY brick_id) running_weight_per_colour
FROM bricks b
ORDER BY brick_id;

select * from bricks;
-- analytical functions cu partition by se foloseste pentru a aplica functii agregate unor grupuri, nu intregului tabel
SELECT b.*,
SUM(weight) OVER (PARTITION BY shape) sum_by_shape,
SUM(weight) OVER (PARTITION BY colour) sum_by_colour,
MAX(weight) OVER (PARTITION BY shape) max_weight_by_shape,
MAX(weight) OVER (PARTITION BY colour) max_weight_by_colour
FROM bricks b;

-- analytical functions cu order by se foloseste pentru a aplica calcula running totals
SELECT b.*,
SUM(weight) OVER (ORDER BY brick_id) running_weight
FROM bricks b; -- calculeaza suma greutatii in la fiecare BRICK ID

SELECT b.*,
COUNT(*) OVER (ORDER BY brick_id) running_count
FROM bricks b; -- calculeaza un contor

SELECT b.*,
SUM(weight) OVER (PARTITION BY colour ORDER BY brick_id) running_weight_per_colour
FROM bricks b; -- imparte tabelul in grupuri de culori si calculeaza running weight-ul pentru fiecare culoare

SELECT b.*,
SUM(weight) OVER (PARTITION BY colour ORDER BY brick_id) running_weight_per_colour
FROM bricks b
ORDER BY brick_id;

-- windowing clause
SELECT b.*,
SUM(weight) OVER (ORDER BY brick_id) running_weight
FROM bricks b
ORDER BY brick_id;

-- "range between unbounded preceding and current row" clause used for OVER ORDER BY functions
SELECT b.*,
SUM(weight) OVER (ORDER BY brick_id range between unbounded preceding and current row) running_weight
FROM bricks b
ORDER BY brick_id; -- get the weight of all the rows before the current one / used for ordering by a unique attribute

SELECT b.*,
SUM(weight) OVER (ORDER BY weight) running_weight
FROM bricks b
ORDER BY weight; -- ordonand dupa weight nu da bine pentru ca sunt mai multe bricks cu acelasi weight deci e nevoie de o noua clauza pentru ordonarea dupa non-unique attributes

SELECT b.*,
SUM(weight) OVER (ORDER BY weight rows between unbounded preceding and current row) running_weight
FROM bricks b
ORDER BY weight; -- pentru OVER ORDER BY dupa un attribute non-unique


