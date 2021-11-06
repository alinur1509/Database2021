create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;


-- 1a
SELECT *
FROM dealer d
JOIN client c ON d.id = c.dealer_id;

-- 1b
SELECT d, c.name, c.city, c.priority, s.id, s.date, s.amount
FROM dealer d
LEFT JOIN client c ON d.id = c.dealer_id
LEFT JOIN sell s ON c.id = s.client_id
WHERE  c.name IS NOT NULL AND
       c.city IS NOT NULL AND
       c.priority IS NOT NULL AND
       s.id IS NOT NULL AND
       s.date IS NOT NULL AND
       s.amount IS NOT NULL;

-- 1c
SELECT d, c
FROM dealer d
INNER JOIN client c ON c.city = d.location;

-- 1d
SELECT s.id, s.amount, c.name, c.city
FROM sell s
INNER JOIN client c ON s.client_id = c.id
WHERE s.amount >= 100 AND s.amount <= 500;

-- 1e
SELECT *
FROM dealer d
LEFT JOIN client c ON d.location = c.city;

--1f
SELECT c.name, c.city, d.name, d.charge
FROM client c
JOIN dealer d ON c.dealer_id = d.id;

-- 1g
SELECT c.name, c.city, d
FROM  client c
JOIN dealer d ON dealer_id = d.id
WHERE d.charge > 0.12;

-- 1h
SELECT c.name, c.city, s.id, s.date, s.amount, d.name,d.charge
FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id;

-- 1i
SELECT c.name, c.priority,d.name, s.id, s.amount
FROM dealer d
LEFT JOIN client c ON d.id = c.dealer_id
LEFT JOIN sell s ON c.id = s.client_id
WHERE s.amount >= 2000 AND c.priority IS NOT NULL;

-- 2a
CREATE VIEW a2 AS
SELECT s.date, COUNT(DISTINCT s.client_id), AVG(s.amount), SUM(s.amount)
FROM sell s
GROUP BY s.date;
-- drop view a2;

-- 2b
CREATE VIEW b2 AS
SELECT s.date, s.amount
FROM sell s
ORDER BY s.amount DESC
LIMIT 5;
-- drop view b2;

-- 2c
CREATE VIEW c2 AS
SELECT  d, COUNT(s.amount), AVG(s.amount), SUM(s.amount)
FROM sell s
JOIN dealer d ON d.id = s.dealer_id
GROUP BY d;
-- drop view c2;

-- 2d
CREATE VIEW d2 AS
SELECT d, SUM(amount * d.charge)
FROM sell s
JOIN dealer d ON d.id = s.dealer_id
GROUP BY d;
-- drop view d2;

--2e
CREATE VIEW e2 AS
SELECT d.location, COUNT(s.amount), AVG(s.amount), SUM(s.amount)
FROM dealer d
JOIN sell s ON d.id = s.dealer_id
GROUP BY d.location;
-- drop view e2;

--2f
CREATE VIEW f2 AS
SELECT c.city, COUNT(s.amount), AVG(s.amount * (d.charge + 1)), SUM(s.amount * (d.charge + 1))
FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id
GROUP BY c.city;
--drop view f2;

--2g
CREATE VIEW g2 AS
SELECT c.city, SUM(s.amount * (d.charge + 1)) AS totalexpense, SUM(s.amount) AS totalamount
FROM client c
JOIN sell s ON c.id = s.client_id
JOIN dealer d ON s.dealer_id = d.id and c.city = d.location
GROUP BY c.city;
-- drop view g2;
