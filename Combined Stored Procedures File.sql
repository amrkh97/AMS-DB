USE KAN_AMO;

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------


-----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
GO
CREATE OR ALTER proc usp_YelloPads_SelectAll
as
	select * from Yellopad

GO

CREATE OR ALTER proc usp_YelloPads_selectActive
AS
    select * from Yellopad
	where YelloPadStatus <> '02'

GO
CREATE OR ALTER proc usp_YelloPads_selectInActive
AS
    select * from Yellopad
	where YelloPadStatus = '02'
 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
CREATE OR ALTER proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
as
IF (@UniqueID IS NOT NULL)
	BEGIN
		select * from Yellopad
		
		WHERE  YelloPad.YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

 ------------------------------------------
-- (3) Get YelloPad Status --
-----------------------------------------
GO
CREATE OR ALTER proc usp_YelloPads_Status @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YelloPadStatus from dbo.Yellopad
		WHERE YelloPad.YelloPadUniqueID=@UniqueID;
	END
	ELSE
		RETURN -1

 ------------------------------------------
-- (4) Get YelloPad Network Info --
-----------------------------------------
GO
CREATE OR ALTER proc usp_YelloPads_NetworkCard @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YellopadNetworkcardNo from YelloPad
		where YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
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
	SET @ResponseID = (SELECT SequenceNumber FROM dbo.Responses WHERE (AssociatedVehicleVIN=@AssociatedVehicleVIN AND StartLocationID=@StartLocationID AND PickLocationID=@PickLocationID 
	AND DropLocationID=@DropLocationID AND DestinationLocationID=@DestinationLocationID AND IncidentSQN=@IncidentSQN AND RespAlarmLevel=@RespAlarmLevel))
	IF(@ResponseID IS NOT NULL)
	BEGIN
		SET @responseMessage = 'Response Already Exist'
		SELECT @return_Hex_value = 'FE'
		RETURN -1
	END
	ELSE 
	SET @ResponseStatus='02' --Car Accepted
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
		
		UPDATE dbo.AmbulanceMap
		SET StatusMap = '01' --Ambulance Is Busy Ans Assigned
		WHERE VIN = @AssociatedVehicleVIN AND StatusMap = '00'

		UPDATE dbo.AmbulanceVehicle
		SET VehicleStatus = '06'
		WHERE VIN = @AssociatedVehicleVIN

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

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

GO

CREATE OR ALTER PROC usp_Patient_getAllLocations
@UserID INT
AS
BEGIN
SELECT * FROM Locations
INNER JOIN dbo.PatientLocations ON PatientLocations.LocationID = Locations.LocationID
WHERE PatientID=@UserID

END
GO


CREATE OR ALTER PROC  usp_Patient_Locations
@UserID INT,
@LocationUser NVARCHAR(100),
@Lat NVARCHAR(32),
@Long NVARCHAR(32),
@HexCode NVARCHAR(2) OUTPUt
AS
Begin
DECLARE @ID INT
Declare @UserTableID INT
Declare @LocID INT
SET @ID = (select PatientnationalID from Patient where PatientID=@UserID)
    --Patient doesn't already exist.
    if(@ID is not NULL)
    BEGIN
    --If this address is previously registered.
    if exists (SELECT FreeFormatAddress FROM Locations
               Inner Join PatientLocations on PatientLocations.LocationID = Locations.LocationID
               WHERE Locations.FreeFormatAddress=@LocationUser)
            --HexCode : 00 -> Location was already registered   
               set @HexCode = '00'
            
            else
            BEGIN
            --If the location wasn't registered.
            Insert into Locations(FreeFormatAddress,Latitude,Longitude)
            values(@LocationUser,@Lat,@Long)

            INSERT INTO  PatientLocations(PatientID,LocationID)
            values((Select PatientID from Patient where Patient.PatientNationalID=@UserID),(SELECT TOP 1 LocationID from Locations where Locations.FreeFormatAddress=@LocationUser))

           --HexCode : 01 -> Location wasn't registered   
               set @HexCode = '01'
        

            END
    END
    ELSE
    BEGIN
            Insert into Patient(PatientID,PatientnationalID) 
            VALUES (@UserID,@UserID)

        --TODO: Handle the case of having more than one apartment
        --on the same Latitude and Longitude.

            Insert into Locations(FreeFormatAddress,Longitude,Latitude)
            Values(@LocationUser,@Long,@Lat)
            
            set @UserTableID = (select PatientID from Patient where Patient.PatientnationalID=@UserID)
            set @LocID = (select top 1 LocationID from Locations 
                        where Locations.FreeFormatAddress=@LocationUser
                        and Locations.Longitude=@Long and Locations.Latitude=@Lat)


        --Add Entry in PatientLocations Table:

            INSERT INTO  PatientLocations(PatientID,LocationID)
            values(@UserTableID,@LocID)  

            
        --HexCode: 02 -> User wasn't registered in database.
            set @HexCode = '02'
    END

END

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
CREATE OR ALTER PROC usp_Receipt_Insert 
	
	@RespSQN NVARCHAR(64),
	@CasheirSSN INT,
	@FTPFileLocation NVARCHAR(128),
	@Cost NVARCHAR(32),
	@PaymentMethod NVARCHAR(32)= '00',
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	
		as 
	BEGIN TRY
	IF (@RespSQN IS NOT NULL )
		BEGIN
			INSERT INTO Receipt(RespSQN,CasheirSSN,FTPFileLocation,Cost,PaymentMethod)
			values (@RespSQN,@CasheirSSN,@FTPFileLocation,@Cost,@PaymentMethod)
	         SELECT @responseCode = '00'
				SELECT @responseMessage = 'Success'
		END
	ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
------------------------------------------------------------------------
GO
CREATE OR ALTER proc usp_Receipt_Delete 
 @ReceiptID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReceiptID IS NOT NULL)
	BEGIN
		UPDATE Receipt
		SET ReceiptStatus = 99
		where ReceiptID = @ReceiptID AND  ReceiptStatus='00'
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
		
	END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			       @responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1	
---------------------------------------------------------------------------
GO
CREATE OR ALTER proc usp_Receipt_SelectByRespSQN  @RespSQN NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@RespSQN IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((RespSQN = @RespSQN) AND (ReceiptStatus='00'))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
CREATE OR ALTER proc usp_Receipt_SelectByCasheirSSN  @CasheirSSN INT,
   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@CasheirSSN IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((CasheirSSN = @CasheirSSN) AND (ReceiptStatus='00'))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1


		
GO
CREATE OR ALTER proc usp_Receipt_SelectByFTPFileLocation  @FTPFileLocation NVARCHAR(128),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@FTPFileLocation IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((FTPFileLocation = @FTPFileLocation) AND (ReceiptStatus='00'))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
CREATE OR ALTER proc usp_Receipt_SelectByReceiptStatus  @ReceiptStatus NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReceiptStatus IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((ReceiptStatus = @ReceiptStatus))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
CREATE OR ALTER proc usp_Receipt_SelectByCost  @Cost NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@Cost IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((Cost = @Cost) AND (ReceiptStatus='00'))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
CREATE OR ALTER proc usp_Receipt_SelectByPaymentMethod  @PaymentMethod NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@PaymentMethod IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((PaymentMethod = @PaymentMethod) AND (ReceiptStatus='00'))
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
CREATE OR ALTER proc usp_Receipt_SelectByReceiptCreationTime  @ReceiptCreationTime DATETIME
as
	IF (@ReceiptCreationTime IS NOT NULL)
		BEGIN
			IF  (NOT(DatePart(yy,@ReceiptCreationTime)=0)) AND 
			(NOT(DatePart(mm,@ReceiptCreationTime) = 0)) AND 
			(NOT(DatePart(dd,@ReceiptCreationTime)=0)) AND 
			(NOT(DatePart(hh,@ReceiptCreationTime) =0)) AND 
			(NOT(DatePart(Mi,@ReceiptCreationTime) =0))
			BEGIN	
			select * from Receipt
			where ReceiptStatus='00' AND (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
			(DatePart(mm,ReceiptCreationTime) = DatePart(mm,@ReceiptCreationTime))
			and (DatePart(dd,ReceiptCreationTime) = DatePart(dd,@ReceiptCreationTime)
			and (DatePart(hh,ReceiptCreationTime) = DatePart(hh,@ReceiptCreationTime))
			and (DatePart(mi,ReceiptCreationTime) = DatePart(mi,@ReceiptCreationTime)) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReceiptCreationTime)=0)) AND 
			(NOT(DatePart(mm,@ReceiptCreationTime) = 0)) AND 
			(NOT(DatePart(dd,@ReceiptCreationTime)=0)) AND 
			(NOT(DatePart(hh,@ReceiptCreationTime) =0)) AND
			(DatePart(Mi,@ReceiptCreationTime)=0)
			BEGIN	
			select * from Receipt
			where  ReceiptStatus='00' AND  (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
			(DatePart(mm,ReceiptCreationTime) = DatePart(mm,@ReceiptCreationTime))
			and (DatePart(dd,ReceiptCreationTime) = DatePart(dd,@ReceiptCreationTime)
			and (DatePart(hh,ReceiptCreationTime) = DatePart(hh,@ReceiptCreationTime))) 
		END
		ELSE IF  (NOT(DatePart(yy,@ReceiptCreationTime)=0)) AND 
			(NOT(DatePart(mm,@ReceiptCreationTime) = 0)) AND 
			(NOT(DatePart(dd,@ReceiptCreationTime)=0)) AND 
			(DatePart(hh,@ReceiptCreationTime)=0) AND 
			(DatePart(mi,@ReceiptCreationTime)=0)
			BEGIN	
			select * from Receipt
			where  ReceiptStatus='00' AND  (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
			(DatePart(mm,ReceiptCreationTime) = DatePart(mm,@ReceiptCreationTime))
			and (DatePart(dd,ReceiptCreationTime) = DatePart(dd,@ReceiptCreationTime) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReceiptCreationTime) = 0)) AND 
			(NOT(DatePart(mm,@ReceiptCreationTime) = 0)) AND 
			(DatePart(dd,@ReceiptCreationTime) = 0) AND 
			(DatePart(hh,@ReceiptCreationTime) = 0) AND 
			(DatePart(Mi,@ReceiptCreationTime) = 0)
			BEGIN	
			select * from Receipt
			where  ReceiptStatus='00' AND (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
			(DatePart(mm,ReceiptCreationTime) = DatePart(mm,@ReceiptCreationTime)) 
		END
			ELSE IF  (NOT(DatePart(yy,@ReceiptCreationTime)=0)) AND 
			(DatePart(mm,@ReceiptCreationTime)=0) AND 
			(DatePart(dd,@ReceiptCreationTime)=0) AND 
			(DatePart(hh,@ReceiptCreationTime)=0) AND 
			(DatePart(Mi,@ReceiptCreationTime)=0)
			BEGIN	
			select * from Receipt
			where  ReceiptStatus='00' AND DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)
	END
	end
	ELSE
		RETURN -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- Reports SP --
--(0) Insert Report --
GO
CREATE OR ALTER PROC usp_Report_Insert 
	
	@ReportTitle VARCHAR(64),
	@PatientID INT,
	@ReportDestination NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	
		as 
	BEGIN TRY
	IF (@ReportTitle IS NOT NULL )
		BEGIN
			INSERT INTO Reports (ReportTitle,PatientID,ReportDestination)
			values (@ReportTitle,@PatientID,@ReportDestination)
	         SELECT @responseCode = '00'
				SELECT @responseMessage = 'Success'
		END
	ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

