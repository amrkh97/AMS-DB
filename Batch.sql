USE kAN_AMO;
GO

CREATE PROC usp_BatchMedicine_CheckID
@UniqueID INT,
@HexCode INT OUTPUT
AS
BEGIN

IF EXISTS (SELECT  Batch.BatchID FROM dbo.Batch WHERE BatchID= @UniqueID)
BEGIN
SET @HexCode = 1
END
ELSE
BEGIN

SET @HexCode = 0

END
END
GO


CREATE proc usp_BatchMedicine_Insert
@BatchID INT,
--@MedicineName NVARCHAR(64),
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity NVARCHAR(64),
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN


insert into dbo.Batch(BatchID,BatchMedBCode,Quantity)
VALUES(@BatchID,@MedicineBarcode,@MedicineQuantity)

INSERT INTO dbo.BatchMedicine
(
    BatchID,
    MedicineBCode,
    Quantity
)
VALUES
(   @BatchID ,
    @MedicineBarcode, -- MedicineBCode - nvarchar(64)
    @MedicineQuantity  -- Quantity - nvarchar(64)
    )

SET @HexCode = '00'
END
go
