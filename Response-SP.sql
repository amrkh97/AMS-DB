USE KAN_AMO
GO
CREATE OR ALTER PROC usp_Response_Insert
@AssociatedVehicleVIN INT, --1
@StartLocationID INT,--2
@PickLocationID INT,--3
@DropLocationID INT,--4
@DestinationLocationID INT,--5
@IncidentSQN INT,--6
@PrimaryResponseSQN INT,--7
@RespAlarmLevel INT,--8
@PersonCount NVARCHAR(32),--9
@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--10
@responseMessage NVARCHAR(128)='' OUTPUT,--11
@ResponseID INT= 0 OUTPUT--12
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ResponseStatus NVARCHAR(32)
	IF(@AssociatedVehicleVIN IS NULL OR @AssociatedVehicleVIN=0)
	BEGIN
		SET @responseMessage = 'Missing VIN'
		SELECT @return_Hex_value = 'AF'
		RETURN -1	
	END
	ELSE IF (@StartLocationID IS NULL OR @StartLocationID=0)
	BEGIN
		SET @responseMessage = 'Missing Start Location'
		SELECT @return_Hex_value = 'BF'
		RETURN -1
	END
	ELSE IF (@PickLocationID IS NULL OR @PickLocationID=0)
	BEGIN
		SET @responseMessage = 'Missing Pick Location'
		SELECT @return_Hex_value = 'CF'
		RETURN -1
	END
	ELSE IF (@DropLocationID IS NULL OR @DropLocationID=0)
	BEGIN
		SET @responseMessage = 'Missing Drop Location'
		SELECT @return_Hex_value = 'DF'
		RETURN -1
	END
	ELSE IF (@DestinationLocationID IS NULL OR @DestinationLocationID=0)
	BEGIN
		SET @responseMessage = 'Missing Destination Location'
		SELECT @return_Hex_value = 'EF'
		RETURN -1
	END
	ELSE IF (@IncidentSQN IS NULL OR @IncidentSQN=0)
	BEGIN
		SET @responseMessage = 'Missing Incident SQN'
		SELECT @return_Hex_value = 'FA'
		RETURN -1
	END
	ELSE IF (@RespAlarmLevel IS NULL OR @PrimaryResponseSQN=0)
	BEGIN
		SET @responseMessage = 'Missing Alarm Level'
		SELECT @return_Hex_value = 'FB'
		RETURN -1
	END
	ELSE IF (@PersonCount IS NULL OR @PersonCount='')
	BEGIN
		SET @responseMessage = 'Missing Persons Count'
		SELECT @return_Hex_value = 'FC'
		RETURN -1
	END
	SET @ResponseID = (SELECT SequenceNumber FROM dbo.Responses WHERE (AssociatedVehicleVIN=@AssociatedVehicleVIN AND StartLocationID=@StartLocationID AND PickLocationID=@PickLocationID 
	AND DropLocationID=@DropLocationID AND DestinationLocationID=@DestinationLocationID AND IncidentSQN=@IncidentSQN AND RespAlarmLevel=@RespAlarmLevel))
	IF(@ResponseID IS NOT NULL)
	BEGIN
		SET @responseMessage = 'Response Already Exist'
		SELECT @return_Hex_value = 'FE'
		RETURN -1
	END
	ELSE 
	SET @ResponseStatus='00'
	BEGIN
		INSERT INTO Responses
		(
			AssociatedVehicleVIN,
			StartLocationID,
			PickLocationID,
			DropLocationID,
			DestinationLocationID,
			RespStatus,
			IncidentSQN,
			PrimaryResponseSQN,
			RespAlarmLevel,
			PersonCount
		)
		VALUES
		(   
			@AssociatedVehicleVIN, 
			@StartLocationID,
			@PickLocationID,
			@DropLocationID,
			@DestinationLocationID,
			@ResponseStatus,
			@IncidentSQN,
			@PrimaryResponseSQN,
			@RespAlarmLevel,
			@PersonCount
		)
	END
	SET @ResponseID = (SELECT SequenceNumber FROM dbo.Responses WHERE (AssociatedVehicleVIN=@AssociatedVehicleVIN AND StartLocationID=@StartLocationID AND PickLocationID=@PickLocationID 
	AND DropLocationID=@DropLocationID AND DestinationLocationID=@DestinationLocationID AND IncidentSQN=@IncidentSQN AND RespAlarmLevel=@RespAlarmLevel))
	IF(@ResponseID IS NULL)
	BEGIN
		SET @responseMessage = 'Failed To Add The Response'
		SELECT @return_Hex_value = 'FF'
		RETURN -1
	END
	ELSE
	BEGIN
		SET @responseMessage = 'Response Has Been Added'
		SELECT @return_Hex_value = '00'
		RETURN 1
	END
