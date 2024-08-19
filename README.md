# Sales Dashboard 
## Summary
The sales dashboard project was created to enhance internet sales reporting by moving from static reports to dynamic visual dashboards. The dashboard tracks sales by product and customer, allows filtering by sales representatives, and compares performance against the budget. Data was cleansed and transformed using SQL, and the resulting Power BI dashboard provides a comprehensive view of sales trends, enabling better analysis and decision-making for sales managers and representatives.
![alt text](https://github.com/lukejbyrne/sales-dashboard-data-analysis/blob/main/SalesDashboard/SalesDashboard-1.png)

## Business Request & User Stories
### Business Request
Steven  - Sales Manager:
We need to improve our internet sales reports and want to move from static reports to visual dashboards.
Essentially, we want to focus it on how much we have sold of what products, to which clients and how it has been over time.
Seeing as each sales person works on different products and customers it would be beneficial to be able to filter them also.
We measure our numbers against budget so I added that in a spreadsheet so we can compare our values against performance. 
The budget is for 2021 and we usually look 2 years back in time when we do analysis of sales.
Let me know if you need anything else!

### User Stories
As a result of the received request, the following stories were created.

| # | As a (role)          | I want (request / demand)                           | So that I (user value)                                                    | Acceptance Criteria                                                   |
|---|----------------------|-----------------------------------------------------|---------------------------------------------------------------------------|-----------------------------------------------------------------------|
| 1 | Sales Manager        | To get a dashboard overview of internet sales       | Can follow better which customers and products sells the best             | A Power BI dashboard which updates data once a day                    |
| 2 | Sales Representative | A detailed overview of Internet Sales per Customers | Can follow up with my customers that buy the most and who we can sell more to | A Power BI dashboard which allows me to filter data for each customer |
| 3 | Sales Representative | A detailed overview of Internet Sales per Product  | Can follow up my Products that sell the most                             | A Power BI dashboard which allows me to filter data for each Product  |
| 4 | Sales Manager        | A dashboard overview of internet sales              | Follow sales over time against budget                                     | A Power BI dashboard with graphs and KPIs comparing against budget.   |

## Data Cleansing & Transformation (SQL)
To create the necessary data model for the analysis to fulfill the business needs, the following tables were extracted using SQL.

One data source (sales budgets) was provided in Excel format and was connected to the data model after initial cleansing.

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
The subsequent data model was produced.
![alt text](https://github.com/lukejbyrne/sales-dashboard-data-analysis/blob/main/datamodel.webp)

## Sales Management Dashboard
The finished sales management dashboard with one page works as a dashboard and overview, with two other pages focused on combining tables for necessary details and visualizations to show sales over time, per customer, and product.

![alt text](https://github.com/lukejbyrne/sales-dashboard-data-analysis/blob/main/SalesDashboard/SalesDashboard-1.png)
![alt text](https://github.com/lukejbyrne/sales-dashboard-data-analysis/blob/main/SalesDashboard/SalesDashboard-2.png)
![alt text](https://github.com/lukejbyrne/sales-dashboard-data-analysis/blob/main/SalesDashboard/SalesDashboard-3.png)
