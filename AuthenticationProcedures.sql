USE KAN_AMO
GO
CREATE OR ALTER PROC usp_Employee_Login
	@EmailOrPAN NVARCHAR(128),
	@HashPassword NVARCHAR(128),

	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT,

	@jobID INTEGER = -1 OUTPUT,
	@title NVARCHAR(256) = '' OUTPUT,
	@employeeID Integer = -1 OUTPUT,
	@userPhoto NVARCHAR(MAX) = '' OUTPUT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT on
	DECLARE @userID INT
	DECLARE @status NVARCHAR(32)
	Declare @inStamp DATETIME

	IF (@EmailOrPAN IS NOT NULL AND @HashPassword IS NOT NULL)
	BEGIN
		IF ((SELECT(LEN(@HashPassword))) > 7 )
		BEGIN
			BEGIN TRY

			IF EXISTS (SELECT *
			FROM EmployeeRegistration
			WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN))
				BEGIN
					SET @userID = (SELECT EID
					FROM EmployeeRegistration
					WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))

					SET @status = (SELECT LogInStatus
					FROM Employee
					WHERE EID=@userID)

					IF(@status = '02')
						BEGIN
						-- Not verrified
						SET @responseMessage='This user is not verified'
						SELECT @return_Hex_value = '04'
						RETURN 4
					END
				END
				
				IF EXISTS (SELECT *
			FROM Employee
			WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN))
				BEGIN
				-- Found the user using email or PAN or National ID
				SET @userID = (SELECT EID
				FROM Employee
				WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))
				IF(@userID IS NULL)
					BEGIN
					-- Wrong Password
					SET @responseMessage='Incorrect password'
					SELECT @return_Hex_value = '02'
					RETURN -1;
				END
					
					ELSE
					BEGIN
					-- @userID IS NOT NULL
					-- Correct password, so check if he's already logged in
					SET @status=(SELECT LogInStatus
					FROM Employee
					WHERE EID=@userID)
					IF(@status = '00')
						BEGIN
						-- Not logged in, so login successful, send his type to backend and jobID
						-- And set status to 1
						SET @responseMessage='User logged in successfully'
						SELECT @return_Hex_value = '00'
						SET @jobID = (SELECT JobID
						FROM Employee
						WHERE EID = @userID)
						SET @title = (SELECT Title
						FROM Jobs
						WHERE JobID = @jobID)
						SET @employeeID = @userID
						SET @userPhoto = (SELECT Photo
						FROM Employee
						WHERE EID = @userID)
						UPDATE Employee SET LogInStatus = '01' WHERE EID = @userID
						SET @inStamp = GETDATE()
						UPDATE Employee SET LogInTStamp = @inStamp WHERE EID = @userID
						INSERT INTO dbo.EmployeeLogs
							(
							EmployeeID,
							LogInTime
							)
						VALUES(
								@userID,
								@inStamp
							)

						RETURN 0
					END
					IF(@status = '01')
						BEGIN
						-- Already logged in, so can't continue
						SET @responseMessage='User is logged in somewhere'
						SELECT @return_Hex_value = '03'
						RETURN 3
					END
					IF(@status = '02')
						BEGIN
						-- Not verrified
						SET @responseMessage='This user is not verified'
						SELECT @return_Hex_value = '04'
						RETURN 4
					END
						ELSE
						BEGIN
						-- Unknown status
						SET @responseMessage='User status undefined'
						SELECT @return_Hex_value = 'FE'
						RETURN -1
					END
				END
			END
				ELSE
				BEGIN
				-- Didn't find the user using Email or PAN or National ID
				-- Wrong Email
				SET @responseMessage='No user found with given Email or PAN or National ID'
				SELECT @return_Hex_value = 'FF'
				RETURN -1

			END
			END TRY
			
			BEGIN CATCH
				SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
				RETURN -1
			END CATCH
		END
		ELSE
		BEGIN
			SELECT @return_Hex_value='FB', @responseMessage='Password length is less than 8'
			RETURN -1
		END
	END
	
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		RETURN -1
	END
END

