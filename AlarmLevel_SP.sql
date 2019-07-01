GO
Create proc usp_AlarmLevel_GetAll
as
	select * from AlarmLevels
GO
EXEC usp_AlarmLevel_GetAll