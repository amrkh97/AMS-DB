use KAN_AMO
GO
Create OR ALTER proc usp_AmbulanceVehicle_SelectAll 
as
	select * from AmbulanceVehicle

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
			LicenceStateOrProvince,ServiceStartDate,EngineNumber,Brand,ChasiahNumber,Model,DriverPhoneNumber,AssignedYPID,	AmbulanceVehiclePicture)
			values (@VIN,@Implication,@Make,@Type,@ProductionYear,@RegYear,@LicencePlate,@OwnerName,@LicenceStateOrProvince,
			@ServiceStartDate,@EngineNumber,@Brand,@ChasiahNumber,@Model,@DriverPhoneNumber,@AssignedYPID ,@AmbulanceVehiclePicture )
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
	@AssignedYPID NVARCHAR(32),
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
			AssignedYPID =ISNULL(@AssignedYPID,AssignedYPID),
				AmbulanceVehiclePicture=ISNULL(	@AmbulanceVehiclePicture,	AmbulanceVehiclePicture)
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
		SET VehicleStatus = 99
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

