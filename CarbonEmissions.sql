--Units--						
--values in CountryEmissions sheet are expressed in Mt CO2/yr 							
--values in SectorEmisions sheet are expressed in Mt CO2/yr														
--values in CapitaEmissions sheet are expressed in t CO2/cap/yr							

--Start by Analyzing the 2021 Data
-- Compares the Country and 2021 Emission Data
SELECT Substance, Country, [2021]
FROM CarbonEmisssions..CountryEmissions
WHERE Country NOT LIKE '%GLOBAL TOTAL%'
ORDER BY 3 desc


-- Sector Emissions focusing on 2021 in United States
-- Sees the Dominating Sectors that contribute to Carbon Emisssions in the United States
Select SE.Sector, CE.Substance, CE.Country, CE.[2021], SE.[2021], (SE.[2021]/CE.[2021])*100 as SectorPercent
From CarbonEmisssions..CountryEmissions CE
JOIN CarbonEmisssions..SectorEmissions SE
	ON CE.Country = SE.COUNTRY
WHERE SE.[2021] IS NOT Null
and SE.Country = 'United States'


-- Seeing which Sectors countribute the most emissions globally in 2021, using a Temptable
-- Aims to identify the average percentage of emissions dedicated towards a certain sector

DROP TABLE IF EXISTS #SectorData
CREATE TABLE #SectorData
(
Sector nvarchar(255),
Substance nvarchar(255),
Country nvarchar(255),
[Carbon2021] float,
[Sector2021] float,
SectorPercent float
)
INSERT INTO #SectorData
Select SE.Sector, CE.Substance, CE.Country, CE.[2021], SE.[2021], (SE.[2021]/CE.[2021])*100 as SectorPercent
From CarbonEmisssions..CountryEmissions CE
JOIN CarbonEmisssions..SectorEmissions SE
	ON CE.Country = SE.COUNTRY
WHERE SE.[2021] IS NOT Null

Select Sector, AVG(Carbon2021) as Avg_carbonEmissions, AVG(Sector2021) as Avg_sectorEmissions, AVG(SectorPercent) as Avg_SectorPercent
FROM #SectorData
GROUP BY Sector
ORDER BY Avg_SectorPercent desc


--------------------------------------------------------
-- Examines which countries have the most carbon emissions per capita
Select Substance, Country, [2021]
FROM CarbonEmisssions..CapitaEmissions
WHERE [2021] IS NOT NULL
ORDER BY 3 desc
-------------------------------------------------------------


---Using PIVOT to switch the columns and rows to make graphing easier for later use
-- Creating a table called CountryEmissions2
DROP TABLE IF EXISTS CountryEmissions2
CREATE TABLE CountryEmissions2
(
Country nvarchar(255),
Year int,
Value float
)
INSERT INTO CountryEmissions2
Select Country, Year, Value from
(Select Country, [1970], [1971], [1972], [1973], [1974], [1975], [1976], [1977], [1978], [1979], 
[1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989], 
[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999],
[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], 
[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021]
From CarbonEmisssions..CountryEmissions) OrigData
UNPIVOT
(Value FOR YEAR IN ([1970], [1971], [1972], [1973], [1974], [1975], [1976], [1977], [1978], [1979], 
[1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989], 
[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999],
[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], 
[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021])
) as UNPIVT_Data

-- displays the country and the year where the carbon emissions were the highest
Select Country, Year, Value
FROM CountryEmissions2
WHERE Value IN (
SELECT MAX(VALUE) FROM CountryEmissions2 GROUP BY COUNTRY)
and Country <> 'GLOBAL TOTAL'
ORDER BY Value
-----------------------------------------------------------------------------

-- Displays the United States trend of Carbon Emissions over the years
Select Year, Value
FROM CountryEmissions2
WHERE Country = 'United States'
ORDER BY 1 



---Using the PIVOT again to switch the columns and rows to make graphing easier for later use
-- Creating a table called AlteredSectorEmissions
DROP TABLE IF EXISTS AlteredSectorEmissisions
CREATE TABLE AlteredSectorEmissisions
(
Sector nvarchar(255),
Country nvarchar(255),
Year int,
Value float
)
INSERT INTO AlteredSectorEmissisions
Select Sector, Country, Year, Value from
(Select Sector, Country, [1970], [1971], [1972], [1973], [1974], [1975], [1976], [1977], [1978], [1979], 
[1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989], 
[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999],
[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], 
[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021]
From CarbonEmisssions..SectorEmissions) OrigData
UNPIVOT
(Value FOR YEAR IN ([1970], [1971], [1972], [1973], [1974], [1975], [1976], [1977], [1978], [1979], 
[1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989], 
[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999],
[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], 
[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021])
) as UNPIVT_Data
------------------------------------------------------------------------------------------

--Examines the power industry trend for the US
Select *
FROM AlteredSectorEmissisions
WHERE Country = 'United States'
and Sector = 'Power Industry'

--Examines the Buildings industry trend for the US
Select *
FROM AlteredSectorEmissisions
WHERE Country = 'United States'
and Sector = 'Buildings'

--Examines the Transport industry trend for the US
Select *
FROM AlteredSectorEmissisions
WHERE Country = 'United States'
and Sector = 'Transport'


--Examines the other industry combustion trends for the US
Select *
FROM AlteredSectorEmissisions
WHERE Country = 'United States'
and Sector like '%Other indus%'


--Examines the Other sectors trends for the US
Select *
FROM AlteredSectorEmissisions
WHERE Country = 'United States'
and Sector = 'Other sectors'


-- Compares the Carbon Emissions between China and the US over the years
DROP TABLE IF EXISTS #China
CREATE TABLE #China
(
ChinaYear nvarchar(255),
ChinaValue float,
)
INSERT INTO #China
SELECT Year, Value
FROM CountryEmissions2
WHERE Country = 'China'

DROP TABLE IF EXISTS #America
CREATE TABLE #America
(
UsYear nvarchar(255),
USValue float,
)
INSERT INTO #America
SELECT Year, Value
FROM CountryEmissions2
WHERE Country = 'United States'

Select * 
From #China C
JOIN #America US
	on C.ChinaYear = US.UsYear
-----------------------------------------------


--Looks at Global Emissions per decade
Select * 
FROM CountryEmissions2
WHERE YEAR % 10 = 0
and Country like '%Global%'

--Looks at all Country's 1980 Data
Select a.Country, b.[1980]
From CarbonEmisssions..CountryEmissions a 
LEFT JOIN CarbonEmisssions..CountryEmissions b
	ON a.Country = b.Country



-- Using a CTE and Case statements in order to create a NorthAmerica row that features the US, Canada, and Mexico
--Compares with the rest of the world for total Emissions just in 2021
With NaComparison (Country, Year, CarbonEmissions, NavWorld)
as
(
SELECT Country, Year, Value,
CASE
	WHEN Country = 'United States' 
	or Country = 'Canada'
	or Country = 'Mexico' THEN 'North America'
	ELSE 'Rest of World'
END as NAvWorld
FROM AlteredSectorEmissisions
WHERE Year = 2021
)

Select NavWorld, SUM(CarbonEmissions) as CarbonEmission
FROM NaComparison
GROUP BY NavWorld

----------------------------------------------------------------------------