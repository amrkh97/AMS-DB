USE KAN_AMO

GO

CREATE OR ALTER PROC usp_BatchMedicine_Insert
@BatchID BIGINT,
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity INTEGER,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN

DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @MedicineBarcode) - @MedicineQuantity

if(@QuantityDifference >= 0)
begin

if not exists(select * from dbo.Batch  where dbo.Batch.BatchID=@BatchID)
begin
insert into dbo.Batch(BatchID)
VALUES(@BatchID)
end

INSERT INTO dbo.BatchMedicine
(
    BatchID,
    MedicineBCode,
    Quantity
)
VALUES
(   @BatchID ,
    @MedicineBarcode,
    @MedicineQuantity
)

UPDATE dbo.Medicine
SET CountInStock = @QuantityDifference WHERE BarCode = @MedicineBarcode;
-- '00' -> Addition Successful    
SET @HexCode = '00'
END
ELSE
BEGIN
-- '01' -> Addition Failed
SET @HexCode = '01'
END
END
go


CREATE OR ALTER PROC usp_Batch_UsedMedicine
@batchID BIGINT,
@sequenceNumber INTEGER,
@barCode NVARCHAR(64),
@usedAmt INTEGER,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @barcode) - @usedAmt

if(@QuantityDifference >= 0)
BEGIN
Update dbo.BatchMedicine
set Quantity = @QuantityDifference
INSERT INTO dbo.MedicineUsedMedicineUsedPerResponse
(	RespSQN ,
	BID,
	MedBCode,
	UsedAmt,
	AmbVIN
)
VALUES
(
	@sequenceNumber,
	@batchID,
	@barCode,
	@usedAmt,
	(select AssociatedVIN from dbo.AmbulanceBatchesMap where BatchID = @batchID)
)
set @HexCode = '00'
END
ELSE
BEGIN
set @HexCode = '01'
END
END
GO

CREATE OR ALTER PROC usp_AmbulanceMap_getAllBatches
@VIN INTEGER
AS
BEGIN
SELECT BatchID FROM dbo.AmbulanceBatchesMap WHERE AssociatedVIN = @VIN
END
GO