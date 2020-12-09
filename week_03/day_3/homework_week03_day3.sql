/******
MVP
*******/

/*Q1 - Are there any pay_details records lacking both a 
 local_account_no and iban number? */

SELECT	*
FROM	pay_details
WHERE	(local_account_no IS NULL
			AND iban IS NULL);
			
			
			
/*Q2 - Get a table of employees first_name, last_name and 
country, ordered alphabetically first by country and then 
by last_name (put any NULLs last) */
			
SELECT		country,
			first_name,
			last_name,
			COUNT(id) AS number_of_employees
FROM		employees
GROUP BY	country,
			first_name,
			last_name
ORDER BY	country ASC NULLS LAST,
			last_name ASC NULLS LAST;
		
		
		
/*Q3 - Find the details of the top ten highest paid employees
in the corporation */
		
SELECT		id,
			CONCAT(last_name,', ',first_name),
			salary
FROM		employees
ORDER BY	salary DESC NULLS LAST
LIMIT		10,



/*Q4 - Find the first_name, last_name and salary of the lowest 
 paid employee in Hungary */

SELECT		country,
			first_name,
			last_name,
			salary
FROM		employees
WHERE		country = 'Hungary'
ORDER BY	salary ASC NULLS LAST
LIMIT		1;



/*Q5 Find all the details of any employees with a ‘yahoo’ 
email address */

SELECT		*
FROM		employees
WHERE		email ILIKE '%@yahoo%'



/*Q6 -Provide a breakdown of the numbers of employees enrolled, 
not enrolled, and with unknown enrollment status in the 
corporation pension scheme  */

SELECT		CASE
				WHEN pension_enrol IS TRUE THEN '1 - Enrolled'
				WHEN pension_enrol IS FALSE THEN '2 - Not enrolled'
				ELSE '3 - Pension status unknown'
			END AS pension_scheme_status,
			COUNT(id)
FROM		employees
GROUP BY	pension_scheme_status
ORDER BY	pension_scheme_status ASC



/*Q7 - What is the maximum salary among those employees in the 
‘Engineering’ department who work 1.0 full-time equivalent hours 
(fte_hours)?*/

SELECT		department,
			MAX(salary) AS max_salary
FROM		employees
WHERE		(department = 'Engineering'
			AND fte_hours = 1.0)
GROUP BY	department;



/*Q8 - Get a table of country, number of employees in that country, 
 and the average salary of employees in that country for any 
 countries in which more than 30 employees are based. Order the 
 table by average salary descending */

SELECT		country,
			COUNT(id) AS number_of_employees,
			ROUND(AVG(salary),2) AS avg_salary
FROM		employees
GROUP BY	country
HAVING		COUNT(id) >= 30
ORDER BY	avg_salary DESC NULLS LAST;



/*Q9 - Return a table containing each employees first_name, last_name, 
full-time equivalent hours (fte_hours), salary, and a new column 
effective_yearly_salary which should contain fte_hours multiplied by salary.*/

SELECT		first_name,
			last_name,
			fte_hours,
			salary,
			ROUND((fte_hours * salary),2) AS effective_yearly_salary
FROM		employees
ORDER BY	last_name,
			first_name;
		
		
		
/*Q10 - Find the first name and last name of all employees who lack 
 a local_tax_code */
		
SELECT		e.first_name,
			e.last_name
FROM		(employees AS e
				LEFT JOIN pay_details pd
				ON e.pay_detail_id = pd.id)
WHERE		pd.local_tax_code IS NULL
ORDER BY	e.last_name,
			e.first_name;
		
		
		
/*Q11 - The expected_profit of an employee is defined as 
 (48 * 35 * charge_cost - salary) * fte_hours, 
 where charge_cost depends upon the team to which the employee belongs. 
 Get a table showing expected_profit for each employee */
		
SELECT		e.id AS employee_id,
			e.last_name,
			e.first_name,
			e.fte_hours,
			e.salary,
	 		CAST(t.charge_cost AS INT) AS charge_cost_numeric,
			(48 * 35 * CAST(t.charge_cost AS INT) - e.salary) * e.fte_hours AS expected_profit
