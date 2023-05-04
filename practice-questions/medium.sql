--Show unique birth years from patients and order them by ascending.

    SELECT DISTINCT(SUBSTRING(birth_date, 1, 4))
    FROM patients
    ORDER BY birth_date ASC;

    or

    SELECT DISTINCT YEAR(birth_date) AS birth_year
    FROM patients
    ORDER BY birth_year;

--Show unique first names from the patients table which only occurs once in the list.
--Ex: If two or more people are named 'John' in the first_name column then don't include their name in the output list.
--If only 1 person is named 'Leo' then include them in the output.

    SELECT first_name
    FROM patients
    GROUP BY first_name
    HAVING COUNT(first_name) = 1;

--Show patient_id & first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

    SELECT patient_id, first_name
    FROM patients
    WHERE first_name LIKE 's%s' AND LENGTH(first_name) > 5;

    or

    SELECT patient_id, first_name
    FROM patients
    WHERE first_name LIKE 's____%s';

--Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
--Primary diagnosis is stored in the admissions table.

    SELECT patients.patient_id, patients.first_name, patients.last_name
    FROM patients
    JOIN admissions
    ON patients.patient_id = admissions.patient_id
    WHERE diagnosis = 'Dementia';

--Display every patient's first_name.
--Order the list by the length of each name and then by alphbetically

    SELECT first_name
    FROM patients
    ORDER BY LENGTH(first_name), first_name ASC;

--Show the total amount of male patients and the total amount of female patients in the patients table.
--Display the two results in the same row.

    SELECT
      (SELECT count(*) FROM patients WHERE gender='M') AS male_count,
      (SELECT count(*) FROM patients WHERE gender='F') AS female_count;

--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
--Show results ordered ascending by allergies then by first_name then by last_name.

    SELECT first_name, last_name, allergies
    FROM patients
    WHERE allergies = 'Penicillin' OR allergies = 'Morphine'
    ORDER BY allergies ASC, first_name ASC, last_name ASC;

--Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

    SELECT patient_id, diagnosis
    FROM admissions
    GROUP BY diagnosis, patient_id
    HAVING COUNT(admission_date) > 1
    ORDER BY patient_id;

--Show the city and the total number of patients in the city.
--Order from most to least patients and then by city name ascending.

    SELECT city, COUNT(patient_id)
    FROM patients
    GROUP BY city
    ORDER BY COUNT(patient_id) DESC, city ;

--Show first name, last name and role of every person that is either patient or doctor.
--The roles are either "Patient" or "Doctor"

    SELECT first_name, last_name, 'Patient' AS role
    FROM patients
    UNION ALL
    SELECT first_name, last_name, 'Doctor' AS role
    FROM doctors

--Show all allergies ordered by popularity. Remove NULL values from query.

    SELECT allergies, COUNT(allergies)
    FROM patients
    WHERE allergies IS NOT null
    GROUP BY allergies
    ORDER BY COUNT(allergies) DESC

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
--Sort the list starting from the earliest birth_date.

    SELECT first_name, last_name, birth_date
    FROM patients
    WHERE YEAR(birth_date) > 1969 AND YEAR(birth_date) < 1980
    ORDER BY birth_date ASC

--We want to display each patient's full name in a single column.
--Their last_name in all upper letters must appear first, then first_name in all lower case letters.
--Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane

    SELECT concat(UPPER(last_name), ',',LOWER(first_name)) AS full_name
    FROM patients
    ORDER BY first_name DESC

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

    SELECT DISTINCT(province_id), SUM(height)
    FROM patients
    GROUP BY province_id
    HAVING SUM(height) >= 7000

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

    SELECT MAX(weight) - MIN(weight)
    FROM patients
    WHERE last_name = 'Maroni'

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day.
--Sort by the day with most admissions to least admissions.

    SELECT DAY(admission_date), COUNT(admission_date) AS number_of_admissions
    FROM admissions
    GROUP BY DAY(admission_date)
    ORDER BY COUNT(DAY(admission_date)) DESC

--Show all columns for patient_id 542's most recent admission_date.

    SELECT *
    FROM admissions
    WHERE patient_id = 542
    GROUP BY patient_id
    HAVING MAX(admission_date)

--Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

    SELECT patient_id, attending_doctor_id, diagnosis
    FROM admissions
    WHERE (patient_id%2 <> 0 AND attending_doctor_id IN (1,5,19))
    OR ( charindex('2',attending_doctor_id) <> 0  AND len(patient_id) = 3)

--Show first_name, last_name, and the total number of admissions attended for each doctor.
--Every admission has been attended by a doctor.

    SELECT doctors.first_name, doctors.last_name, COUNT(admission_date)
    FROM doctors
    JOIN admissions
    ON doctors.doctor_id = admissions.attending_doctor_id
    GROUP BY admissions.attending_doctor_id

--For each doctor, display their id, full name, and the first and last admission date they attended.

    SELECT doctors.doctor_id,
    	concat(first_name,' ',last_name),
        MAX(admission_date) AS last_admission,
        MIN(admission_date) AS first_admission
    FROM doctors
    JOIN admissions
    ON doctors.doctor_id = admissions.attending_doctor_id
    GROUP BY doctors.doctor_id
