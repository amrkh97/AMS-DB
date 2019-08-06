USE KAN_AMO
GO

CREATE OR ALTER PROC usp_Hospital_getAll
AS
BEGIN
SELECT * FROM Hospital
END
GO

Create OR Alter PROC usp_Hospital_getByName
@HospitalName Nvarchar(256)
AS
BEGIN
SELECT * FROM Hospital
WHERE HospitalName LIKE '%' + @HospitalName + '%'
END
GO
