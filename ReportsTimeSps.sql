----------------------------------------------------
use KAN_AMO;
GO
CREATE OR ALTER proc usp_Report_By_Full_Time  @ReportIssueTime DATETIME
as
	IF (@ReportIssueTime IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND	(ReportIssueTime=@ReportIssueTime)
end
	ELSE
		RETURN -1
-------------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year  @ReportCreationYear int
as
	IF (@ReportCreationYear IS NOT NULL)
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
	end
ELSE
	RETURN -1
------------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month   @ReportCreationYear int, @ReportCreationMonth int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth is not null))
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear)
			and(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month_Day  @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL))
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay)
end
	ELSE
		RETURN -1
------------------------------------------------
GO
CREATE OR ALTER proc usp_Report_By_Year_Month_Day_Hour   @ReportCreationYear int, @ReportCreationMonth int,@ReportCreationDay int,@ReportCreationHour int
as
	IF ((@ReportCreationYear IS NOT NULL) and (@ReportCreationMonth IS NOT NULL) and (@ReportCreationDay IS NOT NULL) and (@ReportCreationHour is not null) )
		BEGIN	
			select * from Reports
			where ReportStatus='00' AND (DatePart(yy,ReportIssueTime) = @ReportCreationYear) and
			(DatePart(mm,ReportIssueTime) = @ReportCreationMonth)
			and (DatePart(dd,ReportIssueTime) = @ReportCreationDay
			and (DatePart(hh,ReportIssueTime) = @ReportCreationHour))
end
	ELSE
		RETURN -1
--------------------------------------------------