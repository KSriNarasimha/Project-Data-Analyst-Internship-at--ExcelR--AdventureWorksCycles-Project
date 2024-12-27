create database project;
use project;

-- Tables, Adventure works excel datasets imported to MySQL

select * from fact_internet_sales_new;
select * from factinternetsales;
select * from dimsalesterritory;
select * from dimcustomer;
select * from dimdate;
select * from sales;
Select * from DIMproduct_Catagory_Sub_catagory;

-- 0. Union of Fact Internet sales and Fact internet sales new

create database project;
use project;

CREATE TABLE Fact_Internet_Sales_Union AS
SELECT * FROM FactInternetSales
UNION ALL
SELECT * FROM Fact_Internet_Sales_New;

select * from Fact_Internet_Sales_Union;

-- 1.Lookup the productname from the Product sheet to Sales sheet.

SELECT EnglishProductName as ProductName
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;
      
  
SELECT FISU.*, EnglishProductName as ProductName
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;
    
-- 2.Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet.

SELECT CONCAT(DC.FirstName, ' ', IFNULL(DC.MiddleName, ''), ' ', DC.LastName) AS CustomerFullName
FROM Fact_Internet_Sales_Union FISU
JOIN DimCustomer DC 
    ON FISU.CustomerKey = DC.CustomerKey;

SELECT EnglishProductName as ProductName, CONCAT(DC.FirstName, ' ', IFNULL(DC.MiddleName, ''), ' ', DC.LastName) AS CustomerFullName
FROM Fact_Internet_Sales_Union FISU
JOIN DimCustomer DC 
    ON FISU.CustomerKey = DC.CustomerKey
    JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;


SELECT FISU.*,EnglishProductName as ProductName, CONCAT(DC.FirstName, ' ', IFNULL(DC.MiddleName, ''), ' ', DC.LastName) AS CustomerFullName
FROM Fact_Internet_Sales_Union FISU
JOIN DimCustomer DC 
    ON FISU.CustomerKey = DC.CustomerKey
    JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;

-- 2.Lookup the Unit Price from Product sheet to Sales sheet.

SELECT UnitPrice
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
ON FISU.ProductKey = DPCS.ProductKey;

-- Lookup product name, customer full name and unit price in one frame 
SELECT EnglishProductName as ProductName, CONCAT(DC.FirstName, ' ', IFNULL(DC.MiddleName, ''), ' ', DC.LastName) AS CustomerFullName, UnitPrice
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
ON FISU.ProductKey = DPCS.ProductKey
JOIN DimCustomer DC 
ON FISU.CustomerKey = DC.CustomerKey;


-- 3.calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)
  -- A.Year
  -- B.Monthno
  -- C.Monthfullname
  -- D.Quarter(Q1,Q2,Q3,Q4)
  -- E. YearMonth ( YYYY-MMM)
  -- F. Weekdayno
  -- G.Weekdayname
  -- H.FinancialMOnth
  -- I. Financial Quarter 
  
-- A.Display Year
Select 
  STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS Year
    FROM Fact_Internet_Sales_Union FISU;

-- B.Display Monthno
Select 
  STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo
    FROM Fact_Internet_Sales_Union FISU;

  -- C.Display Monthfullname
  
  Select 
    STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName
    FROM Fact_Internet_Sales_Union FISU;
    
-- Display Orderdate, year, monthNo, MonthFullName

  Select 
  STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName
    FROM Fact_Internet_Sales_Union FISU;

-- D.Display Quarter(Q1,Q2,Q3,Q4)

SELECT 
       MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter
FROM Fact_Internet_Sales_Union FISU;

