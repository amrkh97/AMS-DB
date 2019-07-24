
CREATE  OR ALTER PROC usp_Feedback_Insert 
	@SequenceNumber INT,
	@Rating float,
    @DriverNote NVARCHAR(500) = NULL,
    @ParamedicNote NVARCHAR(500) = NULL,
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY

	IF (@SequenceNumber IS NOT NULL AND @Rating IS NOT NULL)
 BEGIN
 
	  
          BEGIN
		        INSERT INTO Feedback
				 (SequenceNumber,Rating,DriverNote,ParamedicNote,FeedbackStatus)
			    VALUES (@SequenceNumber,@Rating,@DriverNote,@ParamedicNote,'00')
		        SELECT @responseCode = '00'
		        SELECT @responseMessage = 'Success'
	      END
	
	END
ELSE
       BEGIN      
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'SequenceNumber IS  NULL or Rating IS NULL'
			 
           END

	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		    @responseMessage=ERROR_MESSAGE()
		 
	END CATCH
			 
-- (4) Update Feedback --
GO
CREATE  OR ALTER PROC usp_Feedback_Update 
	@FeedbackID INT,
	@SequenceNumber NVARCHAR(64),
	@Rating NVARCHAR(64),
    @DriverNote NVARCHAR(64) = NULL,
    @ParamedicNote NVARCHAR(32) = NULL,

    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY	 
IF (@FeedbackID IS NOT NULL)
		BEGIN
			UPDATE Feedback
			SET SequenceNumber = ISNULL(@SequenceNumber,SequenceNumber),
			Rating = ISNULL(@Rating,Rating),
			DriverNote = ISNULL(@DriverNote,DriverNote),
			ParamedicNote = ISNULL(@ParamedicNote,ParamedicNote)
			WHERE FeedbackID = @FeedbackID
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
-- (5) Delete Medicine By Barcode --
GO
create  OR ALTER PROC usp_Feedback_Delete  
	@FeedbackID NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

AS
BEGIN TRY	 
IF (@FeedbackID IS NOT NULL)
	BEGIN

		 IF Exists (Select * from Feedback where FeedbackID=@FeedbackID ) 
	       BEGIN      
				UPDATE Feedback
					SET  FeedbackStatus = 'FF'
					WHERE FeedbackID = @FeedbackID
				SELECT @responseCode = '00'
				SELECT @responseMessage = 'Success'
           END
		else 
			begin
			 SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'NO Feedback found this this ID '
			end 

			
	END
	ELSE
	BEGIN 
				SELECT @responseCode = 'FF'
				SELECT @responseMessage = 'nO PARAMETER'
     	        RETURN -1

	END
	END TRY
BEGIN CATCH
		 	SELECT @responseCode = 'FF',
		     @responseMessage=ERROR_MESSAGE()
			 RETURN -1;
	END CATCH
		 RETURN -1