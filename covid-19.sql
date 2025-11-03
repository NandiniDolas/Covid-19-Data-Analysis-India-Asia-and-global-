USE portfolio_project1;
SHOW VARIABLES LIKE "secure_file_priv";

SELECT * FROM coviddeaths
WHERE continent IS NOT NULL;

SELECT * FROM coviddeaths
ORDER BY 3,4;

SELECT * FROM covidvaccinations;

-- SELECT * FROM covidvaccinations
-- ORDER BY 3,4;

-- select the data we needed

select count(*) from coviddeaths;
select count(*) from covidvaccinations;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2 ;


-- looking at total cases and total deaths in Africa

-- shows likelyhood of dying if you contact covid in country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
AND location LIKE '%Africa%'
ORDER BY 1,2 ;

-- looking at total cases vs populations
-- shows how much population got affected by deadly disease 
SELECT location, date, total_cases, population, (total_cases/population)* 100 as affected_poplution
FROM coviddeaths
WHERE continent IS NOT NULL
AND location LIKE '%Africa%'

ORDER BY 1,2 ;

-- looking at countries with highest infected  rate compared to population

SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as affected_poplution
FROM coviddeaths
-- WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY affected_poplution DESC ;

-- Showing countries with highest  death count per population

SELECT location, MAX(cast(total_deaths as decimal)) as TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC ;

-- LETS BREAK THINGS BY CONTINENT

SELECT continent, MAX(cast(total_deaths as decimal)) as TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC ;

-- highest continent with highest death count

SELECT continent, MAX(cast(total_deaths as decimal)) as TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC ;

-- GLOBAL NUMBERS
SELECT  date, SUM(new_cases) AS total_cases, sum(cast(new_deaths as decimal))as total_death, SUM(new_deaths)/sum(new_cases) * 100 AS DEATH_PERCENTAGE_BY_NEWCASES 
FROM coviddeaths
WHERE continent IS NOT NULL
-- AND location LIKE '%Africa%'
GROUP BY DATE
ORDER BY 1,2 ;

-- total cases wiwthout date
SELECT  SUM(new_cases) AS total_cases, sum(cast(new_deaths as decimal))as total_death, SUM(new_deaths)/sum(new_cases) * 100 AS DEATH_PERCENTAGE_BY_NEWCASES 
FROM coviddeaths
WHERE continent IS NOT NULL
-- AND location LIKE '%Africa%'
-- GROUP BY DATE
ORDER BY 1,2 ;

-------------------------------------------------------------------------------

SELECT * FROM covidvaccinations;

-- JOINING BOTH TABLES
SELECT * FROM coviddeaths as dea
JOIN covidvaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date;

-- LOOKING AT TOTAL POPULATIONS V/S VACCINATION
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(vac.new_vaccinations, decimal)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
-- (ROLLING_PEOPLE_VACCINATED/ POPULATION)*100
FROM coviddeaths as dea
JOIN covidvaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
-- WHERE continent IS NOT NULL
ORDER BY 2,3;

-- USE CTE
WITH POPVSVAC (continent, location, date, population, ROLLING_PEOPLE_VACCINATED)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(vac.new_vaccinations, decimal)) 
OVER (Partition by dea.loactaion ORDER BY dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
-- (ROLLING_PEOPLE_VACCINATED/ POPULATION)*100
FROM coviddeaths as dea
JOIN covidvaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT * FROM POPVSVAC
;

-- TEMP TABLE
CREATE TABLE PERCENTPOPULATEDVACCINATED
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinated numeric,
ROLLING_PEOPLE_VACCINATED numeric
);





INSERT INTO PERCENTPOPULATEDVACCINATED
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(vac.new_vaccinations, decimal)) 
OVER (Partition by dea.loactaion ORDER BY dea.location, dea.date) as ROLLING_PEOPLE_VACCINATED
-- (ROLLING_PEOPLE_VACCINATED/ POPULATION)*100
FROM coviddeaths as dea
JOIN covidvaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date;
-- WHERE continent IS NOT NULL;
-- ORDER BY 2,3

SELECT * FROM POPVSVAC
;


