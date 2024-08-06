select *
from PortfolioProject..CovidDeaths$
order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases,total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking At Total Death VS Total Cases
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location='India'
order by 5 desc

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location='United States'
order by 5 desc

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location='Bangladesh'
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking At Total Cases VS Population
select location, date, total_cases, population, (total_cases/population)*100 as AffectedPopulation
from PortfolioProject..CovidDeaths$
where location like '%India%'
order by 1,2

select location, date, total_cases, population, (total_cases/population)*100 as AffectedPopulation
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2


--Max Infected Numbers (Worldwide)
select location,population, max(total_cases) as MaxInfectionCount,max(total_cases/population)*100 as MaxAffectedPopulation
from PortfolioProject..CovidDeaths$
group by location, population
order by MaxAffectedPopulation desc

select location,population, max(cast(total_deaths as int)) as MaxDeathCount, max(cast(total_deaths as int)/total_cases)*100 as MaxDeathPerPopulation
from PortfolioProject..CovidDeaths$
group by location, population
order by MaxDeathPerPopulation desc

--Countries with Highest Death Counts
select location,max(cast(total_deaths as int)) as MaxDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by MaxDeathCount desc


--Contient with Highest Death Counts
select location,max(cast(total_deaths as int)) as MaxDeathCount
from PortfolioProject..CovidDeaths$
where continent is null
group by location
order by MaxDeathCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathCounts
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCounts desc

select continent,max(cast(total_deaths as int)) as MaxDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by MaxDeathCount desc

--Global Data
select date, sum(cast(new_deaths  as int)) as  TotalDeaths, sum(new_cases) as TotalCases, sum(cast(new_deaths  as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by date,TotalDeaths

--Covid Vaccinations
select *
from PortfolioProject..CovidVaccinations$

--Joining Tables Together

select *
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where location like '%afg%'

--Looking at Population vs Vaccination Data
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


--Countrywise Total Vaccination(daily)
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

--With CTE
with PopVsVac (continent,location,date,population,new_vaccinations,RollingVaccination) as
(select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null)
select * , (RollingVaccination/population)*100 as RatioPopVaccinated
from PopVsVac
order by 2,3

--With Temp_Table
drop table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingVaccination numeric)
insert into #PercentagePopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
select *, (RollingVaccination/population)*100 as RatioPopVaccinated
from #PercentagePopulationVaccinated
--where location='india'
order by 2,3

--VIEW
--Creating View to Store Data For Later Visualization

create view PercentagePopulationVaccinated as
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null