Select * 
From CovidProject..CovidDeaths

Select * 
From CovidProject..CovidVaccinations

--Data we are going to use
Select location, date, population,continent, total_cases, new_cases, total_deaths
From CovidProject..CovidDeaths 
Where continent is not null
Order by 1,2

--What percentage of COVID contacts in India result in deaths in a single day?
--Shows that you have a 1-3% chance of dying if you get COVID in India.
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From CovidProject..CovidDeaths 
Where location = 'India' and continent is not null
Order by 1,2

-- Total Cases vs Population
-- Shows what percentage of the population is infected with COVID
Select location, date, population, total_cases, (total_cases/population)*100 as infection_rate
From CovidProject..CovidDeaths 
Where continent is not null
Order by 1,2


--Which country has the highest infection count?
--It shows the United States has the highest infection count, followed by India and Brazil.
SELECT location, population, MAX(total_cases) as Highest_Infection_Count
FROM CovidProject..CovidDeaths
Where continent is not null
Group by location, population 
ORDER by 3 desc

--Which continent has the highest death count?
Select location, Max(cast(total_deaths as int)) as Total_Death_Count
From CovidProject..CovidDeaths 
Where continent is null
Group by location
Order by Total_Death_Count desc

--The number of cases, total deaths and death percentage worldwide
SELECT SUM(new_cases) AS Total_New_Cases,SUM(cast(new_deaths as int)) AS Total_New_Deaths
,SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS New_Death_Percentage
FROM CovidProject..CovidDeaths 
WHERE continent is not NULL 
ORDER BY 1,2  


--Which county has the highest count of fully vaccinated people?
SELECT location, Sum(CAST(people_fully_vaccinated as bigint)) as TotalFullyVaccinated
From CovidProject..CovidVaccinations
Where continent is not null
Group by location
Order by TotalFullyVaccinated desc

--Joining CovidDeaths and CovidVacination table
Select *
From CovidProject..CovidDeaths as cd
Join CovidProject..CovidVaccinations as cv
on cd.date = cv.date
and cd.location = cv.location
Where cd.continent is not null
Order by 1,2

--Using Sum window function 
Select cd.continent, cd.location, cd.population, cd.date, cv.new_vaccinations,  
Sum(Cast( cv.new_vaccinations as int)) Over (Partition by cd.location Order by cd.location, cd.date) as Rolling_People_Vaccinated
From CovidProject..CovidDeaths as cd
Join CovidProject..CovidVaccinations as cv
on cd.date = cv.date
and cd.location = cv.location
Where cd.continent is not null 
--Order by 1,2

-- Using CTE to perform Calculation on Partition By in previous query
-- Rolling_People_Vaccinated VS population
With PopVsVac (Continent, location, population, date, new_vaccinations, Rolling_People_Vaccinated)
as 
( Select cd.continent, cd.location, cd.population, cd.date, cv.new_vaccinations,  
Sum(Cast( cv.new_vaccinations as int)) Over (Partition by cd.location Order by cd.location, cd.date) as Rolling_People_Vaccinated
From CovidProject..CovidDeaths as cd
Join CovidProject..CovidVaccinations as cv
on cd.date = cv.date
and cd.location = cv.location
Where cd.continent is not null 
--Order by 1,2
)
Select * , (Rolling_People_Vaccinated/population)*100 as Rolling_People_Vaccinated_Percentage
From PopVsVac
















