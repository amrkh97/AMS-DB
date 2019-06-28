-- Assignment Stored Procedures --
-- (1) Get All Assignments --
GO
Create proc usp_Assignments_SelectAll 
as
	select * from Assignment
-- (2.1) Get Assignment By VehicleVIN --
GO
create proc usp_Assignment_SelectByVehicleVIN  @VehicleVIN INT
as
	IF (@VehicleVIN IS NOT NULL)
	BEGIN
		select * from Assignment
		where VehicleVIN = @VehicleVIN
	END
	ELSE
		RETURN -1
-- (2.2) Get Assignment By YelloPadID--
GO
create proc usp_Assignment_SelectByYelloPadID  @YelloPadID NVARCHAR(64)
as
	IF (@YelloPadID IS NOT NULL)
		BEGIN
			select * from Assignment
			where YelloPadID = @YelloPadID
		END
	ELSE
		RETURN -1
-- (2.3) Get Assignment By DriverSSN --
GO
create proc usp_Assignment_SelectByDriverSSN @DriverSSN INT
as
    IF (@DriverSSN IS NOT NULL)
	    BEGIN
	        select * from Assignment
	        where DriverSSN = @DriverSSN
		END
	ELSE
		RETURN -1	
-- (2.4) Get Assignment By ParamedicSSN --
GO
create proc usp_Assignment_SelectByParamedicSSN @ParamedicSSN INT
as
    IF (@ParamedicSSN IS NOT NULL)
	    BEGIN
	        select * from Assignment
	        where ParamedicSSN = @ParamedicSSN
		END
	ELSE
		RETURN -1	
-- (3) Insert Assignment --
GO
CREATE PROC usp_Assignment_Insert 
	@VehicleVIN INT,
	@YelloPadID NVARCHAR(64),
    @DriverSSN INT,
    @ParamedicSSN INT 
as
	IF (@VehicleVIN IS NOT NULL )
		BEGIN
			INSERT INTO Assignment (VehicleVIN,YelloPadID,DriverSSN,ParamedicSSN)
			values (@VehicleVIN,@YelloPadID,@DriverSSN,@ParamedicSSN)
		END
	ELSE
		return -1
-- (4) Update Assignment --
GO
CREATE PROC usp_Assignment_Update
	@VehicleVIN INT,
	@YelloPadID NVARCHAR(64),
    @DriverSSN INT,
    @ParamedicSSN INT 
as
	IF (@VehicleVIN IS NOT NULL )
		BEGIN
			UPDATE Assignment
			SET 
			YelloPadID = ISNULL(@YelloPadID,YelloPadID),
			DriverSSN = ISNULL(@DriverSSN,DriverSSN),
			ParamedicSSN = ISNULL(@ParamedicSSN,ParamedicSSN)
			WHERE VehicleVIN = @VehicleVIN
		END
	ELSE
		return -1
-- (5) Delete Assignment--
GO
create proc usp_Assignment_Delete  @VehicleVIN NVARCHAR(64)
as
	IF (@VehicleVIN IS NOT NULL)
	BEGIN
		UPDATE Assignment
		SET AssignmentStatus = 99
		where VehicleVIN = @VehicleVIN
	END
	ELSE 
		RETURN -1
--
-- Assignment Stored Procedure End --