--Using a CTE to look at total population vs vaccination records
With PopvsVac (Continent, Location, Date, population, NewPeopleVaxed, PeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, vax.new_vaccinations
, SUM(convert(bigint, vax.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..['COVID deaths$'] death
Join PortfolioProject..['COVID vaccinations$'] vax
	On death.location = vax.location
	and death.date = vax.date
Where death.continent is not null 
)
Select *, (PeopleVaccinated/Population)* 100 as PercentVaccinated
From PopvsVac

--Using a temptable now 
--Analyze the Percent of the population that is vaccinated or not
Drop Table if exists #PercentPopulationVax
Create Table #PercentPopulationVax
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric, 
PeopleVaccinated numeric, 
)
Insert into #PercentPopulationVax
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location 
Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['COVID deaths$'] dea
Join PortfolioProject..['COVID vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 

Select *, (PeopleVaccinated/Population)* 100 
From #PercentPopulationVax


--Creating View
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..['COVID deaths$'] dea
Join PortfolioProject..['COVID vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 