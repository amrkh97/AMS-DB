USE KAN_AMO;
------------------------- Stored Procedures ----------------------------
------------------------------------------------------------------------
-- Medicine Stored Procedures --
-- (1) Get All Medicines --
GO
Create proc usp_Medicines_SelectAll 
as
	select * from Medicine
-- (2.1) Get Medicine By Name --
GO
Create proc usp_Medicine_SelectByName  @MedName NVARCHAR(64)
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
Create proc usp_Medicine_SelectByBCode  @bCode NVARCHAR(64)
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
Create proc usp_Medicine_SelectBySts @MStatus NVARCHAR(32)
as
	select * from Medicine
	where MedicineStatus = @MStatus
-- (3) Insert Medicine --
GO
Create PROC usp_Medicine_Insert 
	@BarCode NVARCHAR(64),
	@Name NVARCHAR(64),
    @CountInStock NVARCHAR(64) = NULL,
    @Price NVARCHAR(32) = NULL,
    @Implications NVARCHAR(MAX) = NULL,
    @MedicineUsage NVARCHAR(MAX) = NULL,
    @SideEffects NVARCHAR(MAX) = NULL,
    @ActiveComponent NVARCHAR(MAX) = NULL
as
	IF (@BarCode IS NOT NULL AND @Name IS NOT NULL)
		BEGIN
			INSERT INTO Medicine (BarCode,CountInStock,MedicineName,Price,Implications,MedicineUsage,SideEffects,ActiveComponent)
			values (@BarCode,@CountInStock,@Name,@Price,@Implications,@MedicineUsage,@SideEffects,@ActiveComponent)
		END
	ELSE
		return -1
-- (4) Update Medicine --
GO
Create PROC usp_Medicine_Update
	@BarCode NVARCHAR(64),
	@Name NVARCHAR(64) = NULL,
    @CountInStock NVARCHAR(64) = NULL,
    @Price NVARCHAR(32)  = NULL,
    @Implications NVARCHAR(MAX) = NULL,
    @MedicineUsage NVARCHAR(MAX) = NULL,
    @SideEffects NVARCHAR(MAX) = NULL,
    @ActiveComponent NVARCHAR(MAX) = NULL
as
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
		END
	ELSE
		return -1
-- (5) Delete Medicine By Barcode --
GO
Create proc usp_Medicine_Delete  @bCode NVARCHAR(64)
as
	IF (@bCode IS NOT NULL)
	BEGIN
		UPDATE Medicine
		SET MedicineStatus = 99
		where BarCode = @bCode
	END
	ELSE 
		RETURN -1
--
-- Medicine Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- PharmaCompany Stored Procedures --
-- (1) Get All Companies --
GO
Create proc usp_PharmaCompany_SelectAll
as
	select * from PharmaCompany
-- (2.1) Get Company By Name --
GO
Create proc usp_PharmaCompany_Select  @compName NVARCHAR(64)
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
Create proc usp_PharmaCompany_SelectByID @CompID INT
as
	select * from PharmaCompany
	where CompanyID = @CompID
-- (2.3) Get Company By Status --
GO
Create proc usp_PharmaCompany_SelectBySts @CompStatus NVARCHAR(64)
as
	select * from PharmaCompany
	where CompanyStatus = @CompStatus
-- (3) Insert Company --
GO
Create PROC usp_PharmaCompany_Insert 
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
Create PROC usp_PharmaCompany_Update 
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
Create proc usp_PharmaCompany_Delete  @CompID INT,
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
--
-- Company Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Company - Medicine Relation SP --

--(1) Insert a medicine to a company --
GO
Create PROC usp_CompanyMedicineMap_Insert @CompID INT, @MedBCode NVARCHAR(64)
AS
	BEGIN
		INSERT INTO CompanyMedicineMap (CompID,MedBCode)
		VALUES (@CompID,@MedBCode)
	END
--(2) Delete a medicine from a company --
GO
Create PROC usp_CompanyMedicineMap_DELETE @CompID INT, @MedBCode NVARCHAR(64)
AS
	BEGIN
		DELETE FROM CompanyMedicineMap 
		WHERE CompID = @CompID  AND MedBCode = @MedBCode
	END
