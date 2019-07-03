use KAN_AMO;
GO
CREATE PROC usp_Receipt_Insert 
	
	@RespSQN NVARCHAR(64),
	@CasheirSSN INT,
	@FTPFileLocation NVARCHAR(128),
	@Cost NVARCHAR(32),
	@PaymentMethod NVARCHAR(32)= '00',
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	
		as 
	BEGIN TRY
	IF (@RespSQN IS NOT NULL )
		BEGIN
			INSERT INTO Receipt(RespSQN,CasheirSSN,FTPFileLocation,Cost,PaymentMethod)
			values (@RespSQN,@CasheirSSN,@FTPFileLocation,@Cost,@PaymentMethod)
	         SELECT @responseCode = '00'
				SELECT @responseMessage = 'Success'
		END
	ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1
------------------------------------------------------------------------
GO
create proc usp_Receipt_Delete 
 @ReceiptID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReceiptID IS NOT NULL)
	BEGIN
		UPDATE Receipt
		SET ReceiptStatus = 99
		where ReceiptID = @ReceiptID AND  ReceiptStatus=0
	    SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
		
	END
		ELSE
	BEGIN
				return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'Unknown Error'
			END
	END TRY
	BEGIN CATCH
			SELECT @responseCode = 'FF',
			       @responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1	
---------------------------------------------------------------------------
GO
create proc usp_Receipt_SelectByRespSQN  @RespSQN NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@RespSQN IS NOT NULL)
	BEGIN
		select * from Receipt
		where RespSQN = @RespSQN AND ReceiptStatus=0
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
create proc usp_Receipt_SelectByCasheirSSN  @CasheirSSN INT,
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@CasheirSSN IS NOT NULL)
	BEGIN
		select * from Receipt
		where CasheirSSN = @CasheirSSN AND ReceiptStatus=0
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
create proc usp_Receipt_SelectByFTPFileLocation  @FTPFileLocation NVARCHAR(128),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@FTPFileLocation IS NOT NULL)
	BEGIN
		select * from Receipt
		where FTPFileLocation = @FTPFileLocation AND ReceiptStatus=0
 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
create proc usp_Receipt_SelectByReceiptStatus  @ReceiptStatus NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReceiptStatus IS NOT NULL)
	BEGIN
		select * from Receipt
		where ReceiptStatus = @ReceiptStatus AND ReceiptStatus=0
	 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
create proc usp_Receipt_SelectByCost  @Cost NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@Cost IS NOT NULL)
	BEGIN
		select * from Receipt
		where Cost = @Cost AND ReceiptStatus=0
	 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO
create proc usp_Receipt_SelectByPaymentMethod  @PaymentMethod NVARCHAR(64),
 @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@PaymentMethod IS NOT NULL)
	BEGIN
		select * from Receipt
		where PaymentMethod = @PaymentMethod AND ReceiptStatus=0
	 SELECT @responseCode = '00'
		SELECT @responseMessage = 'Success'
	END
	ELSE
	BEGIN 
	return -1
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
	END
	END TRY
BEGIN CATCH
			SELECT @responseCode = 'FF',
		@responseMessage=ERROR_MESSAGE()
			return -1;
	END CATCH
		return -1

		
GO