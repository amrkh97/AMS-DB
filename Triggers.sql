USE KAN_AMO
GO

CREATE OR ALTER TRIGGER onLogOut 
ON Employee
AFTER UPDATE
AS
BEGIN

	UPDATE AmbulanceMap
	SET StatusMap = '02'
	FROM AmbulanceMap am
	INNER JOIN Employee e ON am.ParamedicID = e.EID
	INNER JOIN Employee e1 ON am.DriverID = e1.EID
	WHERE ((e1.EmployeeStatus = '05' AND e1.LogInStatus = '00') OR (e.LogInStatus = '00' AND e.EmployeeStatus = '05')
	AND am.StatusMap <> 04)

END

GO

CREATE OR ALTER TRIGGER onLogIn 
ON Employee
AFTER UPDATE
AS
BEGIN

	UPDATE AmbulanceMap
	SET StatusMap = '00'
	FROM AmbulanceMap am
	INNER JOIN Employee e ON am.ParamedicID = e.EID
	INNER JOIN Employee e1 ON am.DriverID = e1.EID
	WHERE ((e1.EmployeeStatus = '05' AND e1.LogInStatus = '01') OR (e.LogInStatus = '01' AND e.EmployeeStatus = '05')
	AND am.StatusMap <> 04)

END
GO

CREATE OR ALTER TRIGGER onInsertAmbulanceMap
ON AmbulanceMap
AFTER INSERT
AS
BEGIN

	UPDATE AmbulanceMap
	SET StatusMap = '02'
	FROM AmbulanceMap am
	INNER JOIN Employee e ON am.ParamedicID = e.EID
	INNER JOIN Employee e1 ON am.DriverID = e1.EID
	WHERE ((e1.EmployeeStatus = '05' AND e1.LogInStatus = '00') OR (e.LogInStatus = '00' AND e.EmployeeStatus = '05')
	AND am.StatusMap <> 04)


END


