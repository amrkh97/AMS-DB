USE KAN_AMO;
----------------------------------------
--Last Update: Amr Khaled -> 11:30

-----------------------------------------
--Files Included:
--Locations_SP
--YelloPad_SP
--Batch
--Medicine
--Patient_SP
--Respnse-SP
--AmbulanceVehicle
--AlarmLevel_SP
--AuthenticationProcedures




------------------------- Stored Procedures ----------------------------
------------------------------------------------------------------------
-- Medicine Stored Procedures --
-- (1) Get All Medicines --
GO
CREATE OR ALTER proc usp_Medicines_SelectAll 
as
	select * from Medicine
-- (2.1) Get Medicine By Name --
GO
CREATE OR ALTER proc usp_Medicine_SelectByName  @MedName NVARCHAR(64)
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
CREATE OR ALTER proc usp_Medicine_SelectByBCode  @bCode NVARCHAR(64)
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
CREATE OR ALTER proc usp_Medicine_SelectBySts @MStatus NVARCHAR(32)
as
	select * from Medicine
	where MedicineStatus = @MStatus
-- (3) Insert Medicine --
GO
CREATE OR ALTER PROC usp_Medicine_Insert 
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
CREATE OR ALTER PROC usp_Medicine_Update
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
CREATE OR ALTER proc usp_Medicine_Delete  @bCode NVARCHAR(64)
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
CREATE OR ALTER proc usp_PharmaCompany_SelectAll
as
	select * from PharmaCompany
-- (2.1) Get Company By Name --
GO
CREATE OR ALTER proc usp_PharmaCompany_Select  @compName NVARCHAR(64)
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
CREATE OR ALTER proc usp_PharmaCompany_SelectByID @CompID INT
as
	select * from PharmaCompany
	where CompanyID = @CompID
-- (2.3) Get Company By Status --
GO
CREATE OR ALTER proc usp_PharmaCompany_SelectBySts @CompStatus NVARCHAR(64)
as
	select * from PharmaCompany
	where CompanyStatus = @CompStatus
-- (3) Insert Company --
GO
CREATE OR ALTER PROC usp_PharmaCompany_Insert 
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
CREATE OR ALTER PROC usp_PharmaCompany_Update 
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
			CompanyStatus = '01'
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
CREATE OR ALTER proc usp_PharmaCompany_Delete  @CompID INT,
@HexCode NVARCHAR(2) OUTPUT
as
begin
	IF (@CompID IS NOT NULL)
	BEGIN
		UPDATE PharmaCompany
		SET CompanyStatus = '02'
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
CREATE OR ALTER PROC usp_CompanyMedicineMap_Insert @CompID INT, @MedBCode NVARCHAR(64)
AS
	BEGIN
		INSERT INTO CompanyMedicineMap (CompID,MedBCode)
		VALUES (@CompID,@MedBCode)
	END
--(2) Delete a medicine from a company --
GO
CREATE OR ALTER PROC usp_CompanyMedicineMap_DELETE @CompID INT, @MedBCode NVARCHAR(64)
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
CREATE OR ALTER proc usp_Batch_SelectAll
as
	select * from Batch
-- (2.1) Select Batch By ID --
GO
CREATE OR ALTER proc usp_Batch_Select  @BatchID INT
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
CREATE OR ALTER proc usp_Batch_SelectBySts  @BatchSts  NVARCHAR(32)
as
	select * from Batch
	where BatchStatus = @BatchSts
-- (3) Insert Batch --
GO
CREATE OR ALTER PROC usp_Batch_Insert 
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
CREATE OR ALTER PROC usp_Batch_Update 
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
CREATE OR ALTER proc usp_Batch_Delete  @BatchID INT
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
CREATE OR ALTER proc usp_AmbulanceVehicle_SelectAll
as
	select * from AmbulanceVehicle
-- (2.1) Select AmbulanceVehicle By Identification Number --
GO
CREATE OR ALTER proc usp_AmbulanceVehicle_Select  @VIN INT
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
CREATE OR ALTER proc usp_AmbulanceVehicle_SelectBySts  @VehicleSts  NVARCHAR(32)
as
	select * from AmbulanceVehicle
	where VehicleStatus = @VehicleSts
