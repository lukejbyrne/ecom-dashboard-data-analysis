# sales-dashboard-data-analysis

## Business Request & User Stories
The business request for this data analyst project was an executive sales report for sales managers. Based on the request that was made from the business we following user stories were defined to fulfill delivery and ensure that acceptance criteria’s were maintained throughout the project.

| # | As a (role)          | I want (request / demand)                           | So that I (user value)                                                    | Acceptance Criteria                                                   |
|---|----------------------|-----------------------------------------------------|---------------------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | Sales Manager        | To get a dashboard overview of internet sales       | Can follow better which customers and products sells the best             | A Power BI dashboard which updates data once a day                    |
| 2 | Sales Representative | A detailed overview of Internet Sales per Customers | Can follow up my customers that buys the most and who we can sell more to | A Power BI dashboard which allows me to filter data for each customer |
| 3 | Sales Representative | A detailed overview of Internet Sales per Products  | Can follow up my Products that sells the most                             | A Power BI dashboard which allows me to filter data for each Product  |
| 4 | Sales Manager        | A dashboard overview of internet sales              | Follow sales over time against budget                                     | A Power Bi dashboard with graphs and KPIs comparing against budget.   |

## Data Cleansing & Transformation (SQL)
To create the necessary data model for doing analysis and fulfilling the business needs defined in the user stories the following tables were extracted using SQL.

One data source (sales budgets) were provided in Excel format and were connected in the data model in a later step of the process.

Below are the SQL statements for cleansing and transforming necessary data.

```
-- Cleansed DIM_DateTable --
SELECT
    d.DateKey,
    d.FullDateAlternateKey AS Date,
    d.EnglishDayNameOfWeek AS Day,
    d.WeekNumberOfYear AS WeekNr,
    d.EnglishMonthName AS Month,
    LEFT(d.EnglishMonthName, 3) AS MonthShort, -- To improve visualisation.
    d.MonthNumberOfYear AS MonthNo,
    d.CalendarQuarter AS Quarter,
    d.CalendarYear AS Year
FROM dbo.DimDate AS d
WHERE d.CalendarYear >= 2019
```

```
-- Cleansed DIM_Customers Table --
SELECT 
	c.customerkey AS CustomerKey,
	c.firstname AS [First Name],
	c.lastname AS [Last Name],
	c.firstname + ' ' + c.lastname AS [Full Name],
	CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender, -- Reformat for better visualisation.
	c.datefirstpurchase AS DateFirstPurchase,
	g.city AS [Customer City]
FROM dbo.dimcustomer AS c
	LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey -- Joined Customer City from Geography Table.
ORDER BY
	CustomerKey ASC
```

```
-- Cleansed DIM_Product Table --
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode, 
  p.[EnglishProductName] AS [Product Name], 
  ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Sub Category Table
  pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Category Table
  p.[Color] AS [Product Color], 
  p.[Size] AS [Product Size], 
  p.[ProductLine] AS [Product Line], 
  p.[ModelName] AS [Product Model Name], 
  p.[EnglishDescription] AS [Product Description], 
  ISNULL (p.Status, 'Outdated') AS [Product Status] 
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] as p
  LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
order by 
  p.ProductKey asc
```

```
-- Cleansed FACT_InternetSales Table --
SELECT 
    [ProductKey],
    [OrderDateKey],
    [DueDateKey],
    [ShipDateKey],
    [CustomerKey],
    [SalesOrderNumber],
    [SalesAmount]
FROM 
	[dbo].[FactInternetSales]
WHERE
	LEFT (OrderDateKey, 4) >= 2019 -- Left as Leftmost 4 are year.
ORDER BY
	OrderDateKey ASC
```

## Data Model
![alt text](http://url/to/img.png)

## Sales Management Dashboard
The finished sales management dashboard with one page with works as a dashboard and overview, with two other pages focused on combining tables for necessary details and visualizations to show sales over time, per customers and per products.
