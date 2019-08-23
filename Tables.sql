USE KAN_AMO;
GO

--CREATE TABLE ResponseStatuses
--(
--	ResponseStatusID NVARCHAR(32),
--	StatusName NVARCHAR(64),
--	StatusNote NVARCHAR(256)

--	PRIMARY KEY (ResponseStatusID)
--);

CREATE TABLE IncidentTypes
(
	IncidentTypeID INT IDENTITY,
	TypeName NVARCHAR(32),
	TypeNote NVARCHAR(256)

		PRIMARY KEY (IncidentTypeID)
);

INSERT INTO IncidentTypes
	(TypeName, TypeNote)
VALUES

	(N'هبوط', N'هبوط'),
	(N'علاج كيميائى/اشعاعى', N'علاج كيميائى/اشعاعى'),
	(N'ولادة', N'ولادة'),
	(N'تصادم سيارة/عدة سيارات', N'تصادم سيارة/عدة سيارات'),
	(N'نقل محافظات مستشفيات', N'نقل محافظات مستشفيات'),
	(N'انقلاب/سقوط مركبه', N'انقلاب/سقوط مركبه'),
	(N'نقل اجراء عمليات', N'نقل اجراء عمليات'),
	(N'كسر', N'كسر'),
	(N'احتباس بولى', N'احتباس بولى'),
	(N'شكاوى', N'شكاوى'),
	(N'حريق', N'حريق'),
	(N'حروق', N'حروق'),
	(N'جلطة', N'جلطة'),
	(N'حادث طريق', N'حادث طريق'),
	(N'حادث غرق', N'حادث غرق'),
	(N'حضانة أكسجين', N'حضانة أكسجين'),
	(N'حضانة تنقس صناعى', N'حضانة تنفس صناعى'),
	(N'خدمة طبية-خدمات طبية و رعاية', N'خدمة طبية-خدمات طبية و رعاية'),
	(N'سقوط من مرتفع', N'سقوط من مرتفع'),
	(N'ارتفاع درجة الحرارة', N'ارتفاع درجة الحرارة'),
	(N'ارتفاع ضغط الدم', N'ارتفاع ضغط الدم'),
	(N'أزمة قلبية', N'أزمة قلبية'),
	(N'غسبل كلوي', N'غسبل كلوي'),
	(N'غيبوبة/اغماء', N'غيبوبة/اغماء'),
	(N'قئ دموى', N'قئ دموى'),
	(N'قئ و اسهال', N'قئ و اسهال'),
	(N'متابعة مستشفى', N'متابعة مستشفى'),
	(N'مشاجرة/اعتداء', N'مشاجرة/اعتداء'),
	(N'مخص كلوي/معوي', N'مخص كلوي/معوي'),
	(N'نزيف', N'نزيف'),
	(N'اشتعال سيارة', N'اشتعال سيارة'),
	(N'ألم بالصدر', N'ألم بالصدر'),
	(N'تقل اخر خدمات مصاحبة', N'تقل اخر خدمات مصاحبة'),
	(N'نقل أشعة/عيادات/تحاليل', N'نقل أشعة/عيادات/تحاليل'),
	(N'نقل للأشعة أو التحاليل', N'نقل للأشعة أو التحاليل'),
	(N'نقل محافظات/سفريات', N'نقل محافظات/سفريات'),
	(N'نقل من سكن الى سكن', N'نقل من سكن الى سكن'),
	(N'نقل من سكن الى مستشفى', N'نقل من سكن الى مستشفى'),
	(N'نقل من مستشفى للسكن', N'نقل من مستشفى للسكن'),
	(N'نقل من مستشفى الى مستشفى', N'نقل من مستشفى الى مستشفى'),
	(N'انهيار مبنى', N'انهيار مبنى'),
	(N'تسمم', N'تسمم'),
	(N'تشنجات و صرع', N'تشنجات و صرع'),
	(N'تصادم بشخص/أشخاص', N'تصادم بشخص/أشخاص'),
	(N'صعق كهربائى', N'صعق كهربائى'),
	(N'ضيق تنفس', N'ضيق تنفس'),
	(N'غرق شخص', N'غرق شخص'),
	(N'غريق', N'غريق'),
	(N'استفسارات عن مفقودات', N'استفسارات عن مفقودات'),
	(N'استفسارات عن مفقودين', N'استفسارات عن مفقودين'),
	(N'استفسارات أخرى', N'استفسارات أخرى'),
	(N'أخرى', N'أخرى')

CREATE TABLE Priorities
(
	PrioritYID INT IDENTITY,
	PriorityName NVARCHAR(32),
	PriorityNote NVARCHAR(256)

		PRIMARY KEY (PrioritYID)
);

INSERT INTO Priorities
	(PriorityName, PriorityNote)
VALUES
	('Urgent', '100%'),
	('High', '80%'),
	('Normal', '50%'),
	('Low', '20%')

CREATE TABLE AlarmLevels
(
	AlarmLevelID INT IDENTITY,
	AlarmLevelName NVARCHAR(32),
	AlarmLevelNote NVARCHAR(256)

		PRIMARY KEY (AlarmLevelID)
);

INSERT INTO AlarmLevels
	(AlarmLevelName, AlarmLevelNote)
VALUES
	('1', 'Danger'),
	('2', 'Quick'),
	('3', 'Instant'),
	('4', 'Fire')

CREATE TABLE Jobs
(
	JobID INT,
	Title NVARCHAR(32),
	Note NVARCHAR(64),
	JobDescription NVARCHAR(256),

	PRIMARY KEY (JobID)
);