-- END of Company - Medicine Relation SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Batch SP --

-- (1) Select All Batches --
GO
Create proc usp_Batch_SelectAll
as
	select * from Batch
-- (2.1) Select Batch By ID --
GO
Create proc usp_Batch_Select  @BatchID INT
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
Create proc usp_Batch_SelectBySts  @BatchSts  NVARCHAR(32)
as
	select * from Batch
	where BatchStatus = @BatchSts
-- (3) Insert Batch --
GO
Create PROC usp_Batch_Insert 
	@BatchID INT,
	@BatchMedBCode NVARCHAR(64),
	@Quantity INT = NULL,
	@ExpiryDate DATE = NULL,
    @OrderDate DATETIME = NULL
as
	BEGIN
		INSERT INTO Batch (BatchID,BatchMedBCode,Quantity,ExpiryDate,OrderDate)
		VALUES (@BatchID,@BatchMedBCode,@Quantity,@ExpiryDate,ISNULL(@OrderDate,getdate()))
	END
-- (4) Update Batch --
GO
Create PROC usp_Batch_Update 
	@BatchID INT,
	@BatchMedBCode NVARCHAR(64) = NULL,
	@Quantity  NVARCHAR(64) = NULL,
	@ExpiryDate DATE = NULL,
    @OrderDate DATETIME = NULL
as
	BEGIN
		UPDATE Batch
		SET BatchID = ISNULL (@BatchID,BatchID),
		BatchMedBCode = ISNULL (@BatchMedBCode,BatchMedBCode),
		Quantity = ISNULL (@Quantity,Quantity),
		ExpiryDate = ISNULL (@ExpiryDate,ExpiryDate),
		OrderDate = ISNULL (@OrderDate,OrderDate),
		BatchStatus = 2
		WHERE BatchID = @BatchID
	END
-- (5) Delete Batch --
GO
Create proc usp_Batch_Delete  @BatchID INT
as
	IF (@BatchID IS NOT NULL)
	BEGIN
		UPDATE Batch
		SET BatchStatus = 99
		where BatchID = @BatchID
	END
	ELSE
		return -1
-- END OF Batch SP --
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- AmbulanceVehicle SP --

-- (1) Select All Batches --
GO
Create proc usp_AmbulanceVehicle_SelectAll
as
	select * from AmbulanceVehicle
-- (2.1) Select AmbulanceVehicle By Identification Number --
GO
Create proc usp_AmbulanceVehicle_Select  @VIN INT
as
	IF (@VIN IS NOT NULL)
	BEGIN
		select * from AmbulanceVehicle
		where VIN = @VIN
		return 0
	END
	ELSE 
		RETURN -1
-- (2.2) Select AmbulanceVehicle By Status --
GO
Create proc usp_AmbulanceVehicle_SelectBySts  @VehicleSts  NVARCHAR(32)
as
	select * from AmbulanceVehicle
	where VehicleStatus = @VehicleSts
-- (3) Insert AmbulanceVehicle --
GO
Create PROC usp_AmbulanceVehicle_Insert 
	@VIN INT,
	@Implication NVARCHAR(32) = NULL,
	@Make NVARCHAR(32) = NULL ,
	@Type NVARCHAR(32)  = NULL,
	@ProductionYear  NVARCHAR(32)  = NULL,
	@RegYear  NVARCHAR(32) = NULL,
	@LicencePlate NVARCHAR(32) = NULL,
	@OwnerName NVARCHAR(128) = NULL,
	@LicenceStateOrProvince NVARCHAR(32) = NULL,
    @ServiceStartDate  NVARCHAR(32) = NULL,
    @EngineNumber NVARCHAR(32) = NULL,
    @Brand NVARCHAR(32) = NULL,
    @ChasiahNumber NVARCHAR(32) = NULL,
    @Model NVARCHAR(32) = NULL,
    @DriverPhoneNumber NVARCHAR(32) = NULL
