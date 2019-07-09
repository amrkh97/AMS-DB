USE KAN_AMO
------------------------- Stored  OR ALTER PROCedures ----------------------------
------------------------------------------------------------------------
-- Medicine Stored  OR ALTER PROCedures --

  
-- Medicine Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

--
-- Company Stored Procedure End --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

		

-- END of Company - Medicine Relation SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- END OF Batch SP --
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- AmbulanceVehicle SP --

-- END OF AmbulanceVehicle SP --
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Batch of Medicine Distribution on Vehicles Relation SP (Batch - vehicle ) --

--(1) Distribute an amount of batch medicine to a Vehicle --
GO
CREATE  OR ALTER PROC usp_BatchDistribution_Insert @DistributedAmt INT, @BID INT, @AmbVIN INT
AS
	BEGIN
		INSERT INTO BatchDistributionMap (DistributedAmt,BID,AmbVIN)
		VALUES (@DistributedAmt,@BID,@AmbVIN)
	END

-- END of Batch of Medicine Distribution SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Employee SP --

-- END of Employee SP --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Triggers --
-- (1) Distribute amount of batch medicine to vehicle --
-- GO
-- Create  trigger TR_BatchDistributionMap_InsteadOfInsert
-- ON BatchDistributionMap
-- instead of insert
-- as
-- 	declare @distributed int,@total int, @bID int
-- 	select @bID = BID from inserted
-- 	select @distributed = DistributedAmt from inserted
-- 	select @total = (select Quantity from Batch where BatchID = @bID)
	
-- 	if @total > @distributed
-- 	begin
-- 		update Batch set Quantity =  Quantity - @distributed 
-- 		Where BatchID = @bID
-- 		insert into BatchDistributionMap(DistributedAmt, BID, AmbVIN)
-- 		select DistributedAmt, BID, AmbVIN
-- 		from inserted;
-- 	end
-- 	else
-- 		select 'Distributed Amount exceeds available amount'
