USE KAN_AMO
------------------------- Stored  OR ALTER PROCedures ----------------------------
------------------------------------------------------------------------
-- Medicine Stored  OR ALTER PROCedures --
-- (1) Get All Medicines --
GO
Create  OR ALTER PROC usp_Medicines_SelectAll 
as
	select * from Medicine
	WHERE  MedicineStatus <>'FF'
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
  
-- Medicine Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
--
-- Company Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
		

-- END of Company - Medicine Relation SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
		INSERT INTO Batch (BatchID,BatchMedBCode,Quantity,ExpiryDate,OrderDate)
		VALUES (@BatchID,@BatchMedBCode,@Quantity,@ExpiryDate,ISNULL(@OrderDate,getdate()))
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
		BatchMedBCode = ISNULL (@BatchMedBCode,BatchMedBCode),
		Quantity = ISNULL (@Quantity,Quantity),
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
-- END OF Batch SP --
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- AmbulanceVehicle SP --

-- (1) Select All Batches --
GO
Create  OR ALTER PROC usp_AmbulanceVehicle_SelectAll
as
	select * from AmbulanceVehicle
-- (2.1) Select AmbulanceVehicle By Identification Number --
GO
create  OR ALTER PROC usp_AmbulanceVehicle_Select  @VIN INT
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
create  OR ALTER PROC usp_AmbulanceVehicle_SelectBySts  @VehicleSts  NVARCHAR(32)
as
	select * from AmbulanceVehicle
	where VehicleStatus = @VehicleSts
-- (3) Insert AmbulanceVehicle --
GO
CREATE  OR ALTER PROC usp_AmbulanceVehicle_Insert 
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
CREATE  OR ALTER PROC usp_AmbulanceVehicle_Update 
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
create  OR ALTER PROC usp_AmbulanceVehicle_Delete  @VIN INT
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
CREATE  OR ALTER PROC usp_BatchDistribution_Insert @DistributedAmt INT, @BID INT, @AmbVIN INT
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
CREATE  OR ALTER PROC usp_Employee_Register
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
  --Will Need to be Handled to get linked to a manager.
  @SuperSSN INT = 1,
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
CREATE  OR ALTER PROC usp_Employee_Login 
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
CREATE  OR ALTER PROC usp_Employee_Logout
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
Create  trigger TR_BatchDistributionMap_InsteadOfInsert
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
