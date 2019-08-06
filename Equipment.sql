USE KAN_AMO
GO

CREATE OR ALTER PROC usp_Equipment_Add
@EquipmentName NVARCHAR(200),
@EquipmentDescription NVARCHAR(MAX),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(64) OUTPUT
AS
BEGIN

IF EXISTS (SELECT * FROM Equipment WHERE EquipmentName = @EquipmentName)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Equipment Already Exists.'
END
ELSE
BEGIN

INSERT INTO Equipment
(EquipmentName, EquipmentDescription)
VALUES
(@EquipmentName, @EquipmentDescription)


IF NOT EXISTS(SELECT * FROM Equipment WHERE EquipmentName = @EquipmentName)
BEGIN

SET @HexCode = '02'
SET @HexMsg = 'Equipment Addition failed please try again.'

END
ELSE
BEGIN


SET @HexCode = '00'
SET @HexMsg = 'Equipment Added Succesfully.'

END

END
END

GO
CREATE OR ALTER PROC usp_Equipment_getAll
AS
BEGIN
SELECT * FROM Equipment
END


GO
CREATE OR ALTER PROC usp_Equipment_getAll
AS
BEGIN
SELECT * FROM Equipment
END


GO
CREATE OR ALTER PROC usp_Equipment_getByName
@EquipmentName NVARCHAR(200)
AS
BEGIN
SELECT * FROM Equipment WHERE EquipmentName = @EquipmentName
END

GO
CREATE OR ALTER PROC usp_Equipment_AssignToAmbulance
@VIN INT,
@EquipmentName NVARCHAR(200),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(64) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM AmbulanceVehicle WHERE VIN = @VIN)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'No Ambulance Vehicle with given VIN'
RETURN 1
END


IF NOT EXISTS(SELECT * FROM Equipment WHERE EquipmentName LIKE '%'+ @EquipmentName + '%')
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'No Equipment with given name'
RETURN 1
END

INSERT INTO EquipmentOnCar
(
    VIN,
    EquipmentName
)
VALUES
(
    @VIN,
    @EquipmentName
)
SET @HexCode = '00'
SET @HexMsg = 'Assigned to vehicle successfully'
END

GO

CREATE OR ALTER PROC usp_Equipment_OnAmbulance
@VIN INT
AS
BEGIN

SELECT Equipment.* FROM EquipmentOnCar
Inner Join Equipment
ON EquipmentOnCar.EquipmentName = Equipment.EquipmentName
WHERE EquipmentOnCar.VIN = @VIN

END

GO
CREATE OR ALTER PROC usp_Equipment_DeleteOnAmbulance
@VIN INT,
@EquipmentName NVARCHAR(200),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(64) OUTPUT
AS
BEGIN


IF NOT EXISTS(SELECT * FROM AmbulanceVehicle WHERE VIN = @VIN)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'No Ambulance Vehicle with given VIN'
RETURN 1
END


IF NOT EXISTS(SELECT * FROM Equipment WHERE EquipmentName LIKE '%'+ @EquipmentName + '%')
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'No Equipment with given name'
RETURN 1
END

IF NOT EXISTS(SELECT * FROM EquipmentOnCar WHERE EquipmentName LIKE '%'+ @EquipmentName + '%')
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'No Equipment with given name assigned on Ambulance'
RETURN 1
END

DELETE EquipmentOnCar
WHERE VIN = @VIN AND EquipmentName LIKE '%' + @EquipmentName + '%'

SET @HexCode = '00'
SET @HexMsg = 'Deleted Succesfully'

END