-- (3) Insert AmbulanceVehicle --
GO
CREATE OR ALTER PROC usp_AmbulanceVehicle_Insert 
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
CREATE OR ALTER PROC usp_AmbulanceVehicle_Update 
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
CREATE OR ALTER proc usp_AmbulanceVehicle_Delete  @VIN INT
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
CREATE OR ALTER PROC usp_BatchDistribution_Insert @DistributedAmt INT, @BID INT, @AmbVIN INT
AS
	BEGIN
		INSERT INTO BatchDistributionMap (DistributedAmt,BID,AmbVIN)
		VALUES (@DistributedAmt,@BID,@AmbVIN)
	END

-- END of Batch of Medicine Distribution SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Employee SP --

GO
CREATE OR ALTER PROC usp_Employee_Login 
	@EmailOrPAN NVARCHAR(128),
	@HashPassword NVARCHAR(128),
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@JobID INTEGER = -1 OUTPUT,
	@employeeID Integer = -1 OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT on
	DECLARE @userID INT
	DECLARE @status NVARCHAR(32)
	
	IF (@EmailOrPAN IS NOT NULL AND @HashPassword IS NOT NULL)
	BEGIN
		IF ((SELECT(LEN(@HashPassword))) > 7 )
		BEGIN
			BEGIN TRY
				
				IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN))
				BEGIN
					-- Found the user using email or PAN or National ID
					SET @userID = (SELECT EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))
					IF(@userID IS NULL)
					BEGIN
						-- Wrong Password
						SET @responseMessage='Incorrect password'
						SELECT @return_Hex_value = '02'
					END
					
					ELSE
					BEGIN
						-- @userID IS NOT NULL
						-- Correct password, so check if he's already logged in
						SET @status=(SELECT LogInStatus from Employee WHERE EID=@userID)				
						IF(@status = '00')
						BEGIN
							-- Not logged in, so login successful, send his type to backend and jobID
							-- And set status to 1
							SET @responseMessage='User logged in successfully'
							SELECT @return_Hex_value = '00'
							SET @JobID = (SELECT JobID from Employee where EID = @userID)
							SET @employeeID = @userID
							UPDATE Employee SET LogInStatus = '01' WHERE EID = @userID
							UPDATE Employee SET LogInTStamp = GETDATE() WHERE EID = @userID
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
	-- IF (@userID IS NOT NULL)
	IF (@dummyToken IS NOT NULL)
	BEGIN
		BEGIN TRY
			-- IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE EID=@userID)
			IF EXISTS (SELECT TOP 1 Email FROM Employee WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
			BEGIN
				-- Found the user using userID
				-- SET @status=(SELECT EmployeeStatus from Employee WHERE EID=@userID)
				SET @status=(SELECT LogInStatus from Employee WHERE Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
				IF(@status='01')
				BEGIN
					-- Right Status
					-- UPDATE Employee SET EmployeeStatus = 0 WHERE EID = @userID
					-- UPDATE Employee SET EmployeeStatus = '00' WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
					UPDATE dbo.Employee SET LogInStatus = '00' WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
					SET @responseMessage='Logged out successfully'
					SELECT @return_Hex_value = '00'
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
	@job INT,
	@image NVARCHAR(MAX) = NULL,
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
			IF EXISTS (SELECT * FROM Employee WHERE Email=@email OR PAN=@pan OR NationalID=@nationalID)
			BEGIN
				-- Found a user using this Email or PAN or National ID
				-- ERROR: Already signed up
				SET @responseMessage='User already registered. Try signing in'
				SELECT @return_Hex_value = 'FF'
				RETURN -1
			END
			ELSE
			BEGIN
				-- Email was not used before
				-- Insert into DB
				INSERT INTO Employee (Fname,Lname,BDate,Email,HashPassword,Gender,ContactNumber,Country,City,AddressState,AddressStreet,AddressPcode,PAN,NationalID,JobID,Photo)
				values (@firstName,@lastName,@dateOfBirth,@email,@password,@gender,@contactNumber,@country,@city,@state,@street,@postalCode,@pan,@nationalID,@job,@image)
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
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Triggers --
-- (1) Distribute amount of batch medicine to vehicle --
GO
CREATE OR ALTER trigger TR_BatchDistributionMap_InsteadOfInsert
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
CREATE OR ALTER proc usp_YelloPads_SelectAll
as
	select YelloPadUniqueID, YelloPadStatus, Yellopad.YellopadNetworkcardNo, Yellopad.YelloPadPicture from Yellopad
	where YelloPadStatus <> '02'
		
 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
CREATE OR ALTER proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
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

GO
CREATE OR ALTER proc usp_IncidentType_GetAll
as
	select * from IncidentTypes
GO
EXEC usp_IncidentType_GetAll
GO
CREATE OR ALTER proc usp_IncidentPriority_GetAll
as
	select * from Priorities
GO
EXEC usp_IncidentPriority_GetAll

GO

CREATE OR ALTER proc usp_Patient_getAllLocations
@UserID INT
AS
BEGIN
SELECT * FROM Locations
INNER JOIN dbo.PatientLocations ON PatientLocations.LocationID = Locations.LocationID
WHERE PatientID=@UserID

END
GO


CREATE OR ALTER proc usp_Patient_Locations
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


---------------------------------------------
--Batch-Medicine:
GO


CREATE OR ALTER proc usp_BatchMedicine_Insert
@BatchID BIGINT,
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity INT
AS
BEGIN

if not exists(select * FROM dbo.Batch  where dbo.Batch.BatchID=@BatchID)
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

update dbo.Medicine 
SET CountInStock = CountInStock - @MedicineQuantity
WHERE BarCode = @MedicineBarcode
END
GO

--TODO: COnfirm that all checks are passed from front end.
CREATE OR ALTER PROC usp_AmbulanceMap_Insert
@VIN INT,
@ParamedicID INT,
@DriverID INT,
@YelloPadID INT,
@HexCode INT OUTPUT
AS
BEGIN
if exists(select * from dbo.AmbulanceMap where VIN = @VIN and StatusMap = '00')
BEGIN
-- 1 -> Ambulance was already inserted but not assigned.
Set @HexCode = 1
RETURN 1
END
ELSE if exists(select * from dbo.AmbulanceMap where VIN = @VIN and StatusMap ='01')
begin
-- 2 -> Ambulance is assigned and already in service.
Set @HexCode = 2
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
WHERE YelloPadUniqueID = @YelloPadID

UPDATE dbo.Employee
SET EmployeeStatus = '00'
WHERE EID = @ParamedicID

UPDATE dbo.Employee
SET EmployeeStatus = '00'
WHERE EID = @DriverID

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '00'
WHERE VIN = @VIN

-- 0 -> Insertion Successful
Set @HexCode = 0
RETURN 0
end
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
@VIN INT
AS
BEGIN
update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='00'

update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='02'
END

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '00'
WHERE VIN = @VIN

GO



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
//-------------------------------------------------------------------
O
create PROC usp_Receipt_Insert 
	
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
create proc usp_Receipt_Delete 
 @ReceiptID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReceiptID IS NOT NULL)
	BEGIN
		UPDATE Receipt
		SET ReceiptStatus = 99
		where ReceiptID = @ReceiptID AND  ReceiptStatus='0'
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
create proc usp_Receipt_SelectByRespSQN  @RespSQN NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@RespSQN IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((RespSQN = @RespSQN) AND (ReceiptStatus='0'))
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
create proc usp_Receipt_SelectByCasheirSSN  @CasheirSSN INT,
   @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@CasheirSSN IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((CasheirSSN = @CasheirSSN) AND (ReceiptStatus='0'))
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
create proc usp_Receipt_SelectByFTPFileLocation  @FTPFileLocation NVARCHAR(128),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@FTPFileLocation IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((FTPFileLocation = @FTPFileLocation) AND (ReceiptStatus='0'))
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
create proc usp_Receipt_SelectByReceiptStatus  @ReceiptStatus NVARCHAR(64),
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
create proc usp_Receipt_SelectByCost  @Cost NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@Cost IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((Cost = @Cost) AND (ReceiptStatus='0'))
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
create proc usp_Receipt_SelectByPaymentMethod  @PaymentMethod NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@PaymentMethod IS NOT NULL)
	BEGIN
		select * from Receipt
		where ((PaymentMethod = @PaymentMethod) AND (ReceiptStatus='0'))
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
create proc usp_Receipt_SelectByReceiptCreationTime  @ReceiptCreationTime DATETIME
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
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
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
			where  ReceiptStatus='0' AND  (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
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
			where  ReceiptStatus='0' AND  (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
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
			where  ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)) and
			(DatePart(mm,ReceiptCreationTime) = DatePart(mm,@ReceiptCreationTime)) 
		END
			ELSE IF  (NOT(DatePart(yy,@ReceiptCreationTime)=0)) AND 
			(DatePart(mm,@ReceiptCreationTime)=0) AND 
			(DatePart(dd,@ReceiptCreationTime)=0) AND 
			(DatePart(hh,@ReceiptCreationTime)=0) AND 
			(DatePart(Mi,@ReceiptCreationTime)=0)
			BEGIN	
			select * from Receipt
			where  ReceiptStatus='0' AND DatePart(yy,ReceiptCreationTime) = DatePart(yy,@ReceiptCreationTime)
	END
	end
	ELSE
		RETURN -1
