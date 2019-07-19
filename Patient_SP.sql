USE KAN_AMO
GO

Create OR ALTER PROC usp_Patient_getAllLocations
@UserID INT
AS
BEGIN
SELECT * FROM Locations
INNER JOIN dbo.PatientLocations ON PatientLocations.LocationID = Locations.LocationID
WHERE PatientID=@UserID

END
GO


Create OR ALTER  PROC  usp_Patient_Locations
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

GO 
Create OR ALTER PROC  usp_add_New_Patient
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

	@PatientID INT = -1 OUTPUT,
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
AS
BEGIN
	SET @PatientID = (SELECT dbo.Patient.PatientID FROM dbo.Patient WHERE Age = @Age AND Gender = @Gender AND PatientFName = @PatientFName
	AND PatientLName = @PatientLName AND Phone = @Phone AND PatientNationalID = @PatientNationalID)
	IF (@PatientID IS NOT NULL)
	BEGIN
		SET @responseCode = 'EF'
		SET @responseMessage = 'Patient Already Exist'
		PRINT @PatientID
		RETURN
	END 
	ELSE
	BEGIN
		INSERT INTO Patient ( PatientFName, PatientLName, Gender, Age, Phone, LastBenifitedTime, FirstBenifitedTime, NextOfKenName, NextOfKenPhone, NextOfKenAddress, PatientStatus, PatientNationalID)
		VALUES (@PatientFName,@PatientLName,@Gender,@Age,@Phone,@LastBenifitedTime,@FirstBenifitedTime,@NextOfKenName,@NextOfKenPhone,@NextOfKenAddress,@PatientStatus,@PatientNationalID)
		SET @PatientID = (
			SELECT PatientID 
			FROM dbo.Patient 
			WHERE (Age = @Age AND Gender = @Gender AND PatientFName = @PatientFName AND PatientLName = @PatientLName 
			AND Phone = @Phone)
		)
		IF (@PatientID IS NOT NULL)
		BEGIN
			SET @responseCode = '00'
			SET @responseMessage = 'Succesfully Added New Patient'
			PRINT @PatientID
			RETURN
		END 
		ELSE 
		BEGIN
			SET @responseCode = 'FF'
			SET @responseMessage = 'Failed To Add Patient'
			PRINT @PatientID
			RETURN
		END
	END
END

GO
Create OR ALTER   PROC usp_Update_Patient
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
	@PatientNationalID NVARCHAR(14),

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
Create OR ALTER  PROC usp_Delete_Patient 
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

Create OR ALTER PROC usp_Patient_getAll
AS
BEGIN
SELECT * FROM Patient


END


GO
Create OR ALTER PROC usp_Patient_getByNID
@NID NVARCHAR(14)
AS
BEGIN
SELECT * FROM Patient
WHERE PatientNationalID  = @NID 

END

GO
Create OR ALTER PROC usp_Patient_getByID
@ID int
AS
BEGIN
SELECT * FROM Patient
WHERE PatientID  = @ID 

END
--------------------------------------------------------------------

GO
Create OR ALTER  PROC usp_Delete_PatientLoc 
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
