USE KAN_AMO;
GO
CREATE OR ALTER PROC usp_getAndroidIncident
@VIN INT,

@startLocID INT,
@destLocID INT,
@alarmLevelID INT,
@incidentSQN INT,

@driverFName NVARCHAR(64) OUTPUT,
@driverLName NVARCHAR(64) OUTPUT,

@paramedicFName NVARCHAR(64) OUTPUT,
@paramedicLName NVARCHAR(64) OUTPUT,

@CarModel NVARCHAR(64) OUTPUT,
@CarBrand NVARCHAR(64) OUTPUT,
@CarLicense NVARCHAR(64) OUTPUT,

@startLocLong NVARCHAR(64) OUTPUT,
@startLocLat NVARCHAR(64) OUTPUT,
@startLocFFA NVARCHAR(500) OUTPUT,

@destLocLong NVARCHAR(64) OUTPUT,
@destLocLat NVARCHAR(64) OUTPUT,
@destLocFFA NVARCHAR(500) OUTPUT,

@incidentTypeName NVARCHAR(64) OUTPUT,
@incidentTypeNote NVARCHAR(64) OUTPUT,
@incidentPriorityName NVARCHAR(64) OUTPUT,
@incidentPriorityNote NVARCHAR(64) OUTPUT,

@alarmLevelName NVARCHAR(64) OUTPUT,
@alarmLevelNote NVARCHAR(64) OUTPUT

AS
BEGIN

SELECT @driverFName = Fname,
       @driverLName=Lname
       FROM dbo.Employee 
	   INNER  JOIN dbo.AmbulanceMap ON AmbulanceMap.DriverID = Employee.EID 
	   WHERE VIN = @VIN AND StatusMap = '01'

SELECT @paramedicFName = Fname,
       @paramedicLName = Lname
	   FROM dbo.Employee
       INNER  JOIN dbo.AmbulanceMap ON AmbulanceMap.ParamedicID = Employee.EID 
	   WHERE VIN = @VIN AND StatusMap = '01'

SELECT @CarModel = Model,
       @CarBrand = Brand,
       @CarLicense = LicencePlate 
       FROM dbo.AmbulanceVehicle WHERE VIN = @VIN

SELECT @startLocLong =  Longitude,
       @startLocLat = Latitude,
       @startLocFFA=FreeFormatAddress
       FROM dbo.Locations WHERE LocationID = @startLocID

SELECT @destLocLong =  Longitude,
       @destLocLat = Latitude,
       @destLocFFA=FreeFormatAddress
       FROM dbo.Locations WHERE LocationID = @destLocID

SELECT @incidentTypeName = TypeName,
       @incidentTypeNote = TypeNote,
       @incidentPriorityName = PriorityName,
       @incidentPriorityNote = PriorityNote FROM incident

INNER JOIN dbo.IncidentTypes ON IncidentTypes.IncidentTypeID = Incident.IncidentType
INNER JOIN dbo.Priorities ON Priorities.PrioritYID = Incident.IncidentPriority
WHERE  IncidentSequenceNumber = @incidentSQN

SELECT @alarmLevelName = AlarmLevelName,
       @alarmLevelNote = AlarmLevelote 
       FROM  dbo.AlarmLevels WHERE AlarmLevelID = @alarmLevelID


END