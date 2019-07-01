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
				SET @ISN = (SELECT IncidentSequenceNumber FROM dbo.Incident WHERE (IncidentLocationID=@IncidentLocationID AND IncidentPriority=@IncidentPriority AND IncidentType=@IncidentType))
				IF(@ISN IS NULL)
				BEGIN
					SET @responseMessage = 'FAILED TO FIND INCIDENT'
					SELECT @return_Hex_value = 'FF'
					RETURN -1
				END
				ELSE
				BEGIN
					SET @responseMessage = 'LOCATION ADDED SUCCESFULLY'
					SELECT @return_Hex_value = '00'
					PRINT @ISN
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
	EXEC usp_Incident_Insert @IncidentType=1,@IncidentPriority=4,@IncidentLocationID=5
	