as
	BEGIN
		INSERT INTO AmbulanceVehicle (VIN,Implication,Make,[Type],ProductionYear,RegYear,LicencePlate,OwnerName,
			LicenceStateOrProvince,ServiceStartDate,EngineNumber,Brand,ChasiahNumber,Model,DriverPhoneNumber)
		VALUES (@VIN,@Implication,@Make,@Type,@ProductionYear,@RegYear,@LicencePlate,@OwnerName,
			@LicenceStateOrProvince,@ServiceStartDate,@EngineNumber,@Brand,@ChasiahNumber,@Model,@DriverPhoneNumber)
	END
-- (4) Update AmbulanceVehicle --
GO
Create PROC usp_AmbulanceVehicle_Update 
	@VIN INT,
	@Implication NVARCHAR(32) = NULL,
	@Make NVARCHAR(32) = NULL ,
	@Type NVARCHAR(32)  = NULL,
	@ProductionYear  NVARCHAR(32)  = NULL,
	@RegYear  NVARCHAR(32) = NULL,
	@LicencePlate NVARCHAR(32) = NULL,
	@OwnerName NVARCHAR(128) = NULL,
	@LicenceStateOrProvince NVARCHAR(32) = NULL,
    @ServiceStartDate  NVARCHAR(32) = NULL,
    @EngineNumber NVARCHAR(32) = NULL,
    @Brand NVARCHAR(32) = NULL,
    @ChasiahNumber NVARCHAR(32) = NULL,
    @Model NVARCHAR(32) = NULL,
    @DriverPhoneNumber NVARCHAR(32) = NULL
as
	BEGIN
		UPDATE AmbulanceVehicle
		SET Implication = ISNULL (@Implication,Implication),
		Make = ISNULL (@Make,Make),
		[Type] = ISNULL (@Type,[Type]),
		ProductionYear = ISNULL (@ProductionYear,ProductionYear),
		RegYear = ISNULL (@RegYear,RegYear),
		LicencePlate = ISNULL (@LicencePlate,LicencePlate),
		OwnerName = ISNULL (@OwnerName,OwnerName),
		LicenceStateOrProvince = ISNULL (@LicenceStateOrProvince,LicenceStateOrProvince),
		ServiceStartDate = ISNULL (@ServiceStartDate,ServiceStartDate),
		EngineNumber = ISNULL (@EngineNumber,EngineNumber),
		Brand = ISNULL (@Brand,Brand),
		ChasiahNumber = ISNULL (@ChasiahNumber,ChasiahNumber),
		Model = ISNULL (Model,Model),
		DriverPhoneNumber = ISNULL (@DriverPhoneNumber,DriverPhoneNumber),
		VehicleStatus = 2
		WHERE VIN = @VIN
	END
-- (5) Delete AmbulanceVehicle --
GO
Create proc usp_AmbulanceVehicle_Delete  @VIN INT
as
	IF (@VIN IS NOT NULL)
	BEGIN
		UPDATE AmbulanceVehicle
		SET VehicleStatus = 99
		where VIN = @VIN
	END
	ELSE
		return -1
-- END OF AmbulanceVehicle SP --
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Batch of Medicine Distribution on Vehicles Relation SP (Batch - vehicle ) --

--(1) Distribute an amount of batch medicine to a Vehicle --
GO
Create PROC usp_BatchDistribution_Insert @DistributedAmt INT, @BID INT, @AmbVIN INT
AS
	BEGIN
		INSERT INTO BatchDistributionMap (DistributedAmt,BID,AmbVIN)
		VALUES (@DistributedAmt,@BID,@AmbVIN)
	END

-- END of Batch of Medicine Distribution SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Employee SP --

