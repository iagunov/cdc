-- Assignment 1.1
CREATE TABLE source1
  (
     id             INT,
     attr1          INT,
     gregor_dt      DATE,
     ctl_action     VARCHAR(1),
     ctl_datechange DATE
  );

CREATE TABLE target1
  (
     id             INT,
     attr1          INT,
     gregor_dt      DATE,
     ctl_action     VARCHAR(1),
     ctl_datechange DATE
  );

select * from source1;
select * from target1;
truncate table source1;
truncate table target1;

insert into source1(id, attr1, gregor_dt, ctl_action, ctl_datechange)
values
(1, 11, '20-07-2023', 'I', '20-07-2023'),
(2, 22, '20-07-2023', 'I', '20-07-2023'),
(3, 33, '20-07-2023', 'I', '20-07-2023')


select * from source1;
select * from target1 order by id;


insert into source1(id, attr1, gregor_dt, ctl_action, ctl_datechange)
values
(1, 11, '21-07-2023', 'I', '21-07-2023'),
(3, 333, '21-07-2023', 'I', '21-07-2023'),
(4, 44, '21-07-2023', 'I', '21-07-2023')

select * from source1;
select * from target1 order by id;

insert into source1(id, attr1, gregor_dt, ctl_action, ctl_datechange)
values
(1, 11, '22-07-2023', 'I', '22-07-2023'),
(3, 333, '22-07-2023', 'I', '22-07-2023'),
(4, 444, '22-07-2023', 'I', '22-07-2023')


select * from source1;
select * from target1 order by id;


truncate table source1;
truncate table target1;