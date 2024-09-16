SELECT * FROM
public.coviddeaths
where continent is not null
order by 3 ,4;

-- select *
-- from public.CovidVaccinations
-- order by 3 ,4;

--  Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1, 2;

--  Looking at Total Cases vs Total Deaths
--  Shows likelihood of dying if you contract covid in our country

select location, date, total_cases, total_deaths, (total_deaths / total_cases:: float)*100 as death_percentage
from coviddeaths
where location like 'India' and
 continent is not null
order by 1, 2;


-- Looking at Total Cases vs Population
-- shows what percentage of population got covid

select location, date, population, total_cases, (total_cases / population:: float)*100 as percent_Population_Infected
from coviddeaths
where location like 'India' and
 continent is not null
order by 1, 2;

-- Looking at countries with Highest infection rate compared to population 

select location, population, max(total_cases) as highest_infection_count, max((total_cases / population::float)) * 100 as percent_population_infected
from coviddeaths
where total_cases is not null and population is not null and  continent is not null
group by location, population
order by percent_population_infected desc;


-- Showing countries with the Highest death count per population

select location, max(total_deaths) as total_death_count
from coviddeaths
where continent is not null
group by location
order by total_death_count desc nulls last;

-- LET'S BREAKDOWN DOWN THINGS BY CONTINENT

select continent, max(total_deaths) as total_death_count
from coviddeaths
where continent is not  null
group by continent
order by total_death_count desc nulls last;


-- SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

select continent, max(total_deaths) as total_death_count
from coviddeaths
where continent is not  null
group by continent
order by total_death_count desc nulls last;



--  GLOBAL NUMBERS

select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths) / sum(new_cases)::float)*100 as death_percentage
from CovidDeaths
where continent is not null
-- group by date
order by 1,2;


-- Looking at Total population vs Vaccinations

select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as rolling_people _vaccinated,
--  (rolling_ppeople_vaccinated/population::float)*100
from CovidDeaths dea
join   CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2 ,3;

-- USING CTE

with pop_vs_vac (Continent, Location, Date, Population, New_vaccinations, rolling_people_vaccinated)
as (
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--  (rolling_ppeople_vaccinated/population::float)*100
from CovidDeaths dea
join   CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

select *, (rolling_people_vaccinated/population::float)*100 as rolling_vaccinations_percent
from pop_vs_vac;


-- Creating view to store data for later visualisation

create view percent_population_vaccinated as 
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--  (rolling_ppeople_vaccinated/population::float)*100
from CovidDeaths dea
join   CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * 
from percent_population_vaccinated


























