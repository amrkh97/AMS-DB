
USE KAN_AMO

GO
CREATE OR ALTER proc usp_MedicalRecord_SelectAll 
as
	select * from MedicalRecord
	
GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByID  @MedicalRecordID INT
as
	IF (@MedicalRecordID IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where MedicalRecordID = @MedicalRecordID
	END
	ELSE
		RETURN -1
		
GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByPatient  @PatientID INT
as
	IF (@PatientID IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where PatientID = @PatientID
	END
	ELSE
		RETURN -1

GO
CREATE OR ALTER proc usp_MedicalRecord_SelectByStatus  @MRStatus NVARCHAR(32)
as
	IF (@MRStatus IS NOT NULL)
	BEGIN
		select * from MedicalRecord
		where MRStatus = @MRStatus
	END
	ELSE
		RETURN -1
		GO
CREATE OR ALTER PROC usp_MedicalRecord_Insert 
	@RespSQN INT,
	@PatientID INT,
	@BloodType NVARCHAR(12),
	@BloodPressure NVARCHAR(2),
	@Diabetes NVARCHAR(2),
	@RespiratoryDiseases NVARCHAR(2),
	@Cancer NVARCHAR(2),
	@CardiovascularDiseases NVARCHAR(2),
	@COPD NVARCHAR(2),
	@Pregnancy NVARCHAR(2),
	@Other NVARCHAR(MAX),
	@Dead NVARCHAR(2),
	@Consciousness NVARCHAR(2),
    @Breathing NVARCHAR(2),
    @Capillaries NVARCHAR(2),
	@Pulse NVARCHAR(12),
	@BloodPressureLevel NVARCHAR(12),
	@DiabetesLevel NVARCHAR(12),
	@BodyTemp NVARCHAR(12),
	@BreathingRate NVARCHAR(12),
	@CapillariesLevel NVARCHAR(12),
	@Injury NVARCHAR(MAX),
	@PhysicalExaminationImage NVARCHAR(MAX),
	@MedicineApplied NVARCHAR(128),
	@ProcedureDoneInCar NVARCHAR(MAX),
	@RecommendedProcedure NVARCHAR(MAX),
	@MRStatus NVARCHAR(32),
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@mrID INT = 0  OUTPUT
	
	as 
	BEGIN TRY
	IF(@RespSQN IS NOT NULL AND @PatientID IS NOT NULL )
		BEGIN
			INSERT INTO MedicalRecord (RespSQN,PatientID,BloodType,BloodPressure,Diabetes,RespiratoryDiseases,Cancer,CardiovascularDiseases,COPD,Pregnancy,Other,Dead,Consciousness,Breathing,Capillaries,Pulse,BloodPressureLevel,DiabetesLevel,BodyTemp,BreathingRate,CapillariesLevel,Injury,PhysicalExaminationImage,MedicineApplied,ProcedureDoneInCar,RecommendedProcedure,MRStatus)
			values(@RespSQN,@PatientID,@BloodType,@BloodPressure,@Diabetes,@RespiratoryDiseases,@Cancer,@CardiovascularDiseases,@COPD,@Pregnancy,@Other,@Dead,@Consciousness,@Breathing,@Capillaries,@Pulse,@BloodPressureLevel,@DiabetesLevel,@BodyTemp,@BreathingRate,@CapillariesLevel,@Injury,@PhysicalExaminationImage,@MedicineApplied,@ProcedureDoneInCar,@RecommendedProcedure,@MRStatus)
		    SELECT @responseCode = '00'
		    SELECT @responseMessage = 'Successfully Added Medical Record'
	        SELECT @mrID = (SELECT MedicalRecordID FROM MedicalRecord WHERE RespSQN = @RespSQN AND PatientID=@PatientID )
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
			@responseMessage = 'This Response Already Has A Medical Record'
			return -1;
	END CATCH
		return -1


		-- (4) Update MedicalRecord --




		-- (4) Update MedicalRecord --

GO
CREATE OR ALTER PROC usp_MedicalRecord_Update

    @MedicalRecordID INT,
	@RespSQN INT,
	@PatientID INT,
	@BloodType NVARCHAR(12),
	@BloodPressure NVARCHAR(2),
	@Diabetes NVARCHAR(2),
	@RespiratoryDiseases NVARCHAR(2),
	@Cancer NVARCHAR(2),
	@CardiovascularDiseases NVARCHAR(2),
	@COPD NVARCHAR(2),
	@Pregnancy NVARCHAR(2),
	@Other NVARCHAR(MAX),
	@Dead NVARCHAR(2),
	@Consciousness NVARCHAR(2),
    @Breathing NVARCHAR(2),
    @Capillaries NVARCHAR(2),
	@Pulse NVARCHAR(12),
	@BloodPressureLevel NVARCHAR(12),
	@DiabetesLevel NVARCHAR(12),
	@BodyTemp NVARCHAR(12),
	@BreathingRate NVARCHAR(12),
	@CapillariesLevel NVARCHAR(12),
	@Injury NVARCHAR(MAX),
	@PhysicalExaminationImage NVARCHAR(MAX),
	@MedicineApplied NVARCHAR(128),
	@ProcedureDoneInCar NVARCHAR(MAX),
	@RecommendedProcedure NVARCHAR(MAX),
	@MRStatus NVARCHAR(32),
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT


as
Begin TRY
	IF (@MedicalRecordID  IS NOT NULL)
		BEGIN
			UPDATE MedicalRecord
			SET   
			
			RespSQN=ISNULL(@RespSQN,RespSQN),
			PatientID=ISNULL(@PatientID,PatientID),
			BloodType=ISNULL(@BloodType,BloodType),
			BloodPressure=ISNULL(@BloodPressure,BloodPressure),
			Diabetes=ISNULL(@Diabetes,Diabetes),
			RespiratoryDiseases=ISNULL(@RespiratoryDiseases,RespiratoryDiseases),
			Cancer=ISNULL(@Cancer,Cancer),
			CardiovascularDiseases=ISNULL(@CardiovascularDiseases,CardiovascularDiseases),
			COPD=ISNULL(@COPD,COPD),
			Pregnancy=ISNULL(@Pregnancy,Pregnancy),
			Other=ISNULL(@Other,Other),
			Dead=ISNULL(@Dead,Dead),
			Consciousness=ISNULL(@Consciousness,Consciousness),
			Breathing=ISNULL(@Breathing,Breathing),
			Capillaries=ISNULL(@Capillaries ,Capillaries),
			Pulse=ISNULL(@Pulse,Pulse),
			BloodPressureLevel=ISNULL(@BloodPressureLevel,BloodPressureLevel),
			DiabetesLevel=ISNULL(@DiabetesLevel,DiabetesLevel),
			BodyTemp=ISNULL(@BodyTemp,BodyTemp),
			BreathingRate=ISNULL(@BreathingRate,BreathingRate),
			CapillariesLevel=ISNULL(@CapillariesLevel,CapillariesLevel),
			Injury=ISNULL(@Injury,Injury),
			PhysicalExaminationImage=ISNULL(@PhysicalExaminationImage,PhysicalExaminationImage),
			MedicineApplied=ISNULL(@MedicineApplied,MedicineApplied),
			ProcedureDoneInCar=ISNULL(@ProcedureDoneInCar,ProcedureDoneInCar),
			RecommendedProcedure=ISNULL(@RecommendedProcedure,RecommendedProcedure),
			MRStatus=ISNULL(@MRStatus,MRStatus)
			
			WHERE MedicalRecordID = @MedicalRecordID
		    SELECT @responseCode = '00'
		    SELECT @responseMessage = 'Successfuly Updated'
			if NOT EXISTS(SELECT * from MedicalRecord WHERE MedicalRecordID = @MedicalRecordID )
			Begin
		    SELECT @responseCode = '05'
		    SELECT @responseMessage = 'Not Found'
			END
		
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

		-- (5) Delete MedicalRecord By ID --
GO
CREATE OR ALTER proc usp_MedicalRecord_Delete  @MedicalRecordID  INT,@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
as
Begin TRY
	IF (@MedicalRecordID IS NOT NULL)
	BEGIN

		UPDATE  MedicalRecord 
		SET MRStatus = 'FF' 
		where MedicalRecordID = @MedicalRecordID AND NOT MRStatus = 'FF'  
		 SELECT @responseCode = '00'
		 SELECT @responseMessage = 'Successfuly Deleted'
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