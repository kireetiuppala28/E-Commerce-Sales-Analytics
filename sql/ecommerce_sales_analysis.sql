create database ecommerce_analytics;
use ecommerce_analytics;

select database();
show tables;
describe sales;
select count(*) from sales;
select *from sales;


# 1.Overall KPIs
select count(distinct Order_Id) as Total_Orders,
count(distinct Customer_Id) as Total_Customers,
sum(Quantity) as Total_Quantity_Sold,
Round(SUM(Revenue),2) as Total_Revenue,
Round(SUM(Revenue)/Count(Distinct Order_Id),2) as Average_Order_Value from sales;

# 2.Monthly Revenue Trend
select Year,Month,Month_name,Round(SUM(Revenue),2) as Revenue,
Count(Distinct Order_ID) as Orders
from sales group by Year,Month,Month_Name Order by Year,Month;

# 3.Category Performance
select Category,
Round(Sum(Revenue),2) as Revenue,
Sum(Quantity) as Quantity_Sold,
count(distinct Order_id) as Orders 
from sales
group by Category
order by Revenue DESC;

# 4.Top 10 Products
select Product_Name,Category,
Round(Sum(Revenue),2) as Revenue,
sum(Quantity) as Quantity_Sold
from sales group by Product_Name,
Category Order by Revenue DESC LIMIT 10;

# 5.Regional/State Performance
Select State,
Round(Sum(Revenue),2) as Revenue,
count(distinct(Order_Id)) as Orders,
count(distinct(Customer_Id)) as Customers
from sales group by state
order by revenue desc;

# 6.Customer Analysis
Select Customer_Id,
Customer_Name,
ROUND(Sum(Revenue)) as Revenue,
count(distinct(Order_Id)) as Orders
from sales
group by Customer_id,customer_name 
order by revenue desc limit 10;

# 7.Payment Method Analysis
select Payment_method,
count(distinct(Order_Id)) as Orders,
round(sum(Revenue),2) as Revenue,
round(sum(Revenue)/(Select sum(revenue) from sales)*100,2) as Revenue_Share_Percent from sales
group by payment_method
order by revenue desc;

# 8. Order Status Analysis
Select Order_Status,
count(distinct(Order_Id)) as Orders,
Round(sum(Revenue)) as Revenue
from sales group by order_status 
order by revenue desc;

# 9.Gender and Age Analysis
select Gender,
count(distinct(Order_id)) as Orders,
count(distinct(Customer_id)) as Orders,
round(sum(revenue)) as Revenue 
from sales group by Gender
order by Revenue DESC;

select Age_Group,
count(distinct(Order_id)) as Orders,
count(distinct(Customer_id)) as Orders,
round(sum(revenue)) as Revenue 
from sales group by Age_Group
order by Revenue DESC;

# 10.Discount Analysis
select Discount*100 as Discount,
Count(distinct(Order_Id))as Orders,
sum(Quantity) as Quantity_Sold,
round(sum(Revenue)) as Revenue from sales 
group by Discount order by discount;

# 11.Return Rate
select count(distinct(Order_Id)) as Orders,
count(distinct case 
when Order_Status="Returned" then Order_Id
end) as Returned_Orders,
round(count(distinct case
when Order_Status="Returend" then Order_Id
end)*100/count(distinct Order_Id),2) as Returrn_Date_Percent from sales;

#12.Monthly Growth
with monthly_sales as(select Year,
onth,Month_name,sum(Revenue) as Revenue from sales
group by Year,Month,Month_name)
select Year,Month,Month_name,round(Revenue,2) as Revenue,
round((Revenue-LAG(Revenue) over (order by Year,Month))/
LAG(Revenue) over(order by Year,Month)*100,2) as Monthly_Growth_Percent
from sales order by Year,Month;


SELECT
    Order_ID,
    COUNT(DISTINCT Order_Date) AS Dates,
    COUNT(DISTINCT Customer_ID) AS Customers,
    COUNT(DISTINCT Customer_Name) AS Names,
    COUNT(DISTINCT Gender) AS Genders,
    COUNT(DISTINCT Age) AS Ages,
    COUNT(DISTINCT City) AS Cities,
    COUNT(DISTINCT State) AS States,
    COUNT(DISTINCT Product_ID) AS Products,
    COUNT(DISTINCT Product_Name) AS Product_Names,
    COUNT(DISTINCT Category) AS Categories,
    COUNT(DISTINCT Quantity) AS Quantities,
    COUNT(DISTINCT Unit_Price) AS Prices,
    COUNT(DISTINCT Discount) AS Discounts,
    COUNT(DISTINCT Revenue) AS Revenues,
    COUNT(DISTINCT Payment_Method) AS Payments,
    COUNT(DISTINCT Order_Status) AS Statuses
FROM sales
WHERE Order_ID IN (
    'ORD000642',
    'ORD001788',
    'ORD003045',
    'ORD004467',
    'ORD009033'
)
GROUP BY Order_ID;




# To verify unknown values
CREATE TABLE ecommerce AS SELECT * FROM sales;
SELECT COUNT(*) AS Rowss FROM ecommerce;


# For ORD000642
UPDATE ecommerce
SET City = 'Madurai'
WHERE Order_ID = 'ORD000642'
AND City = 'Unknown';

