USE kAN_AMO;
GO

CREATE OR ALTER PROC usp_BatchMedicine_Insert
@BatchID BIGINT,
--@MedicineName NVARCHAR(64),
@MedicineBarcode NVARCHAR(64),
@MedicineQuantity NVARCHAR(64)
AS
BEGIN

if not exists(select * from dbo.Batch  where dbo.Batch.BatchID=@BatchID)
begin
insert into dbo.Batch(BatchID,BatchMedBCode,Quantity)
VALUES(@BatchID,@MedicineBarcode,@MedicineQuantity)
end

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
go
