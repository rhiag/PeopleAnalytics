# Find the average age of employees in each department and gender group. ( Round average  age up to two decimal places if needed)
select department, gender, round(avg(age),2) as average_age from employee
group by department,gender

# List the top 3 departments with the highest average training scores. ( Round average scores up to two decimal places if needed)
select department, round(avg(avg_training_score),2) as average_training_score from employee
group by department
order by avg_training_score desc
limit 3

# Find the percentage of employees who have won awards in each region. (Round percentages up to two decimal places if needed)
select sub.region, round((sub.awarded_emp/sub.total_emp)*100,2) as percentage
from (select region, count(*) as total_emp, sum(case awards_won when 0 then 0 else 1 end) as awarded_emp
        from employee group by region)sub
        
# Show the number of employees who have met more than 80% of KPIs for each recruitment channel and education level.
select recruitment_channel, education, count(*) as no_employee
from employee
where KPIs_met_more_than_80 = 1 
group by recruitment_channel,education
order by recruitment_channel,education

# Find the average length of service for employees in each department, considering only employees with previous year ratings greater than or equal to 4. ( Round average length up to two decimal places if needed)
select department,round(avg(length_of_service),2) as average_service from employee
where previous_year_rating >= 4
group by department;

# List the top 5 regions with the highest average previous year ratings.
select region, round(avg(previous_year_rating),2) as average_rating from employee
group by region
order by average_rating desc
limit 5 

# List the departments with more than 100 employees having a length of service greater than 5 years.
select department,count(*) from employee
where length_of_service > 5
group by department
having count(*) > 100

# Show the average length of service for employees who have attended more than 3 trainings, grouped by department and gender. ( Round average length up to two decimal places if needed)
select department,gender,round(avg(length_of_service),2) as average_service from employee
where no_of_trainings > 3
group by department,gender

# Find the percentage of female employees who have won awards, per department. Also show the number of female employees who won awards and total female employees. ( Round percentage up to two decimal places if needed)
select sub.department, sub.total_female,sub.awarded_fem,round((awarded_fem/total_female)*100,2) as pct_female
from (select department, count(*) as total_female, sum(case awards_won when 0 then 0 else 1 end) as awarded_fem from employee
where gender = 'f'
group by department)sub

# Calculate the percentage of employees per department who have a length of service between 5 and 10 years. ( Round percentage up to two decimal places if needed)
select sub.department, round((sub.tenured/sub.total_emp)*100,2) as pct_tenured
from (select department, 
        count(*) as total_emp,
        sum( case when length_of_service < 5 then 0
                    when length_of_service >10 then 0 
                    else 1
                    end) as tenured
from employee
group by department)sub

# Find the top 3 regions with the highest number of employees who have met more than 80% of their KPIs and received at least one award, grouped by department and region.
select department,region,count(*) as employee_count
from employee
where KPIs_met_more_than_80 = 1 and awards_won >= 1
group by department, region
order by employee_count desc
limit 3

# Calculate the average length of service for employees per education level and gender, considering only those employees who have completed more than 2 trainings and have an average training score greater than 75
select education,gender,round(avg(length_of_service),2) as average_service
from employee
where no_of_trainings > 2 and avg_training_Score > 75
group by education,gender

# For each department and recruitment channel, find the total number of employees who have met more than 80% of their KPIs, have a previous_year_rating of 5, and have a length of service greater than 10 years.
select department, recruitment_channel, count(*) as total_emp
from employee
where KPIs_met_more_than_80 = 1 and previous_year_rating = 5 and length_of_service > 10
group by department, recruitment_channel

# Calculate the percentage of employees in each department who have received awards, 
# have a previous_year_rating of 4 or 5, and an average training score above 70,
# grouped by department and gender

select sub.department,sub.gender,sub.total_emp,sub.awarded_emp,round((sub.awarded_emp/sub.total_emp)*100,2) as pct_awarded
from (select department,gender, 
		count(*) as total_emp,
        sum(case when (awards_won > 0 AND previous_year_rating in (4,5) 
						AND avg_training_score between 70 and 100 )
        then 1 else 0
        end) as awarded_emp
		from employee
		group by department,gender
		order by department,gender)sub

# using inner join
select q.department, q.gender, q.total_emp,q.awarded_emp,(q.awarded_emp/q.total_emp) as pct_awd 
from (
select emp.department,emp.gender,count(*) as awarded_emp, 
sub.total_emp from employee emp
inner join (select department,gender,count(*) as total_emp
from employee
group by department,gender) sub
ON sub.gender = emp.gender
AND sub.department = emp.department
AND emp.awards_won != 0 and emp.previous_year_rating >4 and emp.avg_training_score >70
group by emp.department,emp.gender) q;


#List the top 5 recruitment channels with the highest average length of service for employees
# who have met more than 80% of their KPIs, have a previous_year_rating of 5,
# and an age between 25 and 45 years, grouped by department and recruitment channel.

select department,recruitment_channel,round(avg(length_of_service),2) as average_service
from employee
where (KPIs_met_more_than_80 = 1 and previous_year_rating = 5 and age between 25 and 45)
group by department,recruitment_channel
order by avg(length_of_service) desc
limit 5