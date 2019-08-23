USE KAN_AMO
GO

CREATE OR ALTER PROC Insert_Into_Log
@IPAddress NVARCHAR(200),
@RequestPath NVARCHAR(500)
AS
BEGIN

INSERT INTO ActivityLog
(
    IPAddress,
    RequestPath
)
VALUES
(
    @IPAddress,
    @RequestPath
)

END
GO

CREATE OR ALTER PROC Get_All_Logs
AS
BEGIN

SELECT * FROM ActivityLog

END
GO