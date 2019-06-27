------------------------- Stored Procedures ----------------------------
------------------------------------------------------------------------
-- Location Stored Procedures --
-- (1) Insert New Location --
GO
CREATE PROC usp_Locations_Insert 
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
Create proc usp_Locations_SelectAll
as
	select * from Locations
------------------------------------------
-- (2) Get Get All Locations Test --
--GO
--EXEC usp_Locations_SelectAll
-----------------------------------------
-- (2.1) Get Locations by city --
GO
Create proc usp_Locations_SelectByCity @CityName NVARCHAR(32)
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
CREATE PROC usp_Locations_SelectByGPS 
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
CREATE PROC usp_Locations_SelectByStreet
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
CREATE PROC usp_Locations_SelectByPostalCode
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
CREATE PROC usp_Locations_SelectByPostalZipCode
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
CREATE PROC usp_Locations_SelectByID
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
CREATE PROC usp_Locations_SelectByAddress
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
create proc usp_Location_Delete  @LocationID INT
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
CREATE PROC usp_Location_Update
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