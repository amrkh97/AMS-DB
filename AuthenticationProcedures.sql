-- Important note
-- EmployeeStatus is currently of type INT
-- Change it to NVARCHAR
-- And update code accordingly

GO
CREATE OR ALTER PROC usp_Employee_Login 
	@EmailOrPAN NVARCHAR(128),
	@HashPassword NVARCHAR(128),
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,
	@JobID NVARCHAR(64)='' OUTPUT,
	@employeeID NVARCHAR(64)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @userID INT
	DECLARE @status INT
	
	IF (@EmailOrPAN IS NOT NULL AND @HashPassword IS NOT NULL)
	BEGIN
		BEGIN TRY
			
			IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN)
			BEGIN
				-- Found the user using email or PAN or National ID
				SET @userID = (SELECT EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))
				
				IF(@userID IS NULL)
				BEGIN
					-- Wrong Password
					SET @responseMessage='Incorrect password'
					SELECT @return_Hex_value = '02'
				END
				
				ELSE
				BEGIN
					-- @userID IS NOT NULL
					-- Correct password, so check if he's already logged in
					SET @status=(SELECT EmployeeStatus from Employee WHERE EID=@userID)				
					IF(@status = 0) -- IF(@status = '00')
					BEGIN
						-- Not logged in, so login successful, send his type to backend and jobID
						-- And set status to 1
						SET @responseMessage='User logged in successfully'
						SELECT @return_Hex_value = '00'
						SET @JobID = (SELECT JobID from Employee where EID = @userID)
						SET @employeeID = @userID
						UPDATE Employee SET EmployeeStatus = 1 WHERE EID = @userID
						UPDATE Employee SET LogInTStamp = GETDATE() WHERE EID = @userID
					END
					ELSE IF(@status = 1) -- IF(@status = '01')
					BEGIN
						-- Already logged in, so can't continue
						SET @responseMessage='User is logged in somewhere'
						SELECT @return_Hex_value = '03'
					END
					ELSE IF(@status = 2) -- IF(@status = '02')
					BEGIN
						-- Not verrified
						SET @responseMessage='This user is not verified'
						SELECT @return_Hex_value = '04'
					END
					ELSE
					BEGIN
						-- Unknown status
						SET @responseMessage='User status undefined'
						SELECT @return_Hex_value = 'FE'
					END
				END
			END
			ELSE
			BEGIN
			-- Didn't find the user using Email or PAN or National ID
			-- Wrong Email
				SET @responseMessage='No user found with given Email or PAN or National ID'
				SELECT @return_Hex_value = 'FF'
				return -1
			END
		END TRY
		
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			return -1
		END CATCH
	END
	
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		return -1
	END
END

GO
CREATE OR ALTER PROC usp_Employee_Logout
	@userID INT,
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @status INT
	IF (@userID IS NOT NULL)
	BEGIN
		BEGIN TRY
			IF EXISTS (SELECT TOP 1 EID FROM Employee WHERE EID=@userID)
			BEGIN
				-- Found the user using userID
				SET @status=(SELECT EmployeeStatus from Employee WHERE EID=@userID)
				
				IF(@status='01')
				BEGIN
					-- Right Status
					UPDATE Employee SET EmployeeStatus = 0 WHERE EID = @userID
					SET @responseMessage='Logged out successfully'
					SELECT @return_Hex_value = '00'
				END
				ELSE IF(@status='00')
				BEGIN
					-- User already logged out
					SET @responseMessage='Wrong user status; User is already logged out'
					SELECT @return_Hex_value = '01'
				END
				ELSE IF(@status='02')
				BEGIN
					-- User awaiting verification
					SET @responseMessage='Wrong user status; User is awaiting verification'
					SELECT @return_Hex_value = '02'
				END
				ELSE
				BEGIN
					-- Unknown status
					SET @responseMessage='Unknown user status'
					SELECT @return_Hex_value = 'FE'
				END
			END
			ELSE
			BEGIN
				-- Didn't find the user using @userID
				SET @responseMessage='No user found with given ID'
				SELECT @return_Hex_value = 'FF'
			END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			return -1;
		END CATCH
	END
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: User ID is NULL'
		return -1
	END
END

GO
CREATE OR ALTER PROC usp_Employee_Signup
	@firstName NVARCHAR(32),
	@lastName NVARCHAR(32),
	@dateOfBirth DATE,
	@email NVARCHAR(128),
	@password NVARCHAR(128),
	@gender NVARCHAR(1),
	@contactNumber NVARCHAR(64),
	@country NVARCHAR(32),
	@city NVARCHAR(32),
	@state NVARCHAR(32),
	@street NVARCHAR(64),
	@postalCode VARCHAR(20),
	@pan NVARCHAR(20) = NULL,
	@nationalID NVARCHAR(14) = NULL,
	@job INT,
	@image NVARCHAR(MAX) = NULL,
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @userID INT
	DECLARE @status INT
	IF (@email IS NOT NULL AND @password IS NOT NULL)
	BEGIN
		-- Check email is not already used
		BEGIN TRY
			IF EXISTS (SELECT TOP 1 Email FROM Employee WHERE Email=@email)
			BEGIN
				-- Found a user using this Email
				-- ERROR: Already signed up
				SET @responseMessage='User already registered. Try signing in'
				SELECT @return_Hex_value = 'FF'
			END
			ELSE
			BEGIN
				-- Email was not used before
				-- Insert into DB
				INSERT INTO Employee (Fname,Lname,BDate,Email,HashPassword,Gender,ContactNumber,Country,City,AddressState,AddressStreet,AddressPcode,PAN,NationalID,JobID,Photo)
				values (@firstName,@lastName,@dateOfBirth,@email,@password,@gender,@contactNumber,@country,@city,@state,@street,@postalCode,@pan,@nationalID,@job,@image)
				SET @responseMessage='Signed Up. Check Email for Verification'
				SELECT @return_Hex_value = '00'
			END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			return -1;
		END CATCH
	END
	ELSE
	BEGIN
		-- Email or Password is NULL
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		return -1
	END
END