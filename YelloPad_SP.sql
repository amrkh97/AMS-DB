-----------------------------------------------------------------------
-- (1) Get All YelloPads --
---------------------------------------- 
GO
Create proc usp_YelloPads_SelectAll
as
	select YelloPadUniqueID, YelloPadStatus, YellopadNetworkcardNo, YelloPadPicture from YelloPad
	INNER JOIN EntityStatus  ON YelloPad.YelloPadStatus=EntityStatus.EntityStatusID

 ------------------------------------------
-- (2) Search Unique ID --
-----------------------------------------
GO
Create proc usp_YelloPads_Search @UniqueID NVARCHAR(16)
as
IF (@UniqueID IS NOT NULL)
	BEGIN
		select YelloPadUniqueID, EntityStatus.StatusName,EntityStatus.StatusNote, Yellopad.YellopadNetworkcardNo, Yellopad.YelloPadPicture from Yellopad
		INNER JOIN EntityStatus  ON YelloPad.YelloPadStatus=EntityStatus.EntityStatusID
		WHERE  YelloPad.YelloPadUniqueID = @UniqueID
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
		select StatusName, StatusNote from EntityStatus
		INNER JOIN YelloPad  ON YelloPad.YelloPadUniqueID=EntityStatus.EntityStatusID 
		and YelloPad.YelloPadUniqueID=@UniqueID;
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

