initdb -D /home/mq438/pgsql/data -U mq438
pg_ctl -D /home/mq438/pgsql/data -l logfile -o "-F -p 2000" start
createdb my_db -p 2000
psql my_db -p 2000
pg_ctl -D /home/mq438/pgsql/data stop

DROP TABLE trade;
DROP TABLE tradeIndex;
DROP TABLE tradeCluster;
CREATE TABLE trade (stock INT NOT NULL, date INT NOT NULL, quantity INT NOT NULL, price INT NOT NULL, PRIMARY KEY (date));
COPY trade(stock, date, quantity, price) FROM '/home/mq438/trade1.csv' DELIMITER ',';
CREATE TABLE tradeIndex (stock INT NOT NULL, date INT NOT NULL, quantity INT NOT NULL, price INT NOT NULL, PRIMARY KEY (date));
COPY tradeIndex(stock, date, quantity, price) FROM '/home/mq438/trade1.csv' DELIMITER ',';
CREATE TABLE tradeCluster (stock INT NOT NULL, date INT NOT NULL, quantity INT NOT NULL, price INT NOT NULL, PRIMARY KEY (date));
COPY tradeCluster(stock, date, quantity, price) FROM '/home/mq438/trade1.csv' DELIMITER ',';

\timing

CREATE INDEX idx_price ON tradeIndex(price);
CREATE INDEX idx_stock ON tradeIndex(stock);

CREATE INDEX clus_idx_price ON tradeCluster(price);
CREATE INDEX clus_idx_stock ON tradeCluster(stock);
CLUSTER tradeCluster USING clus_idx_price;
CLUSTER tradeCluster USING clus_idx_stock;

DROP INDEX idx_price;
DROP INDEX idx_stock;

### Performance can be particularly improved 
### if the newly-created index has many fewer columns than the table being indexed, 
### since many fewer pages must be retrieved from the disk in order to satisfy the query.

# You can always run CLUSTER with a different index to change the physical order of rows once more.

### query to examine the index and cluster index for price
SELECT price from trade where price >= 300;
SELECT price from tradeIndex where price >= 300;
SELECT price from tradeCluster where price >= 300;

SELECT price from trade where price = 300;
SELECT price from tradeIndex where price = 300;
SELECT price from tradeCluster where price = 300;

### query to examine the index and cluster index for stock
SELECT stock from trade where stock >= 40000;
SELECT stock from tradeIndex where stock >= 40000;
SELECT stock from tradeCluster where stock >= 40000;

SELECT stock from trade where stock = 40000;
SELECT stock from tradeIndex where stock = 40000;
SELECT stock from tradeCluster where stock = 40000;

### query to examine the index and cluster index for price and stock
SELECT price, stock from trade where price >=300 and stock >= 40000;
SELECT price, stock from tradeIndex where price >=300 and stock >= 40000;
SELECT price, stock from tradeCluster where price >=300 and stock >= 40000;


