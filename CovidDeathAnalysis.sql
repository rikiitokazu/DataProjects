-- Total Cases and total deaths
-- Creates new column called DeathPercent to demonstrate likelihood of death
Select location, date, total_cases, total_deaths, (total_deaths/total_cases * 100) as DeathPercent
From PortfolioProject..['COVID deaths$']
Where location like '%states%'
and total_deaths is not null
Order by 1, 2


-- Total number of Cases and Population
-- Creates column to show percentage of population that was infected at that time
Select location, date, total_cases, population, (total_cases/population * 100) as CovidPop
From PortfolioProject..['COVID deaths$']
Where location like '%states%'
Order by 1, 2

-- Countries and their all time highest infected count. 
-- Shows the proportion of people that were severely affected
Select location, MAX(total_cases) as HighestInfection, population, Max((total_cases/population)) * 100 as InfectionPercent
From PortfolioProject..['COVID deaths$']
Group by location, population
Order by InfectionPercent desc

-- Showing the countries that had the most deaths
Select location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['COVID deaths$']
Where continent is not null 
Group by location
Order by TotalDeathCount desc

--Instead of using countries, will be using continents
-- Continents vs TotalDeathCount
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['COVID deaths$']
Where continent is not null 
Group by continent
Order by TotalDeathCount desc


-- Global numbers 
Select SUM(new_cases) as totalCases, SUM((cast(new_deaths as int))) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 10 as DeathPercent
From PortfolioProject..['COVID deaths$']
Where continent is not null 
Order by 1, 2