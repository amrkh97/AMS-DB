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
@TicketNumber NVARCHAR(100), --10
@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--11
@responseMessage NVARCHAR(128)='' OUTPUT,--12
@ResponseID INT= 0 OUTPUT--13
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CreationTime DATETIME
	SET @CreationTime = GETDATE()
	DECLARE @ResponseStatus NVARCHAR(32)

	IF (@StartLocationID IS NULL OR @StartLocationID=0)
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

	SET @ResponseStatus='02' --Car Accepted

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
			PersonCount,
			TicketNumber,
			CreationTime
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
			@PersonCount,
			@TicketNumber,
			@CreationTime
		)

	SET @ResponseID = (SELECT SequenceNumber FROM dbo.Responses WHERE (CreationTime=@CreationTime AND StartLocationID=@StartLocationID AND PickLocationID=@PickLocationID 
	AND DropLocationID=@DropLocationID AND DestinationLocationID=@DestinationLocationID AND IncidentSQN=@IncidentSQN AND RespAlarmLevel=@RespAlarmLevel AND TicketNumber=@TicketNumber))
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
		
		IF (@AssociatedVehicleVIN IS NOT NULL)
		BEGIN
		UPDATE dbo.AmbulanceMap
		SET StatusMap = '01' --Ambulance Is Busy And Assigned
		WHERE VIN = @AssociatedVehicleVIN AND StatusMap = '00'

		UPDATE dbo.AmbulanceVehicle
		SET VehicleStatus = '06'
		WHERE VIN = @AssociatedVehicleVIN
		END --VIN was sent


			INSERT INTO ResponseUpdateLog
			(
				RespSQN,
				RespStatusMap
			)
			VALUES
			(
				@ResponseID,
				@ResponseStatus
			)

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
	@SequenceNumber INT,
	--1
	@ResponseStatus NVARCHAR(32),--2
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--3
	@responseMessage NVARCHAR(128)='' OUTPUT,--4
	@RespStatus NVARCHAR(32) = '' OUTPUT--5
AS
BEGIN
DECLARE @VIN INTEGER



	IF(@ResponseStatus IS NULL OR @ResponseStatus = '')
	BEGIN
		SET @responseMessage = 'MISSING RESPONSE STATUS VALUE TO UPDATED'
		SELECT @return_Hex_value = 'EE'
		RETURN -1
	END

	IF NOT EXISTS(SELECT * FROM AcceptedResponseStatus
	WHERE StatusCode=@ResponseStatus)
	BEGIN
		SET @responseMessage = 'MISSING RESPONSE STATUS VALUE TO UPDATED'
		SELECT @return_Hex_value = 'EE'
		RETURN -1
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT TOP 1
			SequenceNumber
		FROM dbo.Responses
		WHERE SequenceNumber=@SequenceNumber)
		BEGIN
			UPDATE dbo.Responses
			SET RespStatus = @ResponseStatus
			WHERE SequenceNumber = @SequenceNumber
			SET @RespStatus = (SELECT RespStatus
			FROM Responses
			WHERE SequenceNumber=@SequenceNumber)

			INSERT INTO ResponseUpdateLog
			(
				RespSQN,
				RespStatusMap
			)
			VALUES
			(
				@SequenceNumber,
				@ResponseStatus
			)


			IF ( @ResponseStatus = '0E')
			BEGIN
			SET @VIN = (
			SELECT VIN FROM dbo.AmbulanceVehicle
			INNER JOIN dbo.Responses
			ON AmbulanceVehicle.VIN = Responses.AssociatedVehicleVIN
			WHERE AssociatedVehicleVIN = @VIN
				
			)
			UPDATE dbo.AmbulanceMap
			SET StatusMap = '00'
			WHERE VIN = @VIN AND StatusMap = '01'

			UPDATE dbo.AmbulanceVehicle
			SET VehicleStatus = '05'
			WHERE VIN = @VIN AND VehicleStatus = '06'
			END
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
@NumberOfDays INT = 1
AS
BEGIN
DECLARE @dateDiff INT
SET @dateDiff = 1 --Default Value

IF(@NumberOfDays IS NOT NULL)
BEGIN
SET @dateDiff = @NumberOfDays
END

DECLARE @currentTime DATETIME
SET @currentTime = GETDATE()
SELECT
dbo.Responses.IncidentSQN, dbo.IncidentTypes.TypeName, dbo.Responses.SequenceNumber,
dbo.Priorities.PriorityName,dbo.Responses.RespStatus,
dbo.AmbulanceMap.VIN,dbo.AmbulanceMap.ParamedicID,ParamedicTable.Fname,ParamedicTable.Lname,ParamedicTable.ContactNumber,
dbo.AmbulanceMap.DriverID,DriverTable.Fname,DriverTable.Lname,DriverTable.ContactNumber,
dbo.AmbulanceVehicle.LicencePlate,dbo.AmbulanceVehicle.Model,
PatientLoc.FreeFormatAddress, PatientLoc.Latitude, PatientLoc.Longitude,
DropLoc.FreeFormatAddress, DropLoc.Latitude, DropLoc.Longitude,
dbo.Responses.TicketNumber
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
INNER JOIN dbo.Locations AS DropLoc
ON DropLoc.LocationID = Responses.DropLocationID
WHERE ((Responses.RespStatus <> '0E') 
OR
(
(Responses.RespStatus = '0E') AND (@dateDiff >= DATEDIFF(DAY,Responses.CreationTime,@currentTime)))
)