INSERT INTO Jobs
	(JobID,Title,JobDescription)
VALUES

	(0, 'System Manager', 'Manager of the whole system'),
	(1, 'Movement Manager', 'Responsible for managing the day to day operation'),
	(2, 'Paramedic', 'Saves people''s lives'),
	(3, 'Driver', 'Drives Ambulance'),
	(4, 'Operator', 'Adds incident and locations')

CREATE TABLE PaymentMethods
(
	MethodName NVARCHAR(32),
	TreatmentImage VARBINARY(MAX),

	PRIMARY KEY (MethodName)
);

CREATE TABLE PharmaCompany
(
	CompanyID INT IDENTITY,
	CompanyName NVARCHAR(64),
	ContactPerson NVARCHAR(32),
	CompanyAddress NVARCHAR(128),
	CompanyPhone NVARCHAR(32),
	CompanyStatus NVARCHAR(32) DEFAULT '00'

		PRIMARY key (CompanyID)
);
INSERT INTO PharmaCompany
	(CompanyName,ContactPerson,CompanyAddress,CompanyPhone)
VALUES
	('F1', 'Amr', '18, Ibn Al Nafees', '01141837032'),
	('F2', 'Salah', '15, Ibn Al Nafees', '01141837032')


CREATE TABLE Medicine
(
	BarCode NVARCHAR(64),
	MedicineName NVARCHAR(64) NOT NULL UNIQUE,
	CountInStock Integer,
	Price decimal(5,2),
	Implications NVARCHAR(MAX),
	MedicineUsage NVARCHAR(MAX),
	SideEffects NVARCHAR(MAX),
	ActiveComponent NVARCHAR(MAX),
	MedicineStatus NVARCHAR(32) DEFAULT '00',
	ExpirationDate date,
	CompanyID INT,

	PRIMARY KEY(BarCode),
	CHECK (Price > 0),
	CHECK (CountInStock >= 0),
	FOREIGN KEY(CompanyID) REFERENCES PharmaCompany(CompanyID)

);

INSERT INTO Medicine
	(BarCode,MedicineName,CountInStock,Price,Implications,MedicineUsage,SideEffects,ActiveComponent,ExpirationDate,CompanyID)
