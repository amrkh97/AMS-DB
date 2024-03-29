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


CREATE OR ALTER PROC usp_Batch_MedicineUsed
@batchID BIGINT,
@sequenceNumber INTEGER,
@barCode NVARCHAR(64),
@usedAmt INTEGER,
@HexCode NVARCHAR(2) OUTPUT
AS
BEGIN
	DECLARE @QuantityDifference INT
	set @QuantityDifference = (select Quantity
	from BatchMedicine
	WHERE BatchID = @batchID AND MedicineBCode = @barCode) - ABS(@usedAmt)

	if(@QuantityDifference >= 0)
BEGIN
		Update dbo.BatchMedicine
		set Quantity = @QuantityDifference
		WHERE BatchID = @batchID AND MedicineBCode = @barCode

		INSERT INTO dbo.MedicineUsedPerResponse
			( RespSQN ,
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
				ABS(@usedAmt),
				(select AssociatedVIN
				from dbo.AmbulanceBatchesMap
				where BatchID = @batchID)
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

CREATE OR ALTER PROC usp_BatchMedicine_Update
@BatchID bigint,
@MedicineBarcode nvarchar(64),
@MedicineQuantity integer,
@HexCode nvarchar(2) OUTPUT
AS
BEGIN
  DECLARE @OldQuantity INT
  DECLARE @QuantityDifference INT
  DECLARE @QuantityFinal INT
  DECLARE @CountInStock INT


	IF NOT EXISTS(SELECT * FROM BatchMedicine bm WHERE bm.MedicineBCode = @MedicineBarcode)
		BEGIN
		EXEC usp_BatchMedicine_Insert @BatchID ,@MedicineBarcode, @MedicineQuantity, @HexCode OUTPUT
		PRINT @HexCode
		RETURN
	END

	SET @OldQuantity = (
	SELECT bm.Quantity FROM BatchMedicine bm
	WHERE bm.BatchID = @BatchID AND bm.MedicineBCode = @MedicineBarcode
	)

 	 SET @CountInStock = (SELECT
    CountInStock
  	FROM Medicine
  	WHERE BarCode = @MedicineBarcode)
  	SET @QuantityDifference = @CountInStock
  	- @MedicineQuantity + @OldQuantity

  IF (@QuantityDifference >= 0)
  BEGIN

    IF NOT EXISTS (SELECT
        *
      FROM dbo.Batch
      WHERE dbo.Batch.BatchID = @BatchID)
    BEGIN
      -- '01' -> Update Failed
    SET @HexCode = '01'
	RETURN 1
    END

	UPDATE BatchMedicine
	SET Quantity = @MedicineQuantity
	WHERE BatchID = @BatchID AND MedicineBCode = @MedicineBarcode
	
	SET @QuantityFinal = @CountInStock + @OldQuantity - @MedicineQuantity 

    UPDATE dbo.Medicine
    SET CountInStock = @QuantityFinal
    WHERE BarCode = @MedicineBarcode;
    -- '00' -> Update Successful    
    SET @HexCode = '00'
	RETURN 0
  END
  ELSE
  BEGIN
    -- '01' -> Update Failed
    SET @HexCode = '01'
	RETURN 1
  END
END
GO


CREATE OR ALTER PROC usp_Batch_getAllByMedName
@MedName NVARCHAR(100)
AS
BEGIN

SELECT DISTINCT b.BatchID FROM Batch b
LEFT JOIN AmbulanceMap am
ON b.BatchID = am.BatchID
INNER JOIN BatchMedicine bm
ON b.BatchID = bm.BatchID
INNER JOIN Medicine M
ON bm.MedicineBCode = M.BarCode
WHERE am.BatchID IS NULL
AND M.MedicineName LIKE '%' + @MedName + '%'

END
GO
CREATE OR ALTER PROC usp_Batch_getAllBatches
AS
BEGIN

SELECT am.VIN,b.BatchID FROM Batch b
LEFT JOIN AmbulanceMap am
ON b.BatchID = am.BatchID

END

GO

CREATE OR ALTER PROC usp_Batch_getAllAssigned
AS
BEGIN

SELECT abm.AssociatedVIN, b.BatchID FROM Batch b
INNER JOIN AmbulanceBatchesMap abm
ON b.BatchID = abm.BatchID
WHERE abm.AssociatedVIN IS NOT NULL

END

GO

CREATE OR ALTER PROC usp_Batch_getAllUnAssigned
AS
BEGIN

SELECT abm.AssociatedVIN, b.BatchID FROM Batch b
FULL OUTER JOIN AmbulanceBatchesMap abm
ON b.BatchID = abm.BatchID
WHERE abm.AssociatedVIN IS NULL

END
GO

CREATE OR ALTER PROC usp_Batch_getMedicines
	@BatchID BIGINT
AS
BEGIN
	select BarCode, MedicineName, Price, dbo.BatchMedicine.Quantity, Implications, MedicineUsage, SideEffects, ActiveComponent, MedicineStatus
	from dbo.Medicine
		inner join dbo.BatchMedicine
		ON BatchMedicine.MedicineBCode = Medicine.BarCode
	WHERE dbo.BatchMedicine.BatchID = @BatchID
END
GO
