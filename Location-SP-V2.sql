GO
CREATE OR ALTER PROC usp_IncidentPriority_GetAll
as
	select * from Priorities
GO
--EXEC usp_IncidentPriority_GetAll
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
				SET @responseMessage = 'LOCATION ALREADY EXIST'
				SELECT @return_Hex_value = 'FF'
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
	