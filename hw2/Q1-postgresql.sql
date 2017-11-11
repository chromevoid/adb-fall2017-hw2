CREATE TABLE trade (stock INT NOT NULL, date INT NOT NULL, quantity INT NOT NULL, price INT NOT NULL, PRIMARY KEY (date));
# psql load data
COPY trade(stock, date, quantity, price) FROM '/home/mq438/trade.csv' DELIMITER ',';



# query 1
CREATE TABLE temp AS 
SELECT stock, sum(price*quantity) AS value, sum(quantity) AS amount FROM trade GROUP BY stock;

SELECT stock, round(value/amount::numeric, 4) AS weighted_price FROM temp ORDER BY stock;

# query 2

SELECT stock, avg(price) OVER w AS average
FROM trade
WINDOW w AS (PARTITION BY stock ORDER BY date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW);

# query 3
CREATE TABLE temp1 AS
SELECT stock, sum(price*quantity) OVER w2 AS value, sum(quantity) OVER w2 AS amount
FROM trade
WINDOW w2 AS (PARTITION BY stock ORDER BY date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW);

SELECT stock, round(value / amount::numeric,4) AS weighted_average 
FROM temp1;


# query 4
SELECT stock, max(rdif) AS maximum_positive_price FROM (SELECT stock,date, price - min(price) OVER (PARTITION BY stock ORDER BY date ROWS UNBOUNDED PRECEDING) AS rdif FROM trade ) AS temp
GROUP BY stock;