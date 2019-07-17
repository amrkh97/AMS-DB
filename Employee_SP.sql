GO

CREATE OR ALTER PROC get_Employee_getAll
@SuperSSN INT,
@jobID INT
AS
BEGIN

IF(@jobID = -1)
BEGIN
SELECT Emp.EID,Emp.Fname,Emp.Lname,Emp.Email,Emp.ContactNumber,
	   Emp.PAN,Emp.NationalID,Emp.EmployeeStatus,Emp.Photo,Emp.Age,
	   Emp.Gender,Emp.City,Emp.JobID,J.Title FROM dbo.Employee AS Emp
INNER JOIN dbo.Jobs AS J ON J.JobID = Emp.JobID
WHERE Emp.SuperSSN = @SuperSSN
END
ELSE
BEGIN

SELECT Emp.EID,Emp.Fname,Emp.Lname,Emp.Email,Emp.ContactNumber,
	   Emp.PAN,Emp.NationalID,Emp.EmployeeStatus,Emp.Photo,Emp.Age,
	   Emp.Gender,Emp.City,Emp.JobID,J.Title FROM dbo.Employee AS Emp
INNER JOIN dbo.Jobs AS J ON J.JobID = Emp.JobID
WHERE Emp.JobID = @jobID AND Emp.SuperSSN = @SuperSSN
END
END

GO
CREATE OR ALTER PROC get_Employee_AllParamedics
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND SuperSSN = @SuperSSN

END
GO

CREATE OR ALTER PROC get_Employee_Paramedics
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND SuperSSN = @SuperSSN AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END
GO

CREATE OR ALTER PROC get_Employee_InActiveParamedics
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND SuperSSN = @SuperSSN AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' ) 

END

GO
CREATE OR ALTER PROC get_Employee_AllDrivers
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND SuperSSN = @SuperSSN

END

GO
CREATE OR ALTER PROC get_Employee_Drivers
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND SuperSSN = @SuperSSN AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END

GO
CREATE OR ALTER PROC get_Employee_InActiveDrivers
@SuperSSN INT
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND SuperSSN = @SuperSSN AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' )

END
GO

CREATE OR ALTER PROC get_Employee_getDatabyEmployeeID
@eid INT
AS
BEGIN
SELECT
EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,
Age,Gender,BDate,Country,City,SubscriptionDate,LogInTStamp,LogInGPS,SuperSSN,JobID,LogOutStamp,LogInStatus FROM dbo.Employee
WHERE EID = @eid
END