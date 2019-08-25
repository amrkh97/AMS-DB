USE KAN_AMO
GO


CREATE OR ALTER PROC Add_AcceptedResponseCode
@StatusCode NVARCHAR(2),
@StatusMsg NVARCHAR(100),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF NOT EXISTS (SELECT * FROM AcceptedResponseStatus WHERE StatusCode = @StatusCode)
BEGIN

INSERT INTO AcceptedResponseStatus
(
    StatusCode,
    StatusMsg
)
VALUES
(
    @StatusCode,
    @StatusMsg
)

SET @HexCode = '00'
SET @HexMsg = 'Response Status Code Added Successfuly!'


END
ELSE
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Response Status Code Already Exists!'
END
END
GO

CREATE OR ALTER PROC Delete_AcceptedResponseCode
@StatusCode NVARCHAR(2),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN
IF EXISTS (SELECT * FROM AcceptedResponseStatus WHERE StatusCode = @StatusCode)
BEGIN

DELETE AcceptedResponseCode
WHERE StatusCode = @StatusCode

SET @HexCode = '00'
SET @HexMsg = 'Response Status Code Deleted Successfuly!'


END
ELSE
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Response Status Code Does Not Exist!'
END
END
GO

CREATE OR ALTER PROC Update_AcceptedResponseCode
@OldStatusCode NVARCHAR(2),
@StatusCode NVARCHAR(2),
@StatusMsg NVARCHAR(100),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF EXISTS (SELECT * FROM AcceptedResponseCode WHERE StatusCode = @StatusCode)
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'New Response Status Code Already Exists!'
RETURN -1
END

IF NOT EXISTS (SELECT * FROM AcceptedResponseCode WHERE StatusCode = @StatusCode)
BEGIN
SET @HexCode = '03'
SET @HexMsg = 'Response Status Code Does Not Exist!'
RETURN -1
END



EXEC Delete_AcceptedResponseCode @OldStatusCode,@HexCode OUTPUT,@HexMsg OUTPUT

IF(@HexCode = '00')
BEGIN

EXEC Add_AcceptedResponseCode
@StatusCode,
@StatusMsg,
@HexCode OUTPUT,
@HexMsg OUTPUT

IF(@HexCode <> '00')
BEGIN
RETURN -1
END
RETURN 0
END
ELSE
BEGIN
RETURN -1
END
END
GO

CREATE OR ALTER PROC Get_AcceptedResponseCode
AS
BEGIN

SELECT * FROM AcceptedResponseCode

END
GO