-----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
GO
Create proc usp_YelloPads_SelectAll
as
	select YelloPadUniqueID, YelloPadStatus, YellopadNetworkcardNo from YelloPad

 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
Create proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YelloPadUniqueID, YelloPadStatus, YellopadNetworkcardNo from YelloPad
		where YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

 ------------------------------------------
-- (3) Get YelloPad Status --
-----------------------------------------
GO
Create proc usp_YelloPads_Status @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YelloPadStatus from YelloPad
		where YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

 ------------------------------------------
-- (4) Get YelloPad Network Info --
-----------------------------------------
GO
Create proc usp_YelloPads_NetworkCard @UniqueID NVARCHAR(16)
as
	IF (@UniqueID IS NOT NULL)
	BEGIN
		select YellopadNetworkcardNo from YelloPad
		where YelloPadUniqueID = @UniqueID
	END
	ELSE
		RETURN -1

