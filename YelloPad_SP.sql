
-----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
GO
CREATE OR ALTER proc usp_YelloPads_SelectAll
as
	select * from Yellopad

GO

CREATE OR ALTER proc usp_YelloPads_selectActive
AS
    select * from Yellopad
	where (YelloPadStatus <> '01' AND YelloPadStatus <> '02')

GO
CREATE OR ALTER proc usp_YelloPads_selectInActive
AS
    select * from Yellopad
	where YelloPadStatus = '02'

GO
CREATE OR ALTER proc usp_YelloPads_selectNotAssigned
AS
BEGIN
    select * from Yellopad
	where YelloPadStatus = '00'
END

GO
CREATE OR ALTER proc usp_YelloPads_selectAssigned
AS
BEGIN
    select * from Yellopad
	where YelloPadStatus = '01'
END
 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
CREATE OR ALTER proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
as
IF (@UniqueID IS NOT NULL)
	BEGIN
		select * from Yellopad
		
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
CREATE OR ALTER PROC usp_YelloPads_Insert
@YelloPadUniqueID NVARCHAR(16),
@YellopadNetworkcardNo NVARCHAR(64),
@YelloPadMaintenanceNote NVARCHAR(128),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(64) OUTPUT
AS
BEGIN

IF EXISTS(SELECT * FROM YElloPad WHERE YelloPadUniqueID = @YelloPadUniqueID)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'YelloPad Already Exists'
END
ELSE
BEGIN

INSERT INTO YelloPad
	(
		YelloPadUniqueID,
		YellopadNetworkcardNo,
		YelloPadMaintenanceNote
	)
VALUES
	( 	@YelloPadUniqueID, -- YelloPadUniqueID - nvarchar(16)
		@YellopadNetworkcardNo, -- YellopadNetworkcardNo - nvarchar(64)
		@YelloPadMaintenanceNote -- Yellopad device Number 
	)

IF EXISTS(SELECT * FROM YElloPad WHERE YelloPadUniqueID = @YelloPadUniqueID)
BEGIN
SET @HexCode = '00'
SET @HexMsg = 'YelloPad Added Successfully'
END
ELSE
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'YelloPad Failed To Insert, Please Try Again.'
END
END
END

GO

CREATE OR ALTER PROC usp_YelloPads_UpdateLocation
@YelloPadUniqueID NVARCHAR(16),
@YelloPadLatitude NVARCHAR(16),
@YelloPadLongitude NVARCHAR(16),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(64) OUTPUT
AS
BEGIN

IF EXISTS(SELECT * FROM YelloPad WHERE YelloPadUniqueID = @YelloPadUniqueID)
BEGIN

UPDATE YelloPad
SET YelloPadLatitude = @YelloPadLatitude
WHERE YelloPadUniqueID = @YelloPadUniqueID

UPDATE YelloPad
SET YelloPadLongitude = @YelloPadLongitude
WHERE YelloPadUniqueID = @YelloPadUniqueID

SET @HexCode = '00'
SET @HexMsg = 'YelloPad Updated Successfully'

END
ELSE
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'YelloPad Does not Exist'
END
END
GO

CREATE OR ALTER PROC YelloPad_Check_Database
@YelloPadUniqueID NVARCHAR(16),
@DataBaseStatus NVARCHAR(2) OUTPUT
AS
BEGIN
SET @DataBaseStatus = (
SELECT DatabaseStatus 
FROM YelloPad 
WHERE YelloPadUniqueID = @YelloPadUniqueID
)
END
GO

CREATE OR ALTER PROC YelloPad_Set_DataBase
@YelloPadUniqueID NVARCHAR(16),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

UPDATE YelloPad
SET DatabaseStatus = '01'
WHERE YelloPadUniqueID = @YelloPadUniqueID

IF EXISTS(SELECT * FROM YelloPad WHERE DatabaseStatus = '01'
AND YelloPadUniqueID = @YelloPadUniqueID)
BEGIN
SET @HexCode = '00'
SET @HexMsg = 'Success' 
END
ELSE
BEGIN
SET @HexCode = '00'
SET @HexMsg = 'Success'
END
END
GO