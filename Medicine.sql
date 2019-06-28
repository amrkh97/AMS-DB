
--CREATE TABLE Medicine
--(
--	BarCode NVARCHAR(64),
--	MedicineName NVARCHAR(64) NOT NULL UNIQUE, 
--    CountInStock NVARCHAR(64),
--    Price NVARCHAR(32),
--    Implications NVARCHAR(MAX),
--    MedicineUsage NVARCHAR(MAX),
--    SideEffects NVARCHAR(MAX),
--    ActiveComponent NVARCHAR(MAX),
--	MedicineStatus NVARCHAR(32) DEFAULT(1)

--    PRIMARY KEY(BarCode),
--	FOREIGN KEY(MedicineStatus) REFERENCES EntityStatus(EntityStatusID), 
--	CHECK (Price > 0)

--);

--CREATE TABLE PharmaCompany
--(
--	CompanyID INT IDENTITY,
--    CompanyName NVARCHAR(64),
--    ContactPerson NVARCHAR(32),
--    CompanyAddress NVARCHAR(128),
--    CompanyPhone NVARCHAR(32),
--    CompanyStatus NVARCHAR(32) DEFAULT(1)

--	PRIMARY key (CompanyID)
--	FOREIGN KEY (CompanyStatus) REFERENCES EntityStatus(EntityStatusID), 
--);

--CREATE TABLE CompanyMedicineMap (
--    CompID INT,
--    MedBCode NVARCHAR(64),
--    PRIMARY key (CompID,MedBCode),
--    FOREIGN KEY (CompID) REFERENCES PharmaCompany (CompanyID),
--    FOREIGN KEY (MedBCode) REFERENCES Medicine (BarCode)
--);
----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
USE KAN_AMO
GO
Create proc usp_Medicine_SelectByCompanyName
@CompanyName NVARCHAR(64)
as
DECLARE @CompanyID INT
if (@CompanyName IS NOT NULL)
	BEGIN
SET @CompanyID = (select CompanyID from PharmaCompany where CompanyName=@CompanyName)
	select BarCode, MedicineName,CountInStock, Implications,MedicineUsage, SideEffects,    ActiveComponent,   ActiveComponent from Medicine
	INNER JOIN CompanyMedicineMap  
	ON CompanyMedicineMap.MedBCode=Medicine.BarCode
	where CompID=@CompanyID
	END
	ELSE
	RETURN -1
GO
Create proc usp_PharmaCompany_SelectByMedicineName
@MedicineName NVARCHAR(64)
as
DECLARE @BarCode INT
if (@MedicineName IS NOT NULL)
	BEGIN
SET @BarCode = (select BarCode from Medicine where MedicineName = @MedicineName)
	select CompanyID ,CompanyName,ContactPerson ,CompanyAddress ,CompanyPhone , CompanyStatus from PharmaCompany
	INNER JOIN CompanyMedicineMap  
	ON CompanyMedicineMap.CompID=PharmaCompany.CompanyID
	where MedBCode=@BarCode
	END
	ELSE
	return -1


GO
Create proc usp_Medicine_SelectByContactPerson
@ContactPerson NVARCHAR(32)
as
if (@ContactPerson IS NOT NULL)
	BEGIN
	select  BarCode, MedicineName,CountInStock, Implications,MedicineUsage, 
	SideEffects,ActiveComponent,ActiveComponent
	,CompanyID,CompanyName
	from Medicine INNER join  CompanyMedicineMap
	ON CompanyMedicineMap.MedBCode = Medicine.BarCode 
	INNER join PharmaCompany 
	on CompanyMedicineMap.CompID = PharmaCompany.CompanyID  
	where PharmaCompany.ContactPerson =@ContactPerson
	END
	ELSE
	return -1
	
GO
Create proc usp_Medicine_SelectByCompanyStatus
@CompanyStatus NVARCHAR(32)
as
if (@CompanyStatus IS NOT NULL)
	BEGIN
	select  BarCode, MedicineName,CountInStock, Implications,MedicineUsage, 
	SideEffects,ActiveComponent,ActiveComponent
	,CompanyID,CompanyName
	from Medicine INNER join  CompanyMedicineMap
	ON CompanyMedicineMap.MedBCode = Medicine.BarCode 
	INNER join PharmaCompany 
	on CompanyMedicineMap.CompID = PharmaCompany.CompanyID  
	where PharmaCompany.CompanyStatus=@CompanyStatus
	END
	ELSE
	return -1

GO
Create proc usp_Medicine_SelectByActiveComponent
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
























-- (2) Search Unique ID --
