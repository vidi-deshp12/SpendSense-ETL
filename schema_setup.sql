-- ---------------------------------------------------
-- 1. create dimension tables (no foreign keys)
-- ---------------------------------------------------

create table accounts(
    account_id serial primary key,
    account_name varchar(10),
    bank_name varchar(15),
    account_type varchar(10)
);

create table categories(
    category_id serial primary key,
    category_name varchar(20) unique
);

create table merchants(
    merchant_id serial primary key,
    merchant_name varchar(20) unique 
);

-- ---------------------------------------------------
-- 2. create fact table (with foreign keys)
-- ---------------------------------------------------

create table transactions(
    transaction_id serial primary key,
    account_id int references accounts(account_id),
    category_id int references categories(category_id),
    merchant_id int references merchants(merchant_id),
    transaction_date date not null,
    description varchar(50),
    amount numeric(12,2),
    balance numeric(12,2),
    web_id varchar(15),
    online_transaction_id varchar(15)
);

-- ---------------------------------------------------
-- 3. add constraints and modifications
-- ---------------------------------------------------

-- unique constraint on date to prevent duplicates
alter table transactions
add constraint unique_txn unique(transaction_date, amount, description);

-- modification
alter table merchants
alter column merchant_name type varchar(70);