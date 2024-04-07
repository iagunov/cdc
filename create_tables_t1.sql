-- Assignment 1.1
CREATE TABLE source
  (
     id        INT,
     attr1     INT,
     attr2     INT,
     gregor_dt DATE
  );

CREATE TABLE target
  (
     id             INT,
     attr1          INT,
     attr2          INT,
     start_dt       DATE,
     end_dt         DATE,
     ctl_action     VARCHAR,
     ctl_datechange DATE
  ); 

INSERT INTO Source (id, attr1, attr2, gregor_dt)
VALUES
(1, 11, 111, '2023-01-01'::DATE),
(2, 22, 222, '2023-01-01'::DATE),
(3, 33, 333, '2023-01-01'::DATE),
(5, 55, 555, '2023-01-01'::DATE),
(6, 66, 666, '2023-01-01'::DATE);


SELECT * FROM Source;
SELECT * FROM Target ORDER BY id;

INSERT INTO Source (id, attr1, attr2, gregor_dt)
VALUES
(1, 11, 111, '2023-02-01'::DATE),
(2, 22, 222, '2023-02-01'::DATE),
(3, 33, 333, '2023-02-01'::DATE),
(4, 44, 444, '2023-02-01'::DATE),
(5, 55, 5555, '2023-02-01'::DATE);


SELECT * FROM Source;
SELECT * FROM Target ORDER BY id;

INSERT INTO Source (id, attr1, attr2, gregor_dt)
VALUES
(1, 11, 111, '2023-08-01'::DATE),
(2, 222, 222, '2023-08-01'::DATE),
(3, 33, 333, '2023-08-01'::DATE),
(5, 55, 5555, '2023-08-01'::DATE);

SELECT * FROM Source;
SELECT * FROM Target ORDER BY id;


-- Assignment 1.2
WITH RankedTarget AS (
    SELECT
        id,
        attr1,
        attr2,
        start_dt,
        end_dt,
        ctl_action,
        ctl_datechange,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY start_dt DESC) AS row_num
    FROM
        Target
)
SELECT
    id,
    attr1,
    attr2,
    start_dt,
    end_dt,
    ctl_action,
    ctl_datechange
FROM
    RankedTarget
WHERE
    row_num = 1;

DROP TABLE Target;
DROP TABLE Source;

TRUNCATE TABLE Target;
TRUNCATE TABLE Source;