-- E. Year-Month (YYYY-MMM)
SELECT 
STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,

    CONCAT(YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')), '-', 
           DATE_FORMAT(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'), '%b')) AS YearMonth
FROM Fact_Internet_Sales_Union FISU;

-- F. Weekday Number (Weekdayno)

SELECT 
    STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    DAYOFWEEK(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo
FROM Fact_Internet_Sales_Union FISU;

-- G. Weekday Name (Weekdayname)

SELECT 
    STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    DAYOFWEEK(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo,
    DAYNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayName
FROM Fact_Internet_Sales_Union FISU;

-- H. Financial Month (FM1, FM2, ..., FM12)

SELECT 
MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 4 THEN 'FM1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 5 THEN 'FM2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 6 THEN 'FM3'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 7 THEN 'FM4'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 8 THEN 'FM5'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 9 THEN 'FM6'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 10 THEN 'FM7'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 11 THEN 'FM8'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 12 THEN 'FM9'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 1 THEN 'FM10'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 2 THEN 'FM11'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 3 THEN 'FM12'
    END AS FinancialMonth
FROM Fact_Internet_Sales_Union FISU;

-- I. Financial Quarter (FQ1, FQ2, FQ3, FQ4)

SELECT 
MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'FQ3'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'FQ4'
    END AS FinancialQuarter
FROM Fact_Internet_Sales_Union FISU;


-- Combine all 3rd question 
SELECT 
    -- A. Order Date
    STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,

    -- B. Year
    YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,

    -- C. Month Number (Monthno)
    MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,

    -- D. Month Full Name (Monthfullname)
    MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,

    -- E. Quarter (Q1, Q2, Q3, Q4)
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter,

    -- F. Year-Month (YYYY-MMM)
    CONCAT(YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')), '-', 
           DATE_FORMAT(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d'), '%b')) AS YearMonth,

    -- G. Weekday Number (Weekdayno)
    DAYOFWEEK(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo,

    -- H. Weekday Name (Weekdayname)
    DAYNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayName,

    -- I. Financial Month (FM1, FM2, ..., FM12) (Fiscal month starts from April)
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 4 THEN 'FM1'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 5 THEN 'FM2'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 6 THEN 'FM3'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 7 THEN 'FM4'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 8 THEN 'FM5'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 9 THEN 'FM6'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 10 THEN 'FM7'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 11 THEN 'FM8'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 12 THEN 'FM9'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 1 THEN 'FM10'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 2 THEN 'FM11'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = 3 THEN 'FM12'
    END AS FinancialMonth,

    -- J. Financial Quarter (FQ1, FQ2, FQ3, FQ4) (Fiscal quarter starts from April)
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'FQ3'
        WHEN MONTH(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'FQ4'
    END AS FinancialQuarter

FROM Fact_Internet_Sales_Union FISU;


-- 4.Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)
SELECT FISU.productkey,DPCS.EnglishProductName AS ProductName,
       (FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) AS SalesAmount
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;
    
-- Total Sales in Thousands with two decimal values 
    
SELECT 
    ROUND(SUM(FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) / 1000, 2) AS TotalSalesAmount_K
FROM 
    Fact_Internet_Sales_Union FISU
JOIN 
    DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;


-- 5.Calculate the Productioncost uning the columns(unit cost ,order quantity)


SELECT FISU.productkey,DPCS.EnglishProductName AS ProductName ,
       (FISU.ProductStandardCost * FISU.OrderQuantity) AS ProductionCost
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;

-- Total Production cost (KPI) in thousands (K) with only two decimal values 
SELECT 
       Round(sum(((FISU.ProductStandardCost * FISU.OrderQuantity))) /1000,2) AS Total_ProductionCost_in_K
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;


-- 6.Calculate the profit.
SELECT FISU.productkey,DPCS.EnglishProductName AS ProductName,
     (FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) AS SalesAmount,
     (FISU.ProductStandardCost * FISU.OrderQuantity) AS ProductionCost,
     (FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) - (FISU.ProductStandardCost * FISU.OrderQuantity) AS Profit
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;
    
-- Total profit in thousands (K) with two decimal values 
SELECT 
     Round(sum(((FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) - (FISU.ProductStandardCost * FISU.OrderQuantity))) /1000 , 2) AS Profit
FROM Fact_Internet_Sales_Union FISU
JOIN DIMproduct_Catagory_Sub_catagory DPCS 
    ON FISU.ProductKey = DPCS.ProductKey;

-- 7.Create a table for month and sales (provide the Year as filter to select a particular Year)


Select 
    YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    (FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) AS SalesAmount
    FROM Fact_Internet_Sales_Union FISU;

-- Stored procedure : to filter the year to display monthly salesAmount

DELIMITER $$

CREATE PROCEDURE monthly_sales(IN input_year INT)
BEGIN
    SELECT 
        YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
        MONTHNAME(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
        -- Calculate total sales and format it to the nearest thousand unit with 'K'
        CONCAT(FORMAT(SUM(FISU.UnitPrice * FISU.OrderQuantity * (1 - FISU.UnitPriceDiscountPct)) / 1000, 0), 'K') AS TotalSalesInK
    FROM Fact_Internet_Sales_Union FISU
    JOIN DIMproduct_Catagory_Sub_catagory DPCS ON FISU.ProductKey = DPCS.ProductKey
    JOIN DimCustomer DC ON FISU.CustomerKey = DC.CustomerKey
    WHERE YEAR(STR_TO_DATE(CAST(FISU.OrderDateKey AS CHAR), '%Y%m%d')) = input_year
    GROUP BY Year, MonthFullName
    ORDER BY YEAR, MonthFullName;
END $$

DELIMITER ;

-- Display top 5 sub-catagory wise sales 

select DPCS.ProductSubcategoryName as SubCatagory,
       ROUND(sum(FISU.UnitPrice * FISU.OrderQuantity * (1- FISU.UnitPriceDiscountPct)) / 1000 , 2) as TotalSalesAmount_in_K
From
     Fact_internet_Sales_Union FISU
JOIN
     DIMProduct_Catagory_Sub_Catagory DPCS 
ON FISU.ProductKey = DPCS.Productkey
GROUP BY 
	   DPCS.ProductSubcategoryName
ORDER BY 
	   TotalSalesAmount_in_K DESC
Limit 5 ;

   
