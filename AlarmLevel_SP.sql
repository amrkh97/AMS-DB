USE KAN_AMO
GO
CREATE OR ALTER proc usp_AlarmLevel_GetAll
as
	select * from AlarmLevels
GO


-- EXAMPLE OF RUNNING A STORED PROCEDURE
EXEC usp_AlarmLevel_GetAll