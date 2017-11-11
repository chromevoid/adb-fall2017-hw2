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

CREATE TABLE j1 AS SELECT u1.p1 AS person1, u1.p2 AS person2, u1.dummy AS dum1, u2.dummy AS dum2, u1.a AS artist FROM u1 FULL OUTER JOIN u2 USING (p1, p2, a)

CREATE TABLE result AS
SELECT person1, person2, artist FROM j1 WHERE dum1 != 1 AND dum2 = 1