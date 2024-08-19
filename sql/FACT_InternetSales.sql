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
