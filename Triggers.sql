USE KAN_AMO
GO

CREATE OR ALTER TRIGGER onLogOut 
ON Employee
AFTER UPDATE
AS
BEGIN

	IF((SELECT TOP 1 e.LogInStatus FROM Employee e WHERE (e.JobID = 3 OR e.JobID = 2) AND e.EmployeeStatus = '05') = '00') --User Has Logged Out
	BEGIN
	
	UPDATE AmbulanceMap
	SET StatusMap = '02'
	WHERE (DriverID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.DriverID
	AND am.StatusMap <> 04))
	OR (ParamedicID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.ParamedicID
	AND am.StatusMap <> 04))
	END
END

GO

CREATE OR ALTER TRIGGER onLogIn 
ON Employee
AFTER UPDATE
AS
BEGIN

	IF((SELECT TOP 1 e.LogInStatus FROM Employee e WHERE (e.JobID = 3 OR e.JobID = 2) AND e.EmployeeStatus = '05') = '01') --User Has Logged In
	BEGIN
	
	UPDATE AmbulanceMap
	SET StatusMap = '00'
	WHERE (DriverID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.DriverID
	AND am.StatusMap <> 04))
	OR (ParamedicID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.ParamedicID
	AND am.StatusMap <> 04))
	END
END
GO

CREATE OR ALTER TRIGGER onInsertAmbulanceMap
ON AmbulanceMap
AFTER INSERT
AS
BEGIN

UPDATE AmbulanceMap
SET StatusMap = '02'
WHERE (DriverID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.DriverID
	AND am.StatusMap <> 04 AND e.LogInStatus <> '00'))
	OR (ParamedicID = (SELECT e.EID FROM Employee e
	INNER JOIN AmbulanceMap am ON e.EID = am.ParamedicID
	AND am.StatusMap <> 04 AND e.LogInStatus <> '00'))

END