-----------------------------------------------------------------------------
	GO
create proc usp_Receipt_By_Full_Time  @ReceiptCreationTime DATETIME
as
	IF (@ReceiptCreationTime IS NOT NULL)
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND	(ReceiptCreationTime=@ReceiptCreationTime)
end
	ELSE
		RETURN -1
-------------------------------------------------------
GO
create proc usp_Receipt_By_Year  @ReceiptCreationYear int
as
	IF (@ReceiptCreationYear IS NOT NULL)
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear)
	end
ELSE
	RETURN -1
------------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month   @ReceiptCreationYear int, @ReceiptCreationMonth int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth is not null))
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear)
			and(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month_Day  @ReceiptCreationYear int, @ReceiptCreationMonth int,@ReceiptCreationDay int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth IS NOT NULL) and (@ReceiptCreationDay IS NOT NULL))
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear) and
			(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
			and (DatePart(dd,ReceiptCreationTime) = @ReceiptCreationDay)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month_Day_Hour   @ReceiptCreationYear int, @ReceiptCreationMonth int,@ReceiptCreationDay int,@ReceiptCreationHour int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth IS NOT NULL) and (@ReceiptCreationDay IS NOT NULL) and (@ReceiptCreationHour is not null) )
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear) and
			(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
			and (DatePart(dd,ReceiptCreationTime) = @ReceiptCreationDay
			and (DatePart(hh,ReceiptCreationTime) = @ReceiptCreationHour))
end
	ELSE
		RETURN -1
--------------------------------------------------
-----------------------------------------------------------
GO
CREATE PROC usp_Report_Insert 
	
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
create proc usp_Reports_SelectByReportTitle  @ReportTitle NVARCHAR(64)
as
	IF (@ReportTitle IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportTitle = @ReportTitle AND ReportStatus=0
	END
	ELSE
		RETURN -1


--(2) Get Report by ReportStatus --
GO
create proc usp_Reports_SelectByReportStatus  @ReportStatus NVARCHAR(64)
as
	IF (@ReportStatus IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportStatus = @ReportStatus AND ReportStatus=0
	END
	ELSE
		RETURN -1

--(3) Get Report by ReportIssueTime --
GO
Use KAN_AMO
GO

create proc usp_Reports_SelectByReportIssueTime  @ReportIssueTime DATETIME
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
			where ReportStatus=0 AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
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
			where  ReportStatus=0 AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
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
			where  ReportStatus=0 AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
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
			where  ReportStatus=0 AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime)) 
		END
			ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(DatePart(mm,@ReportIssueTime)=0) AND 
			(DatePart(dd,@ReportIssueTime)=0) AND 
			(DatePart(hh,@ReportIssueTime)=0) AND 
			(DatePart(Mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus=0 AND DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)
	END
	end
	ELSE
		RETURN -1


--(4) Get Report by ReportStatus --
GO
create proc usp_Reports_SelectByPatientID  @PatientID INT
as
	IF (@PatientID IS NOT NULL)
	BEGIN
		select * from Reports
		where  ReportStatus=0 AND  PatientID = @PatientID
	END
	ELSE
		RETURN -1
--(5) Get Report by ReportTitleAndStatus --
GO
create proc usp_Reports_SelectByReportTitleAndStatus  @ReportTitle NVARCHAR(64),
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
create proc usp_Reports_Delete 
 @ReportID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReportID IS NOT NULL)
	BEGIN
		UPDATE Reports
		SET ReportStatus = 99
		where ReportID = @ReportID AND  ReportStatus=0
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
------------------------------------------------------------------------------
GO
create proc usp_Report_By_Full_Time  @ReportIssueTime DATETIME
as
	IF (@ReportIssueTime IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='0' AND	(ReportIssueTime=@ReportIssueTime)
end
	ELSE
		RETURN -1
-------------------------------------------------------
GO
create proc usp_Report_By_Year  @ReportCreationYear int
as
	IF (@ReportCreationYear IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='0' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
	end
ELSE
	RETURN -1
------------------------------------------------------
GO
create proc usp_Report_By_Year_Month   @ReportCreationYear int, @ReportCreationMonth int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth is not null))
		BEGIN	
			select * from Reports
			where ReportStatus='0' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
			and(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Report_By_Year_Month_Day  @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL))
		BEGIN	
			select * from Reports
			where ReportStatus='0' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Report_By_Year_Month_Day_Hour   @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int,@ReportCreationHour int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL) and (@ReportCreationHour is not null) )
		BEGIN	
			select * from Reports
			where ReportStatus='0' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay
			and (DatePart(hh,ReportIssueTime) = @ReportCreationHour))
