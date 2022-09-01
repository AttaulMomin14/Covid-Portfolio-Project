
select *
from CovidDeaths$
order by 3,4

select *
from CovidVaccinations$
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Death_Percentage
from CovidDeaths$
where location like '%states'
and continent is not null
order by 1;


-- Looking at Total Cases vs Population

Select location, date, total_cases, population, (total_cases/population) * 100 as Infected_Percentage
from CovidDeaths$
where continent is not null
order by 1,2


-- Looking at Countries with highest Infection Rate compared to Population

select location, population, max(total_cases) as Highest_Infection_Count, max((total_cases/population)) * 100 as Infected_Percentage
from CovidDeaths$
where continent is not null
group by location, population
order by 3 desc


--select distinct continent
--from CovidDeaths$
--where continent is not null

--select distinct location
--from CovidDeaths$


-- Showing Countries with Highest Death Count w.r.t Population

Select location, population, max(cast(total_deaths as int)) as Maximum_Death_Count, max((total_deaths/population)) * 100 as Death_Percentage
from CovidDeaths$
--where location = 'Pakistan'
where continent is not null
group by location, population
order by 3 desc


Select location, max(cast(total_deaths as int)) as Maximum_Death_Count
from CovidDeaths$
where continent is not null
group by location
order by 2 desc


-- Continents with Highest Cases w.r.t Population

select continent, max(total_cases) as Highest_Infection_Count, max((total_cases/population)) * 100 as Infected_Percentage
from CovidDeaths$
where continent is not null
group by continent
order by 3 desc

-- Continents with Highest Death Count w.r.t Population

--Select continent, max(cast(total_deaths as int)) as Maximum_Death_Count
--from CovidDeaths$
--where continent is not null
--group by continent
--order by 2 desc

Select location, max(cast(total_cases as int)) as Maximu_Cases
from CovidDeaths$
where continent is null
group by location
order by 2 desc


-- Continents with Highest Cases w.r.t Population

Select location, max(cast(total_deaths as int)) as Maximum_Death_Count
from CovidDeaths$
where continent is null
group by location
order by 2 desc


-- Global Numbers

select date, SUM(new_cases) as New_Cases, sum(cast(new_deaths as int)) as New_Deaths, sum(cast(new_deaths as int))/SUM(new_cases) as New_Deaths_Percentage
from CovidDeaths$
where continent is not null
group by date
order by 4 desc


-- Joining Tables

Select *
From CovidDeaths$ a
Join CovidVaccinations$ b
	on  a.location = b.location
	and a.date = b.date


-- Looking at Total Vaccination vs Total Population

Select a.continent, a.location, a.date, a.population, convert(int,b.new_vaccinations) as New_Vaccinations
, SUM(convert(int,b.new_vaccinations)) 
	over (partition by a.location order by a.location, a.date) as New_Vaccinations_Running_Total
	--(New_Vaccinations_Running_Total/population)
From CovidDeaths$ a
Join CovidVaccinations$ b
	on  a.location = b.location
	and a.date = b.date
where a.continent is not null
--group by a.location
order by 2,3


--Using CTE

with VacvsPop (continent, location, date, population, New_Vaccinations, New_Vaccinations_Running_Total)
as
(
Select a.continent, a.location, a.date, a.population, convert(int,b.new_vaccinations) as New_Vaccinations
, SUM(convert(int,b.new_vaccinations)) 
	over (partition by a.location order by a.location, a.date) as New_Vaccinations_Running_Total
	--(New_Vaccinations_Running_Total/population)
From CovidDeaths$ a
Join CovidVaccinations$ b
	on  a.location = b.location
	and a.date = b.date
where a.continent is not null
--group by a.location
--order by 2,3
)
Select *, (New_Vaccinations_Running_Total/population) as Percentage_Vaccinated
From VacvsPop


--Temp Table

Drop Table if exists #percentage_vaccinated

Create Table #percentage_vaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_Vaccinations numeric,
New_Vaccinations_Running_Total numeric
)

Insert Into #percentage_vaccinated
Select a.continent, a.location, a.date, a.population, convert(int,b.new_vaccinations) as New_Vaccinations
, SUM(convert(int,b.new_vaccinations)) 
	over (partition by a.location order by a.location, a.date) as New_Vaccinations_Running_Total
	--(New_Vaccinations_Running_Total/population)
From CovidDeaths$ a
Join CovidVaccinations$ b
	on  a.location = b.location
	and a.date = b.date
where a.continent is not null
--group by a.location
--order by 2,3

select *, (New_Vaccinations_Running_Total/population) as Vaccinated_Percentage
from #percentage_vaccinated

-- Global Numbers

--select *
--from CovidDeaths$

select SUM(new_cases) as total_cases, SUM(convert(int,new_deaths)) as total_deaths, 
SUM(convert(int,new_deaths))/SUM(new_cases) * 100 as death_percentage 
from CovidDeaths$
where continent is not null
order by 1,2


-- Creating View to store Data for later visualization

Create view Percent_Population_Vaccinated as
Select a.continent, a.location, a.date, a.population, convert(int,b.new_vaccinations) as New_Vaccinations
, SUM(convert(int,b.new_vaccinations)) 
	over (partition by a.location order by a.location, a.date) as New_Vaccinations_Running_Total
	--(New_Vaccinations_Running_Total/population)
From CovidDeaths$ a
Join CovidVaccinations$ b
	on  a.location = b.location
	and a.date = b.date
where a.continent is not null
--group by a.location
--order by 2,3

Select *, (New_Vaccinations_Running_Total/population) * 100 as Percent_Vaccinated
from Percent_Population_Vaccinated











































































