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
