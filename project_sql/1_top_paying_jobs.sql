/*
Queston: What are the top-paying Data Analyst jobs?
- Indentify the top 10 highest-paying Data Analyst jobs that are available on-site
- Focuse on job postings that have specified salarys (remove nulls
- Why is this useful? Highlight the top-paying job oppurtunities for Data Analysts, to get insights in to the job market
*/

SELECT
    job_postings.job_id,
    job_postings.job_title,
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date,
    companies.name AS company_name
FROM
    job_postings_fact AS job_postings
LEFT JOIN 
    company_dim AS companies 
    ON job_postings.company_id = companies.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;