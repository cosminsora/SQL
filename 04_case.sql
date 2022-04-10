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