END
GO
--1	هبوط	1	Urgent	00	1	1	Ahmed	Al-Gohary	NULL	2	Amr	Khaled	NULL	3D0979	BENZ	Cairo

CREATE OR ALTER PROC usp_Response_TripHistory
@ResponseID INT
AS
BEGIN

SELECT * FROM ResponseUpdateLog
WHERE RespSQN = @ResponseID

END
GO
CREATE OR ALTER PROC usp_Response_AssignCar
@ResponseSQN INT,
@VIN INT,
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT,
@startLocID INT OUTPUT,
@destLocID INT OUTPUT,
@alarmLevelID INT OUTPUT,
@iSQN INT OUTPUT,
@ticketNumber NVARCHAR(32) OUTPUT
AS
BEGIN

UPDATE Responses
SET AssociatedVehicleVIN = @VIN
WHERE SequenceNumber = @ResponseSQN 
AND AssociatedVehicleVIN IS NULL

SELECT @startLocID = StartLocationID,
@destLocID = DropLocationID,
@alarmLevelID = RespAlarmLevel,
@iSQN = IncidentSQN,
@ticketNumber = TicketNumber
FROM Responses
WHERE SequenceNumber = @ResponseSQN

SET @HexCode = '00'
SET @HexMsg = 'Successfully Updated Response.'

END
GO

CREATE OR ALTER PROC usp_Response_Edit
@ResponseSQN INT, --1
@AssociatedVehicleVIN INT, --2
@StartLocationID INT,--3
@DropLocationID INT,--4
@IncidentType INT,--5
@HexCode NVARCHAR(2)='FF' OUTPUT,--6
@HexMsg NVARCHAR(128)='' OUTPUT--7
AS
BEGIN
IF NOT EXISTS(SELECT * FROM Responses WHERE  SequenceNumber=@ResponseSQN)
BEGIN

SET @HexCode = '01'
SET @HexMsg = 'Failed to locate response!'
RETURN -1
END
ELSE
BEGIN

IF (@AssociatedVehicleVIN IS NOT NULL AND @AssociatedVehicleVIN <> 0 )
BEGIN
UPDATE Responses
SET AssociatedVehicleVIN = @AssociatedVehicleVIN
WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
AND AssociatedVehicleVIN = 0
END

IF (@IncidentType IS NOT NULL AND @IncidentType <> 0 )
BEGIN
UPDATE Incident
SET IncidentType = @IncidentType
WHERE IncidentSequenceNumber = (
	SELECT IncidentSQN FROM Responses
	WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
)
END

IF (@StartLocationID IS NOT NULL)
BEGIN
UPDATE Responses
SET StartLocationID = @StartLocationID
WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
END


IF (@PickLocationID IS NOT NULL)
BEGIN
UPDATE Responses
SET PickLocationID = @StartLocationID
WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
END


IF (@DropLocationID IS NOT NULL)
BEGIN
UPDATE Responses
SET DropLocationID = @DropLocationID
WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
END


IF (@DestinationLocationID IS NOT NULL)
BEGIN
UPDATE Responses
SET DestinationLocationID = @DropLocationID
WHERE SequenceNumber = @ResponseSQN
AND RespStatus <> '0E'
END

SET @HexCode = '00'
SET @HexMsg = 'Response Updated Succesfully'

END

END
GO

CREATE OR ALTER PROC usp_Response_TripsByCar
@VIN INT = 0
AS
BEGIN

SELECT
dbo.Responses.IncidentSQN, dbo.IncidentTypes.TypeName, dbo.Responses.SequenceNumber,
dbo.Priorities.PriorityName,dbo.Responses.RespStatus,
dbo.AmbulanceMap.VIN,dbo.AmbulanceMap.ParamedicID,ParamedicTable.Fname,ParamedicTable.Lname,ParamedicTable.ContactNumber,
dbo.AmbulanceMap.DriverID,DriverTable.Fname,DriverTable.Lname,DriverTable.ContactNumber,
dbo.AmbulanceVehicle.LicencePlate,dbo.AmbulanceVehicle.Model,
PatientLoc.FreeFormatAddress, PatientLoc.Latitude, PatientLoc.Longitude,
DropLoc.FreeFormatAddress, DropLoc.Latitude, DropLoc.Longitude,
dbo.Responses.TicketNumber
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
INNER JOIN dbo.Locations AS DropLoc
ON DropLoc.LocationID = Responses.DropLocationID
WHERE Responses.AssociatedVehicleVIN = @VIN

END
GO