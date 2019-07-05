
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
	where YelloPadStatus <> '02'

GO
CREATE OR ALTER proc usp_YelloPads_selectInActive
AS
    select * from Yellopad
	where YelloPadStatus = '02'
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