--(1) Get Report by ReportTitle --
GO
CREATE OR ALTER proc usp_Reports_SelectByReportTitle  @ReportTitle NVARCHAR(64)
as
	IF (@ReportTitle IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportTitle = @ReportTitle AND ReportStatus='00'
	END
	ELSE
		RETURN -1


--(2) Get Report by ReportStatus --
GO
CREATE OR ALTER proc usp_Reports_SelectByReportStatus  @ReportStatus NVARCHAR(64)
as
	IF (@ReportStatus IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportStatus = @ReportStatus AND ReportStatus='00'
	END
	ELSE
		RETURN -1

--(3) Get Report by ReportIssueTime --
GO
Use KAN_AMO
GO

CREATE OR ALTER proc usp_Reports_SelectByReportIssueTime  @ReportIssueTime DATETIME
as
	IF (@ReportIssueTime IS NOT NULL)
		BEGIN
			IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(hh,@ReportIssueTime) =0)) AND 
			(NOT(DatePart(Mi,@ReportIssueTime) =0))
			BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime)
			and (DatePart(hh,ReportIssueTime) = DatePart(hh,@ReportIssueTime))
			and (DatePart(mi,ReportIssueTime) = DatePart(mi,@ReportIssueTime)) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(hh,@ReportIssueTime) =0)) AND
			(DatePart(Mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus='00' AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime)
			and (DatePart(hh,ReportIssueTime) = DatePart(hh,@ReportIssueTime))) 
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(DatePart(hh,@ReportIssueTime)=0) AND 
			(DatePart(mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus='00' AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(DatePart(dd,@ReportIssueTime) = 0) AND 
			(DatePart(hh,@ReportIssueTime) = 0) AND 
			(DatePart(Mi,@ReportIssueTime) = 0)
			BEGIN	
			select * from Reports
			where  ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime)) 
		END
			ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(DatePart(mm,@ReportIssueTime)=0) AND 
			(DatePart(dd,@ReportIssueTime)=0) AND 
			(DatePart(hh,@ReportIssueTime)=0) AND 
			(DatePart(Mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus='00' AND DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)
	END
	end
	ELSE
		RETURN -1


--(4) Get Report by ReportStatus --
GO
CREATE OR ALTER proc usp_Reports_SelectByPatientID  @PatientID INT
as
	IF (@PatientID IS NOT NULL)
	BEGIN
		select * from Reports
		where  ReportStatus='00' AND  PatientID = @PatientID
	END
	ELSE
		RETURN -1
--(5) Get Report by ReportTitleAndStatus --
GO
CREATE OR ALTER proc usp_Reports_SelectByReportTitleAndStatus  @ReportTitle NVARCHAR(64),
 @ReportStatus NVARCHAR(64)
as
	IF (@ReportTitle IS NOT NULL AND @ReportStatus IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportTitle = @ReportTitle AND ReportStatus = @ReportStatus
	END
	ELSE
		RETURN -1
GO
CREATE OR ALTER proc usp_Reports_Delete 
 @ReportID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReportID IS NOT NULL)
	BEGIN
		UPDATE Reports
		SET ReportStatus = 99
		where ReportID = @ReportID AND  ReportStatus='00'
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
		
	END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			       @responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1	


-- END of Reports SP --
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
----------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Full_Time  @ReportIssueTime DATETIME
as
	IF (@ReportIssueTime IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND	(ReportIssueTime=@ReportIssueTime)
end
	ELSE
		RETURN -1
-------------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year  @ReportCreationYear int
as
	IF (@ReportCreationYear IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
	end
ELSE
	RETURN -1
------------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month   @ReportCreationYear int, @ReportCreationMonth int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth is not null))
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
			and(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month_Day  @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL))
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month_Day_Hour   @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int,@ReportCreationHour int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL) and (@ReportCreationHour is not null) )
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay
			and (DatePart(hh,ReportIssueTime) = @ReportCreationHour))
end
	ELSE
		RETURN -1
--------------------------------------------------
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
Create  OR ALTER PROC usp_Medicine_SelectByCompanyName
@CompanyName NVARCHAR(64)
as
DECLARE @CompanyID INT
if (@CompanyName IS NOT NULL)
	BEGIN
SET @CompanyID = (select CompanyID from PharmaCompany where CompanyName=@CompanyName)
	select BarCode,  MedicineStatus, MedicineName,CountInStock, Implications,MedicineUsage, SideEffects, ActiveComponent,price FROM Medicine
	INNER JOIN CompanyMedicineMap  
	ON CompanyMedicineMap.MedBCode=Medicine.BarCode
	where CompID=@CompanyID AND MapStatus<>'ff'
	END
	ELSE
	RETURN -1
GO
Create  OR ALTER PROC usp_PharmaCompany_SelectByMedicineName
@MedicineName NVARCHAR(64)
as
DECLARE @BarCode INT
if (@MedicineName IS NOT NULL)
	BEGIN
SET @BarCode = (select BarCode from Medicine where MedicineName = @MedicineName)
	select CompanyID ,CompanyName,ContactPerson ,CompanyAddress ,CompanyPhone , CompanyStatus
	 from PharmaCompany
	INNER JOIN CompanyMedicineMap
	ON CompanyMedicineMap.CompID=PharmaCompany.CompanyID
	where MedBCode=@BarCode AND MapStatus<>'ff'
	END
	ELSE
	return -1


GO
Create  OR ALTER PROC usp_Medicine_SelectByContactPerson
@ContactPerson NVARCHAR(32)
as
if (@ContactPerson IS NOT NULL)
	BEGIN
	select DISTINCT BarCode,  MedicineStatus, MedicineName,CountInStock, Implications,MedicineUsage, 
	SideEffects,ActiveComponent,ActiveComponent,price
	from Medicine INNER join  CompanyMedicineMap
	ON CompanyMedicineMap.MedBCode = Medicine.BarCode 
	INNER join PharmaCompany 
	on CompanyMedicineMap.CompID = PharmaCompany.CompanyID  
	where PharmaCompany.ContactPerson =@ContactPerson AND MapStatus<>'ff'
	END
	ELSE
	return -1
	
GO
CREATE  OR alter proc usp_Medicine_SelectByCompanyStatus
@CompanyStatus NVARCHAR(32)
as
if (@CompanyStatus IS NOT NULL)
	BEGIN
	select DISTINCT BarCode,  MedicineStatus,  MedicineName,CountInStock, Implications,MedicineUsage, 
	SideEffects,ActiveComponent,ActiveComponent,price
	from Medicine INNER join  CompanyMedicineMap
	ON CompanyMedicineMap.MedBCode = Medicine.BarCode 
	INNER join PharmaCompany 
	on CompanyMedicineMap.CompID = PharmaCompany.CompanyID  
	where PharmaCompany.CompanyStatus=@CompanyStatus  AND MapStatus<>'ff'
	END
	ELSE
	return -1

GO
CREATE OR alter proc usp_Medicine_SelectByActiveComponent
@ActiveComponent NVARCHAR(MAX)
as
if (@ActiveComponent IS NOT NULL)
	BEGIN
	select * from Medicine
	where ActiveComponent=@ActiveComponent
	END
	ELSE
	return -1

 ------------------------------------------

 	
GO
CREATE  OR alter proc usp_Medicine_UpdateStatus
@MedicineStatus NVARCHAR(2),
@barCode NVARCHAR(64),
@responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY
if (@barCode IS NOT NULL AND @MedicineStatus  IS NOT NULL )
	BEGIN
	UPDATE dbo.Medicine
	SET MedicineStatus = ISNULL (@MedicineStatus,MedicineStatus)
	where BarCode=@barCode
	SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 

				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
				 RETURN -1
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
	           	@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1

-- (2) Search Unique ID --

----------------------------------------MEDICAL RECORD STORED PROCEDURES --------------------------------------------------------------

GO
CREATE OR ALTER proc usp_MedicalRecord_SelectAll 
as
	select * from MedicalRecord
	
GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByID  @MedicalRecordID INT
as
	IF (@MedicalRecordID IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where MedicalRecordID = @MedicalRecordID
	END
	ELSE
		RETURN -1
		
GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByPatient  @PatientID INT
as
	IF (@PatientID IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where PatientID = @PatientID
	END
	ELSE
		RETURN -1

GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByStatus  @MRStatus NVARCHAR(32)
as
	IF (@MRStatus IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where MRStatus = @MRStatus
	END
	ELSE
		RETURN -1
		GO
CREATE OR ALTER PROC usp_MedicalRecord_Insert 
	@RespSQN INT,
	@PatientID INT,
	@BloodType NVARCHAR(12),
	@BloodPressure NVARCHAR(2),
	@Diabetes NVARCHAR(2),
	@RespiratoryDiseases NVARCHAR(2),
	@Cancer NVARCHAR(2),
	@CardiovascularDiseases NVARCHAR(2),
	@COPD NVARCHAR(2),
	@Pregnancy NVARCHAR(2),
	@Other NVARCHAR(MAX),
	@Dead NVARCHAR(2),
	@Consciousness NVARCHAR(2),
    @Breathing NVARCHAR(2),
    @Capillaries NVARCHAR(2),
	@Pulse NVARCHAR(12),
	@BloodPressureLevel NVARCHAR(12),
	@DiabetesLevel NVARCHAR(12),
	@BodyTemp NVARCHAR(12),
	@BreathingRate NVARCHAR(12),
	@CapillariesLevel NVARCHAR(12),
	@Injury NVARCHAR(MAX),
	@PhysicalExaminationImage NVARCHAR(MAX),
	@MedicineApplied NVARCHAR(128),
	@ProcedureDoneInCar NVARCHAR(MAX),
	@RecommendedProcedure NVARCHAR(MAX),
	@MRStatus NVARCHAR(32),
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@mrID INT = 0  OUTPUT
	
	as 
	BEGIN TRY
	IF(@RespSQN IS NOT NULL AND @PatientID IS NOT NULL )
		BEGIN
			INSERT INTO MedicalRecord (RespSQN,PatientID,BloodType,BloodPressure,Diabetes,RespiratoryDiseases,Cancer,CardiovascularDiseases,COPD,Pregnancy,Other,Dead,Consciousness,Breathing,Capillaries,Pulse,BloodPressureLevel,DiabetesLevel,BodyTemp,BreathingRate,CapillariesLevel,Injury,PhysicalExaminationImage,MedicineApplied,ProcedureDoneInCar,RecommendedProcedure,MRStatus)
			values(@RespSQN,@PatientID,@BloodType,@BloodPressure,@Diabetes,@RespiratoryDiseases,@Cancer,@CardiovascularDiseases,@COPD,@Pregnancy,@Other,@Dead,@Consciousness,@Breathing,@Capillaries,@Pulse,@BloodPressureLevel,@DiabetesLevel,@BodyTemp,@BreathingRate,@CapillariesLevel,@Injury,@PhysicalExaminationImage,@MedicineApplied,@ProcedureDoneInCar,@RecommendedProcedure,@MRStatus)
		    SELECT @responseCode = '00'
		    SELECT @responseMessage = 'Successfully Added Medical Record'
	        SELECT @mrID = (SELECT MedicalRecordID FROM MedicalRecord WHERE RespSQN = @RespSQN AND PatientID=@PatientID )
			END
			
	ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1


		-- (4) Update MedicalRecord --




		-- (4) Update MedicalRecord --

GO
CREATE OR ALTER PROC usp_MedicalRecord_Update

    @MedicalRecordID INT,
	@RespSQN INT,
	@PatientID INT,
	@BloodType NVARCHAR(12),
	@BloodPressure NVARCHAR(2),
	@Diabetes NVARCHAR(2),
	@RespiratoryDiseases NVARCHAR(2),
	@Cancer NVARCHAR(2),
	@CardiovascularDiseases NVARCHAR(2),
	@COPD NVARCHAR(2),
	@Pregnancy NVARCHAR(2),
	@Other NVARCHAR(MAX),
	@Dead NVARCHAR(2),
	@Consciousness NVARCHAR(2),
    @Breathing NVARCHAR(2),
    @Capillaries NVARCHAR(2),
	@Pulse NVARCHAR(12),
	@BloodPressureLevel NVARCHAR(12),
	@DiabetesLevel NVARCHAR(12),
	@BodyTemp NVARCHAR(12),
	@BreathingRate NVARCHAR(12),
	@CapillariesLevel NVARCHAR(12),
	@Injury NVARCHAR(MAX),
	@PhysicalExaminationImage NVARCHAR(MAX),
	@MedicineApplied NVARCHAR(128),
	@ProcedureDoneInCar NVARCHAR(MAX),
	@RecommendedProcedure NVARCHAR(MAX),
	@MRStatus NVARCHAR(32),
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT


as
Begin TRY
	IF (@MedicalRecordID  IS NOT NULL)
		BEGIN
			UPDATE MedicalRecord
			SET   
			
			RespSQN=ISNULL(@RespSQN,RespSQN),
			PatientID=ISNULL(@PatientID,PatientID),
			BloodType=ISNULL(@BloodType,BloodType),
			BloodPressure=ISNULL(@BloodPressure,BloodPressure),
			Diabetes=ISNULL(@Diabetes,Diabetes),
			RespiratoryDiseases=ISNULL(@RespiratoryDiseases,RespiratoryDiseases),
			Cancer=ISNULL(@Cancer,Cancer),
			CardiovascularDiseases=ISNULL(@CardiovascularDiseases,CardiovascularDiseases),
			COPD=ISNULL(@COPD,COPD),
			Pregnancy=ISNULL(@Pregnancy,Pregnancy),
			Other=ISNULL(@Other,Other),
			Dead=ISNULL(@Dead,Dead),
			Consciousness=ISNULL(@Consciousness,Consciousness),
			Breathing=ISNULL(@Breathing,Breathing),
			Capillaries=ISNULL(@Capillaries ,Capillaries),
			Pulse=ISNULL(@Pulse,Pulse),
			BloodPressureLevel=ISNULL(@BloodPressureLevel,BloodPressureLevel),
			DiabetesLevel=ISNULL(@DiabetesLevel,DiabetesLevel),
			BodyTemp=ISNULL(@BodyTemp,BodyTemp),
			BreathingRate=ISNULL(@BreathingRate,BreathingRate),
			CapillariesLevel=ISNULL(@CapillariesLevel,CapillariesLevel),
			Injury=ISNULL(@Injury,Injury),
			PhysicalExaminationImage=ISNULL(@PhysicalExaminationImage,PhysicalExaminationImage),
			MedicineApplied=ISNULL(@MedicineApplied,MedicineApplied),
			ProcedureDoneInCar=ISNULL(@ProcedureDoneInCar,ProcedureDoneInCar),
			RecommendedProcedure=ISNULL(@RecommendedProcedure,RecommendedProcedure),
			MRStatus=ISNULL(@MRStatus,MRStatus)
			
			WHERE MedicalRecordID = @MedicalRecordID
		    SELECT @responseCode = '00'
		    SELECT @responseMessage = 'Successfuly Updated'
			if NOT EXISTS(SELECT * from MedicalRecord WHERE MedicalRecordID = @MedicalRecordID )
			Begin
		    SELECT @responseCode = '05'
		    SELECT @responseMessage = 'Not Found'
			END
		
		END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		-- (5) Delete MedicalRecord By ID --
GO
CREATE OR ALTER proc usp_MedicalRecord_Delete  @MedicalRecordID  INT,@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
as
Begin TRY
	IF (@MedicalRecordID IS NOT NULL)
	BEGIN

		UPDATE  MedicalRecord 
		SET MRStatus = 'FF' 
		where MedicalRecordID = @MedicalRecordID AND NOT MRStatus = 'FF'  
		 SELECT @responseCode = '00'
		 SELECT @responseMessage = 'Successfuly Deleted'
    END
 
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
------------------------- Stored Procedures ----------------------------
------------------------------------------------------------------------
-- Location Stored Procedures --
-- (1) Insert New Location --
GO
CREATE OR ALTER PROC usp_Locations_Insert 
	@FreeFormatAddress NVARCHAR(256),
    @City NVARCHAR(32) = NULL,
    @Longitude  NVARCHAR(32) = NULL,
    @Latitude  NVARCHAR(32) = NULL,
    @Street NVARCHAR(32) = NULL,
    @Apartement NVARCHAR(32) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @FloorLevel NVARCHAR(20) = NULL,
	@HouseNumber NVARCHAR(12) = NULL,
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
as
	BEGIN TRY
		IF (@FreeFormatAddress IS NOT NULL)
			BEGIN
				INSERT INTO Locations (FreeFormatAddress,City,Longitude,Latitude,Street,Apartement,PostalCode,FloorLevel,HouseNumber)
				values (@FreeFormatAddress,@City,@Longitude,@Latitude,@Street,@Apartement,@PostalCode,@FloorLevel,@HouseNumber)
				SELECT @responseCode = '00'
				SELECT @responseMessage = 'Location Added Successfully'
			END
		ELSE	
			BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
Go
----------------------------------------------------------------------
-- (1) Insert New Location Test --
--EXEC usp_Locations_Insert @FreeFormatAddress = 'dgd',
--@City = 'Giza',
--@Longitude = 34.56,
--@Latitude = 23.67,
--@Street = 'dokki',
--@Apartement = '4',
--@PostalCode = '1232',
--@FloorLevel = '4',
--@HouseNumber = '10'

-----------------------------------------------------------------------
-- (2) Get All Locations --
---------------------------------------- 
GO
CREATE OR ALTER proc usp_Locations_SelectAll
as
	select * from Locations
------------------------------------------
-- (2) Get Get All Locations Test --
--GO
--EXEC usp_Locations_SelectAll
-----------------------------------------
-- (2.1) Get Locations by city --
GO
CREATE OR ALTER proc usp_Locations_SelectByCity @CityName NVARCHAR(32)
as
	IF (@CityName IS NOT NULL)
	BEGIN
		select * from Locations
		where City = @CityName
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.1) Get Locations by city Test --
--GO
--EXEC usp_Locations_SelectByCity @CityName = 'Giza'
-----------------------------------------
-- (2.2) GET Locations by Cooredinates --
GO
CREATE OR ALTER PROC usp_Locations_SelectByGPS 
	@Longitude  NVARCHAR(32),
	@Latitude  NVARCHAR(32)
as
	IF (@Longitude IS NOT NULL AND @Latitude IS NOT NULL)
	BEGIN
		select * from Locations
		where Longitude = @Longitude AND Latitude = @Latitude
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.2) GET Locations by Cooredinates Test --
--GO
--EXEC usp_Locations_SelectByCity @Longitude = '34.56', @Latitude = '23.67'
-----------------------------------------
-- (2.3) GET Locations by Street --
GO
CREATE OR ALTER PROC usp_Locations_SelectByStreet
	@Street NVARCHAR(32)
as
	IF (@Street IS NOT NULL)
	BEGIN
		select * from Locations
		where Street = @Street
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.3) GET Locations by Street Test --
--GO
--EXEC usp_Locations_SelectByStreet @Street = 'dokki'
-----------------------------------------
-- (2.4) GET Locations by PostalCode --
GO
CREATE OR ALTER PROC usp_Locations_SelectByPostalCode
	@PostalCode NVARCHAR(20)
as
	IF (@PostalCode IS NOT NULL)
	BEGIN
		select * from Locations
		where PostalCode = @PostalCode
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.4) GET Locations by PostalCode Test --
--GO
--EXEC usp_Locations_SelectByPostalCode @PostalCode = '1232'
-----------------------------------------
-- (2.5) GET Locations by PostalZipCode --
GO
CREATE OR ALTER PROC usp_Locations_SelectByPostalZipCode
	@PostalZipCode NVARCHAR(32)
as
	IF (@PostalZipCode IS NOT NULL)
	BEGIN
		select * from Locations
		where PostalCode = @PostalZipCode
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.5) GET Locations by PostalZipCode Test --
--GO
--EXEC usp_Locations_SelectByPostalZipCode @PostalZipCode = '20'
-----------------------------------------
-- (2.6) GET Locations by LocationID --
GO
CREATE OR ALTER PROC usp_Locations_SelectByID
	@LocationID INT
as
	IF (@LocationID IS NOT NULL)
	BEGIN
		select * from Locations
		where LocationID = @LocationID
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.6) GET Locations by LocationID Test --
--GO
--EXEC usp_Locations_SelectByID @LocationID = 2
-----------------------------------------
-- (2.7) GET Locations by Location Address --
GO
CREATE OR ALTER PROC usp_Locations_SelectByAddress
	@FreeFormatAddress NVARCHAR(256)
as
	IF (@FreeFormatAddress IS NOT NULL)
	BEGIN
		select * from Locations
		where FreeFormatAddress LIKE '%' + @FreeFormatAddress + '%'
	END
	ELSE
		RETURN -1
-----------------------------------------
-- (2.7) GET Locations by Location Address Test --
GO
EXEC usp_Locations_SelectByAddress @FreeFormatAddress = 'giza'
-----------------------------------------
-- (3) Delete Location By LocationID --
GO
CREATE OR ALTER proc usp_Location_Delete  @LocationID INT
as
	IF (@LocationID IS NOT NULL)
	BEGIN
		UPDATE Locations
		SET LocationStatus = 99
		where LocationID = @LocationID
	END
	ELSE
		return -1
-----------------------------------------
-- (3) Delete Location By LocationID Test --
--GO
--EXEC usp_Location_Delete @LocationID = 4
-----------------------------------------
-- (4) Update Location By LocationID --
GO
CREATE OR ALTER PROC usp_Location_Update
	@LocationID INT,
	@FreeFormatAddress NVARCHAR(256) = NULL,
    @Longitude  NVARCHAR(32) = NULL,
    @Latitude  NVARCHAR(32) = NULL,
    @Street NVARCHAR(32) = NULL,
    @Apartement NVARCHAR(32) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @FloorLevel NVARCHAR(20) = NULL,
	@HouseNumber NVARCHAR(12) = NULL
as
	IF (@LocationID IS NOT NULL)
		BEGIN
			UPDATE Locations
			SET FreeFormatAddress = ISNULL(@FreeFormatAddress,FreeFormatAddress),
			Longitude = ISNULL(@Longitude,Longitude),
			Latitude = ISNULL(@Latitude,Latitude),
			Street = ISNULL(@Street,Street),
			Apartement = ISNULL(@Apartement,Apartement),
			PostalCode = ISNULL(@PostalCode,PostalCode),
			FloorLevel = ISNULL(@FloorLevel,FloorLevel),
			HouseNumber = ISNULL(@HouseNumber,HouseNumber),
			LocationStatus = 2
			WHERE LocationID = @LocationID
		END
	ELSE
		return -1
