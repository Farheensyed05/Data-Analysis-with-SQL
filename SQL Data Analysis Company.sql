CREATE DATABASE Company;

USE Company;

CREATE TABLE jobs(
  id INTEGER
  ,work_year INTEGER
  ,experience_level VARCHAR(20)
  ,employment_type VARCHAR(20)
  ,job_title VARCHAR(40)
  ,salary INTEGER
  ,salary_currency VARCHAR(20)
  ,salary_in_usd INTEGER
  ,employee_residence VARCHAR(20)
  ,remote_ratio INTEGER
  ,company_location VARCHAR(20)
  ,company_size VARCHAR(20)
);


CREATE TABLE companies(
id INT,
company_name VARCHAR(20));

SELECT * FROM COMPANIES;
SELECT * FROM JOBS;

-- 1. What is the average salary for all the jobs in the dataset?

SELECT * FROM JOBS;

SELECT AVG(salary) as average_salary FROM jobs;

-- 2. What is the highest salary in the dataset and which job role does it correspond to?
 
 SELECT * FROM jobs;
 
SELECT salary AS highest_salary,job_title FROM jobs order by salary desc limit 1;

-- 3. What is the average salary for data scientists in US?

SELECT job_title,AVG(salary) AS average_salary FROM JOBS where job_title = 'Data Scientist' and company_location = 'US';

-- 4. What is the number of jobs available for each job title?

SELECT job_title,count(*) as no_of_jobs FROM jobs GROUP BY job_title;

-- 5. What is the total salary paid for all data analyst jobs in DE?
SELECT * FROM JOBS;
SELECT job_title,sum(salary) as total_salary from jobs where job_title='Data Analyst' and company_location = 'DE';

-- 6. What are the top 5 highest paying job titles and their corresponding average salaries?

SELECT job_title, AVG(salary) AS average_salary FROM jobs GROUP BY job_title ORDER BY average_salary DESC LIMIT 5;

-- 7. What is the number of jobs available in each location?

SELECT company_location, COUNT(*) AS num_jobs FROM jobs GROUP BY company_location;

-- 8. What are the top 3 job titles that have the most jobs available in the dataset?

SELECT job_title, COUNT(*) AS num_jobs FROM jobs GROUP BY job_title ORDER BY num_jobs DESC LIMIT 3;

-- 9. What is the average salary for data engineers in INDIA?

SELECT AVG(salary) AS average_salary FROM jobs WHERE job_title = 'Data Engineer' AND company_location = 'IN';

-- 10.What are the top 5 cities with the highest average salaries?

SELECT company_location, AVG(salary) AS average_salary FROM jobs GROUP BY company_location ORDER BY average_salary DESC LIMIT 5;

-- 11.What is the average salary for each job title, and what is the total number of jobs available for each job title?

SELECT job_title, AVG(salary) AS average_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY job_title;

-- 12.What are the top 5 job titles with the highest total salaries, and what is the total number of jobs available for each job title?

SELECT job_title, SUM(salary) AS total_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY job_title 
ORDER BY total_salary DESC 
LIMIT 5;

-- 13.What are the top 5 locations with the highest total salaries, and what is the total number of jobs available for each location?

SELECT company_location, SUM(salary) AS total_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY company_location 
ORDER BY total_salary DESC 
LIMIT 5;

-- 14.What is the average salary for each job title in each location, and what is the total number of jobs available for each job title in each location?

SELECT job_title, company_location, AVG(salary) AS average_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY job_title, company_location;

-- 15.What is the average salary for each job title in each location, and what is the percentage of jobs for each job title in each location?

SELECT job_title, company_location, AVG(salary) AS average_salary, 
(COUNT(*) * 100 / (SELECT COUNT(*) FROM jobs WHERE company_location = j.company_location)) AS job_percentage 
FROM jobs j 
GROUP BY job_title, company_location;

-- 16.What are the top 5 job titles with the highest average salaries, and what is the total number of jobs available for each job title?

SELECT job_title, AVG(salary) AS average_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY job_title 
ORDER BY average_salary DESC 
LIMIT 5;

-- 17.What is the average salary for each job title, and what is the percentage of jobs for each job title in the dataset?

SELECT job_title, AVG(salary) AS average_salary, 
(COUNT(*) * 100 / (SELECT COUNT(*) FROM jobs)) AS job_percentage 
FROM jobs 
GROUP BY job_title;

-- 18.What is the total number of jobs available for each year of experience, and what is the average salary for each year of experience?

SELECT experience_level, COUNT(*) AS num_jobs, AVG(salary) AS average_salary 
FROM jobs 
GROUP BY experience_level;

-- 19. What are the top 5 job titles with the highest average salaries in each location?

SELECT job_title, company_location, AVG(salary) AS average_salary 
FROM jobs 
WHERE job_title IN (SELECT job_title FROM jobs GROUP BY job_title ORDER BY AVG(salary) DESC) 
GROUP BY job_title, company_location;

-- 20. What is the average salary for each degree level, and what is the total number of jobs available for each degree level?

SELECT degree_level, AVG(salary) AS average_salary, COUNT(*) AS num_jobs 
FROM jobs 
GROUP BY degree_level;

-- 21.What are the top 5 job titles with the highest salaries, and what is the name of the company that offers the highest salary for each job title?

SELECT job_title, MAX(salary) AS highest_salary, company_name 
FROM jobs 
INNER JOIN companies ON jobs.id = companies.id 
GROUP BY job_title 
ORDER BY highest_salary DESC 
LIMIT 5;

-- 22. What is the total number of jobs available for each job title, and what is the name of the company that offers the highest salary for each job title?


SELECT job_title, COUNT(*) AS num_jobs, company_name 
FROM jobs 
INNER JOIN companies ON jobs.id = companies.id 
WHERE salary = (SELECT MIN(salary) FROM jobs WHERE job_title = jobs.job_title) 
GROUP BY job_title, company_name;


-- 23. What are the top 5 cities with the highest average salaries, and what is the name of the company that offers the highest salary for each city?

SELECT company_location, AVG(salary) AS average_salary, company_name 
FROM jobs 
INNER JOIN companies ON jobs.id = companies.id 
GROUP BY company_location 
ORDER BY average_salary DESC 
LIMIT 5;

-- 24. What is the average salary for each job title in each company, and what is the rank of each job title within each company based on the average salary?

SELECT job_title, company_name, AVG(salary) AS average_salary, 
RANK() OVER (PARTITION BY company_name ORDER BY AVG(salary) DESC) AS salary_rank 
FROM jobs 
INNER JOIN companies ON jobs.id = companies.id 
GROUP BY job_title, company_name;

-- 25. What is the total number of jobs available for each job title in each location, and what is the rank of each job title within each location based on the total number of jobs?

SELECT job_title, company_location, COUNT(*) AS num_jobs, 
RANK() OVER (PARTITION BY company_location ORDER BY COUNT(*) DESC) AS job_rank 
FROM jobs 
GROUP BY job_title, company_location;


-- 26. What is the average salary for each job title in each location, and what is the name of the company that offers the highest salary for each job title in each location?

SELECT job_title, company_location, AVG(salary) AS average_salary, company_name 
FROM jobs 
INNER JOIN companies ON jobs.id = companies.id 
WHERE salary = (SELECT MAX(salary) FROM jobs WHERE job_title = j.job_title AND company_location = j.location) 
GROUP BY job_title, location, company_name;