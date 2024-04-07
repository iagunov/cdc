-- A temporary table that is used as a variable to verify if the source table is empty.
CREATE TEMPORARY TABLE IF NOT EXISTS var
  (
     id             INT,
     attr1          INT,
     attr2          INT,
     start_dt       DATE,
     end_dt         DATE,
     ctl_action     VARCHAR,
     ctl_datechange DATE
  );
-- A start of script block.
DO $$
  BEGIN
    IF
       (
        SELECT count(*)
        FROM   var) > 0 THEN
		  INSERT INTO target
					  (
								  id,
								  attr1,
								  attr2,
								  start_dt,
								  end_dt,
								  ctl_action,
								  ctl_datechange
					  )
		  SELECT s.id,
				 s.attr1,
				 s.attr2,
				 s.gregor_dt        AS start_dt,
				 '9999.12.31'::DATE AS end_dt,
				 'I'                AS ctl_action,
				 s.gregor_dt        AS ctl_datechange
		  FROM   source s
		  WHERE  NOT EXISTS
				 (
						SELECT 1
						FROM   target t
						WHERE  t.attr1 = s.attr1
						AND    t.attr2 = s.attr2 );
		 WITH cte AS
				 (
				 SELECT id,
						attr1,
						attr2,
						gregor_dt,
						Last_value(gregor_dt) over()
				 FROM   source )
		  UPDATE target AS t1
		  SET    ctl_action = 'D',
				 end_dt = t3.last_value - interval '1 day',
				 ctl_datechange = t3.last_value
		  FROM   cte AS t3
		  WHERE  start_dt < t3.last_value
		  AND    NOT EXISTS
				 (
						SELECT 1
						FROM   cte AS t2
						WHERE  t2.id = t1.id
						AND    t2.gregor_dt = t2.last_value )
		  AND    ctl_action <> 'D';
		  WITH cte AS
		  (
				 SELECT id,
						attr1,
						attr2,
						gregor_dt,
						Last_value(gregor_dt) over()
				 FROM   source )
		  UPDATE target AS t4
		  SET    ctl_action = 'U',
				 end_dt = t3.last_value - interval '1 day',
				 ctl_datechange = t3.last_value
		  FROM   cte AS t3
		  WHERE  (
						t4.id, t4.start_dt) =
				 (
						SELECT t1.id,
							   t1.start_dt
						FROM   target t1
						JOIN   target t2
						ON     t1.id = t2.id
						WHERE  t1.id = t2.id
						AND    t1.start_dt <> t2.start_dt
						AND    t1.start_dt <> t3.last_value
						AND    t1.ctl_action <> 'U'
						AND    t2.ctl_action <> 'U');
	ELSE
      INSERT INTO target
                  (
                              id,
                              attr1,
                              attr2,
                              start_dt,
                              end_dt,
                              ctl_action,
                              ctl_datechange
                  )
      SELECT id,
             attr1,
             attr2,
             gregor_dt          AS start_dt,
             '31.12.9999'::DATE AS end_dt,
             'I'                AS ctl_action,
             gregor_dt          AS ctl_datechange
      FROM   source;
	  INSERT INTO var
                  (
                              id,
                              attr1,
                              attr2,
                              start_dt,
                              end_dt,
                              ctl_action,
                              ctl_datechange
                  )
      SELECT id,
             attr1,
             attr2,
             gregor_dt          AS start_dt,
             '31.12.9999'::DATE AS end_dt,
             'I'                AS ctl_action,
             gregor_dt          AS ctl_datechange
      FROM   source;
	END IF;
END $$;