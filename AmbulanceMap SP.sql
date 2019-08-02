USE [KAN_AMO]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmbulanceMap_Insert]    Script Date: 7/9/2019 3:18:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------NEW SET OF STORED PROCEDURES--------------------------------------------------------------

CREATE OR ALTER PROC [dbo].[usp_AmbulanceMap_Insert]
@VIN INT,
@ParamedicID INT,
@DriverID INT,
@YelloPadID INT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
if exists(select * from dbo.AmbulanceMap where VIN = @VIN and (StatusMap = '00' OR StatusMap = '02'))
BEGIN
-- 1 -> Ambulance was already inserted but not assigned.
Set @HexCode = '01'
RETURN 1
END
ELSE if exists(select * from dbo.AmbulanceMap where VIN = @VIN and StatusMap ='02')
begin
-- 2 -> Ambulance is assigned and already in service.
Set @HexCode = '02'
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
WHERE YelloPadID = @YelloPadID

UPDATE dbo.Employee
SET EmployeeStatus = '05'
WHERE EID = @ParamedicID

UPDATE dbo.Employee
SET EmployeeStatus = '05'
WHERE EID = @DriverID

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '05'
WHERE VIN = @VIN

-- 0 -> Insertion Successful
Set @HexCode = '00'
RETURN 0
END
END

GO

CREATE OR ALTER PROC usp_AmbulanceMap_Insert_Batch
@VIN INT,
@batchID BIGINT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
if exists(select * from dbo.AmbulanceMap where  VIN = @VIN and StatusMap = '00')
begin
UPDATE dbo.AmbulanceMap
SET BatchID = @batchID
where VIN = @VIN and StatusMap = '00'

INSERT INTO AmbulanceBatchesMap
(
    AssociatedVIN,
    BatchID
)
VALUES (
    @VIN,
    @batchID
)


-- '00' -> updated succesfully
SET @HexCode = '00'
end
else
BEGIN
-- '01' -> Failure to add because a vehicle with these conditions doesn't exist
SET @HexCode = '01'
END
END

GO

CREATE OR ALTER PROC usp_AmbulanceMap_getRelevantData
@VIN INTEGER,
@License NVARCHAR(64) OUTPUT,
@Make NVARCHAR(64) OUTPUT,
@ParamedicFName NVARCHAR(64) OUTPUT,
@ParamedicLName NVARCHAR(64) OUTPUT,
@ParamedicID Integer OUTPUT,
@DriverFName NVARCHAR(64) OUTPUT,
@DriverLName NVARCHAR(64) OUTPUT,
@DriverID Integer OUTPUT,
@YelloPadUniqueID NVARCHAR(64) OUTPUT
			
AS
BEGIN
select @License = LicencePlate, @Make= Make from dbo.AmbulanceVehicle 
inner join dbo.AmbulanceMap ON AmbulanceMap.VIN = AmbulanceVehicle.VIN
where dbo.AmbulanceVehicle.VIN = @VIN

SELECT @ParamedicFName = Fname, @ParamedicLName = Lname,@ParamedicID = EID FROM dbo.Employee
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.ParamedicID = Employee.EID
WHERE dbo.AmbulanceMap.VIN = @VIN

SELECT @DriverFName = Fname, @DriverLName = Lname,@DriverID = EID FROM dbo.Employee
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.DriverID = Employee.EID
WHERE dbo.AmbulanceMap.VIN = @VIN

SELECT @YelloPadUniqueID= YelloPadUniqueID FROM dbo.Yellopad
INNER JOIN dbo.AmbulanceMap ON AmbulanceMap.YelloPadID = Yellopad.YelloPadID
WHERE dbo.AmbulanceMap.VIN = @VIN
END

GO

CREATE OR ALTER  Proc usp_deleteAmbulanceMap
@VIN INT,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

if exists (select * from AmbulanceMap where VIN = @VIN AND (StatusMap='00' OR StatusMap='02'))
BEGIN
update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='00'

update dbo.AmbulanceMap
set StatusMap = '04'
WHERE VIN = @VIN AND StatusMap='02'

UPDATE dbo.AmbulanceVehicle
SET VehicleStatus = '00'
WHERE VIN = @VIN

SET @HexCode = '00'
END
ELSE
BEGIN
SET @HexCode = '01'
END
END
GO