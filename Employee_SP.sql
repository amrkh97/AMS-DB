USE KAN_AMO
GO

CREATE OR ALTER PROC get_Employee_AllParamedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2

END
GO

CREATE OR ALTER PROC get_Employee_Paramedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END
GO

CREATE OR ALTER PROC get_Employee_InActiveParamedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' ) 

END

GO
CREATE OR ALTER PROC get_Employee_AllDrivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3

END

GO
CREATE OR ALTER PROC get_Employee_Drivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END

GO
CREATE OR ALTER PROC get_Employee_InActiveDrivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' )

END