-----------------------------------------
-- (4) Update Location By LocationID Test --
--GO
--EXEC usp_Location_Update @LocationID = 1, @FreeFormatAddress = 'adsdasdfsa', @Longitude = 25.334,
--@Latitude = 65.32, @Street = 'Tahrir',  @HouseNumber = '7'
-----------------------------------------

GO
CREATE OR ALTER PROC usp_InsertNewLocation 
	@FreeFormatAddress NVARCHAR(256),--1
	@City NVARCHAR(32),--2
	@Longitude NVARCHAR(32),--3
	@Latitude NVARCHAR(32),--4
	@Street NVARCHAR(32),--5
	@Apartement NVARCHAR(32),--6
	@PostalCode NVARCHAR(32),--7
	@FloorLevel NVARCHAR(32),--8
	@HouseNumber NVARCHAR(12),--9
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--10
	@responseMessage NVARCHAR(128)='' OUTPUT,--11
	@LocationID INT= 0 OUTPUT--12
	AS
	BEGIN
	SET NOCOUNT ON
	DECLARE @locID INT
	DECLARE @LocationStatus NVARCHAR(32)
	IF (@FreeFormatAddress IS NOT NULL AND @Longitude IS NOT NULL AND @Latitude IS NOT NULL)
		BEGIN
			SET @locID = (SELECT LocationID FROM dbo.Locations WHERE (Longitude = @Longitude AND Latitude = @Latitude AND FreeFormatAddress = @FreeFormatAddress))
			IF(@locID IS NOT NULL)
			BEGIN
				SET @LocationID = @locID
				SET @responseMessage = 'LOCATION ALREADY EXIST'
				SELECT @return_Hex_value = 'EF'
				RETURN -1
			END
			ELSE
				BEGIN
				SELECT @LocationStatus = '00'
				INSERT INTO dbo.Locations
				(
					FreeFormatAddress,
					City,
					Longitude,
					Latitude,
					Street,
					Apartement,
					PostalCode,
					FloorLevel,
					HouseNumber,
					LocationStatus
				)
				VALUES
				(   @FreeFormatAddress,  -- FreeFormatAddress - nvarchar(256)
					@City,  -- City - nvarchar(32)
					@Longitude, -- Longitude - decimal(9, 6)
					@Latitude, -- Latitude - decimal(9, 6)
					@Street,  -- Street - nvarchar(32)
					@Apartement,  -- Apartement - nvarchar(32)
					@PostalCode,  -- PostalCode - nvarchar(20)
					@FloorLevel,  -- FloorLevel - nvarchar(20)
					@HouseNumber,  -- HouseNumber - nvarchar(12)
					@LocationStatus     -- LocationStatus - int
					)
				END	
		END
		ELSE 
		BEGIN
			SET @responseMessage = 'FAILED TO ADD LOCATION'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END
		SET @locID = (SELECT LocationID FROM dbo.Locations WHERE (Longitude = @Longitude AND Latitude = @Latitude AND FreeFormatAddress = @FreeFormatAddress))
		IF (@locID IS NULL)
		BEGIN
			SET @responseMessage = 'FAILED TO FIND LOCATION'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END 
		ELSE
		BEGIN
			SET @responseMessage = 'LOCATION ADDED SUCCESFULLY'
			SELECT @return_Hex_value = '00'
			SET @LocationID = @locID
			PRINT @locID
			RETURN 1
		END
	END
	GO
	--EXEC usp_InsertNewLocation  @FreeFormatAddress='FGDG', @City=NULL,
	--@Longitude='45.3313',
	--@Latitude='32.341231',
	--@Street=NULL,
	--@Apartement=NULL,
	--@PostalCode=NULL,
	--@FloorLevel=NULL,
	--@HouseNumber=NULL
	GO 
	CREATE OR ALTER PROC usp_location_getByID
	@LocID INT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	AS
	BEGIN
		IF(@LocID IS NOT NULL)
		BEGIN
			SELECT * FROM  dbo.Locations WHERE (LocationID=@LocID)
			SET @responseMessage = 'Found The Location'
		END
		ELSE
		BEGIN
			SET @responseMessage = 'Location Not Found'
		END
	END
	GO 
	CREATE OR ALTER PROC usp_location_getAll
	as
	select * from dbo.Locations
	GO
	--EXEC usp_location_getAll
	
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
CREATE OR ALTER PROC usp_Incident_InsertCallData
@ISQN INT,
@FName NVARCHAR(64),
@LName NVARCHAR(64),
@MobileNumber NVARCHAR(64),
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
if not exists(Select * from IncidentCallers where CallerMobile = @MobileNumber)
BEGIN
INSERT INTO  IncidentCallers(
	IncidentSQN ,
	CallerFName ,
	CallerLName ,
	CallerMobile
	)
VALUES
(
	@ISQN,
	ISNULL(@FName,'UnKnown'),
	ISNULL(@LName,'UnKnown'),
	@MobileNumber	
)
SET @HexCode = '00'
END
ELSE
BEGIN
SET @HexCode = '01' --Number is already in database.
END
END

GO 
CREATE OR ALTER PROC usp_Incident_getCallers
@iSQN INTEGER
AS
BEGIN
SELECT CallerFName, CallerLName, CallerMobile, CallTime FROM IncidentCallers
WHERE IncidentSQN = @iSQN
END

GO
CREATE OR ALTER  proc usp_IncidentType_GetAll
as
	select * from IncidentTypes
GO
GO
CREATE OR ALTER proc usp_IncidentPriority_GetAll
as
	select * from Priorities
GO

CREATE OR ALTER PROC usp_Incident_Insert
	@IncidentType INT,--1
	@IncidentPriority INT,--2
	@IncidentLocationID INT,--3
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--4
	@responseMessage NVARCHAR(128)='' OUTPUT,--5
	@IncidentSequenceNumber INT= 0 OUTPUT--6
	AS
	BEGIN 
	SET NOCOUNT ON
	DECLARE @ISN INT
	IF(@IncidentType IS NOT NULL OR  @IncidentPriority IS NOT NULL OR  @IncidentLocationID IS NOT NULL)
		BEGIN
			SET @ISN = (SELECT IncidentSequenceNumber FROM dbo.Incident WHERE (IncidentLocationID=@IncidentLocationID AND IncidentPriority=@IncidentPriority AND IncidentType=@IncidentType))
			IF(@ISN IS NOT NULL)
			BEGIN
				SET @responseMessage = 'INCIDENT ALREADY EXIST'
				SELECT @return_Hex_value = 'FF'
				SET @IncidentSequenceNumber = @ISN
				UPDATE dbo.Incident 
				SET CreationTime = GETDATE()
				WHERE (IncidentLocationID=@IncidentLocationID AND IncidentPriority=@IncidentPriority AND IncidentType=@IncidentType)
				RETURN -1
			END
			ELSE
			BEGIN
				INSERT INTO dbo.Incident
				(
				    IncidentType,
				    IncidentPriority,
				    IncidentLocationID
				)
				VALUES
				( 
				    @IncidentType,         -- IncidentType - int
				    @IncidentPriority,         -- IncidentPriority - int
				    @IncidentLocationID         -- IncidentLocationID - int
				)
				SET @IncidentSequenceNumber = (SELECT IncidentSequenceNumber FROM dbo.Incident WHERE (IncidentLocationID=@IncidentLocationID AND IncidentPriority=@IncidentPriority AND IncidentType=@IncidentType))
				IF(@IncidentSequenceNumber IS NULL)
				BEGIN
					SET @responseMessage = 'FAILED TO FIND INCIDENT'
					SELECT @return_Hex_value = 'FF'
					RETURN -1
				END
				ELSE
				BEGIN
					SET @responseMessage = 'IINCIDENT ADDED SUCCESFULLY'
					SELECT @return_Hex_value = '00'
					PRINT @IncidentSequenceNumber
					RETURN 1
				END
			END
		END
		ELSE
		BEGIN 
			SET @responseMessage = 'MISSING INFORMATION'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END
	END


GO	
CREATE OR ALTER PROC [dbo].[spIncidentTypes_AddRow]
		@TypeName nvarchar(32),
		@TypeNote nvarchar(256),
		@IncidentTypeID int OUTPUT
As
Begin
	insert into dbo.IncidentTypes (TypeName, TypeNote)
	Values (@TypeName, @TypeNote)

	SET @IncidentTypeID = (SELECT IncidentTypeID
						   From IncidentTypes
						   where TypeName = @TypeName)
End	


GO
CREATE OR ALTER PROC [dbo].[spIncidentTypes_DeleteByTypeName]
		@TypeName nvarchar(32)
As
Begin
	delete from dbo.IncidentTypes
	where TypeName = @TypeName
End
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
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
SELECT LogInTime,LogOutTime,DATEDIFF(MINUTE,LogInTime,ISNULL(LogOutTime,LogInTime)) AS WorkMins FROM dbo.EmployeeLogs
WHERE EmployeeID = @EID
END
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO

CREATE OR ALTER PROC usp_BatchMedicine_Insert
@BatchID BIGINT,
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity INTEGER,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @MedicineBarcode) - @MedicineQuantity

if(@QuantityDifference >= 0)
begin

if not exists(select * from dbo.Batch  where dbo.Batch.BatchID=@BatchID)
begin
insert into dbo.Batch(BatchID)
VALUES(@BatchID)
end

INSERT INTO dbo.BatchMedicine
(
    BatchID,
    MedicineBCode,
    Quantity
)
VALUES
(   @BatchID ,
    @MedicineBarcode,
    @MedicineQuantity
)

UPDATE dbo.Medicine
SET CountInStock = @QuantityDifference WHERE BarCode = @MedicineBarcode;
-- '00' -> Addition Successful    
SET @HexCode = '00'
END
ELSE
BEGIN
-- '01' -> Addition Failed
SET @HexCode = '01'
END
END
go


CREATE OR ALTER PROC usp_Batch_UsedMedicine
@batchID BIGINT,
@sequenceNumber INTEGER,
@barCode NVARCHAR(64),
@usedAmt INTEGER,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @barcode) - @usedAmt

if(@QuantityDifference >= 0)
BEGIN
Update dbo.BatchMedicine
set Quantity = @QuantityDifference
INSERT INTO dbo.MedicineUsedMedicineUsedPerResponse
(	RespSQN ,
	BID,
	MedBCode,
	UsedAmt,
	AmbVIN
)
VALUES
(
	@sequenceNumber,
	@batchID,
	@barCode,
	@usedAmt,
	(select VIN from dbo.AmbulanceMap where BatchID = @batchID)
)
set @HexCode = '00'
END
ELSE
BEGIN
set @HexCode = '01'
END
END

GO

CREATE OR ALTER PROC usp_Batch_getMedicines
@BatchID BIGINT
AS
BEGIN
select BarCode,MedicineName,Price,dbo.BatchMedicine.Quantity,Implications,MedicineUsage,SideEffects,ActiveComponent,MedicineStatus from dbo.Medicine
inner join dbo.BatchMedicine
ON BatchMedicine.MedicineBCode = Medicine.BarCode
WHERE dbo.BatchMedicine.BatchID = @BatchID
END

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- Employee SP --
-- Login --

