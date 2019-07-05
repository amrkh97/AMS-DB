USE KAN_AMO
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