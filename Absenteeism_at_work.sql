SELECT *
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number;

--Healthiest employees according to bmi index
SELECT*
FROM Absenteeism_at_work
WHERE Social_drinker = 0 AND Social_smoker = 0
AND Body_mass_index BETWEEN 18.5 AND 25
AND Absenteeism_time_in_hours<
       (SELECT AVG(Absenteeism_time_in_hours)
        FROM Absenteeism_at_work);

--Number of non smokers and smokers / 686-54
SELECT COUNT(*) AS Non_Smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 0;

SELECT COUNT(*) AS Smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 1;

--Reasons for absence/season
SELECT a.ID,r.Reason 'Absence_Reasons',
CASE
    WHEN Month_of_absence IN(12,1,2) THEN 'Winter'
	WHEN Month_of_absence IN(3,4,5) THEN 'Spring'
	WHEN Month_of_absence IN(6,7,8) THEN 'Summer'
	WHEN Month_of_absence IN(9,10,11) THEN 'Fall'
	ELSE 'Unkown'
END AS Seasons
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number;

--Weight scale of employees
SELECT Weight,Body_mass_index 'BMI',r.Reason,
CASE
    WHEN Body_mass_index <18.5 THEN 'Underweight'
	WHEN Body_mass_index BETWEEN 18.5 and 25 THEN 'Healthy Weight'
	WHEN Body_mass_index BETWEEN 25 AND 30 THEN 'Overweight'
	WHEN Body_mass_index >30 THEN 'Obese'
	ELSE 'Unkown'
END AS 'Weight Scale'
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number;

SELECT A.Body_mass_index,Social_drinker,Social_smoker,r.Reason
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number
WHERE Body_mass_index> 30
AND r.Reason!='Unkown'
ORDER BY 1 DESC;


SELECT A.Body_mass_index,Social_drinker,Social_smoker,r.Reason
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number
WHERE Body_mass_index<20
AND r.Reason!='Unkown'
ORDER BY 1 DESC;


SELECT (a.Age-a.Service_time) AS Entry_Age
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number
	WHERE a.Service_time>(SELECT AVG(Service_time)
	                      FROM Absenteeism_at_work)
	ORDER BY Entry_Age DESC;


SELECT a.Distance_from_Residence_to_Work,a.Transportation_expense,a.Absenteeism_time_in_hours
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number
	WHERE a.Distance_from_Residence_to_Work>(SELECT AVG(Distance_from_Residence_to_Work)
	                                         FROM Absenteeism_at_work)
ORDER BY a.Absenteeism_time_in_hours DESC;

SELECT a.Service_time,a.Absenteeism_time_in_hours,((a.Service_time*10)/a.Absenteeism_time_in_hours) AS ST_Over_Absence
FROM Absenteeism_at_work a
LEFT JOIN compensation c
    ON  a.ID = c.ID
LEFT JOIN Reasons r
    ON a.Reason_for_absence = r.Number
	WHERE a.Absenteeism_time_in_hours !=0
ORDER BY 1 DESC;


SELECT COUNT(*) AS Drinker -- 420
FROM Absenteeism_at_work
WHERE Social_drinker = 1;

SELECT COUNT(*) AS Non_Drinker --320
FROM Absenteeism_at_work
WHERE Social_drinker = 0;

SELECT  ID,Disciplinary_failure
FROM Absenteeism_at_work
WHERE Social_drinker = 1 AND Social_smoker = 1
ORDER BY 2 DESC;

SELECT COUNT(*) AS Family_People
FROM Absenteeism_at_work
WHERE Son>1 AND Pet>1;

SELECT COUNT(*) AS Family_People
FROM Absenteeism_at_work
WHERE Son>1;

SELECT COUNT(*) AS Family_People
FROM Absenteeism_at_work
WHERE Pet>1;


SELECT Age, SUM(Absenteeism_time_in_hours)  AS expensive_transportation_hours
FROM Absenteeism_at_work
WHERE Transportation_expense>(SELECT AVG(Transportation_expense)
                              FROM Absenteeism_at_work)
AND Distance_from_Residence_to_Work>(SELECT AVG(Distance_from_Residence_to_Work)
                                     FROM Absenteeism_at_work)
GROUP BY Age
ORDER BY SUM(Absenteeism_time_in_hours) DESC;


SELECT Age, SUM(Absenteeism_time_in_hours)  AS cheap_transportation_hours
FROM Absenteeism_at_work
WHERE Transportation_expense<(SELECT AVG(Transportation_expense)
                              FROM Absenteeism_at_work)
AND Distance_from_Residence_to_Work<(SELECT AVG(Distance_from_Residence_to_Work)
                                     FROM Absenteeism_at_work)
GROUP BY Age
ORDER BY SUM(Absenteeism_time_in_hours) DESC;


--END--