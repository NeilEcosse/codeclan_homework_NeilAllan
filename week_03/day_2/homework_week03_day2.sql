/********************
 * MVP
 ********************/

/*Q1 - Get a table of all employees details, together with their  
 local_account_no and local_sort_code, if they have them */

SELECT			e.*,
				pd.local_account_no,
				local_sort_code
FROM 			employees AS e	LEFT JOIN pay_details pd
					ON e.pay_detail_id = pd.id;
				
				
				
/*Q2 - Amend your query from question 1 above to also return the 
 name of the team that each employee belongs to */

SELECT		e.*,
			pd.local_account_no,
			local_sort_code,
			t.name AS team_name
FROM 		(employees AS e	
				LEFT JOIN pay_details pd
				ON e.pay_detail_id = pd.id)
				LEFT JOIN teams AS t
				ON e.team_id = t.id;
					
					
					
/*Q3 - Find the first name, last name and team name of employees 
 who are members of teams for which the charge cost is greater 
 than 80. Order the employees alphabetically by last name*/
							
SELECT		e.first_name,
			e.last_name,
			t.name AS team_name,
			t.charge_cost
FROM		employees AS e
				LEFT JOIN teams AS t
				ON e.team_id = t.id
WHERE		CAST (t.charge_cost AS INT) > 80
ORDER BY	e.last_name ASC NULLS LAST;



/*Q4 - Breakdown the number of employees in each of the teams, 
 including any teams without members. Order the table by 
 increasing size of team */

SELECT		t.name AS team_name,
			COUNT(e.id) AS number_of_employees
FROM		teams AS t
				LEFT JOIN employees AS e
				ON t.id = e.team_id
GROUP BY	team_name
ORDER BY	number_of_employees ASC NULLS LAST;



/*Q5 - The effective_salary of an employee is defined as their 
fte_hours multiplied by their salary. Get a table for each 
employee showing their id, first_name, last_name, fte_hours, 
salary and effective_salary, along with a running total of 
effective_salary with employees placed in ascending order of 
effective_salary*/

SELECT		e.id AS employee_id,
			e.first_name,
			e.last_name,
			e.fte_hours,
			e.salary,
			(e.fte_hours * e.salary) AS effective_salary,
			SUM(e.fte_hours * e.salary) OVER 
				(ORDER BY (e.fte_hours * e.salary) ASC NULLS LAST)
				AS effective_salary_cumulative
FROM		employees AS e;



/*Q6 - The total_day_charge of a team is defined as the 
charge_cost of the team multiplied by the number of employees 
in the team. Calculate the total_day_charge for each team */

/* CTE for team size first */
WITH		ts(team_id, team_name,number_of_employees) AS(
				SELECT		t.id,	
							t.name,
							COUNT(e.ID)
				FROM		teams AS t
								LEFT JOIN employees as e
								ON t.id = e.team_id
				GROUP BY	t.id
						)
/* link this to team */
SELECT		t.id AS team_id,
			t.name AS team_name,
			t.charge_cost,
			ts.number_of_employees,
			(ts.number_of_employees * CAST (t.charge_cost AS INT)) AS total_day_charge
FROM		teams AS t
				INNER JOIN ts
				ON t.id = ts.team_id
ORDER BY	total_day_charge DESC NULLS LAST;
				
				
				
/*Q7 - How would you amend your query from question 6 above 
 to show only those teams with a total_day_charge greater than 5000?*/

/*****RESPONSE***** : add a WHERE clause, see code below */

				
/* CTE for team size first */
WITH		ts(team_id, team_name,number_of_employees) AS(
				SELECT		t.id,	
							t.name,
							COUNT(e.ID)
				FROM		teams AS t
								LEFT JOIN employees as e
								ON t.id = e.team_id
				GROUP BY	t.id
						)
/* link this to team */
SELECT		t.id AS team_id,
			t.name AS team_name,
			t.charge_cost,
			ts.number_of_employees,
			(ts.number_of_employees * CAST (t.charge_cost AS INT)) AS total_day_charge
FROM		teams AS t
				INNER JOIN ts
				ON t.id = ts.team_id
/****************************************************************************************/
				WHERE		(ts.number_of_employees * CAST (t.charge_cost AS INT)) >= 5000
/****************************************************************************************/
ORDER BY	total_day_charge DESC NULLS LAST

				




/*********************
 EXTENSION QUESTIONS
 *********************/

/*Q1 - How many of the employees serve on one or more committees? */	

SELECT	COUNT(DISTINCT(employee_id))
FROM	employees_committees



/*Q2 - How many of the employees do not serve on a committee*/

/***** RESPONSE: could do it as a count of the number of IDs in the
 employee table minus the answer to Q1, or:  */

SELECT	COUNT(e.id)
FROM	employees AS e
			LEFT JOIN employees_committees as ec
			ON e.id = ec.employee_id
WHERE	ec.id IS NULL



/*Q3 - Get the full employee details (including committee name) 
of any committee members based in China*/

/* I've only included a few columns to keep results tidy */
SELECT			e.first_name,
				e.last_name,
				e.country,
				c.name AS committee_name	
FROM			(employees AS e
					INNER JOIN employees_committees AS ec
					ON e.id = ec.employee_ID)
						LEFT JOIN committees AS c
						ON ec.committee_id = c.id
WHERE			e.country = 'China'
ORDER BY		e.last_name,
				e.first_name;
			
			
			
/* Group committee members into the teams in which they work, 
 counting the number of committee members in each team (including 
 teams with no committee members). Order the list by the number 
 of committee members, highest first. */
			
/*****RESPONSE: the code below does not produce results
 for teams which have no committee members*/ 
			
					
SELECT		t.name AS team_name,
			/*CASE
				WHEN (ec.id IS NOT NULL) THEN TRUE
				ELSE FALSE
			END AS committee_mamber,*/
			COUNT(DISTINCT(e.id)) AS number_of_committee_members
FROM		(employees AS e
				LEFT JOIN employees_committees AS ec
				ON e.id = ec.employee_id)
					LEFT JOIN teams t
					ON e.team_id = t.id
WHERE		ec.id IS NOT NULL
GROUP BY	team_name
ORDER BY	number_of_committee_members DESC NULLS LAST	







					