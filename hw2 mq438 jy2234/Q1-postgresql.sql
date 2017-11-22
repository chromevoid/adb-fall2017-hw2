#psql
-- module load postgresql-9.6.1
-- initdb -D /home/mq438/pgsql/data -U mq438
-- pg_ctl -D /home/mq438/pgsql/data -l logfile -o "-F -p 2000" start
-- createdb my_db -p 2000
-- psql my_db -p 2000
-- pg_ctl -D /home/mq438/pgsql/data stop


-- psql -s my_db -f filename.sql


\timing
CREATE TABLE trade (stock INT NOT NULL, date INT NOT NULL, quantity INT NOT NULL, price INT NOT NULL, PRIMARY KEY (date));
# psql load data
COPY trade(stock, date, quantity, price) FROM '/home/mq438/trade1.csv' DELIMITER ',';

# query 1
CREATE TABLE temp1 AS SELECT stock, sum(price*quantity) AS value, sum(quantity) AS amount FROM trade GROUP BY stock;

SELECT stock, round(value/amount::numeric, 4) AS weighted_price FROM temp1 ORDER BY stock;

# query 2

SELECT stock, avg(price) OVER w AS average
FROM trade
WINDOW w AS (PARTITION BY stock ORDER BY date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW);

# query 3
CREATE TABLE temp2 AS
SELECT stock, sum(price*quantity) OVER w2 AS value, sum(quantity) OVER w2 AS amount
FROM trade
WINDOW w2 AS (PARTITION BY stock ORDER BY date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW);

SELECT stock, round(value / amount::numeric,4) AS weighted_average FROM temp2;


# query 4
SELECT stock, max(rdif) AS maximum_positive_price 
FROM (
	SELECT stock,date, price - min(price) OVER (PARTITION BY stock ORDER BY date ROWS UNBOUNDED PRECEDING) AS rdif 
	FROM trade 
) AS temp
GROUP BY stock;

# \q to quit


# Timing
-- 22.073
-- 70145.909
# add = 70167.982

-- 12390.731
-- 360.527
# add = 12751.258
# result = 82919.24 = 82.91924s

-- 68885.785
# result = 139053.767 = 139.053767s

-- 60340.561
-- 20651.621
# add = 80992.182
# result = 151160.164 = 151.160164s

-- 36903.303
# result = 107071.285 = 107.071285




