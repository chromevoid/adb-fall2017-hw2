CREATE INDEX idx_stock ON trade(stock);

CREATE INDEX idx_price ON trade(price);


Performance can be particularly improved if the newly-created index has many fewer columns than the table being indexed, since many fewer pages must be retrieved from the disk in order to satisfy the query.


### query to examine the covering index price
SELECT price from trade where price >=100;

### query to examine the covering index stock
SELECT stock from trade where stock >= 100;


# You can always run CLUSTER with a different index to change the physical order of rows once more.

### query to examine the cluster using stock
CLUSTER trade USING stock;
SELECT stock from trade where stock >= 100;

### query to examine the cluster using price
CLUSTER trade USING price where price >= 100;