FROM		employees AS e
				INNER JOIN teams AS t
				ON e.team_id = t.id;
				
				
				
/*Q12 - Return a table of those employee first_names shared by 
 more than one employee, together with a count of the number of 
 times each first_name occurs. Omit employees without a stored 
 first_name from the table. Order the table descending by count, 
 and then alphabetically by first_name */
				
SELECT		first_name,
			COUNT(first_name) AS number_of_instances
FROM		employees
WHERE		first_name IS NOT NULL
GROUP BY	first_name
HAVING		COUNT(first_name) > 1
ORDER BY	number_of_instances DESC NULLS LAST,
			first_name ASC NULLS LAST;
		

		
		
		

/*******************
 EXTENSION QUESTIONS
 *******************/
		
	
/*Q1 - Get a list of the id, first_name, last_name, salary and 
 fte_hours of employees in the largest department. 
 Add two extra columns showing the ratio of each employee’s salary 
 to that department’s average salary, and each employee’s fte_hours 
 to that department’s average fte_hours */


/* CTE - find largest department - the one with most employees */
		
WITH largest_team_avgs(department, avg_salary, avg_fte_hours, number_of_employees)  AS(
SELECT
 department,
 ROUND(AVG(salary),2),
 ROUND(AVG(fte_hours),2),
 COUNT(id)
FROM employees
GROUP BY department
ORDER BY COUNT(id) DESC NULLS LAST
LIMIT 1
)
SELECT		e.department,
			e.id,
			e.first_name,
			e.last_name,
			e.salary AS employee_salary,
			largest_team_avgs.avg_salary AS dept_avg_salary,
			(e.salary / largest_team_avgs.avg_salary) AS employee_salary_over_avg_salary,
			e.fte_hours AS employee_fte_hours,
			largest_team_avgs.avg_fte_hours AS dept_avg_fte_hours,
			(e.fte_hours / largest_team_avgs.avg_fte_hours) AS fte_over_avg_fte
FROM		employees AS e
				INNER JOIN largest_team_avgs 
				ON e.department = largest_team_avgs.department
				
			
				
/*Q2 - Have a look again at your table for MVP question 6. It will likely contain a 
blank cell for the row relating to employees with ‘unknown’ pension enrollment status. 
This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. 
Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), 
or a CASE statement?*/
				
/*** Already answered in Q6 above ***/
				

				
				
				
/* Find the first name, last name, email address and start date of all the employees 
 who are members of the ‘Equality and Diversity’ committee. Order the member employees 
 by their length of service in the company, longest first */
				
SELECT		c.name AS committee_name,
			e.first_name,
			e.last_name,
			e.email,
			e.start_date,
			/* DATEDIFF(YEAR, start_date,NOW()) */
			/*(NOW() - start_date)*/
			DATE_PART('year',NOW()::date) - DATE_PART('year',start_date::date) AS years_service
FROM		employees as e
				INNER  JOIN employees_committees AS ec
				ON e.id = ec.employee_id
					LEFT JOIN committees AS c
					ON ec.committee_id = c.id
WHERE		c.name = 'Equality and Diversity'
ORDER BY	start_date ASC NULLS LAST





/*Q4 - Use a CASE() operator to group employees who are members of committees into 
 salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000). A NULL salary 
 should lead to 'none' in salary_class. Count the number of committee members 
 in each salary_class */

SELECT		CASE
				WHEN e.salary IS NULL THEN 'None'
				WHEN e.salary < 40000 THEN 'Low'
				WHEN e.salary >= 40000 THEN 'High'
				ELSE 'Error'
			END AS salary_class,
			COUNT(DISTINCT(e.id)) AS number_of_commttee_members
FROM		employees as e
				INNER  JOIN employees_committees AS ec
				ON e.id = ec.employee_id
GROUP BY	salary_class
ORDER BY	salary_class ASC NULLS LAST;
				
	
			
			


			