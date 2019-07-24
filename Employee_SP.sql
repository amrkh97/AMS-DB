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

GO
CREATE OR ALTER PROC get_Employee_getLogTimes
@EID INTEGER
AS
BEGIN
SELECT LogInTime,ISNULL(LogOutTime,LogInTime),DATEDIFF(MINUTE,LogInTime,ISNULL(LogOutTime,LogInTime)) AS WorkMins FROM dbo.EmployeeLogs
WHERE EmployeeID = @EID
END
GO

CREATE OR ALTER PROC get_Employee_getUnverified
AS
BEGIN
	SELECT Emp.EID, Emp.Fname, Emp.Lname, Emp.Email, Emp.ContactNumber,
		Emp.PAN, Emp.NationalID, Emp.EmployeeStatus, Emp.Photo, Emp.Age,
		Emp.Gender, Emp.City, Emp.JobID, J.Title
	FROM dbo.EmployeeRegistration AS Emp
	INNER JOIN dbo.Jobs AS J ON J.JobID = Emp.JobID
END
GO
CREATE OR ALTER PROC usp_Employee_Verify
@EmployeeID INT,
@SuperSSN INT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

Declare @Fname NVARCHAR(32)
Declare @Lname NVARCHAR(32)
Declare @BDate DATE
Declare @Email NVARCHAR(128)
Declare @HashPassword NVARCHAR(128)
Declare @Gender NVARCHAR(1)
Declare @ContactNumber NVARCHAR(64)
Declare @Country NVARCHAR(32)
Declare @City NVARCHAR(32)
Declare @AddressState NVARCHAR(32)
Declare @AddressStreet NVARCHAR(64)
Declare @AddressPcode VARCHAR(20)
Declare @SubscriptionDate DATETIME
Declare @PAN NVARCHAR(20)
Declare @NationalID	NVARCHAR(14)
Declare @JobID INT
Declare @Photo NVARCHAR(MAX)


SELECT @Fname = er.Fname,@Lname = er.Lname,@BDate = er.BDate,
@Email= er.Email, @HashPassword = er.HashPassword, @Gender = er.Gender, @ContactNumber = er.ContactNumber,
@Country = er.Country, @City = er.City, @AddressState = er.AddressState, @AddressStreet = er.AddressStreet,
@AddressPcode = er.AddressPcode, @SubscriptionDate = er.SubscriptionDate,
@PAN = er.PAN, @NationalID = er.NationalID, @JobID = er.JobID, @Photo = er.Photo FROM EmployeeRegistration AS er
WHERE er.EID = @EmployeeID

IF EXISTS(SELECT * FROM Employee WHERE (Employee.Email = @Email OR Employee.PAN = @PAN OR Employee.NationalID = @NationalID))
BEGIN
SET @HexCode = '01' --Email Already Exists.
END
ELSE
BEGIN
SET @HexCode = '00'
DELETE FROM EmployeeRegistration
WHERE EID = @EmployeeID

INSERT INTO Employee
(   
    Fname
   ,Lname
   ,BDate
   ,Email
   ,HashPassword
   ,Gender
   ,ContactNumber
   ,Country
   ,City
   ,AddressState
   ,AddressStreet
   ,AddressPcode
   ,SubscriptionDate
   ,PAN
   ,NationalID
   ,SuperSSN
   ,JobID
   ,Photo
   )
   VALUES
   (
		@Fname,
		@Lname,
		@BDate,
		@Email,
		@HashPassword,
		@Gender,
		@ContactNumber,
		@Country,
		@City,
		@AddressState,
		@AddressStreet,
		@AddressPcode,
		@SubscriptionDate,
		@PAN,
		@NationalID,
		@SuperSSN,
		@JobID,
		@Photo
   )

END

END
GO