end
	ELSE
		RETURN -1
--------------------------------------------------
--GO
--EXEC usp_Locations_SelectAll
-----------------------------------------
-- (2.1) Get Locations by city --
GO
Create OR ALTER PROC usp_Locations_SelectByCity @CityName NVARCHAR(32)
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
-- (3) Delete Location By LocationID --
GO
create OR ALTER PROC usp_Location_Delete  @LocationID INT
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
	

--GO
--EXEC usp_Location_Update @LocationID = 1, @FreeFormatAddress = 'adsdasdfsa', @Longitude = 25.334,
--@Latitude = 65.32, @Street = 'Tahrir',  @HouseNumber = '7'
-----------------------------------------


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
		
-----------------------------------------------------

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
------------------------------------------------------------------------------
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
		 
-- (3) Insert Patient --
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
		go


GO
CREATE OR ALTER proc usp_AlarmLevel_GetAll
as
	select * from AlarmLevels

GO

CREATE OR ALTER PROC get_Employee_AllParamedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2

END
GO

CREATE OR ALTER PROC get_Employee_Paramedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END
GO

CREATE OR ALTER PROC get_Employee_InActiveParamedics
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 2 AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' ) 

END

GO
CREATE OR ALTER PROC get_Employee_AllDrivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3

END

GO
CREATE OR ALTER PROC get_Employee_Drivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND (EmployeeStatus = '00' OR EmployeeStatus = '01') 

END

GO
CREATE OR ALTER PROC get_Employee_InActiveDrivers
AS
BEGIN

SELECT EID,Fname,Lname,Email,ContactNumber,PAN,NationalID,EmployeeStatus,Photo,Age FROM dbo.Employee
WHERE JobID = 3 AND (EmployeeStatus = '02' OR EmployeeStatus = '03'  OR EmployeeStatus = '04' )

END