VALUES

	('6221508010313', 'Ranitidine', 50, 22.5, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2025-08-17', 1),
	('3400938341836', 'Daflon500', 36, 33.5, 'For treatment of gastric', 'For treatment of Headache', 'Digestive Manifestations', 'H2O', '2021-12-12', 2),
	('6221043012414', 'VITACID C', 78, 25.00, 'Heart operations', 'For treatment of cold', 'Digestive Manifestations', 'H2O', '2020-04-17', 1),
	('6221060001507', 'Candistan', 15, 33.5, 'Beautify the skin', 'For treatment of skin burning', 'Digestive Manifestations', 'H2O', '2023-03-01', 2),
	('6221180000039', 'ZITHROMAX', 10, 55.45, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2022-02-15', 1),
	('6221508121118', 'Sediproct', 13, 16.8, 'For treatment of haemorrhoids', 'For treatment of haemorrhoids', 'Digestive Manifestations', 'H2O', '2025-05-05', 2),
	('6221077072316', 'Lignocaine', 40, 21.00, 'Local anaesthetic', 'For Analgesia', 'Digestive Manifestations', 'H2O', '2028-10-24', 1),
	('3582910065654', 'No-SPA 40mg', 17, 10.5, 'For treatment of haemorrhoids', 'For treatment of haemorrhoids', 'Digestive Manifestations', 'H2O', '2019-01-01', 2),
	('3400926629526', 'Ketoprofene', 45, 16.36, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2030-10-30', 1),
	('3400939541778', 'Omeprazole', 25, 44.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2029-09-22', 2),
	('6224001050381', 'Remowax', 9, 7.5, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2028-08-14', 1),
	('6221050130224', 'Ultracaine', 23, 25.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2027-07-07', 2),
	('0123456748795', 'Flagyl', 30, 13.6, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2026-06-19', 1),
	('5879811144556', 'Profen', 50, 22.5, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2024-05-29', 2),
	('8899205597136', 'Cataflam', 29, 15.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2023-12-25', 1),
	('4548777410003', 'Ganaton', 10, 80, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2021-03-04', 2),
	('1249878710832', 'Curam', 22, 22.5, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2020-06-08', 1),
	('1147845215499', 'VITAMIN E 400mg', 15, 12.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2029-12-25', 2),
	('4815687500000', 'Antinal 200mg', 7, 15.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2026-09-11', 1),
	('7700289996335', 'Zithrokan', 13, 18.00, 'For treatment of gastric', 'For treatment of doudenal ulcer', 'Digestive Manifestations', 'H2O', '2022-04-07', 2)

CREATE TABLE Batch
(
	BatchID BIGINT,
	ExpiryDate DATE,
	OrderDate DATETIME DEFAULT getdate(),
	BatchStatus NVARCHAR(32) DEFAULT '00',
	PRIMARY KEY(BatchID)
);

CREATE TABLE BatchMedicine
(
	EntryID INT IDENTITY,
	BatchID BIGINT,
	MedicineBCode NVARCHAR(64),
	Quantity INT,
	FOREIGN KEY(BatchID) REFERENCES Batch(BatchID),
	FOREIGN KEY(MedicineBCode) REFERENCES Medicine(BarCode)

);

CREATE TABLE Yellopad
(
	YelloPadID INT IDENTITY,
	YelloPadUniqueID NVARCHAR(16) NOT NULL UNIQUE,
	YellopadNetworkcardNo NVARCHAR(64),
	YelloPadorderdate DATE,
	YelloPadorderPatch NVARCHAR(64),
	YelloPadorderby NVARCHAR(64),
	YelloPadmanufactureDate date,
	YelloPadmanufacturePatch NVARCHAR(64),
	YelloPadmanufactureBy NVARCHAR(64),
	YelloPad1stdeploymentdate date,
	YelloPadLastmaintenanceDate date,
	YelloPadMaintenanceNature NVARCHAR(128),
	YelloPadMaintenanceNote NVARCHAR(128),
	YelloPadStatus NVARCHAR(32) NOT NULL DEFAULT '00',
	YelloPadPicture NVARCHAR(500),
	YelloPadLatitude NVARCHAR(32),
	YelloPadLongitude NVARCHAR(32),
	DatabaseStatus NVARCHAR(2) DEFAULT '00',
	PRIMARY KEY (YelloPadID)
);

INSERT INTO dbo.Yellopad
	(
	YelloPadUniqueID,
	YellopadNetworkcardNo,
	YelloPadMaintenanceNote
	)
VALUES
	( N'1d11c1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'1', -- YellopadNetworkcardNo - nvarchar(64)
		'device 6' -- Yellopad device Number 
	),
	( N'1c05a1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'2', -- YellopadNetworkcardNo - nvarchar(64)
		'device 5' -- Yellopad device Number 
	),
	( N'151ba1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'3', -- YellopadNetworkcardNo - nvarchar(64)
		'device 8' -- Yellopad device Number 
	),
	( N'1b06a1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'4', -- YellopadNetworkcardNo - nvarchar(64)
		'device 3' -- Yellopad device Number 
	),
	( N'1b18a1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'5', -- YellopadNetworkcardNo - nvarchar(64)
		'device 7' -- Yellopad device Number 
	),
	( N'1208a1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'6', -- YellopadNetworkcardNo - nvarchar(64)
		'device 11' -- Yellopad device Number 
	),
	( N'1f16a1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'7', -- YellopadNetworkcardNo - nvarchar(64)
		'device 2' -- Yellopad device Number
	),
	( N'190209d4e3167aba', -- YelloPadUniqueID - nvarchar(16)
		N'8', -- YellopadNetworkcardNo - nvarchar(64)
		'device 1' -- Yellopad device Number
	),
	( N'0a0d11d4e3167aba', -- YelloPadUniqueID - nvarchar(16)
		N'9', -- YellopadNetworkcardNo - nvarchar(64)
		'device 10' -- Yellopad device Number
	),
	( N'1702c1d4ea9b8e5b', -- YelloPadUniqueID - nvarchar(16)
		N'10', -- YellopadNetworkcardNo - nvarchar(64)
		'device 4' -- Yellopad device Number
	),
	( N'240d11d4e3167aba', -- YelloPadUniqueID - nvarchar(16)
		N'11', -- YellopadNetworkcardNo - nvarchar(64)
		'device 9' -- Yellopad device Number
	),
	(
		N'1d17a1d4ea9b8e5b',
		N'12',
		'device 12'
	),
	(
		N'180dc1d4ea9b8e5b',
		N'13',
		'device 13'
	),
	(
		N'170da1d4ea9b8e5b',
		N'14',
		'device 14'
	),
	(
		N'050da1d4ea9b8e5b',
		N'15',
		'device 15'
	),
	(
		--For Test Purposes Only
		N'Amr', -- YelloPadUniqueID - nvarchar(16)
		N'16', -- YellopadNetworkcardNo - nvarchar(64)
		'Amr' -- Yellopad device Number
	
	),
	(
		--For Test Purposes Only
		N'Kanda', -- YelloPadUniqueID - nvarchar(16)
		N'17', -- YellopadNetworkcardNo - nvarchar(64)
		'Kanda' -- Yellopad device Number
	),
	(
		--For Test Purposes Only
		N'Salah', -- YelloPadUniqueID - nvarchar(16)
		N'18', -- YellopadNetworkcardNo - nvarchar(64)
		'Salah' -- Yellopad device Number
	)

--TODO: Discuss the Vehicle Location Entry
CREATE TABLE AmbulanceVehicle
(
	VIN INT,
	Implication NVARCHAR(32),
	Make NVARCHAR(32) ,
	[Type] NVARCHAR(32) ,
	ProductionYear NVARCHAR(32) ,
	RegYear NVARCHAR(32),
	LicencePlate NVARCHAR(4),
	OwnerName NVARCHAR(128),
	LicenceStateOrProvince NVARCHAR(32),
	ServiceStartDate NVARCHAR(32),
	EngineNumber NVARCHAR(32),
	Brand NVARCHAR(32),
	ChasiahNumber NVARCHAR(32),
	Model NVARCHAR(32),
	DriverPhoneNumber NVARCHAR(32),
	VehicleStatus NVARCHAR(32) DEFAULT '00',
	AmbulanceVehiclePicture NVARCHAR(500),

	PRIMARY KEY (VIN),
	CONSTRAINT Negative_VIN CHECK (VIN > 0)
);

INSERT INTO dbo.AmbulanceVehicle
	(
	VIN,
	Make,
	Brand,
	LicencePlate,
	Model,
	OwnerName
	)
VALUES
	( 	1, -- VIN - int
		N'Mercedes', -- Make - nvarchar(32)
		N'Mercedes',--Brand - nvarchar(32)
		N'0000',--LicencePlate - NVARCHAR(4)
		N'BENZ', -- MODEL - NVARCHAR(32)
		N'Mohamed Hamed Madkor' --OwnerName - NVARCHAR(32)
	),
	(
		2,
		N'BMW',-- Make - nvarchar(32)
		N'BMW',--Brand - nvarchar(32)
		N'0001',--LicencePlate - NVARCHAR(4)
		N'6 Series Coupe', -- MODEL - NVARCHAR(32)
		N'Samer Mohamed Kabel' --OwnerName - NVARCHAR(32)
	),
	(
		3,
		N'renault',-- Make - nvarchar(32)
		N'renault',--Brand - nvarchar(32)
		N'7588',--LicencePlate - NVARCHAR(4)
		N'Megane', -- MODEL - NVARCHAR(32)
		N'Kabel Nael Makdor' --OwnerName - NVARCHAR(32)
	),
	(
		4,
		N'Fiat',-- Make - nvarchar(32)
		N'Fiat',--Brand - nvarchar(32)
		N'4128',--LicencePlate - NVARCHAR(4)
		N'124 Spider', -- MODEL - NVARCHAR(32)
		N'Amgad Amit Caren' --OwnerName - NVARCHAR(32)
	),
	(
		5,
		N'Nissan',-- Make - nvarchar(32)
		N'Nissan',--Brand - nvarchar(32)
		N'5329',--LicencePlate - NVARCHAR(4)
		N'Armada', -- MODEL - NVARCHAR(32)
		N'poe poeingham Mcpoe' --OwnerName - NVARCHAR(32)
	),
	( 6, -- VIN - int
		N'Mercedes', -- Make - nvarchar(32)
		N'Mercedes',--Brand - nvarchar(32)
		N'307B',--LicencePlate - NVARCHAR(4)
		N'BENZ', -- MODEL - NVARCHAR(32)
		N'Samer Hamed Mohamed' --OwnerName - NVARCHAR(32)


	    ),
	(
		7,
		N'BMW',-- Make - nvarchar(32)
		N'BMW',--Brand - nvarchar(32)
		N'6FR1',--LicencePlate - NVARCHAR(4)
		N'6 Series Coupe', -- MODEL - NVARCHAR(32)
		N'Kabel Mohamed Madkor' --OwnerName - NVARCHAR(32)
	),
	(
		8,
		N'renault',-- Make - nvarchar(32)
		N'renault',--Brand - nvarchar(32)
		N'904A',--LicencePlate - NVARCHAR(4)
		N'Megane', -- MODEL - NVARCHAR(32)
		N'Mohamed Nael Samer' --OwnerName - NVARCHAR(32)
	),
	(
		9,
		N'Fiat',-- Make - nvarchar(32)
		N'Fiat',--Brand - nvarchar(32)
		N'6FGR',--LicencePlate - NVARCHAR(4)
		N'124 Spider', -- MODEL - NVARCHAR(32)
		N'Emma Takin Tomenger' --OwnerName - NVARCHAR(32)
	),
	(
		10,
		N'Nissan',-- Make - nvarchar(32)
		N'Nissan',--Brand - nvarchar(32)
		N'8631',--LicencePlate - NVARCHAR(4)
		N'Armada', -- MODEL - NVARCHAR(32)
		N'Alin Alingham Mcalin' --OwnerName - NVARCHAR(32)
	)

CREATE TABLE Locations
(
	LocationID INT IDENTITY,
	FreeFormatAddress NVARCHAR(265) NOT NULL UNIQUE,
	City NVARCHAR(32),
	Longitude NVARCHAR(32),
	Latitude NVARCHAR(32),
	Street NVARCHAR(32),
	Apartement NVARCHAR(32),
	PostalCode NVARCHAR(20),
	FloorLevel NVARCHAR(20),
	HouseNumber NVARCHAR(12),
	LocationStatus NVARCHAR(32) DEFAULT '00',
	FFAEncoded NVARCHAR(MAX),

	PRIMARY KEY (LocationID)
);

CREATE TABLE Employee
(
	EID INT IDENTITY,
	Fname NVARCHAR(32),
	Lname NVARCHAR(32),
	BDate Date,
	Email NVARCHAR(128) NOT NULL UNIQUE,
	HashPassword NVARCHAR(128) NOT NULL,
	Gender NVARCHAR(1),
	ContactNumber NVARCHAR(64),
	Country NVARCHAR(32),
	City NVARCHAR(32),
	AddressState NVARCHAR(32),
	AddressStreet NVARCHAR(64),
	AddressPcode VARCHAR(20),
	SubscriptionDate DateTime DEFAULT (GETDATE()),
	PAN NVARCHAR(20),
	NationalID NVARCHAR(14),
	LogInTStamp DATETIME,
	LogOutStamp DATETIME,
	LogInGPS NVARCHAR(20),
	LogInStatus NVARCHAR(32) DEFAULT '00',
	EmployeeStatus NVARCHAR(32) DEFAULT '00',
	SuperSSN INT,
	JobID INT,
	Photo NVARCHAR(MAX) DEFAULT 'https://i.ibb.co/rGVwt7P/user-default.jpg',
	Age as DATEDIFF(YEAR, BDate, GETDATE()),

	FOREIGN KEY (SuperSSN) REFERENCES Employee(EID),
	FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
	PRIMARY KEY (EID)

);

INSERT INTO Employee
	(Email,HashPassword,PAN,NationalID,SuperSSN,JobID,Fname,Lname)
VALUES
	('admin@test.com', '12345678', null, null, 1, 0, 'Ahmed', 'Al-Gohary') ,
	--1
	('move_manager1@test.com', '91234567', null, '0121212121212', 1, 1, 'Amr', 'Khaled'),
	--2
	('move_manager2@test.com', '89123456', '0123456789012345', null, 1, 1, 'Mostafa', 'Mufeed'),
	--3
	('move_manager3@test.com', '78912345', '01234567890123', null, 1, 1, 'Ahmed', 'Salah'),
	--4
	('move_manager4@test.com', '67891234', '9876543210987654', '01234567890125', 1, 1, 'Mohamed', 'Sherif'),
	--5
	('rashad_m@test.com', '53513676', null, null, 1, 1, 'Mahmoud', 'Rashad'),
	--6
	('dewidar_manager@test.com', '1234567890mo', null, null, 1, 1, 'mohamed', 'dewidar'),
	--7
	('operator1@test.com', '91234567', null, '29704090101857', 2, 4, 'Hossam', 'Hassan'),
	--8
	('operator2@test.com', '89123456', null, null, 3, 4, 'Ibrahim', 'Hassan'),
	--9
	('operator3@test.com', '78912345', null, null, 4, 4, 'Mohamed', 'El-Sokkary'),
	--10
	('operator4@test.com', '67891234', null, null, 4, 4, 'Mohamed', 'Said'),
	--11
	('rashad_o@test.com', '53513676', null, '29704090101931', 6, 4, 'Mahmoud', 'Rashad'),
	--12
	('dewidar_operator@test.com', '1234567890mo', null, null, 7, 4, 'mohamed', 'dewidar'),
	--13
	('driver1@test.com', '91234567', null, null, 2, 3, 'Anas', 'Mohamed'),
	--14
	('driver2@test.com', '12588888', '1010101010101010', null, 3, 3, 'Ahmed', 'Amrawy'),
	--15
	('driver3@test.com', '78912345', null, '11112222333344', 4, 3, 'Kamel', 'Mohsen'),
	--16
	('driver4@test.com', '67891234', null, '12345678978945', 2, 3, 'Ahmed', 'Elgohary'),
	--17
	('driver5@test.com', '56789123', null, '55555669933214', 3, 3, 'Ahmed', 'Zaki'),
	--18
	('driver6@test.com', '45678912', null, '77715892541359', 4, 3, 'Mohamed', 'Abdelhady'),
	--19
	('driver7@test.com', '34567891', null, '01258963271408', 2, 3, 'Mahmoud', 'Rashad'),
	--20
	('driver8@test.com', '23456789', null, '40489305967281', 5, 3, 'Eman', 'Mohamed'),
	--21
	('driver9@test.com', '12345678', null, '12302020363699', 2, 3, 'Aya', 'Mohamed'),
	--22
	('driver10@test.com', '01234567', null, '89887744252664', 5, 3, 'Noha', 'Ezzat'),
	--23
	('rashad_d@test.com', '53513676', null, null, 6, 3, 'Mahmoud', 'Rashad'),
	--24
	('dewidar_driver@test.com', '1234567890mo', null, null, 7, 3, 'mohamed', 'dewidar'),
	--25
	('paramedic1@test.com', '91234567', null, null, 2, 2, 'Mohamed', 'Salah'),
	--26
	('paramedic2@test.com', '89123456', null, null, 3, 2, 'Abdelrahman', 'Ahmed'),
	--27
	('paramedic3@test.com', '78912345', '4017772008280452', null, 4, 2, 'Omar', 'Mohamed'),
	--28
	('paramedic4@test.com', '67891234', '4918012011072830', null, 2, 2, 'Hussien', 'Khaled'),
	--29
	('paramedic5@test.com', '56789123', '4325885600298917', null, 3, 2, 'Ahmed', 'Al-Gohary'),
	--30
	('paramedic6@test.com', '45678912', '1233555889966004', null, 4, 2, 'Mohamed', 'Dwidar'),
	--31
	('paramedic7@test.com', '34567891', '3366998855001258', null, 5, 2, 'Dina', 'Jouda'),
	--32
	('paramedic8@test.com', '23456789', '6699874890125969', null, 2, 2, 'Nehal', 'Hegazy'),
	--33
	('paramedic9@test.com', '12345678', '0189720283374105', null, 3, 2, 'Khalid', 'Abdalla'),
	--34
	('paramedic10@test.com', '01234567', '9874502983497779', null, 2, 2, 'Walid', 'Mohamd'),
	--35
	('rashad_p@test.com', '53513676', null, null, 6, 2, 'Mahmoud', 'Rashad'),
	--36
	('dewidar_paramedic@test.com', '1234567890mo', '9874502983497779', '', 7, 2, 'mohamed', 'dewidar'),
	--37
	('m@m.com', '12345678', '4444444444444444', '29410242104097', 2, 2, 'Mohamed', 'Sherif'),
	--38
	('aya_m@test.com', '12345678', null, null, 1, 1, 'aya', 'aya'),
	--39
	('aya_o@test.com', '12345678', null, null, 39, 4, 'aya', 'aya'),
	--40
	('aya_d@test.com', '12345678', null, null, 39, 3, 'aya', 'aya'),
	--41
	('aya_p@test.com', '12345678', null, null, 39, 2, 'aya', 'aya'),
	--42
	('eman_m@test.com', '12345678', null, null, 1, 1, 'eman', 'eman'),
	--43
	('eman_o@test.com', '12345678', null, null, 43, 4, 'eman', 'eman'),
	--44
	('eman_d@test.com', '12345678', null, null, 43, 3, 'eman', 'eman'),
	--45
	('eman_p@test.com', '12345678', null, null, 43, 2, 'eman', 'eman'),
	--46
	('khaled_m@test.com', '12345678', null, null, 1, 1, 'khaled', 'abdallah'),
	--47
	('khaled_o@test.com', '12345678', null, null, 47, 4, 'khaled', 'Hassan'),
	--48
	('khaled_d1@test.com', '12345678', null, null, 47, 3, 'khaled', 'Mostafa'),
	--49
	('khaled_p1@test.com', '12345678', null, null, 47, 2, 'khaled', 'Ahmed'),
	--50
	('khaled_d2@test.com', '12345678', null, null, 47, 3, 'khaled', 'Zaky'),
	--51
	('khaled_p2@test.com', '12345678', null, null, 47, 2, 'khaled', 'Hussien'),
	--52
	('khaled_d3@test.com', '12345678', null, null, 47, 3, 'khaled', 'Hasabelnaby'),
	--53
	('khaled_p3@test.com', '12345678', null, null, 47, 2, 'khaled', 'Amr'),
	--54
	('sameh_m@test.com', '12345678', null, null, 1, 1, 'Sameh', 'Bedir'),
	--55
	('sameh_o@test.com', '12345678', null, null, 55, 4, 'Sameh', 'Khaled'),
	--56
	('sameh_d1@test.com', '12345678', null, null, 55, 3, 'Sameh', 'Farouk'),
	--57
	('sameh_p1@test.com', '12345678', null, null, 55, 2, 'Sameh', 'Salah'),
	--58
	('sameh_d2@test.com', '12345678', null, null, 55, 3, 'Sameh', 'Mostafa'),
	--59
	('sameh_p2@test.com', '12345678', null, null, 55, 2, 'Sameh', 'Mohamed'),
	--60
	('sameh_d3@test.com', '12345678', null, null, 55, 3, 'Sameh', 'Salah'),
	--61
	('sameh_p3@test.com', '12345678', null, null, 55, 2, 'Sameh', 'Ahmed'),
	--62
	('amr_m@test.com','12345678',null,null,1,1,'Amr','Khaled'),
	--63
	('amr_o@test.com','12345678',null,null,63,4,'Amr','Khaled'),
	--64
	('amr_d@test.com','12345678',null,null,63,3,'Amr','Khaled'),
	--65
	('amr_p@test.com','12345678',null,null,63,2,'Amr','Khaled'),
	--66
	('kanda_m@test.com','12345678',null,null,1,1,'Mustafa','Kanda'),
	--67
	('kanda_o@test.com','12345678',null,null,67,4,'Mustafa','Kanda'),
	--68
	('kanda_d@test.com','12345678',null,null,67,3,'Mustafa','Kanda'),
	--69
	('kanda_p@test.com','12345678',null,null,67,2,'Mustafa','Kanda'),
	--70
	('salah_m@test.com','12345678',null,null,1,1,'Ahmed','Salah'),
	--71
	('salah_o@test.com','12345678',null,null,71,4,'Ahmed','Salah'),
	--72
	('salah_d@test.com','12345678',null,null,71,3,'Ahmed','Salah'),
	--73
	('salah_p@test.com','12345678',null,null,71,2,'Ahmed','Salah')
	--74

CREATE TABLE Incident
(
	IncidentSequenceNumber INT IDENTITY NOT NULL,
	CreationTime DATETIME DEFAULT (GETDATE()),
	IncidentType INT,
	IncidentPriority INT,
	IncidentLocationID INT,
	IncidentTime DATETIME DEFAULT (GETDATE()),
	FOREIGN KEY (IncidentType) REFERENCES IncidentTypes(IncidentTypeID),
	FOREIGN KEY (IncidentPriority) REFERENCES Priorities(PrioritYID),
	FOREIGN KEY (IncidentLocationID) REFERENCES Locations(LocationID),
	PRIMARY KEY(IncidentSequenceNumber)
);


CREATE TABLE Responses
(
	SequenceNumber INT IDENTITY,
	AssociatedVehicleVIN INT NOT NULL,
	CreationTime DATETIME DEFAULT (getdate()),
	StartLocationID INT,
	PickLocationID INT,
	DropLocationID INT,
	DestinationLocationID INT,
	RespStatus NVARCHAR(32),
	IncidentSQN INT NOT NULL,
	PrimaryResponseSQN INT,
	RespAlarmLevel INT,
	PersonCount NVARCHAR(32),

	FOREIGN KEY (AssociatedVehicleVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (StartLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (PickLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DropLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DestinationLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (IncidentSQN) REFERENCES Incident(IncidentSequenceNumber),
	FOREIGN KEY (RespAlarmLevel) REFERENCES AlarmLevels(AlarmLevelID),
	PRIMARY KEY (SequenceNumber)
);


CREATE TABLE MedicineUsedPerResponse
(
	RespSQN INT,
	BID BIGINT,
	MedBCode NVARCHAR(64),
	UsedAmt INT,
	AmbVIN INT,

	--PRIMARY KEY (RespSQN,BID),
	FOREIGN KEY (BID) REFERENCES Batch(BatchID),
	FOREIGN KEY (AmbVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (MedBCode) REFERENCES Medicine(BarCode),
	CONSTRAINT chk_MedicineUsedPerResponse_UsedAmtPositive CHECK(UsedAmt > 0 )
);

CREATE TABLE Receipt
(
	ReceiptID INT IDENTITY,
	RespSQN INT NOT NULL,
	CasheirSSN INT,
	ReceiptCreationTime DATETIME DEFAULT (GETDATE()),
	FTPFileLocation NVARCHAR(128),
	ReceiptStatus NVARCHAR(32) DEFAULT '00',
	Cost NVARCHAR(32),
	PaymentMethod NVARCHAR(32),

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (CasheirSSN) REFERENCES Employee(EID),
	FOREIGN KEY (PaymentMethod) REFERENCES PaymentMethods(MethodName),
	PRIMARY KEY(ReceiptID)
);
CREATE TABLE Patient
(
	PatientID INT IDENTITY,
	PatientFName VARCHAR(32),
	PatientLName VARCHAR(32),
	Gender NVARCHAR(1),
	Age NVARCHAR(32),
	Phone NVARCHAR(24),
	LastBenifitedTime DATETIME DEFAULT(GETDATE()),
	FirstBenifitedTime DATETIME DEFAULT(GETDATE()),
	NextOfKenName NVARCHAR(32),
	NextOfKenPhone NVARCHAR(24),
	NextOfKenAddress NVARCHAR(256),
	PatientStatus NVARCHAR(32) DEFAULT '00',
	PatientNationalID NVARCHAR(14),
	CreationTime BIGINT

	PRIMARY KEY (PatientID)

);

INSERT INTO Patient
	(PatientFName,PatientLName)
VALUES
	('john', 'doe')

CREATE TABLE MedicalRecord
(
	MedicalRecordID INT IDENTITY,
	RespSQN INT UNIQUE,
	PatientID INT,
	BloodType NVARCHAR(12),

	BloodPressure NVARCHAR(2),
	Diabetes NVARCHAR(2),
	RespiratoryDiseases NVARCHAR(2),
	Cancer NVARCHAR(2),
	CardiovascularDiseases NVARCHAR(2),
	COPD NVARCHAR(2),
	Pregnancy NVARCHAR(2),
	Other NVARCHAR(MAX),
	Dead NVARCHAR(2),
	Consciousness NVARCHAR(2),
	Breathing NVARCHAR(2),
	Capillaries NVARCHAR(2),

	Pulse NVARCHAR(12),
	BloodPressureLevel NVARCHAR(12),
	DiabetesLevel NVARCHAR(12),
	BodyTemp NVARCHAR(12),

	BreathingRate NVARCHAR(12),
	CapillariesLevel NVARCHAR(12),
	Injury NVARCHAR(MAX),
	PhysicalExaminationImage NVARCHAR(MAX),
	MedicineApplied NVARCHAR(128),
	ProcedureDoneInCar NVARCHAR(MAX),
	RecommendedProcedure NVARCHAR(MAX),
	MRStatus NVARCHAR(32) DEFAULT '00',

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	PRIMARY KEY (MedicalRecordID),
);


CREATE TABLE PatientLocations
(
	PatientID INT,
	LocationID INT,
	StatusLocation NVARCHAR(2) DEFAULT '00',

	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
	PRIMARY KEY (PatientID,LocationID)

);


CREATE TABLE Reports
(
	ReportID INT IDENTITY,
	ReportTitle VARCHAR(64) NOT NULL,
	ReportIssueTime DATETIME DEFAULT(GETDATE()),
	PatientID INT,
	ReportDestination NVARCHAR(64),
	ReportStatus NVARCHAR(32) DEFAULT '00',

	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	PRIMARY KEY (ReportID)
);


CREATE TABLE AmbulanceMap
(
	VIN INT NOT NULL,
	ParamedicID INT NOT NULL,
	DriverID INT NOT NULL,
	YelloPadID INT NOT NULL,
	StatusMap NVARCHAR(32) DEFAULT '00',
	BatchID BIGINT,

	FOREIGN KEY (VIN) REFERENCES dbo.AmbulanceVehicle(VIN),
	FOREIGN KEY (ParamedicID) REFERENCES dbo.Employee(EID),
	FOREIGN KEY (DriverID) REFERENCES dbo.Employee(EID),
	FOREIGN KEY (YelloPadID) REFERENCES dbo.Yellopad(YelloPadID),
	FOREIGN KEY (BatchID) REFERENCES dbo.Batch(BatchID)
);
CREATE TABLE Feedback
(
	FeedbackID INT IDENTITY,
	SequenceNumber INT,
	CreationTime DATETIME DEFAULT (getdate()),
	Rating float,
	DriverNote NVARCHAR(500),
	ParamedicNote NVARCHAR(500),
	FeedbackStatus NVARCHAR(32),
	FOREIGN KEY (SequenceNumber) REFERENCES Responses(SequenceNumber),
	PRIMARY KEY (FeedbackID)
);

CREATE TABLE ResponseUpdateLog
(
	RespSQN INT NOT NULL,
	RespStatusMap NVARCHAR(64),
	RespStatusTime DATETIME DEFAULT (GETDATE())

	FOREIGN KEY (RespSQN) REFERENCES dbo.Responses(SequenceNumber)
);


CREATE TABLE IncidentCallers
(
	IncidentSQN INT NOT NULL,
	CallerFName NVARCHAR(64),
	CallerLName NVARCHAR(64),
	CallerMobile NVARCHAR(11),
	CallTime DATETIME DEFAULT (GETDATE()),
	RelationToPatient NVARCHAR(32),
	PRIMARY KEY(IncidentSQN),
	FOREIGN KEY(IncidentSQN) REFERENCES dbo.Incident(IncidentSequenceNumber)
);
CREATE TABLE EmployeeLogs
(
	LogInID INT IDENTITY,
	LogInTime DATETIME,
	LogOutTime DATETIME,
	EmployeeID INT NOT NULL,
	PRIMARY KEY (LogInID),
	FOREIGN KEY(EmployeeID) REFERENCES dbo.Employee(EID)
);

--Table to handle multiple Batches on the same car.
CREATE TABLE AmbulanceBatchesMap
(
	EntryID INT IDENTITY,
	AssociatedVIN INT,
	BatchID BIGINT,
	PRIMARY KEY (EntryID),
	FOREIGN KEY (AssociatedVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (BatchID) REFERENCES Batch(BatchID)
);

CREATE TABLE EmployeeRegistration
(
	EID INT IDENTITY,
	Fname NVARCHAR(32),
	Lname NVARCHAR(32),
	BDate Date,
	Email NVARCHAR(128) NOT NULL UNIQUE,
	HashPassword NVARCHAR(128) NOT NULL,
	Gender NVARCHAR(1),
	ContactNumber NVARCHAR(64),
	Country NVARCHAR(32),
	City NVARCHAR(32),
	AddressState NVARCHAR(32),
	AddressStreet NVARCHAR(64),
	AddressPcode VARCHAR(20),
	SubscriptionDate DateTime DEFAULT (GETDATE()),
	PAN NVARCHAR(20),
	NationalID NVARCHAR(14),
	LogInStatus NVARCHAR(32) DEFAULT '02',
	EmployeeStatus NVARCHAR(32) DEFAULT '00',
	JobID INT,
	Photo NVARCHAR(MAX) DEFAULT 'https://i.ibb.co/rGVwt7P/user-default.jpg',
	Age as DATEDIFF(YEAR, BDate, GETDATE()),

	FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
	PRIMARY KEY (EID)

);

CREATE TABLE Parameters
(
	MedicineThreshold INT DEFAULT 0,
	SearchRadiusInKM INT DEFAULT 1,
	AlgoEncryption NVARCHAR(64)
);


CREATE TABLE Hospital
(
	HospitalID INT IDENTITY,
	HospitalName NVARCHAR(256),
	HospitalDescription Nvarchar(500),
	Latitude NVARCHAR(32),
	Longitude NVARCHAR(32),
	HospitalStatus NVARCHAR(2) DEFAULT '00',
	TotalBeds INT ,
	TotalAvailableBeds INT,
	TotalICUBeds INT,
	TotalAvailableICUBeds INT,
	TotalRegularBeds INT,
	TotalAvailableRegularBeds INT,
	TotalBabyBeds INT,
	TotalAvailableBabyBeds INT
	
	PRIMARY KEY(HospitalID)
);

INSERT INTO Hospital
(HospitalName,
 HospitalDescription,
 Latitude,
 Longitude,
 TotalBeds,
 TotalAvailableBeds,
 TotalICUBeds,
 TotalAvailableICUBeds,
 TotalRegularBeds,
 TotalAvailableRegularBeds,
 TotalBabyBeds,
 TotalAvailableBabyBeds)
 VALUES
 (
 N'Al Salam International',
 N'International Hospital in Maadi',
 N'29.9823175',
 N'31.2306764',
 100,
 90,
 10,
 5,
 40,
 10,
 20,
 10
 ),
 (
 N'Military Hospital',
 N'Military Hospital in Maadi',
 N'29.962458',
 N'31.2481057',
 100,
 90,
 10,
 5,
 40,
 10,
 20,
 10
 )


CREATE TABLE Equipment
(
	EquipmentName NVARCHAR(200),
	EquipmentDescription NVARCHAR(MAX)

	PRIMARY KEY(EquipmentName)
);

INSERT INTO Equipment
	(
	EquipmentName,
	EquipmentDescription
	)
VALUES
	(
		N'حضانة',
		N'حضانة اطفال'
),
	(
		N' جهازانعاش',
		N'جهاز انعاش'
),
	(
		N'جهاز تنفس',
		N'جهاز تنفس'
)

CREATE TABLE EquipmentOnCar
(
	VIN INT,
	EquipmentName NVARCHAR(200)

	FOREIGN KEY (VIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (EquipmentName) REFERENCES Equipment(EquipmentName)
);

CREATE TABLE AmbulanceVehicleHistory
(
	EntryID INT IDENTITY,
	VIN INT,
	ParamedicID INT,
	DriverID INT,
	YelloPadID INT

	PRIMARY KEY(EntryID),
	FOREIGN KEY(VIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY(ParamedicID) REFERENCES Employee(EID),
	FOREIGN KEY(DriverID) REFERENCES Employee(EID),
	FOREIGN KEY(YelloPadID) REFERENCES Yellopad(YelloPadID)

);

--TODO: After Implementing the token Add Extra Data.
CREATE TABLE ActivityLog
(
	ID INT IDENTITY,
	IPAddress NVARCHAR(200),
	RequestPath NVARCHAR(500),
	CreationTime DATETIME DEFAULT (GETDATE())

	PRIMARY KEY(ID)
);
------------------------------------------------------------------------
-- Creating Indecies --
-- (1) Medicine BarCode Unique Index -- 
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_Medicine_Name
ON Medicine(BarCode)
-- End of Indecies -- 
------------------------------------------------------------------------