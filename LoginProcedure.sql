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
				-- Found the user using email or PAN or National ID
					BEGIN
						SET @userID = (SELECT EID FROM Employee WHERE (Email=@EmailOrPAN OR PAN = @EmailOrPAN OR NationalID=@EmailOrPAN) AND (HashPassword=@HashPassword))
						IF(@userID IS NULL)
						-- Wrong Password
							BEGIN
								SET @responseMessage='Incorrect password'
								SELECT @return_Hex_value = '02'
							END
						ELSE
						BEGIN
						-- Correct password, so check if he's already logged in
							SET @status=(SELECT EmployeeStatus from Employee WHERE EID=@userID)
							IF(@status = 0)
							-- Not logged in, so login successful, send his type to backend and jobID
							-- And set status to 1
								BEGIN
									SET @responseMessage='User logged in successfully'
									SELECT @return_Hex_value = '00'
									SET @JobID = (SELECT JobID from Employee where EID = @userID)
									SET @employeeID = @userID
									UPDATE Employee SET EmployeeStatus = 1 WHERE EID = @userID
									UPDATE Employee SET LogInTStamp = GETDATE() WHERE EID = @userID
								END
							ELSE IF(@status = 1)
							-- Already logged in, so can't continue
								BEGIN
									SET @responseMessage='User is logged in somewhere'
									SELECT @return_Hex_value = '03'
								END
							ELSE IF(@status = 2)
							-- Not verrified
								BEGIN
									SET @responseMessage='This user is not verified'
									SELECT @return_Hex_value = '04'
								END
							ELSE
								BEGIN
									SET @responseMessage='User status undefined'
									SELECT @return_Hex_value = 'FE'
								END
					END
					END
				ELSE
				-- Didn't find the user using email or PAN or National ID
				-- Wrong Email
					BEGIN
						SET @responseMessage='No user found with given Email or PAN or National ID'
						SELECT @return_Hex_value = '01'
						return 1
					END
			END TRY
			BEGIN CATCH
					SELECT @return_Hex_value='FF', @responseMessage='CATCH BLOCK: ' + ERROR_MESSAGE()
					return -1;
			END CATCH
		END
	ELSE 
		return -1
END
GO
EXEC usp_Employee_Login  @EmailOrPAN='mxitpewz.fasigoi@jfukjzhbr.jhvwti.net',@HashPassword = '123456789'