# For ORD001788
UPDATE sales
SET Gender = 'Female'
WHERE Order_ID = 'ORD001788'
AND Gender = 'Unknown';

# For ORD003045
UPDATE sales
SET Gender = 'Female'
WHERE Order_ID = 'ORD003045'
AND Gender = 'Unknown';

# For ORD004467
UPDATE sales
SET Gender = 'Female'
WHERE Order_ID = 'ORD004467'
AND Gender = 'Unknown';

# For ORD009033
UPDATE sales
SET City = 'Kolkata'
WHERE Order_ID = 'ORD009033'
AND City = 'Unknown';

SELECT
    Order_ID,
    COUNT(*) AS Row_Count
FROM sales
GROUP BY Order_ID
HAVING COUNT(*) > 1;


# Business Analysis
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM sales_final;

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT Order_ID),
        2
    ) AS Average_Order_Value
FROM sales_final;

SELECT
    Year,
    Month,
    Month_Name,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY
    Year,
    Month;
    
    
    
SELECT
    Year,
    Month,
    Month_Name,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY Revenue DESC
LIMIT 1;

SELECT
    Year,
    Month,
    Month_Name,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY Revenue ASC
LIMIT 1;

SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Category
ORDER BY Revenue DESC;


SELECT
    Product_Name,
    Category,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Product_Name,
    Category
ORDER BY Revenue DESC
LIMIT 10;


SELECT
    State,
    COUNT(DISTINCT Order_ID) AS Orders,
    COUNT(DISTINCT Customer_ID) AS Customers,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY State
ORDER BY Revenue DESC;



SELECT
    Year,
    Month,
    Month_Name,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY
    Year,
    Month;
    
    
# Category Analysis
SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Category
ORDER BY Revenue DESC;


SELECT
    Category,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) /
        (SELECT SUM(Revenue) FROM sales_final) * 100,
        2
    ) AS Revenue_Percentage
FROM sales_final
GROUP BY Category
ORDER BY Revenue DESC;


SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT Order_ID),
        2
    ) AS Average_Order_Value
FROM sales_final
GROUP BY Category
ORDER BY Average_Order_Value DESC;

SELECT
    Product_ID,
    Product_Name,
    Category,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Product_ID,
    Product_Name,
    Category
ORDER BY Revenue DESC
LIMIT 10;

SELECT
    Product_Name,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) /
        (SELECT SUM(Revenue) FROM sales_final) * 100,
        2
    ) AS Revenue_Percentage
FROM sales_final
WHERE Product_Name = 'Laptop'
GROUP BY Product_Name;

SELECT
    State,
    COUNT(DISTINCT Order_ID) AS Orders,
    COUNT(DISTINCT Customer_ID) AS Customers,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY State
ORDER BY Revenue DESC;

SELECT
    State,
    COUNT(DISTINCT Customer_ID) AS Customers,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) /
        COUNT(DISTINCT Customer_ID),
        2
    ) AS Revenue_Per_Customer
FROM sales_final
GROUP BY State
ORDER BY Revenue_Per_Customer DESC;

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Customer_ID,
    Customer_Name
ORDER BY Revenue DESC
LIMIT 10;

SELECT
    COUNT(*) AS Repeat_Customers
FROM (
    SELECT
        Customer_ID
    FROM sales_final
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) AS repeat_customers;

SELECT
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT CASE
        WHEN Order_Count > 1 THEN Customer_ID
    END) AS Repeat_Customers
FROM (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Order_Count
    FROM sales_final
    GROUP BY Customer_ID
) AS customer_orders;


SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN Order_Count > 1 THEN Customer_ID
        END)
        / COUNT(DISTINCT Customer_ID) * 100,
        2
    ) AS Repeat_Customer_Percentage
FROM (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Order_Count
    FROM sales_final
    GROUP BY Customer_ID
) AS customer_orders;


SELECT
    Payment_Method,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Payment_Method
ORDER BY Revenue DESC;

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Order_Status
ORDER BY Orders DESC;

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(
        COUNT(DISTINCT Order_ID) /
        (SELECT COUNT(DISTINCT Order_ID) FROM sales_final) * 100,
        2
    ) AS Order_Percentage
FROM sales_final
GROUP BY Order_Status
ORDER BY Orders DESC;

SELECT
    Payment_Method,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Payment_Method
ORDER BY Revenue DESC;

SELECT
    Payment_Method,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT Order_ID),
        2
    ) AS Average_Order_Value
FROM sales_final
GROUP BY Payment_Method
ORDER BY Average_Order_Value DESC;

SELECT
    Discount,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY Discount
ORDER BY Discount;

SELECT
    Discount,
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Discount,
    Order_Status
ORDER BY
    Discount,
    Order_Status;

SELECT
    Discount,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT Order_ID),
        2
    ) AS Average_Order_Value
FROM sales_final
GROUP BY Discount
ORDER BY Discount;

SELECT
    Discount,
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_final
GROUP BY
    Discount,
    Order_Status
ORDER BY
    Discount,
    Order_Status;
    
SELECT
    COUNT(*) AS Repeat_Customers
FROM (
    SELECT
        Customer_ID
    FROM sales_final
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) AS repeat_customers;