-- exploratory data analysis

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, location  #own
from layoffs_staging2
where total_laid_off = 12000
;

select *
from layoffs_staging2  #so this is why 12000 did not come up when total_laid_off was called in desc order for percentage_laid_off = 1, because company which fired 12000 did not fire 100 percent of its employees.
ORDER BY total_laid_off desc;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

SELECT company, sum(total_laid_off) #analyzing the total layoffs for each company
from layoffs_staging2
GROUP BY company
ORDER BY 2 desc;

SELECT MAX(`date`), MIN(`date`)   #finding out the time span over which our data is spread
FROM layoffs_staging2;

SELECT industry, sum(total_laid_off)  #analyzing what industries were impacted
from layoffs_staging2
GROUP BY industry
ORDER BY 2 desc;

SELECT country, sum(total_laid_off)  #analyzing what countries were impacted the most
from layoffs_staging2
GROUP BY country
ORDER BY 2 desc;

SELECT year(`date`), sum(total_laid_off)  #analyzing the timeline
from layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 desc;

-- let us get a rolling sum of the total layoffs

SELECT substring(`date`,1,7) as `Month`, SUM(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not NULL
GROUP BY `Month`
order by 1 asc;

-- generating a rolling total for the above table
WITH Rolling_total AS
(
SELECT substring(`date`,1,7) as `Month`, SUM(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not NULL
GROUP BY `Month`
order by 1 asc
) 
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) As rolling_total
FROM Rolling_total;

SELECT company, Year(`date`), sum(total_laid_off) #analyzing the total layoffs for each company yearewise
from layoffs_staging2
GROUP BY company, Year(`date`)
ORDER BY company asc;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, Year(`date`), sum(total_laid_off) 
from layoffs_staging2
GROUP BY company, Year(`date`)
), Company_Year_Rank As
(Select *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
From Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