-- Employee SP --
-- Login --
GO
CREATE OR ALTER PROC usp_Employee_Login 
	@EmailOrPAN NVARCHAR(128),
	@HashPassword NVARCHAR(128),
	
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@jobID INTEGER = -1 OUTPUT,
	@title NVARCHAR(256) = '' OUTPUT,
	@employeeID Integer = -1 OUTPUT,
	@userPhoto NVARCHAR(MAX) = '' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT on
	DECLARE @userID INT
	DECLARE @status NVARCHAR(32)
	Declare @inStamp DATETIME

	IF (@EmailOrPAN IS NOT NULL AND @HashPassword IS NOT NULL)
	BEGIN
		IF ((SELECT(LEN(@HashPassword))) > 7 )
		BEGIN
			BEGIN TRY
				
				IF EXISTS (SELECT * FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN))
				BEGIN
					-- Found the user using email or PAN or National ID
					SET @userID = (SELECT EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))
					IF(@userID IS NULL)
					BEGIN
						-- Wrong Password
						SET @responseMessage='Incorrect password'
						SELECT @return_Hex_value = '02'
						RETURN -1;
					END
					
					ELSE
					BEGIN
						-- @userID IS NOT NULL
						-- Correct password, so check if he's already logged in
						SET @status=(SELECT LogInStatus FROM Employee WHERE EID=@userID)				
						IF(@status = '00')
						BEGIN
							-- Not logged in, so login successful, send his type to backend and jobID
							-- And set status to 1
							SET @responseMessage='User logged in successfully'
							SELECT @return_Hex_value = '00'
							SET @jobID = (SELECT JobID FROM Employee WHERE EID = @userID)
							SET @title = (SELECT Title FROM Jobs WHERE JobID = @jobID)
							SET @employeeID = @userID
							SET @userPhoto = (SELECT Photo FROM Employee WHERE EID = @userID)
							UPDATE Employee SET LogInStatus = '01' WHERE EID = @userID
							SET @inStamp = GETDATE()
							UPDATE Employee SET LogInTStamp = @inStamp WHERE EID = @userID
							INSERT INTO dbo.EmployeeLogs(
								EmployeeID,
								LogInTime
							)
							VALUES(
								@userID,
								@inStamp
							)

							RETURN 0
						END
						IF(@status = '01')
						BEGIN
							-- Already logged in, so can't continue
							SET @responseMessage='User is logged in somewhere'
							SELECT @return_Hex_value = '03'
							RETURN 3
						END
						IF(@status = '02')
						BEGIN
							-- Not verrified
							SET @responseMessage='This user is not verified'
							SELECT @return_Hex_value = '04'
							RETURN 4
						END
						ELSE
						BEGIN
							-- Unknown status
							SET @responseMessage='User status undefined'
							SELECT @return_Hex_value = 'FE'
							RETURN -1
						END
					END
				END
				ELSE
				BEGIN
				-- Didn't find the user using Email or PAN or National ID
				-- Wrong Email
					SET @responseMessage='No user found with given Email or PAN or National ID'
					SELECT @return_Hex_value = 'FF'
					RETURN -1
				
				END
			END TRY
			
			BEGIN CATCH
				SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
				RETURN -1
			END CATCH
		END
		ELSE
		BEGIN
			SELECT @return_Hex_value='FB', @responseMessage='Password length is less than 8'
			RETURN -1
		END
	END
	
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		RETURN -1
	END
END

-- Logout --
GO
CREATE OR ALTER PROC usp_Employee_Logout
	-- @userID INT,
	@dummyToken NVARCHAR(128),
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @status NVARCHAR(32)
	Declare @outStamp DATETIME
	-- IF (@userID IS NOT NULL)
	IF (@dummyToken IS NOT NULL)
	BEGIN
		BEGIN TRY
			-- IF EXISTS (SELECT * FROM Employee WHERE EID=@userID)
			IF EXISTS (SELECT * FROM Employee WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
			BEGIN
				-- Found the user using userID
				-- SET @status=(SELECT LogInStatus FROM Employee WHERE EID=@userID)
				SET @status=(SELECT LogInStatus FROM Employee WHERE Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
				IF(@status='01')
				BEGIN
					-- Right Status
					-- UPDATE Employee SET LogInStatus = '00' WHERE EID = @userID
					-- UPDATE Employee SET LogOutStamp = GETDATE() WHERE EID = @userID
					UPDATE dbo.Employee SET LogInStatus = '00' WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
					SET @outStamp = GETDATE()
					UPDATE dbo.Employee SET LogOutStamp = @outStamp WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
					SET @responseMessage='Logged out successfully'
					SELECT @return_Hex_value = '00'
					UPDATE EmployeeLogs
					SET LogOutTime = @outStamp
					WHERE EmployeeID = (SELECT EID FROM Employee WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
					AND LogInTime= (SELECT LogInTStamp FROM Employee where (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
					RETURN 0
				END
				ELSE IF(@status='00')
				BEGIN
					-- User already logged out
					SET @responseMessage='Wrong user status; User is already logged out'
					SELECT @return_Hex_value = '01'
					RETURN 1
				END
				ELSE IF(@status='02')
				BEGIN
					-- User awaiting verification
					SET @responseMessage='Wrong user status; User is awaiting verification'
					SELECT @return_Hex_value = '02'
					RETURN 2
				END
				ELSE
				BEGIN
					-- Unknown status
					SET @responseMessage='Unknown user status'
					SELECT @return_Hex_value = 'FE'
					RETURN -1
				END
			END
			ELSE
			BEGIN
				-- Didn't find the user using @userID
				-- SET @responseMessage='No user found with given ID'
				SET @responseMessage='No user found with given email or pan or national id'
				SELECT @return_Hex_value = 'FF'
				RETURN -1
			END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			RETURN -1
		END CATCH
	END
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: User ID is NULL'
		RETURN -1
	END
END

-- SignUp --
GO
CREATE OR ALTER PROC usp_Employee_Signup
	@firstName NVARCHAR(32),
	@lastName NVARCHAR(32),
	@dateOfBirth DATE,
	@email NVARCHAR(128),
	@password NVARCHAR(128),
	@gender NVARCHAR(1),
	@contactNumber NVARCHAR(64),
	@country NVARCHAR(32),
	@city NVARCHAR(32),
	@state NVARCHAR(32),
	@street NVARCHAR(64),
	@postalCode VARCHAR(20),
	@pan NVARCHAR(20) = NULL,
	@nationalID NVARCHAR(14) = NULL,
	@jobID INT,
	@photo NVARCHAR(MAX) = NULL,
	
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @userID INT
	DECLARE @status NVARCHAR(32)
	IF (@email IS NOT NULL AND @password IS NOT NULL)
	BEGIN
		-- Check email is not already used
		BEGIN TRY
			IF (@pan IS NOT NULL)
			BEGIN
				IF ( (SELECT(LEN(@pan))) < 16 OR  (SELECT(LEN(@pan))) > 20)
				BEGIN
					SET @responseMessage='PAN length is not between 16 and 20 numbers'
					SELECT @return_Hex_value = 'F8'
					RETURN -1
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT * FROM Employee WHERE PAN=@pan)
					BEGIN
						-- Found a user using this PAN
						SET @responseMessage='A registered user is using this PAN'
						SELECT @return_Hex_value = 'F9'
						RETURN -1
					END
				END
			END
			
			IF (@nationalID IS NOT NULL)
			BEGIN
				IF ( (SELECT(LEN(@nationalID))) <> 14)
				BEGIN
					SET @responseMessage='National ID length is not 14 numbers'
					SELECT @return_Hex_value = 'FA'
					RETURN -1
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT * FROM Employee WHERE NationalID=@nationalID)
					BEGIN
						-- Found a user using this National ID
						SET @responseMessage='A registered user is using this National ID'
						SELECT @return_Hex_value = 'FB'
						RETURN -1
					END
				END
			END
			
			IF EXISTS (SELECT * FROM Employee WHERE Email=@email)
			BEGIN
				-- Found a user using this Email
				-- ERROR: Already signed up
				SET @responseMessage='User already registered with this email. Try signing in'
				SELECT @return_Hex_value = 'FF'
				RETURN -1
			END
			ELSE
			BEGIN
				-- Email was not used before
				-- Insert into DB
				INSERT INTO Employee (Fname,Lname,BDate,Email,HashPassword,Gender,ContactNumber,Country,City,AddressState,AddressStreet,AddressPcode,PAN,NationalID,JobID,Photo)
				values (@firstName,@lastName,@dateOfBirth,@email,@password,@gender,@contactNumber,@country,@city,@state,@street,@postalCode,@pan,@nationalID,@jobID,@photo)
				SET @responseMessage='Signed Up. Check Email for Verification'
				SELECT @return_Hex_value = '00'
				RETURN 0
			END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			RETURN -1
		END CATCH
	END
	ELSE
	BEGIN
		-- Email or Password is NULL
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		RETURN -1
	END
END


--GO
--DECLARE @return_Hex_value NVARCHAR(2),
--        @responseMessage NVARCHAR(128),
--        @jobID NVARCHAR(64),
--        @employeeID NVARCHAR(64);
--EXEC dbo.usp_Employee_Login @EmailOrPAN = N'07810798770078',                            -- nvarchar(128)
--                            @HashPassword = N'Z8Y8IXV7AO8CAI77J1U380ITRONV2SY21MEJW9VFZN0U1I2I',                          -- nvarchar(128)
--                            @return_Hex_value = @return_Hex_value OUTPUT, -- nvarchar(2)
--                            @responseMessage = @responseMessage OUTPUT,   -- nvarchar(128)
--                            @jobID = @jobID OUTPUT,                       -- nvarchar(64)
--                            @employeeID = @employeeID OUTPUT              -- nvarchar(64)
--							PRINT @responseMessage
--							PRINT @return_Hex_value
--							PRINT @jobID
--							PRINT @employeeID

--GO
--DECLARE @return_Hex_value NVARCHAR(2),
--        @responseMessage NVARCHAR(128);
--EXEC dbo.usp_Employee_Logout @dummyToken = N'91008004917121647682',                            -- nvarchar(128)
--                             @return_Hex_value = @return_Hex_value OUTPUT, -- nvarchar(2)
--                             @responseMessage = @responseMessage OUTPUT    -- nvarchar(128)
--							 PRINT @responseMessage
--							 PRINT @return_Hex_value
-- END of Employee SP --

--GO
--DECLARE @return_Hex_value NVARCHAR(2),
--        @responseMessage NVARCHAR(128),
--        @JobID NVARCHAR(64),
--        @employeeID NVARCHAR(64);
--EXEC dbo.usp_Employee_Login @EmailOrPAN = N'07810798770078',                            -- nvarchar(128)
--                            @HashPassword = N'Z8Y8IXV7AO8CAI77J1U380ITRONV2SY21MEJW9VFZN0U1I2I',                          -- nvarchar(128)
--                            @return_Hex_value = @return_Hex_value OUTPUT, -- nvarchar(2)
--                            @responseMessage = @responseMessage OUTPUT,   -- nvarchar(128)
--                            @JobID = @JobID OUTPUT,                       -- nvarchar(64)
--                            @employeeID = @employeeID OUTPUT              -- nvarchar(64)
--							PRINT @responseMessage
--							PRINT @return_Hex_value
--							PRINT @JobID
--							PRINT @employeeID

--GO
--DECLARE @return_Hex_value NVARCHAR(2),
--        @responseMessage NVARCHAR(128);
--EXEC dbo.usp_Employee_Logout @dummyToken = N'91008004917121647682',                            -- nvarchar(128)
--                             @return_Hex_value = @return_Hex_value OUTPUT, -- nvarchar(2)
--                             @responseMessage = @responseMessage OUTPUT    -- nvarchar(128)
--							 PRINT @responseMessage
--							 PRINT @return_Hex_value
-- END of Employee SP --
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

--TODO: Add the PatientID select query to set values.
GO
CREATE OR ALTER PROC usp_getAndroidIncident
@VIN INT,

@startLocID INT,
@destLocID INT,
@alarmLevelID INT,
@iSQN INT,

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
@alarmLevelNote NVARCHAR(64) OUTPUT,

@batchID BIGINT OUTPUT,

@patientID INT = -1 OUTPUT,

@callerFName NVARCHAR(64) OUTPUT,
@callerLName NVARCHAR(64) OUTPUT,
@callerMobileNumber NVARCHAR(11) OUTPUT 

AS
BEGIN

SELECT @driverFName = Fname,
       @driverLName=Lname
       FROM dbo.Employee 
          INNER  JOIN dbo.AmbulanceMap ON AmbulanceMap.DriverID = Employee.EID 
          WHERE VIN = @VIN AND StatusMap = '00'

SELECT @paramedicFName = Fname,
       @paramedicLName = Lname
          FROM dbo.Employee
       INNER  JOIN dbo.AmbulanceMap ON AmbulanceMap.ParamedicID = Employee.EID 
          WHERE VIN = @VIN AND StatusMap = '00'

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
WHERE  IncidentSequenceNumber = @iSQN

SELECT @alarmLevelName = AlarmLevelName,
       @alarmLevelNote = AlarmLevelNote 
       FROM  dbo.AlarmLevels WHERE AlarmLevelID = @alarmLevelID

SELECT @BatchID = BatchID FROM dbo.AmbulanceMap WHERE dbo.AmbulanceMap.VIN = @VIN AND StatusMap = '00'

SELECT @callerFName = CallerFName,@callerLName = CallerFName, @callerMobileNumber = CallerMobile
FROM dbo.IncidentCallers WHERE IncidentSQN = @iSQN

END

GO

CREATE OR ALTER PROC usp_IncidentResponse_GetYelloPad
@VIN INTEGER,
@UniqueID NVARCHAR(64) OUTPUT
AS
BEGIN
SELECT @UniqueID = YelloPadUniqueID FROM dbo.Yellopad
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.YelloPadID = Yellopad.YelloPadID
WHERE dbo.AmbulanceMap.VIN = @VIN AND dbo.AmbulanceMap.StatusMap = '00'
END
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
Create OR ALTER proc usp_AmbulanceVehicle_SelectAll 
as
	select * from AmbulanceVehicle
	WHERE VehicleStatus <>'FF'
-- (2.1) Get Patient By ID --
GO
Create OR ALTER proc usp_AmbulanceVehicle_SelectByVIN
  @VIN INT,
   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@VIN IS NOT NULL)
	BEGIN
		select * from AmbulanceVehicle
		where VIN = @VIN
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
Create OR ALTER proc usp_AmbulanceVehicle_SelectByBrand
  @Brand  NVARCHAR(32),
   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@Brand IS NOT NULL)
	BEGIN
		select * from AmbulanceVehicle
		where Brand = @Brand
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1
		 
	
GO

Create OR ALTER proc usp_AmbulanceVehicle_SelectBySts
  @VehicleStatus  NVARCHAR(32),
   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@VehicleStatus IS NOT NULL)
	BEGIN
		select * from AmbulanceVehicle
		where VehicleStatus = @VehicleStatus
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
		 
