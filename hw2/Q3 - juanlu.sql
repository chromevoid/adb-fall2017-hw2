CREATE TABLE TFriends (person1 INT, person2 INT)
CREATE TABLE TLike (person INT, artist INT)

LOAD DATA INFILE "friends.csv"
  INTO TABLE TFriends FIELDS TERMINATED BY ","

LOAD DATA INFILE "like.csv"
  INTO TABLE TLike FIELDS TERMINATED BY ","

INSERT INTO TFriends SELECT person2, person1 FROM TFriends

CREATE TABLE UFriends AS
  SELECT person1, person2 FROM DISTINCT(TFriends)

CREATE TABLE ULike AS SELECT * FROM DISTINCT(TLike)
// ULike (person, artist)


CREATE TABLE t1 AS SELECT person1 as person, person2 FROM UFriends
// t1 (person, person2)
CREATE TABLE t2 AS SELECT person1, person2 as person FROM UFriends
// t2 (person1, person)

// added dummy columns...
CREATE TABLE u1 AS
  SELECT t1.person as p1, t1.person2 as p2, ULike.artist as a, 1 as dummy
    FROM t1 INNER JOIN ULike USING person
// u1 (p1, p2, a, 1)
CREATE TABLE u2 AS
  SELECT t2.person1 as p1, t2.person as p2, ULike.artist as a, 1 as dummy
    FROM t2 INNER JOIN ULike USING person
// u2 (p1, p2, a, 1)

CREATE TABLE u3 AS
  SELECT p1, p2, a FROM u1 INNER JOIN u2 USING (p1, p2, a)

CREATE TABLE u AS
  SELECT *
    FROM u1 FULL OUTER JOIN u2 USING (p1, p2, a)

CREATE TABLE result AS
  SELECT u1__p1_u2__p1 as p1, u1__p2_u2__p2 as p2, u1__a_u2__a as a
    FROM u WHERE u1__dummy != 1 AND u2__dummy = 1

-- SELECT * FROM result INTO OUTFILE "result1.txt" FIELDS TERMINATED BY ","
-- SELECT * FROM result INTO OUTFILE "result2.txt" FIELDS TERMINATED BY ","
-- java -jar aquery.jar -a 1 -s -c -o query3-1.q query3-1.a
-- java -jar aquery.jar -a 1 -s -c -o query3-2.q query3-2.a


===== ===== ===== =====

CREATE TABLE TFriends (person1 INT, person2 INT)
CREATE TABLE TLike (person INT, artist INT)

LOAD DATA INFILE "friends.csv"
  INTO TABLE TFriends FIELDS TERMINATED BY ","

LOAD DATA INFILE "like.csv"
  INTO TABLE TLike FIELDS TERMINATED BY ","

INSERT INTO TFriends SELECT person2, person1 FROM TFriends

CREATE TABLE UFriends AS
  SELECT person1, person2 FROM DISTINCT(TFriends)

CREATE TABLE ULike AS SELECT * FROM DISTINCT(TLike)


CREATE TABLE t1 AS SELECT person1 as person, person2 FROM UFriends
CREATE TABLE t2 AS SELECT person1, person2 as person FROM UFriends

CREATE TABLE u1 AS
  SELECT t1.person as p1, t1.person2 as p2, ULike.artist as a, 1 as dummy
    FROM t1 INNER JOIN ULike USING person
CREATE TABLE u2 AS
  SELECT t2.person1 as p1, t2.person as p2, ULike.artist as a, 1 as dummy
    FROM t2 INNER JOIN ULike USING person

CREATE TABLE u AS
  SELECT *
    FROM u1 FULL OUTER JOIN u2 USING (p1, p2, a)

CREATE TABLE result AS
  SELECT u1__p1_u2__p1 as p1, u1__p2_u2__p2 as p2, u1__a_u2__a as a
    FROM u WHERE u1__dummy != 1 AND u2__dummy = 1
