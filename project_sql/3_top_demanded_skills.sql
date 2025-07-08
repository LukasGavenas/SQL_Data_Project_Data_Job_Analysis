/*
Question: What are the most in-demand skills for Data Analyst?
- Join job postings to INNER JOIN table just like in query 2
- Identify top 5 in-demand skills for Data Analyst
- Focus on all job postings
- Why? Retrieves the top 5 skills with the highest demand in the job market
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5;