-- (3) Insert Ambulance Vehicle --
GO
Create OR ALTER PROC usp_AmbulanceVehicle_Insert 
	
	@VIN INT,
	@Implication NVARCHAR(32),
	@Make NVARCHAR(32) ,
	@Type NVARCHAR(32) ,
	@ProductionYear NVARCHAR(32) ,
	@RegYear NVARCHAR(32),
	@LicencePlate NVARCHAR(32),
	@OwnerName NVARCHAR(128),
	@LicenceStateOrProvince NVARCHAR(32),
    @ServiceStartDate NVARCHAR(32),
    @EngineNumber NVARCHAR(32),
    @Brand NVARCHAR(32),
    @ChasiahNumber NVARCHAR(32),
    @Model NVARCHAR(32),
    @DriverPhoneNumber NVARCHAR(32),
	@AssignedYPID NVARCHAR(16),
    @AmbulanceVehiclePicture NVARCHAR(500),

   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	
		as 
	BEGIN TRY
	
	IF (@VIN IS NOT NULL )
		BEGIN
			INSERT INTO AmbulanceVehicle (VIN,Implication,Make,[Type],ProductionYear,RegYear,LicencePlate,OwnerName,
			LicenceStateOrProvince,ServiceStartDate,EngineNumber,Brand,ChasiahNumber,Model,DriverPhoneNumber,	AmbulanceVehiclePicture)
			values (@VIN,@Implication,@Make,@Type,@ProductionYear,@RegYear,@LicencePlate,@OwnerName,@LicenceStateOrProvince,
			@ServiceStartDate,@EngineNumber,@Brand,@ChasiahNumber,@Model,@DriverPhoneNumber ,@AmbulanceVehiclePicture )
	         SELECT @responseCode = '00'
			SELECT @responseMessage = 'Success'
		END
	
	
	ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'wrong Parameters'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

-- (4) Update AmbulanceVehicle --
GO
Create OR ALTER PROC usp_AmbulanceVehicle_Update
	@VIN INT,
	@Implication NVARCHAR(32),
	@Make NVARCHAR(32) ,
	@Type NVARCHAR(32) ,
	@ProductionYear NVARCHAR(32) ,
	@RegYear NVARCHAR(32),
	@LicencePlate NVARCHAR(32),
	@OwnerName NVARCHAR(128),
	@LicenceStateOrProvince NVARCHAR(32),
    @ServiceStartDate NVARCHAR(32),
    @EngineNumber NVARCHAR(32),
    @Brand NVARCHAR(32),
    @ChasiahNumber NVARCHAR(32),
    @Model NVARCHAR(32),
    @DriverPhoneNumber NVARCHAR(32),
    @AmbulanceVehiclePicture NVARCHAR(500),
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as   

	BEgin Try	
	IF (@VIN IS NOT NULL)
		BEGIN
			UPDATE AmbulanceVehicle
			SET Implication = ISNULL(@Implication,Implication),
			Make = ISNULL(@Make,Make),
			[Type] = ISNULL(@Type,[Type]),
			ProductionYear = ISNULL(@ProductionYear,ProductionYear),
			RegYear = ISNULL(@RegYear,RegYear),
			LicencePlate = ISNULL(@LicencePlate,LicencePlate),
			OwnerName = ISNULL(@OwnerName,OwnerName),
			LicenceStateOrProvince = ISNULL(@LicenceStateOrProvince,LicenceStateOrProvince),
			ServiceStartDate = ISNULL(@ServiceStartDate,ServiceStartDate),
			EngineNumber = ISNULL(@EngineNumber,EngineNumber),
			Brand = ISNULL(@Brand,Brand),
			ChasiahNumber = ISNULL(@ChasiahNumber,ChasiahNumber),
			Model = ISNULL(@Model,Model),
			DriverPhoneNumber = ISNULL(@DriverPhoneNumber,DriverPhoneNumber),
				AmbulanceVehiclePicture=ISNULL(	@AmbulanceVehiclePicture,	AmbulanceVehiclePicture),
			VehicleStatus = 2 
			WHERE VIN = @VIN
			
        SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
		END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
			END TRY
			BEGIN CATCH
				SELECT @responseCode = 'FF',
			       @responseMessage=ERROR_MESSAGE()
			return -1;
			END CATCH
				return -1

-- (5) Delete Patient By VIN --
GO
Create OR ALTER proc usp_AmbulanceVehicle_Delete 
 @VIN INT,
 @responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@VIN IS NOT NULL)
	BEGIN
		UPDATE AmbulanceVehicle
		SET VehicleStatus = 'FF'
		where VIN = @VIN
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
		
	END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			       @responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1	

		
 	
GO
CREATE  OR alter proc usp_AmbulanceVehicle_UpdateStatus
@AmbulanceVehicleStatus NVARCHAR(2),
@Vin INT,
@responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY
if (@Vin IS NOT NULL AND @AmbulanceVehicleStatus  IS NOT NULL )
	BEGIN
	UPDATE AmbulanceVehicle
	SET VehicleStatus = ISNULL (@AmbulanceVehicleStatus,VehicleStatus)
	where Vin=@Vin
	SELECT @responseCode = '00'
	SELECT @responseMessage = 'Success'
	
	END
	ELSE
	BEGIN 

				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
				 RETURN -1
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
	           	@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1
		
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
CREATE OR ALTER proc usp_AlarmLevel_GetAll
as
	select * from AlarmLevels
GO


-- EXAMPLE OF RUNNING A STORED PROCEDURE
--EXEC usp_AlarmLevel_GetAll
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
--TODO: COnfirm that all checks are passed from front end.
CREATE OR ALTER PROC usp_AmbulanceMap_Insert
@VIN INT,
@ParamedicID INT,
@DriverID INT,
@YelloPadID INT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
if exists(select * from dbo.AmbulanceMap where VIN = @VIN and StatusMap = '00')
BEGIN
-- 1 -> Ambulance was already inserted but not assigned.
Set @HexCode = '01'
RETURN 1
END
ELSE if exists(select * from dbo.AmbulanceMap where VIN = @VIN and StatusMap ='01')
begin
-- 2 -> Ambulance is assigned and already in service.
Set @HexCode = '02'
 RETURN 2
end 
else begin
insert into dbo.AmbulanceMap(VIN,ParamedicID,DriverID,YelloPadID)
VALUES(
@VIN,
@ParamedicID,
@DriverID,
@YelloPadID
)

UPDATE dbo.Yellopad
SET YelloPadStatus = '01'
WHERE YelloPadID = @YelloPadID

UPDATE dbo.Employee
SET EmployeeStatus = '05'
WHERE EID = @ParamedicID

UPDATE dbo.Employee
SET EmployeeStatus = '05'
WHERE EID = @DriverID

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '05'
WHERE VIN = @VIN

-- 0 -> Insertion Successful
Set @HexCode = '00'
RETURN 0
end
END
GO

CREATE OR ALTER PROC usp_AmbulanceMap_Insert_Batch
@VIN INT,
@batchID BIGINT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
if exists(select * from dbo.AmbulanceMap where  VIN = @VIN and StatusMap = '00')
begin
UPDATE dbo.AmbulanceMap
SET BatchID = @batchID
where VIN = @VIN and StatusMap = '00'
-- '00' -> updated succesfully
SET @HexCode = '00'
end
else
BEGIN
-- '01' -> Failure to add because a vehicle with these conditions doesn't exist
SET @HexCode = '01'
END
END

GO

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

CREATE OR ALTER PROC usp_getAmbulanceCarMapByCarID
@CarID INT
AS
BEGIN
SELECT * FROM dbo.AmbulanceMap WHERE VIN = @CarID
END
GO

CREATE OR ALTER PROC usp_getAmbulanceCarMapByDriverID
@DriverID INT
AS
BEGIN
SELECT * FROM dbo.AmbulanceMap WHERE DriverID = @DriverID
END
GO

CREATE OR ALTER PROC usp_getAmbulanceCarMapByParamedicID
@ParamedicID INT
AS
BEGIN
SELECT * FROM dbo.AmbulanceMap WHERE ParamedicID = @ParamedicID
END
GO

CREATE OR ALTER PROC usp_getAmbulanceCarMapByYelloPadID
@YelloPadID INT
AS
BEGIN
SELECT * FROM dbo.AmbulanceMap WHERE YelloPadID = @YelloPadID
END
GO


