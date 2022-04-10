-- Exists
SELECT *
FROM emp e 
WHERE EXISTS (select * from emp where job = 'SALESMAN')

-- Not exists
SELECT *
FROM emp e 
WHERE NOT EXISTS (select * from emp where job = 'SALESMAN')

-- selecteaza doar ce exista in tabelul din where exists
-- selecteaza departamentele unde exista un angajat mapat in tabela de angajati
SELECT d.*
FROM dept d 
WHERE EXISTS (select * from emp where d.deptno = emp.deptno)

-- selecteaza departamentele unde nu exista un angajat mapat in tabela de angajati
SELECT d.*
FROM dept d 
WHERE NOT EXISTS (select * from emp where d.deptno = emp.deptno)