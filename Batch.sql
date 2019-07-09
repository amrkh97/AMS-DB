USE kAN_AMO;
GO

CREATE OR ALTER PROC usp_BatchMedicine_Insert
@BatchID BIGINT,
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity NVARCHAR(64)
AS
BEGIN

DECLARE @QuantityDifference INT
set @QuantityDifference = (select CountInStock from Medicine where BarCode = @MedicineBarcode) - @MedicineQuantity

if(@QuantityDifference > 0)
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

END

END
go
