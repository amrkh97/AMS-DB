
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
		





















-- (2) Search Unique ID --
