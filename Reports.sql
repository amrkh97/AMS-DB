-- Reports SP --
--(0) Insert Report --
use KAN_AMO;
GO
CREATE PROC usp_Report_Insert 
	
	@ReportTitle VARCHAR(64),
	@PatientID INT,
	@ReportDestination NVARCHAR(64),
    @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
	
		as 
	BEGIN TRY
	IF (@ReportTitle IS NOT NULL )
		BEGIN
			INSERT INTO Reports (ReportTitle,PatientID,ReportDestination)
			values (@ReportTitle,@PatientID,@ReportDestination)
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

--(1) Get Report by ReportTitle --
GO
create proc usp_Reports_SelectByReportTitle  @ReportTitle NVARCHAR(64)
as
	IF (@ReportTitle IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportTitle = @ReportTitle AND ReportStatus=1
	END
	ELSE
		RETURN -1


--(2) Get Report by ReportStatus --
GO
create proc usp_Reports_SelectByReportStatus  @ReportStatus NVARCHAR(64)
as
	IF (@ReportStatus IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportStatus = @ReportStatus AND ReportStatus=1
	END
	ELSE
		RETURN -1

--(3) Get Report by ReportIssueTime --
GO
Use KAN_AMO
GO

create proc usp_Reports_SelectByReportIssueTime  @ReportIssueTime DATETIME
as
	IF (@ReportIssueTime IS NOT NULL)
		BEGIN
			IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(hh,@ReportIssueTime) =0)) AND 
			(NOT(DatePart(Mi,@ReportIssueTime) =0))
			BEGIN	
			select * from Reports
			where ReportStatus=1 AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime)
			and (DatePart(hh,ReportIssueTime) = DatePart(hh,@ReportIssueTime))
			and (DatePart(mi,ReportIssueTime) = DatePart(mi,@ReportIssueTime)) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(hh,@ReportIssueTime) =0)) AND
			(DatePart(Mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus=1 AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime)
			and (DatePart(hh,ReportIssueTime) = DatePart(hh,@ReportIssueTime))) 
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(dd,@ReportIssueTime)=0)) AND 
			(DatePart(hh,@ReportIssueTime)=0) AND 
			(DatePart(mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus=1 AND  (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime))
			and (DatePart(dd,ReportIssueTime) = DatePart(dd,@ReportIssueTime) )
		END
		ELSE IF  (NOT(DatePart(yy,@ReportIssueTime) = 0)) AND 
			(NOT(DatePart(mm,@ReportIssueTime) = 0)) AND 
			(DatePart(dd,@ReportIssueTime) = 0) AND 
			(DatePart(hh,@ReportIssueTime) = 0) AND 
			(DatePart(Mi,@ReportIssueTime) = 0)
			BEGIN	
			select * from Reports
			where  ReportStatus=1 AND (DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)) and
			(DatePart(mm,ReportIssueTime) = DatePart(mm,@ReportIssueTime)) 
		END
			ELSE IF  (NOT(DatePart(yy,@ReportIssueTime)=0)) AND 
			(DatePart(mm,@ReportIssueTime)=0) AND 
			(DatePart(dd,@ReportIssueTime)=0) AND 
			(DatePart(hh,@ReportIssueTime)=0) AND 
			(DatePart(Mi,@ReportIssueTime)=0)
			BEGIN	
			select * from Reports
			where  ReportStatus=1 AND DatePart(yy,ReportIssueTime) = DatePart(yy,@ReportIssueTime)
	END
	end
	ELSE
		RETURN -1


--(4) Get Report by ReportStatus --
GO
create proc usp_Reports_SelectByPatientID  @PatientID INT
as
	IF (@PatientID IS NOT NULL)
	BEGIN
		select * from Reports
		where  ReportStatus=1 AND  PatientID = @PatientID
	END
	ELSE
		RETURN -1
--(5) Get Report by ReportTitleAndStatus --
GO
create proc usp_Reports_SelectByReportTitleAndStatus  @ReportTitle NVARCHAR(64),
 @ReportStatus NVARCHAR(64)
as
	IF (@ReportTitle IS NOT NULL AND @ReportStatus IS NOT NULL)
	BEGIN
		select * from Reports
		where ReportTitle = @ReportTitle AND ReportStatus = @ReportStatus
	END
	ELSE
		RETURN -1
GO
create proc usp_Reports_Delete 
 @ReportID INT,
  @responseCode NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT

as
BEGIN TRY
	IF (@ReportID IS NOT NULL)
	BEGIN
		UPDATE Reports
		SET ReportStatus = 99
		where ReportID = @ReportID AND  ReportStatus=1
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


-- END of Reports SP --