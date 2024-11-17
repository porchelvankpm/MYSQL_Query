use project_medical_data_history;
# 1 . Show first name, last name, and gender of patients whose gender is 'M'
select first_name,last_name,gender from patients where gender = 'M';
# 2.  Show first name and last name of patients who do not have allergies
select first_name,last_name from patients where allergies is null;
# 3.  Show first name of patients that start with the letter 'C'
select first_name from patients where first_name like 'C%';
# 4 . Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name,last_name,weight from patients where weight between 100 and 120 order by weight;
# 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update allergies set allergies = 'NKA' where allergies is null;
# 6. Show first name and last name concatenated into one column to show their full name.
select concat(first_name," ",last_name) as name from patients;
# 7. Show first name, last name, and the full province name of each patient.
select pa.first_name,pa.last_name,pn.province_name from patients pa inner join province_names pn on pa.province_id = pn.province_id;
# 8. Show how many patients have a birth_date with 2010 as the birth year
select count(*) as patient_count from patients where date_format(birth_date,"%Y")=2010;
# 9. Show the first_name, last_name, and height of the patient with the greatest height.
select first_name,last_name,height from patients where height= (select max(height) from patients);
# 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select * from patients where patient_id in (1,45,534,879,1000);
# 11. Show the total number of admissions
select count(*) as Total_Admission from admissions;
# 12. Show all the columns from admissions where the patient was admitted and discharged on the same day
select * from admissions where admission_date=discharge_date;
# 13. Show the total number of admissions for patient_id 579
select count(*) as Total_Admission_579 from admissions where patient_id = 579;
# 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct(city) from patients where province_id = ("NS");
# 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date,height,weight from patients where height > 160 and weight > 70;
# 16 . Show unique birth years from patients and order them by ascending
select distinct(date_format(birth_date,"%Y")) as bithyear from patients order by date_format(birth_date,"%Y") asc ; 
# 17 . Show unique first names from the patients table which only occurs once in the list.
select first_name from patients group by first_name having count(first_name)=1;
# 18 . Show patient_id and first_name from patients where their first_name starts and ends with 's' and is at least 6 characters long.
select patient_id,first_name from patients where lower(first_name) like "s%s"  and length(first_name) >= 6;
# 19 .Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table
select pa.patient_id,pa.first_name,pa.last_name from patients pa inner join admissions ad on pa.patient_id = ad.patient_id where ad.diagnosis = "Dementia";
# 20 . Display every patient's first_name. Order the list by the length of each name and then by alphabetically
select first_name from patients order by length(first_name),first_name asc ;
# 21 . Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row
select(select count(*) from patients where gender = "M") as "Male_Patients",
(select count(*) from patients where gender = "F") as "Female_Patients" ;
# 22. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis
select patient_id,diagnosis from admissions group by patient_id,diagnosis having count(patient_id)!=1;
# 23. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending
select city,count(patient_id) as " Total Patients" from patients group by city order by count(patient_id) desc , city asc ;
# 24. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
select pa.first_name,pa.last_name,'Patient' as Role from patients pa
union all
select da.first_name,da.last_name,'Doctor' as Role from doctors da ;
# 25 . Show all allergies ordered by popularity. Remove NULL values from the query .
select allergies,count(patient_id) as popularity from patients group by allergies having allergies is not null order by popularity desc ;
# 26 . Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date
select first_name,last_name,birth_date 
from patients where date_format(birth_date,"%Y") between 1970 and 1979
order by birth_date asc;
# 27 . We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower
# case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in descending order EX: SMITH,jane
select concat(upper(last_name),",",lower(first_name)) as FullName from patients order by first_name desc;
# 28 . Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select pn.province_id,sum(pa.height) " Total Height " from province_names pn inner join patients pa on pn.province_id = pa.province_id
group by pn.province_id
having sum(pa.height) >= 7000;
# 29 . Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight)-min(weight) " Weight Diff" from patients where last_name like 'Maroni';
# 30 . Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select admission_date,count(admission_date) as admission_count from admissions group by admission_date order by admission_count desc;
# 31 . Show all of the patients grouped into weight groups. Show the total number of patients in each weight group. Order the list by the weight group
# descending. e.g. if they weigh 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc. 
select * ,
case
when weight between 100 and 109 then "100 weight group"
when weight between 110 and 119 then "110 weight group"
when weight between 120 and 129 then "120 weight group"
when weight between 130 and 139 then "130 weight group"
when weight >= 140 then "140 weight group"
else
"Weight less than 100"
end as "weight_group"
from patients order by weight desc;

# 32 . Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m).
# Weight is in units kg. Height is in units cm
select patient_id,first_name,last_name,height,weight,weight*100/height as bmi,
case 
when weight*100/height  > 30 then '1'
else '0' end as weight from patients;

# 33. Show patient_id, first_name, last_name, and attending doctor's specialty.
# Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information
select pa.patient_id,pa.first_name,pa.last_name from patients pa inner join admissions ad 
on pa.patient_id = ad.patient_id
inner join doctors doc
on doc.doctor_id = ad.attending_doctor_id
where ad.diagnosis = 'Epilepsy'
and doc.first_name like 'Lisa';

# 34 . All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after
 # their first admission. Show the patient_id and temp_password.
 select patient_id,concat(patient_id,length(last_name),date_format(birth_date,"%Y")) as temp_pass from patients;