--(1) Register --
GO
Create PROC usp_Employee_Register
	@Fname NVARCHAR(32) = NULL,
	@Lname NVARCHAR(32) = NULL,
	@BDate Date = NULL,
	@Email NVARCHAR(128),
	@HashPassword NVARCHAR(128),
	@Gender NVARCHAR(1) = NULL,
	@ContactNumber NVARCHAR(64) = NULL,
	@Country NVARCHAR(32) = NULL,
  @City NVARCHAR(32) = NULL,
  @AddressState NVARCHAR(32) = NULL,
  @AddressStreet NVARCHAR(64) = NULL,
  @AddressPcode VARCHAR(20) = NULL,
  @PAN NVARCHAR(20) = NULL,
  @NationalID NVARCHAR(14) = NULL,
  @LogInTStamp DATETIME = NULL,
  @LogInGPS NVARCHAR(20) = NULL,
  @SuperSSN INT = NULL,
	@JobID INT = NULL,
  @Photo VARBINARY(MAX) = NULL,
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	declare @id INT = null
    BEGIN TRY
		IF NOT EXISTS (SELECT TOP 1 EID FROM Employee WHERE Email=@Email)
			BEGIN
					INSERT INTO Employee (Fname, Lname, BDate, Email, HashPassword, Gender, ContactNumber, Country, 
					City, AddressState, AddressStreet, AddressPcode, PAN, NationalID, LogInTStamp, LogInGPS, SuperSSN, JobID, Photo)
					VALUES (@Fname,@Lname,@BDate,@Email,HASHBYTES('SHA1', @HashPassword),@Gender,@ContactNumber,@Country ,
					@City ,@AddressState ,@AddressStreet ,@AddressPcode ,@PAN,@NationalID ,@LogInTStamp,@LogInGPS ,@SuperSSN ,@JobID ,@Photo)
					SELECT @return_Hex_value='00',@responseMessage='User Signed Up Successfully'
					
			END
		ELSE
			BEGIN
				SELECT @return_Hex_value='04', @responseMessage='Email Already Exists'
				return 4;
			END

	END TRY
	BEGIN CATCH
			SELECT @return_Hex_value='FF',@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
END
--(2) Login --
GO
Create PROC usp_Employee_Login 
	@EmailOrPAN NVARCHAR(128),
	@HashPassword NVARCHAR(128),
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@JobID NVARCHAR(64) OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @userID INT
	DECLARE @status INT
	BEGIN TRY
		IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN)
		-- Found the user using email or PAN or National ID
			BEGIN
				SET @userID = (SELECT EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND HashPassword=HASHBYTES('SHA1', @HashPassword))
				IF(@userID IS NULL)
				-- Worng Password
					BEGIN
						SET @responseMessage='Incorrect password'
						SELECT @return_Hex_value = '02'
						return 2
					END
				ELSE
				-- Correct password, so check if he's already logged in
					SET @status=(SELECT EmployeeStatus from Employee WHERE EID=@userID)
					IF(@status = 0)
					-- Not logged in, so login successful, send his type to backend
					-- And set status to 1
						BEGIN
							SET @responseMessage='User successfully logged in'
							SELECT @return_Hex_value = '00'
							SET @JobID = (SELECT JobID from Employee where EID = @userID)
							UPDATE Employee SET EmployeeStatus = 1 WHERE EID = @userID
							return 0
						END
					ELSE IF(@status = 1)
					-- Already logged in, so can't continue
						BEGIN
							SET @responseMessage='User is logged in somewhere'
							SELECT @return_Hex_value = '03'
							return 3
						END
				ELSE
				BEGIN
				   SET @responseMessage='Something went wrong'
				   SELECT @return_Hex_value = 'ff'
				END		
			END
		ELSE
		-- Didn't find the user using email or PAN or National ID
	  -- Wrong Email
			BEGIN
				SET @responseMessage='Invalid Email / PAN / National ID'
				SELECT @return_Hex_value = '01'
				return 1
			END
	END TRY
	BEGIN CATCH
			SELECT @return_Hex_value='FF', @responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
END

--(3) Logout --
GO
Create PROC usp_Employee_Logout
	@userID INT,
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
-- ASK --
WITH ENCRYPTION
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE EID=@userID)
			BEGIN
				UPDATE Employee SET EmployeeStatus = 0 WHERE EID = @userID
				SET @responseMessage='Successfuly Logged Out'
				SELECT @return_Hex_value = '00'
				return 0
			END
		ELSE
		-- Didn't find the user
			BEGIN
				SET @responseMessage='Invalid User ID'
				SELECT @return_Hex_value = '01'
				return 1
			END
	END TRY
	BEGIN CATCH
		SELECT @return_Hex_value='FF', @responseMessage=ERROR_MESSAGE()
		return -1;
	END CATCH
END

