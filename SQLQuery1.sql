

select * from 
SQLPortfolioProject..CovidDeaths$
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from SQLPortfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths
select location, date, total_cases, new_cases, total_deaths, CONVERT(float,total_deaths) / NULLIF(CONVERT(float, total_cases),0)
*100 as death_percentage
from SQLPortfolioProject..CovidDeaths$
where location like '%States%'
order by 1,2

-- what percentage of population got covid

select location, date, population, total_cases, new_cases,  nullif(convert(float, total_cases),0)/convert(float, population)
* 100 as death_percentage
from SQLPortfolioProject..CovidDeaths$
order by 1,2;

-- Looking at countries with highest infection rates compared to population
select location, date, population, total_cases, new_cases, max(total_cases) as highlyInfectedPopulation,
max(nullif(convert(float, total_cases),0)/convert(float, population))
* 100 as PercentPopulationinfected
from SQLPortfolioProject..CovidDeaths$
group by location, date, population, total_cases, new_cases
order by 1,2;

--Showing countries with the highest death count per population

select location, max(cast(total_deaths as int)) as total_death_count
from SQLPortfolioProject..CovidDeaths$
where continent is not NULL
group by location

--GLOBAL NUMBERS

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases) * 100 as DeathPercentage
from SQLPortfolioProject..CovidDeaths$
where continent is not null
order by 1,2;

--Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date)
as RollingpeopleVaccinated
from SQLPortfolioProject..CovidVaccines$ vac
join SQLPortfolioProject..CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--CTE

with popvsvac(Continent, location, date,population, new_vaccinations, RollingpeopleVaccinated) as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.Date)
as RollingpeopleVaccinated
from SQLPortfolioProject..CovidVaccines$ vac
join SQLPortfolioProject..CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingpeopleVAccinated/population) * 100  
from popvsvac;

--TEMP TABLE
drop table if exists PercentpopulationVaccinated 
Create table PercentpopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingpeopleVaccinated numeric
)

Insert into PercentpopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.Date)
as RollingpeopleVaccinated
from SQLPortfolioProject..CovidVaccines$ vac
join SQLPortfolioProject..CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *, (RollingpeopleVAccinated/population) * 100 
from PercentpopulationVaccinated ;

-- Creating views to store data for later use

Create View PercentpopVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.Date)
as RollingpeopleVaccinated
from SQLPortfolioProject..CovidVaccines$ vac
join SQLPortfolioProject..CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from PercentpopVaccinated



