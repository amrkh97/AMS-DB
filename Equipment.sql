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