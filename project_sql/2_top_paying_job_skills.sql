/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from the previous query
- Add the specific skills required
- Why is this useful? To understand the skills that are in demand for high-paying Data Analyst positions
*/
WITH top_paying_jobs AS (
    SELECT
        job_postings.job_id,
        job_postings.job_title,
        job_postings.salary_year_avg,
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
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills  
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
