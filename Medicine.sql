use KAN_AMO
GO
Create  OR ALTER PROC usp_Medicine_SelectByCompanyName
	@CompanyName NVARCHAR(64)
as
DECLARE @CompanyID INT
if (@CompanyName IS NOT NULL)
	BEGIN
	SET @CompanyID = (select CompanyID
	from PharmaCompany
	where CompanyName=@CompanyName)
	select BarCode, MedicineStatus, MedicineName, CountInStock, Implications, MedicineUsage, SideEffects, ActiveComponent, price
	FROM Medicine
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
	SET @BarCode = (select BarCode
	from Medicine
	where MedicineName = @MedicineName)
	select CompanyID , CompanyName, ContactPerson , CompanyAddress , CompanyPhone , CompanyStatus
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
	select DISTINCT BarCode, MedicineStatus, MedicineName, CountInStock, Implications, MedicineUsage,
		SideEffects, ActiveComponent, ActiveComponent, price
	from Medicine INNER join CompanyMedicineMap
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
	select DISTINCT BarCode, MedicineStatus, MedicineName, CountInStock, Implications, MedicineUsage,
		SideEffects, ActiveComponent, ActiveComponent, price
	from Medicine INNER join CompanyMedicineMap
		ON CompanyMedicineMap.MedBCode = Medicine.BarCode
		INNER join PharmaCompany
		on CompanyMedicineMap.CompID = PharmaCompany.CompanyID
	where PharmaCompany.CompanyStatus=@CompanyStatus AND MapStatus<>'ff'
END
	ELSE
	return -1

GO
CREATE OR alter proc usp_Medicine_SelectByActiveComponent
	@ActiveComponent NVARCHAR(MAX)
as
if (@ActiveComponent IS NOT NULL)
	BEGIN
	select *
	from Medicine
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



		GO
Create  OR ALTER PROC usp_Medicines_SelectAll
as
select *
from Medicine
WHERE  MedicineStatus <>'FF'
	OR CountInStock <> 0
-- (2.1) Get Medicine By Name --
GO
create  OR ALTER PROC usp_Medicine_SelectByName
	@MedName NVARCHAR(64)
as
IF (@MedName IS NOT NULL)
	BEGIN
	select *
	from Medicine
	where MedicineName = @MedName
END
	ELSE
		RETURN -1
-- (2.2) Get Medicine By Bar Code --
GO
create  OR ALTER PROC usp_Medicine_SelectByBCode
	@bCode NVARCHAR(64)
as
IF (@bCode IS NOT NULL)
		BEGIN
	select *
	from Medicine
	where BarCode = @bCode
END
	ELSE
		RETURN -1
-- (2.3) Get Medicine By Status --
GO
create  OR ALTER PROC usp_Medicine_SelectBySts
	@MStatus NVARCHAR(32)
as
select *
from Medicine
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
	@CompanyID INT,
	@responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY

	IF (@BarCode IS NOT NULL AND @Name IS NOT NULL)
 BEGIN
	IF Exists (Select *
	from Medicine
	where BarCode=@BarCode ) 
	       BEGIN
		SELECT @responseCode = '01';
		SELECT @responseMessage = 'Allready exists';
		RETURN -1;
	END
     ELSE
          BEGIN
		INSERT INTO Medicine
			(BarCode,CountInStock,MedicineName,Price,Implications,MedicineUsage,SideEffects,ActiveComponent,CompanyID)
		VALUES
			(@BarCode, @CountInStock, @Name, @Price, @Implications, @MedicineUsage, @SideEffects, @ActiveComponent,@CompanyID)
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








-- (2) Search Unique ID --
