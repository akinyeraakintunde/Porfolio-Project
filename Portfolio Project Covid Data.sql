SELECT *
FROM PortfolioProject.dbo.coviddata
where continent is not null
order by 3,4

------looking for the total cases vs total deaths
SELECT location, date, population, (Cast(total_cases as int)) as totalcase, (Cast(total_deaths as int)) as totaldeaths,
((Cast(total_cases as int))/(Cast(total_deaths as int)))*100 as Deathscases
FROM PortfolioProject.dbo.coviddata
--where location like '%Nigeria%'
--where continent is not null
order by location

--looking at the total cases vs the population
--percentage of population has covid

SELECT location, date, population, total_cases,  (total_cases/population)*100 as Covidcases
FROM PortfolioProject.dbo.coviddata
where location like '%Nigeria%'
order by 1,2

--looking for contries with the highest infention rate compared to population

SELECT location, Population,  MAX(total_cases) as HighestCount,  Max((total_cases/population))*100 as 
PercentageInfected
FROM PortfolioProject.dbo.coviddata
where continent is not null
Group by location, population
order by PercentageInfected desc


--Showing counties wuth the highest Death Count per population

SELECT Location, MAX(Cast(total_deaths as int)) as Totaldeathcount
FROM PortfolioProject.dbo.coviddata
where continent is not null
Group by location
order by Totaldeathcount desc

--BY CONTINENT
SELECT continent, MAX(Cast(total_deaths as int)) as Totaldeathcount
FROM PortfolioProject.dbo.coviddata
where continent is not null
Group by continent
order by Totaldeathcount desc


SELECT location, MAX(Cast(total_deaths as int)) as Totaldeathcount
FROM PortfolioProject.dbo.coviddata
where continent is  null
Group by location
order by Totaldeathcount desc


--looking at the global numbers
SELECT  continent, SUM(New_cases) , SUM(Cast(new_deaths as int)),
SUM(cast(new_deaths as int))/SUM(New_cases)*100 as Deathpercentage
FROM PortfolioProject.dbo.coviddata
where continent is not null
Group by continent
order by  1,2

--temp Table
Drop Table if exists #PercentPopulationdeaths
Create Table #PercentPopulationdeaths
( 
Contintent nvarchar(255),
Location nvarchar(255),
date Datetime,
Population numeric) 

--insert into #PercentPopulationdeaths
SELECT  location, date, population, (Cast(total_cases as int)) as totalcase, (Cast(total_deaths as int)) as totaldeaths,
((Cast(total_cases as int))/(Cast(total_deaths as int)))*100 as Deathscases
FROM PortfolioProject.dbo.coviddata
--where location like '%Nigeria%'
--where continent is not null
order by location

--Creating Views to store data for later visualzation
Create view PercentageInfected as
SELECT location, Population,  MAX(total_cases) as HighestCount,  Max((total_cases/population))*100 as 
PercentageInfected
FROM PortfolioProject.dbo.coviddata
where continent is not null
Group by location, population
