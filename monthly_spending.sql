-- ###################################################
-- 1. BASE VIEW CREATION (Foundational Aggregation)
-- ###################################################

-- view: aggregates all transactions by month
create or replace view monthly_summary as
select 
    date_trunc('month', transaction_date)::date as month,
    sum(case when amount<0 then amount else 0 end) as total_spending,
    sum(case when amount>0 then amount else 0 end) as total_income,
    sum(amount) as net_savings,
    count(*) as num_transactions
from transactions
group by 1
order by 1;

-- view: groups transactions by month (for easier joining)
create or replace view monthly_transactions as
select 
    transaction_id, 
    category_id, 
    amount, 
    merchant_id,
    date_trunc('month', transaction_date)::date as month
from transactions
order by transaction_date;


-- ###################################################
-- 2. FINAL KPI VIEW (Monthly Summary with MoM Calculations)
-- ###################################################

-- drop view if exists monthly_summary_new cascade;

create or replace view monthly_summary_new as
with base as (
    select 
        month,
        total_spending,
        total_income,
        net_savings,
        num_transactions,

        -- previous month values using lag window functions
        -1 * lag(total_spending, 1, 0) over (order by month) as prev_spending,
        lag(total_income, 1, 0) over (order by month) as prev_income,
        lag(net_savings, 1, 0) over (order by month) as prev_savings
    from monthly_summary
),
final as (
    select 
        *,
        
        --------------------------------
        -- absolute changes (spending, income & savings value change)
        --------------------------------
        case 
            when prev_spending = 0 then 0
            else (prev_spending - (-1 * total_spending))
        end as spending_change,

        case 
            when prev_income = 0 then 0
            else (prev_income - total_income)
        end as income_change,

        case 
            when prev_savings = 0 then 0
            else (prev_savings - net_savings)
        end as savings_change,

        --------------------------------
        -- percentage changes(spending, income & savings)
        --------------------------------
        case 
            when prev_spending = 0 then 0
            else round(100 * (prev_spending - (-1 * total_spending)) / prev_spending, 2)
        end as pct_spending_change,

        case 
            when prev_income = 0 then 0
            else round(100 * (prev_income - total_income) / prev_income, 2)
        end as pct_income_change,

        case 
            when prev_savings = 0 then 0
            else round(100 * (prev_savings - net_savings) / prev_savings, 2)
        end as pct_savings_change
    from base
)
select * from final;


-- ###################################################
-- 3. INTERMEDIATE/REPORTING VIEWS (Dashboard Components)
-- ###################################################

-- spending per category per month (was commented out)
create or replace view spend_per_category_per_month as
select 
    to_char(m.month, 'fmmonth') as month, 
    c.category_name,
    -sum(amount) as spend_per_category
from monthly_transactions m
join categories c
on m.category_id=c.category_id
where m.amount<0 -- so that we only sum over spendings
group by m.month, c.category_id
order by m.month, c.category_id;


-- ###################################################
-- 4. DATA MANIPULATION (DML) - FOR SETUP/CLEANING
-- ###################################################

insert into categories(category_name)
values ('transit/travel');

update transactions
set category_id=(
    select category_id from categories where category_name='transit/travel'
)
where merchant_id=30;

-- set synthetic flag 
alter table transactions
add column is_synthetic boolean default false;

update transactions
set is_synthetic=true
where transaction_date between '2025-10-28' and '2025-11-15';


-- ###################################################
-- 5. TESTING AND AD HOC ANALYSIS QUERIES
-- ###################################################

select * from monthly_summary_new;

select * from spend_per_category_per_month;

select * from categories;

select * from merchants;

select * from transactions
order by transaction_date;

-- other ad-hoc queries:

-- monthly income vs spending, net savings
select to_char(month, 'fmmonth'),
 sum(case when amount>0 then amount else 0 end) as monthly_income,
 -1*sum(case when amount<0 then amount else 0 end) as monthly_spending
from monthly_transactions
group by month
order by month;

-- top 2 spending categories
select month, category_name
from(
 select *,
 row_number() over(order by spend_per_category desc) as rn
 from spend_per_category_per_month
 where month = 'october'
)t
where rn=1 or rn=2;

-- weekly spending trends
select
 date_trunc('week', transaction_date) as week,
 -sum(case when amount<0 then amount else 0 end) as weekly_spending
from transactions
group by week
order by week;

select 
 min(transaction_date) as start_date,
 max(transaction_date) as end_date,
 sum(amount) as net_change
from transactions;