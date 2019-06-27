GO
Create proc usp_AlramLevel_GetAll
as
	select * from AlarmLevels
GO
EXEC usp_AlramLevel_GetAll