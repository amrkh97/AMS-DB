USE KAN_AMO
GO


CREATE OR ALTER PROC get_MainDepartments
AS
BEGIN
SELECT * FROM MainDepartments
END
GO


CREATE OR ALTER PROC get_IncidentTypesByDepID
@Dep_ID INT
AS
BEGIN
SELECT * FROM IncidentTypes
WHERE Dep_ID = @Dep_ID

END
GO