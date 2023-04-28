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
    WHERE allergies = 'Penicillin' or allergies = 'Morphine'
    ORDER BY allergies ASC, first_name ASC, last_name ASC;

--Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

    SELECT patient_id, diagnosis
    FROM admissions
    GROUP BY diagnosis, patient_id
    HAVING COUNT(admission_date) > 1
    ORDER BY patient_id;

--Show the city and the total number of patients in the city.
--Order from most to least patients and then by city name ascending.

    select city, count(patient_id)
    from patients
    group by city
    order by count(patient_id) desc, city ;
