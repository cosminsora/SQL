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


