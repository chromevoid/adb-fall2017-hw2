(a) Find the weighted (by quantity) average price of each stock over the entire time series.
(b) Find the vector of 10 trade unweighted moving averages
(i.e. moving average of price) per stock.
(c) Find the vector of 10 trade weighted moving averages per stock.
(d) Find the single best buy first/sell later trade you could have done on each stock (your
query should work on our data as well as yours). That is, for each stock, find the
maximum positive price difference between a later sell and an earlier buy.


### query 1

CREATE TABLE trade_start(stock INT, date INT, quantity INT, price INT)
LOAD DATA INFILE "trade.csv" INTO TABLE trade_start FIELDS TERMINATED BY ","

CREATE TABLE temp AS 
SELECT stock, sum(price*quantity) AS value, sum(quantity) AS amount FROM trade_start GROUP BY stock

CREATE TABLE result AS
SELECT stock, value/amount AS weighted_price FROM temp ASSUMING ASC stock 


### query 2

CREATE TABLE trade_start(stock INT, date INT, quantity INT, price INT)
LOAD DATA INFILE "trade.csv" INTO TABLE trade_start FIELDS TERMINATED BY ","

CREATE TABLE result AS
SELECT stock, avgs(10,price) AS average, date FROM trade_start ASSUMING ASC date GROUP BY stock



### query 3

CREATE TABLE trade_start(stock INT, date INT, quantity INT, price INT)
LOAD DATA INFILE "trade.csv" INTO TABLE trade_start FIELDS TERMINATED BY ","

CREATE TABLE result AS
SELECT stock, sums(10,price*quantity)/sums(10, quantity) AS weighted_average , date FROM trade_start ASSUMING ASC date GROUP BY stock


### query 4
CREATE TABLE trade_start(stock INT, date INT, quantity INT, price INT)
LOAD DATA INFILE "trade.csv" INTO TABLE trade_start FIELDS TERMINATED BY ","
CREATE TABLE result AS
SELECT stock, max(price - mins(price)) AS maximum_positive_price FROM trade_start ASSUMING ASC date GROUP BY stock



### type error when trying to write to output file, use show command in q instead
INTO OUTFILE "weightedPrice.txt" FIELDS TERMINATED BY ","