-- END of Employee SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Triggers --
-- (1) Distribute amount of batch medicine to vehicle --
GO
Create trigger TR_BatchDistributionMap_InsteadOfInsert
ON BatchDistributionMap
instead of insert
as
	declare @distributed int,@total int, @bID int
	select @bID = BID from inserted
	select @distributed = DistributedAmt from inserted
	select @total = (select Quantity from Batch where BatchID = @bID)
	
	if @total > @distributed
	begin
		update Batch set Quantity =  Quantity - @distributed 
		Where BatchID = @bID
		insert into BatchDistributionMap(DistributedAmt, BID, AmbVIN)
		select DistributedAmt, BID, AmbVIN
		from inserted;
	end
	else
		select 'Distributed Amount exceeds available amount'


		-----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
GO
Create proc usp_YelloPads_SelectAll
as
	select YelloPadUniqueID, YelloPadStatus, Yellopad.YellopadNetworkcardNo, Yellopad.YelloPadPicture from Yellopad
		
 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
Create proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
as
IF (@UniqueID IS NOT NULL)
	BEGIN
		select YelloPadUniqueID, YelloPadStatus, Yellopad.YellopadNetworkcardNo, Yellopad.YelloPadPicture from Yellopad
		
		WHERE  YelloPad.YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

 ------------------------------------------
-- (3) Get YelloPad Status --
-----------------------------------------
GO
Create proc usp_YelloPads_Status @UniqueID NVARCHAR(16)
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
Create proc usp_YelloPads_NetworkCard @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YellopadNetworkcardNo from YelloPad
		where YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

GO
Create proc usp_IncidentType_GetAll
as
	select * from IncidentTypes
GO
EXEC usp_IncidentType_GetAll
GO
Create proc usp_IncidentPriority_GetAll
as
	select * from Priorities
GO
EXEC usp_IncidentPriority_GetAll

GO

Create proc usp_Patient_getAllLocations
@UserID INT
AS
BEGIN
SELECT * FROM Locations
INNER JOIN dbo.PatientLocations ON PatientLocations.LocationID = Locations.LocationID
WHERE PatientID=@UserID

END
GO


Create proc usp_Patient_Locations
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

------------------------- Stored Procedures ----------------------------
------------------------------------------------------------------------
-- Location Stored Procedures --
-- (1) Insert New Location --
GO
Create PROC usp_Locations_Insert 
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
Create PROC usp_Locations_SelectByGPS 
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
Create PROC usp_Locations_SelectByStreet
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
Create PROC usp_Locations_SelectByPostalCode
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
Create PROC usp_Locations_SelectByPostalZipCode
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
Create PROC usp_Locations_SelectByID
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
Create PROC usp_Locations_SelectByAddress
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
Create proc usp_Location_Delete  @LocationID INT
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
Create PROC usp_Location_Update
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


---------------------------------------------
--Batch-Medicine:
GO

CREATE PROC usp_BatchMedicine_CheckID
@UniqueID INT,
@HexCode INT OUTPUT
AS
BEGIN

IF EXISTS (SELECT  Batch.BatchID FROM dbo.Batch WHERE BatchID= @UniqueID)
BEGIN
SET @HexCode = 1
END
ELSE
BEGIN
SET @HexCode = 0
END


END
GO


CREATE proc usp_BatchMedicine_Insert
@BatchID INT,
--@MedicineName NVARCHAR(64),
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity NVARCHAR(64),
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

if not exists(select * from dbo.Batch  where dbo.Batch.BatchID=@BatchID)
begin
insert into dbo.Batch(BatchID,BatchMedBCode,Quantity)
VALUES(@BatchID,@MedicineBarcode,@MedicineQuantity)
end
INSERT INTO dbo.BatchMedicine
(
    BatchID,
    MedicineBCode,
    Quantity
)
VALUES
(   @BatchID ,
    @MedicineBarcode, -- MedicineBCode - nvarchar(64)
    @MedicineQuantity  -- Quantity - nvarchar(64)
    )

SET @HexCode = '00'
END
go






--GO
--EXEC usp_Location_Update @LocationID = 1, @FreeFormatAddress = 'adsdasdfsa', @Longitude = 25.334,
--@Latitude = 65.32, @Street = 'Tahrir',  @HouseNumber = '7'
-----------------------------------------