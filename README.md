# Introduction
Get insights into the data job market. This project was aimed to learn how to write effienct queries by exploring different data analyst roles, top-paying jobs, in-demand skills and where demand meets high salary in data analaytics.

Check my SQL queries here: [project_sql folder](/project_sql/)

# Background
The main quest was understand which skills are necessary to learn to for landing a job in data analytics and which skills are the highest-paid

## These were the main questions answered in this analysis:
1. What are the top-paying jobs for data analysts?
2. What are the skills required for these top-paying jobs?
3. What skills are the mosk in demand for data analysts?
4. What skills offer the highest salaries?
5. What are the most optimal skills to learn?

# Tools I Used
- **SQL**: The main languege used in order to order to query the database and answer the main questions
- **PostgreSQL**: This was the chosen database for this project in order to handle our dataset
- **VSCode**: My go-to IDE for executing SQL queries
- **Git & GitHub**: For version control, project tracking and sharing my analyssis
# The Analysis
Each query for this project was aimed to analyze specific aspects of data analyst job market:

### 1. Top Paying Data Analyst jobs
To identify top paying data analyst jobs, first I filtered my data to only show Data Analyst positiongs by averagy yearly salary. I filtered to show both on-site and remote schedule types and the location could be anywhere to get comparison from different countries.
```sql
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
```
### 2. Top paying job skills
To answer what are the top paying job skills, I joined the job postings table with the skills data, providing insights into what skills employers value the most for high-paying roles.
```sql
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
```
### 3. In-demand skills for Data Analytics
This query shows what skills are the most frequently requested in job postings, focusing on areas with high demand.
```sql
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
```
### 4. Top paying skills based on salary
Explored average salaries based on different skills and revealed which skills are the highest paying
```sql 
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 50;
```
### 5. Most optimal skills to learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skill_count,
    average_salary
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    skill_count > 25
ORDER BY
    average_salary DESC,
    skill_count DESC
LIMIT 20;
```
# What I Learned
With this project, I have gained knowledge about SQL and expanded my toolkit:
- **Complex Queries**: Learned the secrets of advanced SQL, merging different tables and writting complex queries
- **Data Aggregation**: Understood how to use GROUP BY and turned aggregate functions like COUNT() and AVG() into my buddies
- **Analytical mindset**: Leveled up my real-word analytical solving skills with insightful SQL queries

# Conclusions

From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
- **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
- **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
- **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills**: for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project helped me to understand how to use SQL, including writing complex queries,using joins, aggregate functions and more. In addtion, project provided me essential insights into the data analytics job market. Findings from the analysis serve as a mini guide to prioritizing skill development and job seeking.