CREATE OR ALTER  Proc usp_deleteAmbulanceMap
@VIN INT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

if exists (select * from AmbulanceMap where VIN = @VIN AND (StatusMap='00' OR StatusMap='02'))
BEGIN
update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='00'

update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='02'

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '00'
WHERE VIN = @VIN

SET @HexCode = '00'
END
ELSE
BEGIN
SET @HexCode = '01'
END
END
GO


CREATE OR ALTER PROC usp_AmbulanceMap_getRelevantData
@VIN INTEGER,
@License NVARCHAR(64) OUTPUT,
@Make NVARCHAR(64) OUTPUT,
@ParamedicFName NVARCHAR(64) OUTPUT,
@ParamedicLName NVARCHAR(64) OUTPUT,
@ParamedicID Integer OUTPUT,
@DriverFName NVARCHAR(64) OUTPUT,
@DriverLName NVARCHAR(64) OUTPUT,
@DriverID Integer OUTPUT,
@YelloPadUniqueID NVARCHAR(64) OUTPUT
			
AS
BEGIN
select @License = LicencePlate, @Make= Make from dbo.AmbulanceVehicle 
inner join dbo.AmbulanceMap ON AmbulanceMap.VIN = AmbulanceVehicle.VIN
where dbo.AmbulanceVehicle.VIN = @VIN

SELECT @ParamedicFName = Fname, @ParamedicLName = Lname,@ParamedicID = EID FROM dbo.Employee
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.ParamedicID = Employee.EID
WHERE dbo.AmbulanceMap.VIN = @VIN

SELECT @DriverFName = Fname, @DriverLName = Lname,@DriverID = EID FROM dbo.Employee
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.DriverID = Employee.EID
WHERE dbo.AmbulanceMap.VIN = @VIN

SELECT @YelloPadUniqueID= YelloPadUniqueID FROM dbo.Yellopad
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.YelloPadID = Yellopad.YelloPadID
WHERE dbo.AmbulanceMap.VIN = @VIN
END
go
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- Medicine Stored Procedures --
-- (1) Get All Medicines --
GO
Create  OR ALTER PROC usp_Medicines_SelectAll 
as
	select * from Medicine
	WHERE  MedicineStatus <>'FF'
	OR CountInStock <> 0
-- (2.1) Get Medicine By Name --
GO
create  OR ALTER PROC usp_Medicine_SelectByName  @MedName NVARCHAR(64)
as
	IF (@MedName IS NOT NULL)
	BEGIN
		select * from Medicine
		where MedicineName = @MedName
	END
	ELSE
		RETURN -1
-- (2.2) Get Medicine By Bar Code --
GO
create  OR ALTER PROC usp_Medicine_SelectByBCode  @bCode NVARCHAR(64)
as
	IF (@bCode IS NOT NULL)
		BEGIN
			select * from Medicine
			where BarCode = @bCode
		END
	ELSE
		RETURN -1
-- (2.3) Get Medicine By Status --
GO
create  OR ALTER PROC usp_Medicine_SelectBySts @MStatus NVARCHAR(32)
as
	select * from Medicine
	where MedicineStatus = @MStatus
-- (3) Insert Medicine --
GO
CREATE  OR ALTER PROC usp_Medicine_Insert 
	@BarCode NVARCHAR(64),
	@Name NVARCHAR(64),
    @CountInStock NVARCHAR(64) = NULL,
    @Price NVARCHAR(32) = NULL,
    @Implications NVARCHAR(MAX) = NULL,
    @MedicineUsage NVARCHAR(MAX) = NULL,
    @SideEffects NVARCHAR(MAX) = NULL,
    @ActiveComponent NVARCHAR(MAX) = NULL,
	 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY

	IF (@BarCode IS NOT NULL AND @Name IS NOT NULL)
 BEGIN
	 IF Exists (Select * from Medicine where BarCode=@BarCode ) 
	       BEGIN      
				SELECT @responseCode = '01';
				SELECT @responseMessage = 'Allready exists';
				RETURN -1;
           END
     ELSE
          BEGIN
		        INSERT INTO Medicine (BarCode,CountInStock,MedicineName,Price,Implications,MedicineUsage,SideEffects,ActiveComponent)
			    VALUES (@BarCode,@CountInStock,@Name,@Price,@Implications,@MedicineUsage,@SideEffects,@ActiveComponent)
		        SELECT @responseCode = '00'
		        SELECT @responseMessage = 'Success'
	      END
	
	END
ELSE
       BEGIN      
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'BarCode IS  NULL or Name IS NULL'
				RETURN -1
           END

	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		    @responseMessage=ERROR_MESSAGE()
			 RETURN -1;
	END CATCH
			 return -1;
-- (4) Update Medicine --
GO
CREATE  OR ALTER PROC usp_Medicine_Update
	@BarCode NVARCHAR(64),
	@Name NVARCHAR(64) = NULL,
    @CountInStock NVARCHAR(64) = NULL,
    @Price NVARCHAR(32)  = NULL,
    @Implications NVARCHAR(MAX) = NULL,
    @MedicineUsage NVARCHAR(MAX) = NULL,
    @SideEffects NVARCHAR(MAX) = NULL,
    @ActiveComponent NVARCHAR(MAX) = NULL,
     @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY	 
IF (@BarCode IS NOT NULL)
		BEGIN
			UPDATE Medicine
			SET CountInStock = ISNULL(@CountInStock,CountInStock),
			MedicineName = ISNULL(@Name,MedicineName),
			Price = ISNULL(@Price,Price),
			Implications = ISNULL(@Implications,Implications),
			MedicineUsage = ISNULL(@MedicineUsage,MedicineUsage),
			SideEffects = ISNULL(@SideEffects,SideEffects),
			ActiveComponent = ISNULL(@ActiveComponent,ActiveComponent),
			MedicineStatus = 2
			WHERE BarCode = @BarCode
		SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
-- (5) Delete Medicine By Barcode --
GO
create  OR ALTER PROC usp_Medicine_Delete  
	@BarCode NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY	 
IF (@BarCode IS NOT NULL)
		BEGIN
			UPDATE Medicine
			SET  MedicineStatus = 'FF'
			WHERE BarCode = @BarCode
		SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
     	        RETURN -1

	END
	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		     @responseMessage=ERROR_MESSAGE()
			 RETURN -1;
	END CATCH
		 RETURN -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- PharmaCompany Stored Procedures --
-- (1) Get All Companies --
GO
Create  OR ALTER PROC usp_PharmaCompany_SelectAll
as
	select * from PharmaCompany
-- (2.1) Get Company By Name --
GO
CREATE  OR ALTER proc usp_PharmaCompany_Select  @compName NVARCHAR(64)
as
	IF (@compName IS NOT NULL)
	BEGIN
		select * from PharmaCompany
		where CompanyName = @compName
		return 0
	END
	ELSE 
		RETURN -1
-- (2.2) Get Company By ID --
GO
create  OR ALTER PROC usp_PharmaCompany_SelectByID @CompID INT
as
	select * from PharmaCompany
	where CompanyID = @CompID
-- (2.3) Get Company By Status --
GO
create  OR ALTER proc usp_PharmaCompany_SelectBySts @CompStatus NVARCHAR(64)
as
	select * from PharmaCompany
	where CompanyStatus = @CompStatus
-- (3) Insert Company --
GO
CREATE  OR ALTER PROC usp_PharmaCompany_Insert 
	@CompanyName NVARCHAR(64),
    @ContactPerson NVARCHAR(32) = NULL,
    @CompanyAddress NVARCHAR(128) = NULL,
    @CompanyPhone NVARCHAR(32) = NULL,
	@HexCode NVARCHAR(2) OUTPUT
as
	IF (@CompanyName IS NOT NULL)
		BEGIN
			if not exists (select top 1 * from PharmaCompany where PharmaCompany.CompanyName = @CompanyName)
			begin
			INSERT INTO PharmaCompany (CompanyName,ContactPerson,CompanyAddress,CompanyPhone)
			values (@CompanyName,@ContactPerson,@CompanyAddress,@CompanyPhone)
			--Insertion Succesful.
			set @HexCode = '00'
			RETURN '00'
			END
			else
			BEGIN
			--Pharma Company Already Exists
			set @HexCode = '01'
			if((select CompanyStatus from PharmaCompany where CompanyName=@CompanyName)=99)
			begin
			update PharmaCompany
			set CompanyStatus = 2,
			CompanyName = ISNULL(@CompanyName,CompanyName), 
			ContactPerson = ISNULL(@ContactPerson,ContactPerson),
			CompanyAddress = ISNULL(@CompanyAddress,CompanyAddress),
			CompanyPhone = ISNULL(@CompanyPhone,CompanyPhone)
			where CompanyName = @CompanyName
			RETURN '01'
			END
		end
	END
	ELSE
	BEGIN
		--Insertion Failed because Company name is Null.
		set @HexCode = '02'
		return '02'
		END
-- (4) Update Company By ID --
GO
CREATE  OR ALTER PROC usp_PharmaCompany_Update 
	@CompID INT,
	@CompanyName NVARCHAR(64) = NULL,
    @ContactPerson NVARCHAR(32) = NULL,
    @CompanyAddress NVARCHAR(128) = NULL,
    @CompanyPhone NVARCHAR(32) = NULL,
	@HexCode NVARCHAR(2) OUTPUT
as
	IF (@CompID IS NOT NULL)
		BEGIN
			UPDATE PharmaCompany
			SET CompanyName = ISNULL(@CompanyName,CompanyName), 
			ContactPerson = ISNULL(@ContactPerson,ContactPerson),
			CompanyAddress = ISNULL(@CompanyAddress,CompanyAddress),
			CompanyPhone = ISNULL(@CompanyPhone,CompanyPhone),
			CompanyStatus = 2
			WHERE CompanyID = @CompID
			--Data Updated Succesfully
		set @HexCode = '00'		
		END
	ELSE
	begin
		--Error in updating, Company ID doesn't exist
		set @HexCode = '01'
		
	END
-- (5) Delete Company By ID --
GO
create  OR ALTER PROC usp_PharmaCompany_Delete  @CompID INT,
@HexCode NVARCHAR(2) OUTPUT
as
begin
	IF (@CompID IS NOT NULL)
	BEGIN
		UPDATE PharmaCompany
		SET CompanyStatus = 99
		where CompanyID = @CompID
		--Deleteion Succesful
		set @HexCode = '00'
	END
	ELSE
	--Deletion Failed
	set @HexCode = '01'
END	
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- Company - Medicine Relation SP --

--(1) Insert a medicine to a company --
GO
CREATE  OR ALTER PROC usp_CompanyMedicineMap_Insert 
@CompID INT, 
 @MedBCode NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

AS

	BEGIN TRY
    IF (@CompID IS NOT NULL AND @MedBCode IS NOT NULL)
 	 BEGIN
		INSERT INTO CompanyMedicineMap (CompID,MedBCode,MapStatus)
		VALUES (@CompID,@MedBCode,'00')
		
		 SELECT @responseCode = '00'
	     SELECT @responseMessage = 'Success'
	
	END

	ELSE
     	BEGIN 

				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
				 RETURN -1
	    END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
	           	@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1
--(2) Delete a medicine from a company --
GO
CREATE  OR ALTER PROC usp_CompanyMedicineMap_DELETE
@CompID INT,
@MedBCode NVARCHAR(64),
@responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

