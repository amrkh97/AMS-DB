GO
Create proc usp_IncidentType_GetAll
as
	select * from IncidentTypes
GO
EXEC usp_IncidentType_GetAll
GO
Create proc usp_IncidentPriority_GetAll
as
	select * from Priorities
GO
