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
	DECLARE @ResponseStatus NVARCHAR(64)
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
