

-- Quesries used for tableau proj
--1 taking death percentage--
select sum(new_cases) as total_cases , sum( cast(new_deaths as int)) as total_deaths,
	sum( cast(new_deaths as int))/sum(new_cases) * 100 as deathpercentage
	from dbo.['Covid Death$']

--2 removing/separating continents--
select location, sum( cast(new_deaths as int)) as total_deaths
from dbo.['Covid Death$']
where  continent is null and location not IN ('European Union', 'World' , 'International')
group by location
order by location

--3 taking cases by country without EU , World , keeping International Values for on air deaths

select location, population, MAX( total_cases) as Highest_infected , MAX(total_cases/population)*100 as Pop_affected
from dbo.['Covid Death$']
where  continent is not null and location not IN ('European Union', 'World' )
group by location , population
order by Pop_affected desc

--4 taking cases by date

select location, date, population, MAX( total_cases) as Highest_infected , MAX(total_cases/population)*100 as Pop_affected
from dbo.['Covid Death$']
where  continent is not null and location not IN ('European Union', 'World' )
group by location , population , date
order by Pop_affected desc










--Querying for different values /Exploring the data

--select * from dbo.['Covid Death$']
--order by 3,4
--select * from dbo.['Covid Vacc$']
--order by 3,4

Select location, date, total_cases, total_deaths, new_cases, population
from dbo.['Covid Death$']
order by location, date

select location, date, dbo.['Covid Death$'].total_cases as Total_Cases, dbo.['Covid Death$'].total_deaths as Total_Deaths,
(Total_Deaths/ Total_Cases)*100 as percetage_death
from Dbo.['Covid Death$']
where location like '%India' and Date = '2021-06-13 00:00:00.000'
order by 1, 2

select location, date, dbo.['Covid Death$'].total_cases as Total_Cases, dbo.['Covid Death$'].total_deaths as Total_Deaths,
(Total_Cases/ population )*100 as percetage_death, population
from Dbo.['Covid Death$']
where location like '%India' and Date = '2021-06-13 00:00:00.000'
order by 1, 2

Select location, population, MAX( total_cases) as total_cases , MAX (total_cases/population) * 100 as PopAffected
from dbo.['Covid Death$']
group by location, population 
order by PopAffected desc

Select location, population, MAX( CAST(total_deaths as int)) as total_deaths , MAX (total_deaths/population) * 100 as Popdeaths
from dbo.['Covid Death$']
where continent is not null
group by location, population 
order by total_deaths desc

select continent, max (total_cases) as TC, MAX( cast(total_deaths as int)) as TD , SUM (population) as Pops
from dbo.['Covid Death$']
where continent is not null
group by continent 
order by continent

select location, max (total_cases) as TC, MAX( cast(total_deaths as int)) as TD , SUM (population) as Pops
from dbo.['Covid Death$']
where continent is null
group by location 
order by location

select sum (new_cases) as TC , SUM ( CAST ( new_deaths as int)) as TD 
from dbo.['Covid Death$']
where continent is not null

--created CTE table

with PopvVac ( continent, location, date, population, total_cases, total_deaths, total_vac)
as
(
select  dea.continent, dea.location, dea.date , dea.population, dea.total_cases, dea.total_deaths,
sum(convert (int, vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date ) as total_vac
from dbo.['Covid Death$'] as dea
join dbo.['Covid Vacc$'] as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)

Select location, MAX(total_vac)/ population * 100 as percentvaccinated
from PopvVac
group by location, population
order by location

--created view

create view Percentvaccinated
as
(
select  dea.continent, dea.location, dea.date , dea.population, dea.total_cases, dea.total_deaths,
sum(convert (int, vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date ) as total_vac
from dbo.['Covid Death$'] as dea
join dbo.['Covid Vacc$'] as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)

-- Query to see the % correct

Select location, MAX(total_vac)/ population * 100 as percentvaccinated
from Percentvaccinated
group by location, population
order by percentvaccinated desc
--query is correct , 2 dose per person.

--trying to make % correct  

select  dea.continent, dea.location, dea.date , dea.population, dea.total_cases, dea.total_deaths,
sum(convert (int, vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date ) as total_vac
from dbo.['Covid Death$'] as dea
join dbo.['Covid Vacc$'] as vac
on dea.location = vac.location and dea.date = vac.date
where dea.location like 'Gibraltar'

--checking if everyone on Gibraltar got 2 dose vaccination

select dea.location,  dea.population,
sum ( convert (int, vac.new_vaccinations))/population as dosephead
from dbo.['Covid Death$'] as dea
join dbo.['Covid Vacc$'] as vac
on dea.location = vac.location and dea.date = vac.date
where dea.location like 'Gibraltar'
group by dea.location , dea.population

