----------------------------------------------------
use KAN_AMO;
GO
create proc usp_Receipt_By_Full_Time  @ReceiptCreationTime DATETIME
as
	IF (@ReceiptCreationTime IS NOT NULL)
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND	(ReceiptCreationTime=@ReceiptCreationTime)
end
	ELSE
		RETURN -1
-------------------------------------------------------
GO
create proc usp_Receipt_By_Year  @ReceiptCreationYear int
as
	IF (@ReceiptCreationYear IS NOT NULL)
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear)
	end
ELSE
	RETURN -1
------------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month   @ReceiptCreationYear int, @ReceiptCreationMonth int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth is not null))
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear)
			and(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month_Day  @ReceiptCreationYear int, @ReceiptCreationMonth int,@ReceiptCreationDay int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth IS NOT NULL) and (@ReceiptCreationDay IS NOT NULL))
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear) and
			(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
			and (DatePart(dd,ReceiptCreationTime) = @ReceiptCreationDay)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
create proc usp_Receipt_By_Year_Month_Day_Hour   @ReceiptCreationYear int, @ReceiptCreationMonth int,@ReceiptCreationDay int,@ReceiptCreationHour int
as
	IF ((@ReceiptCreationYear IS NOT NULL) and (@ReceiptCreationMonth IS NOT NULL) and (@ReceiptCreationDay IS NOT NULL) and (@ReceiptCreationHour is not null) )
		BEGIN	
			select * from Receipt
			where ReceiptStatus='0' AND (DatePart(yy,ReceiptCreationTime) = @ReceiptCreationYear) and
			(DatePart(mm,ReceiptCreationTime) = @ReceiptCreationMonth)
			and (DatePart(dd,ReceiptCreationTime) = @ReceiptCreationDay
			and (DatePart(hh,ReceiptCreationTime) = @ReceiptCreationHour))
end
	ELSE
		RETURN -1
--------------------------------------------------