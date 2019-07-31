USE KAN_AMO
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
	@encodedFFA NVARCHAR(MAX), --10
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,--11
	@responseMessage NVARCHAR(128)='' OUTPUT,--12
	@LocationID INT= 0 OUTPUT--13
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @locID INT
	DECLARE @LocationStatus NVARCHAR(32)
	IF (@FreeFormatAddress IS NOT NULL AND @Longitude IS NOT NULL AND @Latitude IS NOT NULL)
		BEGIN
		SET @locID = (SELECT LocationID
		FROM dbo.Locations
		WHERE (Longitude = @Longitude AND Latitude = @Latitude AND FreeFormatAddress = @FreeFormatAddress))
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
				FFAEncoded,
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
				( @FreeFormatAddress, -- FreeFormatAddress - nvarchar(265)
					@encodedFFA, -- FFAEncoded -NVARCHAR(MAX)
					@City, -- City - nvarchar(32)
					@Longitude, -- Longitude - decimal(9, 6)
					@Latitude, -- Latitude - decimal(9, 6)
					@Street, -- Street - nvarchar(32)
					@Apartement, -- Apartement - nvarchar(32)
					@PostalCode, -- PostalCode - nvarchar(20)
					@FloorLevel, -- FloorLevel - nvarchar(20)
					@HouseNumber, -- HouseNumber - nvarchar(12)
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
	SET @locID = (SELECT LocationID
	FROM dbo.Locations
	WHERE (Longitude = @Longitude AND Latitude = @Latitude AND FreeFormatAddress = @FreeFormatAddress))
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
	