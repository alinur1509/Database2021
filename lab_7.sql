create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

--1. Task
--Large objects (photos, videos, CAD files, etc.) are stored as a large object:
------• blob: binary large object -- object is a large collection of
--------uninterpreted binary data (whose interpretation is left to
--------an application outside of the database system)
--------
------• clob: character large object -- object is a large collection of character data

--- When a query returns a large object, a pointer is returned rather than the large object itself.
---Large objects may be stored either as files in a file system area managed by the
---database, or as file structures stored in and managed by the database. In the latter case,
---such in-database large objects can optionally be represented using B+-tree file organizations

--2. Task
--A role, a collection of privileges, is created by users . It simplifies privilege management by allowing to manage bundles of privileges.
--A privilege is a right to execute a particular type of SQL statement.
--A user is someone who can connect to a database and optionally can own objects in the database.

-- task 2.1
create role accountant;
create role administrator;
create role support;
grant all privileges on accounts, transactions to accountant;
grant all privileges on customers, accounts, transactions to administrator;
grant select, insert, delete on accounts to support;

-- task 2.2
create user Amina;
grant accountant to Amina;
create user Janibek;
grant administrator to Janibek;
create user Tima;
grant support to Tima;

-- task 2.3
grant administrator to Tima with admin option;
-- or
grant all privileges on customers, accounts, transactions to Tima with grant option;
-- or
alter role support createrole;

-- task 2.4
revoke insert on accounts from Tima;

-- task 3.1
create assertion same_currency check
((select currency
  from accounts a join transactions on transactions.src_account = a.account_id) =
    (select currency
     from accounts a join transactions on transactions.dst_account = a.account_id));

-- task 3.2
alter table customers alter column birth_date set not null;

-- task 4
create type val as (sql varchar(3));
alter table accounts alter column currency type val;

-- task 5.1
create unique index un_cur on accounts(customer_id, currency);

-- task 5.2
create view trans
    as select * from transactions, accounts
            where src_account = accounts.account_id or dst_account = accounts.account_id;

create index search_trans on trans(currency, balance);

-- task 6
begin;
update accounts set balance = balance - 400 where account_id = 'RS88012';
savepoint oops;
update accounts set balance = balance + 400 where account_id = 'NT10204';
rollback to oops;
commit;