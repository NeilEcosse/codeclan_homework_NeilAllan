/**************************************************************************
 * 
 * MVP 
 * 
 **************************************************************************/

/* Q1 - Find all the employees who work in the ‘Human Resources’ department */

SELECT	*
FROM	employees
WHERE	department = 'Human Resources';



/* Q2 - Get the first_name, last_name, and country of the employees 
 * who work in the ‘Legal’ department */

SELECT	first_name,
		last_name,
		country
FROM	employees
WHERE	department = 'Legal';



/*Q3 -  Count the number of employees based in Portugal */

SELECT	COUNT(*) AS number_of_employees
FROM	employees
WHERE	country = 'Portugal';



/*Q4 -  Count the number of employees based in either Portugal or Spain */

SELECT	COUNT(*) AS number_of_employees
FROM	employees
WHERE	country IN('Portugal', 'Spain');



/*Q5 - Count the number of pay_details records lacking a local_account_no.  */

SELECT	COUNT(*) AS number_of_accounts
FROM	pay_details
WHERE	local_account_no IS NULL;



/*Q6 - Get a table with employees first_name and last_name ordered alphabetically 
 * by last_name (put any NULLs last).  */

SELECT		first_name,
			last_name
FROM		employees
ORDER BY	last_name NULLS LAST;



/*Q7 -  How many employees have a first_name beginning with ‘F’? */ 

SELECT	COUNT(*) AS number_of_employees
FROM	employees
WHERE	first_name LIKE 'F%';



/*Q8 -  Count the number of pension enrolled employees not based in 
 * either France or Germany. */

SELECT	COUNT(*) AS number_of_employees
FROM	employees
WHERE	pension_enrol = TRUE
		AND country NOT IN ('France', 'Germany');
		
		
		
/*Q9 - Obtain a count by department of the employees who 
 * started work with the corporation in 2003 */
		
SELECT		department,
			COUNT(*) AS number_of_employees
FROM		employees
WHERE		start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY	department;



/*Q10 - Obtain a table showing department, fte_hours and 
 * the number of employees in each department who work each 
 * fte_hours pattern. Order the table alphabetically 
 * by department, and then in ascending order of fte_hours */

SELECT		department,
			fte_hours,
			COUNT(*) AS number_of_employees
FROM		employees
GROUP BY	department,
			fte_hours
ORDER BY	department ASC NULLS LAST,
			fte_hours ASC NULLS LAST
			
			
			
/*Q11 - Obtain a table showing any departments in which there are 
 * two or more employees lacking a stored first name. 
 * Order the table in descending order of the number of employees 
 * lacking a first name, and then in alphabetical order by department */
		
SELECT		department,
			COUNT(*) AS number_of_employees
FROM		employees
WHERE		first_name IS NULL
GROUP BY	department
HAVING 		COUNT(*) >=  2
ORDER BY	number_of_employees DESC,
			department ASC
			
			
			
/*Q12 - Find the proportion of employees in each department who are grade 1 */
			


/**************************************************************************
 * 
 * Extension Questions 
 * 
 **************************************************************************/		
			
					
/*Q1 - Do a count by year of the start_date of all employees, 
 * ordered most recent year last */	
			
SELECT		EXTRACT(YEAR FROM start_date) AS start_year,
			COUNT (*)
FROM		employees
GROUP BY	start_year
ORDER BY	start_year DESC NULLS LAST


			
/*Q2 -  Return the first_name, last_name and salary of all employees 
 * together with a new column called salary_class with a value 
 * 'low' where salary is less than 40,000 and value 'high' where 
 * salary is greater than or equal to 40,000*/

SELECT		first_name,
			last_name,
			salary,
			CASE
				WHEN salary <  40000 THEN 'low'
				WHEN salary >= 40000 THEN 'high'
				ELSE 'error'
			END AS salary_class
FROM		employees
ORDER BY	salary DESC NULLS LAST



/*Q3 - The first two digits of the local_sort_code (e.g. digits 97 in code 97-09-24)
 * in the pay_details table are indicative of the region of an account. 
 * Obtain counts of the number of pay_details records bearing each set of first two
 * digits? Make sure that the count of NULL local_sort_codes comes at the top of 
 * the table, and then order all subsequent rows first by counts in descending order, 
 * and then by the first two digits in ascending order   */

SELECT		CAST(LEFT(local_sort_code, 2) AS VARCHAR) AS first_two_digits,
			COUNT(*) AS number_of_records
FROM		pay_details
GROUP BY	first_two_digits
ORDER  BY	number_of_records DESC NULLS FIRST

/* ?need to check how to ensure first_two_digit NULLS appear at top if I'm not 
 * just sorting by first_two_digits then by number_of_records*/









			
			

			

