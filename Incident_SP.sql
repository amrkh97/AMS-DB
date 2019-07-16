USE KAN_AMO
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
				UPDATE dbo.Incident 
				SET CreationTime = GETDATE()
				WHERE (IncidentLocationID=@IncidentLocationID AND IncidentPriority=@IncidentPriority AND IncidentType=@IncidentType)
				SET @IncidentSequenceNumber = @ISN
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

GO
CREATE OR ALTER PROC usp_Incident_InsertCallData
@ISQN INT,
@FName NVARCHAR(64),
@LName NVARCHAR(64),
@MobileNumber NVARCHAR(64),
@HexCode NVARCHAR(2) OUTPUT
AS
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

GO 
CREATE OR ALTER PROC usp_Incident_getCallers
@iSQN INTEGER
AS
BEGIN
SELECT CallerFName, CallerLName, CallerMobile, CallTime FROM IncidentCallers
WHERE IncidentSQN = @iSQN
END