END
GO
------------------------------------------------------------------------------------
-- FIND RESPONSE STATUS BY ID --
CREATE OR ALTER PROC usp_ResponseStatus_SearchByID 
@SequenceNumber INT, --1
@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--2
@responseMessage NVARCHAR(128)='' OUTPUT,--3
@RespStatus NVARCHAR(32) = '' OUTPUT--4
AS
BEGIN
	IF EXISTS (SELECT TOP 1 SequenceNumber FROM dbo.Responses WHERE SequenceNumber=@SequenceNumber)
	BEGIN
		SET @RespStatus = (SELECT RespStatus FROM Responses WHERE SequenceNumber=@SequenceNumber)
		SET @responseMessage = 'RESPONSE STATUS LOCATED'
		SELECT @return_Hex_value = '00'
		RETURN 1
	END
	ELSE
	BEGIN
		SET @responseMessage = 'FAILED TO LOCATE RESPONSE STATUS'
		SELECT @return_Hex_value = 'FF'
		RETURN -1
	END
END
GO
------------------------------------------------------------------------------------
-- UPDATE RESPONSE STATUS BY ID --
CREATE OR ALTER PROC usp_ResponseStatus_UpdateByID 
@SequenceNumber INT, --1
@ResponseStatus NVARCHAR(32),--2
@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--3
@responseMessage NVARCHAR(128)='' OUTPUT,--4
@RespStatus NVARCHAR(32) = '' OUTPUT--5
AS
BEGIN
	IF(@ResponseStatus IS NULL OR @ResponseStatus = '')
	BEGIN
		SET @responseMessage = 'MISSING RESPONSE STATUS VALUE TO UPDATED'
		SELECT @return_Hex_value = 'EE'
		RETURN -1
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT TOP 1 SequenceNumber FROM dbo.Responses WHERE SequenceNumber=@SequenceNumber)
		BEGIN
			UPDATE dbo.Responses
			SET RespStatus = @ResponseStatus
			WHERE SequenceNumber = @SequenceNumber
			SET @RespStatus = (SELECT RespStatus FROM Responses WHERE SequenceNumber=@SequenceNumber)
			SET @responseMessage = 'RESPONSE STATUS LOCATED'
			SELECT @return_Hex_value = '00'
			RETURN 1
		END
		ELSE
		BEGIN
			SET @responseMessage = 'FAILED TO LOCATE RESPONSE STATUS'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END
	END
END

GO

CREATE OR ALTER PROC usp_Response_TableData

AS
BEGIN

SELECT
dbo.Responses.IncidentSQN, dbo.IncidentTypes.TypeName, dbo.Responses.SequenceNumber,
dbo.Priorities.PriorityName,dbo.Responses.RespStatus,
dbo.AmbulanceMap.VIN,dbo.AmbulanceMap.ParamedicID,ParamedicTable.Fname,ParamedicTable.Lname,ParamedicTable.ContactNumber,
dbo.AmbulanceMap.DriverID,DriverTable.Fname,DriverTable.Lname,DriverTable.ContactNumber,
dbo.AmbulanceVehicle.LicencePlate,dbo.AmbulanceVehicle.Model,
PatientLoc.FreeFormatAddress
FROM dbo.AmbulanceMap
INNER JOIN dbo.AmbulanceVehicle 
ON AmbulanceVehicle.VIN = AmbulanceMap.VIN
INNER JOIN dbo.Employee AS ParamedicTable
ON ParamedicTable.EID = AmbulanceMap.ParamedicID
INNER JOIN dbo.Employee AS DriverTable
ON DriverTable.EID = AmbulanceMap.DriverID
INNER JOIN dbo.Responses
ON Responses.AssociatedVehicleVIN = AmbulanceVehicle.VIN
INNER JOIN dbo.Incident
ON Incident.IncidentSequenceNumber = Responses.IncidentSQN
INNER JOIN dbo.IncidentTypes
ON IncidentTypes.IncidentTypeID = Incident.IncidentType
INNER JOIN dbo.Priorities
ON Priorities.PrioritYID = Incident.IncidentPriority
INNER JOIN dbo.Locations AS PatientLoc
ON PatientLoc.LocationID = Responses.PickLocationID


END

--1	هبوط	1	Urgent	00	1	1	Ahmed	Al-Gohary	NULL	2	Amr	Khaled	NULL	3D0979	BENZ	Cairo


