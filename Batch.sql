USE KAN_AMO;
GO

CREATE OR ALTER PROC usp_BatchMedicine_Insert
@BatchID BIGINT,
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity INT
AS
BEGIN
DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @MedicineBarcode) - @MedicineQuantity
if(@QuantityDifference > 0)
begin
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

END
end
go