-- Logout --
GO
CREATE OR ALTER PROC usp_Employee_Logout
	-- @userID INT,
	@dummyToken NVARCHAR(128),
	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH
	ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @status NVARCHAR(32)
	Declare @outStamp DATETIME
	-- IF (@userID IS NOT NULL)
	IF (@dummyToken IS NOT NULL)
	BEGIN
		BEGIN TRY
			-- IF EXISTS (SELECT * FROM Employee WHERE EID=@userID)
			IF EXISTS (SELECT *
		FROM Employee
		WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
			BEGIN
			-- Found the user using userID
			-- SET @status=(SELECT LogInStatus FROM Employee WHERE EID=@userID)
			SET @status=(SELECT LogInStatus
			FROM Employee
			WHERE Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
			IF(@status='01')
				BEGIN
				-- Right Status
				-- UPDATE Employee SET LogInStatus = '00' WHERE EID = @userID
				-- UPDATE Employee SET LogOutStamp = GETDATE() WHERE EID = @userID
				UPDATE dbo.Employee SET LogInStatus = '00' WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
				SET @outStamp = GETDATE()
				UPDATE dbo.Employee SET LogOutStamp = @outStamp WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken)
				SET @responseMessage='Logged out successfully'
				SELECT @return_Hex_value = '00'
				UPDATE EmployeeLogs
					SET LogOutTime = @outStamp
					WHERE EmployeeID = (SELECT EID
					FROM Employee
					WHERE (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
					AND LogInTime= (SELECT LogInTStamp
					FROM Employee
					where (Email=@dummyToken OR PAN=@dummyToken OR NationalID=@dummyToken))
				RETURN 0
			END
				ELSE IF(@status='00')
				BEGIN
				-- User already logged out
				SET @responseMessage='Wrong user status; User is already logged out'
				SELECT @return_Hex_value = '01'
				RETURN 1
			END
				ELSE IF(@status='02')
				BEGIN
				-- User awaiting verification
				SET @responseMessage='Wrong user status; User is awaiting verification'
				SELECT @return_Hex_value = '02'
				RETURN 2
			END
				ELSE
				BEGIN
				-- Unknown status
				SET @responseMessage='Unknown user status'
				SELECT @return_Hex_value = 'FE'
				RETURN -1
			END
		END
			ELSE
			BEGIN
			-- Didn't find the user using @userID
			-- SET @responseMessage='No user found with given ID'
			SET @responseMessage='No user found with given email or pan or national id'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			RETURN -1
		END CATCH
	END
	ELSE
	BEGIN
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: User ID is NULL'
		RETURN -1
	END
END

-- SignUp --
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
	@jobID INT,
	@photo NVARCHAR(MAX) = NULL,

	@return_Hex_value NVARCHAR(2)='FF' OUTPUT,
	@responseMessage NVARCHAR(128)='' OUTPUT
WITH
	ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @userID INT
	DECLARE @status NVARCHAR(32)
	IF (@email IS NOT NULL AND @password IS NOT NULL)
	BEGIN
		-- Check email is not already used
		BEGIN TRY
			IF (@pan IS NOT NULL)
			BEGIN
			IF ( (SELECT(LEN(@pan))) < 16 OR (SELECT(LEN(@pan))) > 20)
				BEGIN
				SET @responseMessage='PAN length is not between 16 and 20 numbers'
				SELECT @return_Hex_value = 'F8'
				RETURN -1
			END
				ELSE
				BEGIN
				IF EXISTS (SELECT *
				FROM Employee
				WHERE PAN=@pan)
					BEGIN
					-- Found a user using this PAN
					SET @responseMessage='A registered user is using this PAN'
					SELECT @return_Hex_value = 'F9'
					RETURN -1
				END
			END
		END
			
			IF (@nationalID IS NOT NULL)
			BEGIN
			IF ( (SELECT(LEN(@nationalID))) <> 14)
				BEGIN
				SET @responseMessage='National ID length is not 14 numbers'
				SELECT @return_Hex_value = 'FA'
				RETURN -1
			END
				ELSE
				BEGIN
				IF EXISTS (SELECT *
				FROM Employee
				WHERE NationalID=@nationalID)
					BEGIN
					-- Found a user using this National ID
					SET @responseMessage='A registered user is using this National ID'
					SELECT @return_Hex_value = 'FB'
					RETURN -1
				END
			END
		END
			
			IF EXISTS (SELECT *
		FROM Employee
		WHERE Email=@email)
			BEGIN
			-- Found a user using this Email
			-- ERROR: Already signed up
			SET @responseMessage='User already registered with this email. Try signing in'
			SELECT @return_Hex_value = 'FF'
			RETURN -1
		END
			ELSE
			BEGIN
			-- Email was not used before
			-- Insert into DB
			INSERT INTO EmployeeRegistration
				(Fname,Lname,BDate,Email,HashPassword,Gender,ContactNumber,Country,City,AddressState,AddressStreet,AddressPcode,PAN,NationalID,JobID,Photo)
			values
				(@firstName, @lastName, @dateOfBirth, @email, @password, @gender, @contactNumber, @country, @city, @state, @street, @postalCode, @pan, @nationalID, @jobID, @photo)
			SET @responseMessage='Signed Up. Check Email for Verification'
			SELECT @return_Hex_value = '00'
			RETURN 0
		END
		END TRY
		BEGIN CATCH
			SELECT @return_Hex_value='FC', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
			RETURN -1
		END CATCH
	END
	ELSE
	BEGIN
		-- Email or Password is NULL
		SELECT @return_Hex_value='FD', @responseMessage='FAILED: Email or Password is NULL'
		RETURN -1
	END
END