AS

	BEGIN TRY
    IF (@CompID IS NOT NULL AND @MedBCode IS NOT NULL)
 	 BEGIN
		UPDATE  CompanyMedicineMap 
		SET MapStatus ='FF'
		WHERE CompID = @CompID  AND MedBCode = @MedBCode
		
		 SELECT @responseCode = '00'
	     SELECT @responseMessage = 'Success'
	
	END

	ELSE
     	BEGIN 

				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
				 RETURN -1
	    END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
	           	@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1


	------------------------- get specific  relation----------------------
		GO
create  OR ALTER PROC usp_CompanyMedicineMap_Select  
@CompID INT,
@MedBCode  NVARCHAR(64)
as
	 IF (@CompID IS NOT NULL AND @MedBCode IS NOT NULL)
 	 BEGIN
	
		select * from dbo.CompanyMedicineMap
		where CompID= @CompID
		AND  MedBCode=@MedBCode
		return 0
	END
	ELSE 
		RETURN -1

		GO
CREATE  OR alter proc usp_CompanyMedicineMap_UpdateStatus
@CompID INT,
@MedBCode  NVARCHAR(64),
@MapStatus NVARCHAR(2),
@responseCode NVARCHAR(2)='FF' OUTPUT,
@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY
if (@CompID IS NOT NULL AND @MedBCode  IS NOT NULL )
	BEGIN
	UPDATE dbo.CompanyMedicineMap
	SET MapStatus = ISNULL (@MapStatus,MapStatus)
	where MedBCode  = @MedBCode AND  CompID = @CompID
	SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 

				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
				 RETURN -1
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
	           	@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		
	return -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
-- Batch SP --

-- (1) Select All Batches --
GO
Create  OR ALTER PROC usp_Batch_SelectAll
as
	select * from Batch
-- (2.1) Select Batch By ID --
GO
create  OR ALTER PROC usp_Batch_Select  @BatchID INT
as
	IF (@BatchID IS NOT NULL)
	BEGIN
		select * from Batch
		where BatchID = @BatchID
		return 0
	END
	ELSE 
		RETURN -1
-- (2.2) Select Batch By Status --
GO
create  OR ALTER PROC usp_Batch_SelectBySts  @BatchSts  NVARCHAR(32)
as
	select * from Batch
	where BatchStatus = @BatchSts
-- (3) Insert Batch --
GO
CREATE  OR ALTER PROC usp_Batch_Insert 
	@BatchID INT,
	@BatchMedBCode NVARCHAR(64),
	@Quantity INT = NULL,
	@ExpiryDate DATE = NULL,
    @OrderDate DATETIME = NULL
as
	BEGIN
		INSERT INTO Batch (BatchID,ExpiryDate,OrderDate)
		VALUES (@BatchID,@ExpiryDate,ISNULL(@OrderDate,getdate()))
	END
-- (4) Update Batch --
GO
CREATE  OR ALTER PROC usp_Batch_Update 
	@BatchID INT,
	@BatchMedBCode NVARCHAR(64) = NULL,
	@Quantity  NVARCHAR(64) = NULL,
	@ExpiryDate DATE = NULL,
    @OrderDate DATETIME = NULL
as
	BEGIN
		UPDATE Batch
		SET BatchID = ISNULL (@BatchID,BatchID),
		ExpiryDate = ISNULL (@ExpiryDate,ExpiryDate),
		OrderDate = ISNULL (@OrderDate,OrderDate),
		BatchStatus = 2
		WHERE BatchID = @BatchID
	END
-- (5) Delete Batch --
GO
create  OR ALTER PROC usp_Batch_Delete  @BatchID INT
as
	IF (@BatchID IS NOT NULL)
	BEGIN
		UPDATE Batch
		SET BatchStatus = 99
		where BatchID = @BatchID
	END
	ELSE
		return -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------


GO 
CREATE OR ALTER PROC  usp_add_New_Patient
	@PatientFName VARCHAR(32),
	@PatientLName VARCHAR(32),
	@Gender NVARCHAR(1),
	@Age NVARCHAR(32),
	@Phone NVARCHAR(24),
	@LastBenifitedTime DATETIME  ,
	@FirstBenifitedTime DATETIME ,
	@NextOfKenName NVARCHAR(32),
	@NextOfKenPhone NVARCHAR(24),
	@NextOfKenAddress NVARCHAR(256),
	@PatientStatus NVARCHAR(32) ,
	@PatientNationalID NVARCHAR(14),

	@PatientID INT OUTPUT,
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
AS
	BEGIN TRY
INSERT INTO Patient ( PatientFName, PatientLName, Gender, Age, Phone, LastBenifitedTime, FirstBenifitedTime, NextOfKenName, NextOfKenPhone, NextOfKenAddress, PatientStatus, PatientNationalID)
			  VALUES  (@PatientFName,@PatientLName,@Gender,@Age,@Phone,@LastBenifitedTime,@FirstBenifitedTime,@NextOfKenName,@NextOfKenPhone,@NextOfKenAddress,@PatientStatus,@PatientNationalID)
			    SELECT @responseCode = '00'
		        SELECT @responseMessage = 'Success'
		      SET 	@PatientID = (SELECT PatientID 
				       FROM Patient		
					WHERE PatientNationalID  =@PatientNationalID
					AND  PatientFName = @PatientFName  AND  PatientLName = @PatientLName  AND Gender = @Gender AND Age =@Age  AND  Phone = @Phone 
					 AND LastBenifitedTime  = @LastBenifitedTime   AND FirstBenifitedTime  = @FirstBenifitedTime  AND  NextOfKenName = @NextOfKenName 
					AND  NextOfKenPhone = @NextOfKenPhone AND NextOfKenAddress= @NextOfKenAddress AND PatientStatus = @PatientStatus)
 
 
				END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

GO
CREATE OR ALTER PROC usp_Update_Patient
    @PatientID INT,
	@PatientFName VARCHAR(32),
	@PatientLName VARCHAR(32),
	@Gender NVARCHAR(1),
	@Age NVARCHAR(32),
	@Phone NVARCHAR(24),
	@LastBenifitedTime DATETIME  ,
	@FirstBenifitedTime DATETIME ,
	@NextOfKenName NVARCHAR(32),
	@NextOfKenPhone NVARCHAR(24),
	@NextOfKenAddress NVARCHAR(256),
	@PatientStatus NVARCHAR(32) ,
	@PatientNationalID INT,

	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
as
	BEGIN TRY
	
	IF (@PatientID IS NOT NULL)
		Begin
		UPDATE Patient
		SET PatientFName = ISNULL (@PatientFName,PatientFName),
		PatientLName = ISNULL (@PatientLName,PatientLName),
		Gender = ISNULL (@Gender,Gender),
		Age = ISNULL (@Age,Age),
		Phone = ISNULL (@Phone,Phone),
		LastBenifitedTime = ISNULL (@LastBenifitedTime,LastBenifitedTime),
		FirstBenifitedTime = ISNULL (@FirstBenifitedTime,FirstBenifitedTime),
		NextOfKenName = ISNULL (@NextOfKenName,NextOfKenName),
	    NextOfKenPhone = ISNULL (@NextOfKenPhone,NextOfKenPhone),
		NextOfKenAddress = ISNULL (@NextOfKenAddress,NextOfKenAddress),
		PatientStatus = ISNULL (@PatientStatus,PatientStatus),
		PatientNationalID = ISNULL (@PatientNationalID,PatientNationalID)		 
		WHERE PatientID = @PatientID
		   
		 SELECT @responseCode = '00'
		 SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
GO
create OR ALTER PROC usp_Delete_Patient 
 @PatientID INT,
 @responseCode NVARCHAR(2)='FF' OUTPUT,
 @responseMessage NVARCHAR(128)='' OUTPUT
as
BEGIN TRY
	IF (@PatientID IS NOT NULL)
	BEGIN
		UPDATE Patient
		SET PatientStatus = 'FF'
		where PatientID = @PatientID
		SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
		ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

			GO

CREATE OR ALTER PROC usp_Patient_getAll
AS
BEGIN
SELECT * FROM Patient


END


GO
CREATE OR ALTER PROC usp_Patient_getByNID
@NID NVARCHAR(14)
AS
BEGIN
SELECT * FROM Patient
WHERE PatientNationalID  = @NID 

END
--------------------------------------------------------------------

GO
create OR ALTER PROC usp_Delete_PatientLoc 
 @PatientID INT,
 @responseCode NVARCHAR(2)='FF' OUTPUT,
 @responseMessage NVARCHAR(128)='' OUTPUT
as
BEGIN TRY
	IF (@PatientID IS NOT NULL)
	BEGIN
		UPDATE PatientLocations
		SET StatusLocation = 'FF'
		where PatientID = @PatientID
		SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
		ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
	
	
		GO
	CREATE OR ALTER PROC usp_Patient_getByID
	@ID int
	AS
	BEGIN
	SELECT * FROM Patient
	WHERE PatientID  = @ID 

	END

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
GO
CREATE  OR ALTER PROC usp_Feedback_Insert 
	@SequenceNumber INT,
	@Rating float,
    @DriverNote NVARCHAR(500) = NULL,
    @ParamedicNote NVARCHAR(500) = NULL,
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY

	IF (@SequenceNumber IS NOT NULL AND @Rating IS NOT NULL)
 BEGIN
 
	  
          BEGIN
		        INSERT INTO Feedback
				 (SequenceNumber,Rating,DriverNote,ParamedicNote,FeedbackStatus)
			    VALUES (@SequenceNumber,@Rating,@DriverNote,@ParamedicNote,'00')
		        SELECT @responseCode = '00'
		        SELECT @responseMessage = 'Success'
	      END
	
	END
ELSE
       BEGIN      
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'SequenceNumber IS  NULL or Rating IS NULL'
			 
           END

	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		    @responseMessage=ERROR_MESSAGE()
		 
	END CATCH
			 
-- (4) Update Feedback --
GO
CREATE  OR ALTER PROC usp_Feedback_Update 
	@FeedbackID INT,
	@SequenceNumber NVARCHAR(64),
	@Rating NVARCHAR(64),
    @DriverNote NVARCHAR(64) = NULL,
    @ParamedicNote NVARCHAR(32) = NULL,

    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY	 
IF (@FeedbackID IS NOT NULL)
		BEGIN
			UPDATE Feedback
			SET SequenceNumber = ISNULL(@SequenceNumber,SequenceNumber),
			Rating = ISNULL(@Rating,Rating),
			DriverNote = ISNULL(@DriverNote,DriverNote),
			ParamedicNote = ISNULL(@ParamedicNote,ParamedicNote)
			WHERE FeedbackID = @FeedbackID
		SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
-- (5) Delete Medicine By Barcode --
GO
create  OR ALTER PROC usp_Feedback_Delete  
	@FeedbackID NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY	 
IF (@FeedbackID IS NOT NULL)
	BEGIN

		 IF Exists (Select * from Feedback where FeedbackID=@FeedbackID ) 
	       BEGIN      
				UPDATE Feedback
					SET  FeedbackStatus = 'FF'
					WHERE FeedbackID = @FeedbackID
				SELECT @responseCode = '00'
				SELECT @responseMessage = 'Success'
           END
		else 
			begin
			 SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'NO Feedback found this this ID '
			end 

			
	END
	ELSE
	BEGIN 
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
     	        RETURN -1

	END
	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		     @responseMessage=ERROR_MESSAGE()
			 RETURN -1;
	END CATCH
		 RETURN -1
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------
