CREATE TEMPORARY TABLE IF NOT EXISTS var
  (
     id             INT,
     attr1          INT,
     gregor_dt      DATE,
     ctl_action     VARCHAR(1),
     ctl_datechange DATE
  ); 

DO $$
BEGIN
  IF
     (
      SELECT count(*)
      FROM   var) > 0 THEN
		DELETE FROM target1
		WHERE  ( id ) IN (WITH cte
							   AS (SELECT id,
										  attr1,
										  gregor_dt,
										  ctl_action,
										  ctl_datechange,
										  Last_value(gregor_dt)
											over()
								   FROM   source1)
						  SELECT s.id
						   FROM   cte s
								  left join target1 t
										 ON s.id = t.id
											AND s.attr1 = t.attr1
											AND s.gregor_dt = t.gregor_dt
						   WHERE  ( t.id ) IN (SELECT id
											   FROM   source1
											   WHERE  gregor_dt = s.last_value)
								   OR t.ctl_action = 'D'); 
		
		INSERT INTO target1
					(
								id,
								attr1,
								gregor_dt,
								ctl_action,
								ctl_datechange
					)
					WITH cte AS
					(
						   SELECT id,
								  attr1,
								  gregor_dt,
								  ctl_action,
								  ctl_datechange,
								  Last_value(gregor_dt) over()
						   FROM   source1
					)
			 SELECT id,
					attr1,
					gregor_dt,
					ctl_action,
					ctl_datechange
			 FROM   cte s1
			 WHERE  s1.gregor_dt = s1.last_value
			 AND    s1.id NOT IN
					(
						   SELECT id
						   FROM   source1 s2
						   WHERE  s2.gregor_dt = s1.last_value - interval '1 day' );

		INSERT INTO target1
					(
								id,
								attr1,
								gregor_dt,
								ctl_action,
								ctl_datechange
					)
					WITH cte AS
					(
						   SELECT id,
								  attr1,
								  gregor_dt,
								  ctl_action,
								  ctl_datechange,
								  Last_value(gregor_dt) over()
						   FROM   source1
					)
			 SELECT s1.id,
					s1.attr1,
					s1.gregor_dt,
					'U' AS ctl_action,
					ctl_datechange
			 FROM   cte s1
			 WHERE  s1.gregor_dt = s1.last_value
			 AND    (
						   s1.id) IN
					(
						   SELECT id
						   FROM   source1 s2
						   WHERE  s2.gregor_dt = s1.last_value - interval '1 day')
			 AND    s1.attr1 NOT IN
					(
						   SELECT attr1
						   FROM   source1 s3
						   WHERE  s3.gregor_dt = s1.last_value - interval '1 day');
		
		WITH cte
			 AS (SELECT id,
						attr1,
						gregor_dt,
						ctl_action,
						ctl_datechange,
						Last_value(gregor_dt)
						  OVER()
				 FROM   source1)
		UPDATE target1 t2
		SET    ctl_action = 'D',
			   ctl_datechange = s.last_value
		FROM   cte s
		WHERE  t2.id IN (SELECT t1.id
						 FROM   source1 t1
						 WHERE  id NOT IN (SELECT id
										   FROM   source1
										   WHERE  gregor_dt = s.last_value)); 

  ELSE
    INSERT INTO target1
                (
                            id,
                            attr1,
                            gregor_dt,
                            ctl_action,
                            ctl_datechange
                )
    SELECT *
    FROM   source1;
	
	INSERT INTO var
                (
                            id,
                            attr1,
                            gregor_dt,
                            ctl_action,
                            ctl_datechange
                )
    SELECT *
    FROM   source1;
  END IF;
END $$;
