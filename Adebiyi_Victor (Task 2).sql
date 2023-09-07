CREATE DATABASE PrescriptionsDB


USE PrescriptionsDB
GO;



----To make Practice_code a Foreign Key in the Prescriptions table, a Practice_code Foreign Key constraint
----is added to the Prescriptions table referencing Medical_Practice
ALTER TABLE dbo.Prescriptions 
ADD FOREIGN KEY (PRACTICE_CODE) REFERENCES Medical_Practice (PRACTICE_CODE);


----To make BNF_Code a Foreign Key in the Prescriptions table, a BNF_Code Foreign Key constraint
----is added to the Prescriptions table referencing Drugs
ALTER TABLE dbo.Prescriptions 
ADD FOREIGN KEY (BNF_CODE) REFERENCES Drugs (BNF_CODE);


-----Viewing the imported tables
SELECT *
FROM dbo.Medical_Practice;


SELECT *
FROM dbo.Drugs;


SELECT *
FROM Prescriptions;


SELECT *
FROM dbo.Drugs
WHERE BNF_DESCRIPTION LIKE '%tablets%' OR BNF_DESCRIPTION LIKE '%capsules%'



SELECT PRESCRIPTION_CODE, ROUND(ITEMS * QUANTITY, 0) AS Total_Quantity
FROM dbo.Prescriptions;


SELECT DISTINCT CHEMICAL_SUBSTANCE_BNF_DESCR
FROM Drugs;


SELECT BNF_CHAPTER_PLUS_CODE,
				COUNT (*) AS PrescriptionsNumber,
				AVG(ITEMS * QUANTITY) AS AvgPrescriptionCosts,
				MIN(ITEMS * QUANTITY) AS MinPrescriptionCosts,
				MAX(ITEMS * QUANTITY) AS MaxPrescriptionCosts
FROM dbo.Prescriptions p INNER JOIN dbo.Drugs d ON p.BNF_CODE = d.BNF_CODE
GROUP BY BNF_CHAPTER_PLUS_CODE;



SELECT m.PRACTICE_NAME, p.ACTUAL_COST
FROM dbo.Medical_Practice m 
INNER JOIN dbo.Prescriptions p ON m.PRACTICE_CODE = p.PRACTICE_CODE
INNER JOIN (
						SELECT PRACTICE_CODE, MAX(ACTUAL_COST) AS MostExpensivePresc
						FROM dbo.Prescriptions
						GROUP BY PRACTICE_CODE
) mep ON p.PRACTICE_CODE = mep.PRACTICE_CODE 
AND p.ACTUAL_COST = mep.MostExpensivePresc
WHERE p.ACTUAL_COST > 4000
ORDER BY p.ACTUAL_COST DESC;



SELECT m.PRACTICE_NAME, COUNT(*) AS NumPrescriptions
FROM dbo.Medical_Practice m 
INNER JOIN dbo.Prescriptions p ON m.PRACTICE_CODE = p.PRACTICE_CODE
WHERE m.PRACTICE_NAME = (
				SELECT TOP 1 PRACTICE_NAME
				FROM (
							SELECT m.PRACTICE_NAME, COUNT(*) AS NumPrescriptions
							FROM dbo.Medical_Practice m INNER JOIN dbo.Prescriptions 
							p ON m.PRACTICE_CODE = p.PRACTICE_CODE
							GROUP BY m.PRACTICE_NAME) MedPracticePresc
				ORDER BY NumPrescriptions DESC)
GROUP BY m.PRACTICE_NAME;



SELECT TOP 1 d.BNF_DESCRIPTION AS Drug, COUNT(*) AS PrescriptionCount
FROM dbo.Prescriptions p INNER JOIN dbo.Drugs d ON p.BNF_CODE = d.BNF_CODE
GROUP BY d.BNF_DESCRIPTION
ORDER BY PrescriptionCount DESC;



SELECT QUANTITY, COUNT(*) AS NumPrescriptions
FROM dbo.Prescriptions
GROUP BY QUANTITY
HAVING COUNT(*) >50
ORDER BY QUANTITY DESC;




SELECT MAX(ACTUAL_COST) AS HighestCost
FROM dbo.Prescriptions;



SELECT SUM(ACTUAL_COST) AS SumTotalCosts
FROM dbo.Prescriptions;



SELECT * 
FROM Medical_Practice m
WHERE EXISTS (
				SELECT *
				FROM Prescriptions p
				WHERE p.PRACTICE_CODE = m.PRACTICE_CODE AND p.BNF_CODE IN (
								SELECT BNF_CODE
								FROM Drugs d
								WHERE d.CHEMICAL_SUBSTANCE_BNF_DESCR LIKE'%Theophylline%'));


