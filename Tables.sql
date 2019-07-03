Use KAN_AMO;
--Comment: Entity Status was removed because it caused
--errors with the Foreign key relationship on Insert or update.
--It was also too generic to be of use as each table has
--its own Status values.


--GO
--CREATE TABLE EntityStatus
--(
--	EntityStatusID NVARCHAR(32),
--	StatusName NVARCHAR(32),
--	StatusNote NVARCHAR(256)

--		PRIMARY KEY (EntityStatusID)
--);
--INSERT INTO EntityStatus
--	(EntityStatusID,StatusName)
--VALUES

--	('1', 'Undefined'),
--	('2', 'Updated'),
--	('3', 'Verified'),
--	('99', 'Deleted')

CREATE TABLE ResponseStatuses
(
	ResponseStatusID NVARCHAR(32),
	StatusName NVARCHAR(64),
	StatusNote NVARCHAR(256)

		PRIMARY KEY (ResponseStatusID)
);

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

	('هبوط','هبوط'),
	('علاج كيميائى/اشعاعى','علاج كيميائى/اشعاعى'),
	('ولادة','ولادة'),
	('تصادم سيارة/عدة سيارات','تصادم سيارة/عدة سيارات'),
	('نقل محافظات مستشفيات','نقل محافظات مستشفيات'),
	('انقلاب/سقوط مركبه','انقلاب/سقوط مركبه'),
	('نقل اجراء عمليات','نقل اجراء عمليات'),
	('كسر','كسر'),
	('احتباس بولى','احتباس بولى'),
	('شكاوى','شكاوى'),
	('حريق','حريق'),
	('حروق','حروق'),
	('جلطة','جلطة'),
	('حادث طريق','حادث طريق'),
	('حادث غرق','حادث غرق'),
	('حضانة أكسجين','حضانة أكسجين'),
	('حضانة تنقس صناعى','حضانة تنفس صناعى'),
	('خدمة طبية-خدمات طبية و رعاية','خدمة طبية-خدمات طبية و رعاية'),
	('سقوط من مرتفع','سقوط من مرتفع'),
	('ارتفاع درجة الحرارة','ارتفاع درجة الحرارة'),
	('ارتفاع ضغط الدم','ارتفاع ضغط الدم'),
	('أزمة قلبية','أزمة قلبية'),
	('غسبل كلوي','غسبل كلوي'),
	('غيبوبة/اغماء','غيبوبة/اغماء'),
	('قئ دموى','قئ دموى'),
	('قئ و اسهال','قئ و اسهال'),
	('متابعة مستشفى','متابعة مستشفى'),
	('مشاجرة/اعتداء','مشاجرة/اعتداء'),
	('مخص كلوي/معوي','مخص كلوي/معوي'),
	('نزيف','نزيف'),
	('اشتعال سيارة','اشتعال سيارة'),
	('ألم بالصدر','ألم بالصدر'),
	('تقل اخر خدمات مصاحبة','تقل اخر خدمات مصاحبة'),
	('نقل أشعة/عيادات/تحاليل','نقل أشعة/عيادات/تحاليل'),
	('نقل للأشعة أو التحاليل','نقل للأشعة أو التحاليل'),
	('نقل محافظات/سفريات','نقل محافظات/سفريات'),
	('نقل من سكن الى سكن','نقل من سكن الى سكن'),
	('نقل من سكن الى مستشفى','نقل من سكن الى مستشفى'),
	('نقل من مستشفى للسكن','نقل من مستشفى للسكن'),
	('نقل من مستشفى الى مستشفى','نقل من مستشفى الى مستشفى'),
	('انهيار مبنى','انهيار مبنى'),
	('تسمم','تسمم'),
	('تشنجات و صرع','تشنجات و صرع'),
	('تصادم بشخص/أشخاص','تصادم بشخص/أشخاص'),
	('صعق كهربائى','صعق كهربائى'),
	('ضيق تنفس','ضيق تنفس'),
	('غرق شخص','غرق شخص'),
	('غريق','غريق'),
	('استفسارات عن مفقودات','استفسارات عن مفقودات'),
	('استفسارات عن مفقودين','استفسارات عن مفقودين'),
	('استفسارات أخرى','استفسارات أخرى'),
	('أخرى','أخرى')

CREATE TABLE Priorities
(
	PrioritYID INT IDENTITY,
	PriorityName NVARCHAR(32),
	PriorityNote NVARCHAR(256)

		PRIMARY KEY (PrioritYID)
);

CREATE TABLE AlarmLevels
(
	AlarmLevelID INT,
	AlarmLevelName NVARCHAR(32),
	AlarmLevelote NVARCHAR(256)

		PRIMARY KEY (AlarmLevelID)
);

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

	(0, 'System Manager','Manager of the whole system'),
	(1, 'Movement Manager','Responsible for managing the day to day operation'),
	(2, 'Paramedic','Saves people''s lives'),
	(3, 'Driver','Drives Ambulance'),
	(4, 'Operator','Adds incident and locations')

CREATE TABLE PaymentMethods
(
	MethodName NVARCHAR(32),
	TreatmentImage VARBINARY(MAX),

	PRIMARY KEY (MethodName)
);

CREATE TABLE Medicine
(
	BarCode NVARCHAR(64),
	MedicineName NVARCHAR(64) NOT NULL UNIQUE,
	CountInStock Integer,
	Price NVARCHAR(32),
	Implications NVARCHAR(MAX),
	MedicineUsage NVARCHAR(MAX),
	SideEffects NVARCHAR(MAX),
	ActiveComponent NVARCHAR(MAX),
	MedicineStatus NVARCHAR(32) DEFAULT(00),

	PRIMARY KEY(BarCode)
	--FOREIGN KEY(MedicineStatus) REFERENCES EntityStatus(EntityStatusID),
	--CHECK (Price > 0)

);

CREATE TABLE PharmaCompany
(
	CompanyID INT IDENTITY,
	CompanyName NVARCHAR(64),
	ContactPerson NVARCHAR(32),
	CompanyAddress NVARCHAR(128),
	CompanyPhone NVARCHAR(32),
	CompanyStatus NVARCHAR(32) DEFAULT(00)

		PRIMARY key (CompanyID)
	--	FOREIGN KEY (CompanyStatus) REFERENCES EntityStatus(EntityStatusID),
);

CREATE TABLE CompanyMedicineMap
(
	CompID INT,
	MedBCode NVARCHAR(64),
	MapStatus NVARCHAR(2),
	PRIMARY key (CompID,MedBCode),
	FOREIGN KEY (CompID) REFERENCES PharmaCompany (CompanyID),
	FOREIGN KEY (MedBCode) REFERENCES Medicine (BarCode)
);
CREATE TABLE Batch
(
	BatchID BIGINT,
	BatchMedBCode NVARCHAR(64) NOT NULL,
	Quantity INT,
	ExpiryDate DATE,
	OrderDate DATETIME DEFAULT getdate(),
	BatchStatus NVARCHAR(32) DEFAULT(00),
	PRIMARY KEY(BatchID),
	FOREIGN KEY (BatchMedBCode) REFERENCES Medicine(BarCode)
	--FOREIGN KEY (BatchStatus) REFERENCES EntityStatus(EntityStatusID),
	--CONSTRAINT chk_Batch_QuantityPositive CHECK(Quantity > 0 )
);

--TODO: Check the quantity element's type.
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
	YelloPadID INT NOT NULL,
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
	YelloPadStatus NVARCHAR(32) NOT NULL DEFAULT (00),
	YelloPadPicture NVARCHAR(500),

	PRIMARY KEY (YelloPadID),
	--FOREIGN KEY (YelloPadStatus) REFERENCES EntityStatus(EntityStatusID)
);

CREATE TABLE AmbulanceVehicle
(
	VIN INT,
	Implication NVARCHAR(32),
	Make NVARCHAR(32) ,
	[Type] NVARCHAR(32) ,
	ProductionYear NVARCHAR(32) ,
	RegYear NVARCHAR(32),
	LicencePlate NVARCHAR(32),
	OwnerName NVARCHAR(128),
	LicenceStateOrProvince NVARCHAR(32),
	ServiceStartDate NVARCHAR(32),
	EngineNumber NVARCHAR(32),
	Brand NVARCHAR(32),
	ChasiahNumber NVARCHAR(32),
	Model NVARCHAR(32),
	DriverPhoneNumber NVARCHAR(32),
	AssignedYPID INT NOT NULL UNIQUE,
	VehicleStatus NVARCHAR(32) DEFAULT(00),
	AmbulanceVehiclePicture NVARCHAR(500),

	PRIMARY KEY (VIN),
	--FOREIGN KEY (VehicleStatus) REFERENCES EntityStatus (EntityStatusID),
	FOREIGN KEY (AssignedYPID) REFERENCES Yellopad (YelloPadID)
);

CREATE TABLE BatchDistributionMap
(
	DistributedAmt INT,
	BID BIGINT,
	AmbVIN INT

		PRIMARY KEY (BID,AmbVIN),
	FOREIGN KEY (BID) REFERENCES Batch(BatchID),
	FOREIGN KEY (AmbVIN) REFERENCES AmbulanceVehicle(VIN),
	--CONSTRAINT chk_BatchDistributionMap_DistributedAmtPositive CHECK(DistributedAmt > 0 )
);

CREATE TABLE Locations
(
	LocationID INT IDENTITY,
	FreeFormatAddress NVARCHAR(256) NOT NULL UNIQUE,
	City NVARCHAR(32),
	Longitude NVARCHAR(32),
	Latitude NVARCHAR(32),
	Street NVARCHAR(32),
	Apartement NVARCHAR(32),
	PostalCode NVARCHAR(20),
	FloorLevel NVARCHAR(20),
	HouseNumber NVARCHAR(12),
	LocationStatus NVARCHAR(32) DEFAULT (00),

	--FOREIGN KEY (LocationStatus) REFERENCES EntityStatus(EntityStatusID),
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
	LogInGPS NVARCHAR(20),
	EmployeeStatus NVARCHAR(32) DEFAULT (00),
	SuperSSN INT,
	JobID INT,
	Photo NVARCHAR(MAX),
	Age as DATEDIFF(YEAR, BDate, GETDATE()),

	FOREIGN KEY (SuperSSN) REFERENCES Employee(EID),
	FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
	--FOREIGN KEY(EmployeeStatus) REFERENCES EntityStatus(EntityStatusID),
	PRIMARY KEY (EID)

);

INSERT INTO Employee
	(Email,HashPassword,PAN,NationalID,SuperSSN,JobID)
VALUES

	('admin@test.com','12345678',null,'',1,0) ,
    ('move_manager1@test.com','91234567',null,'',1,1),
	('move_manager2@test.com','89123456','0123456789012345','',1,1),
	('move_manager3@test.com','78912345','','01234567890123',1,1),
	('operator1@test.com','91234567','','29704090101931',2,4),
	('operator2@test.com','89123456',null,'',3,4),
	('operator3@test.com','78912345',null,'',4,4),
	('driver1@test.com','91234567','',null,2,3),
	('driver2@test.com','89123456','1010101010101010','',3,3),
	('driver3@test.com','78912345','','11112222333344',4,3),
	('paramedic1@test.com','91234567',null,'',2,2),
	('paramedic2@test.com','89123456',null,'',3,2),
	('paramedic3@test.com','78912345','4017772008280452','',4,2),
	('paramedic4@test.com','91234567','4918012011072830','',2,2),
	('paramedic5@test.com','91234567',null,'',2,2)

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
	RespSQN INT NOT NULL,
	UsedAmt INT,
	BID BIGINT,
	AmbVIN INT

	PRIMARY KEY (RespSQN,BID),
	FOREIGN KEY (BID) REFERENCES Batch(BatchID),
	FOREIGN KEY (AmbVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	--CONSTRAINT chk_MedicineUsedPerResponse_UsedAmtPositive CHECK(UsedAmt > 0 )
);

CREATE TABLE Receipt
(
	ReceiptID INT,
	RespSQN INT NOT NULL,
	CasheirSSN INT,
	ReceiptCreationTime DATETIME DEFAULT (GETDATE()),
	FTPFileLocation NVARCHAR(128),
	ReceiptStatus NVARCHAR(32) DEFAULT (00),
	Cost NVARCHAR(32),
	PaymentMethod NVARCHAR(32),

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (CasheirSSN) REFERENCES Employee(EID),
	FOREIGN KEY (PaymentMethod) REFERENCES PaymentMethods(MethodName),
	--FOREIGN KEY (ReceiptStatus) REFERENCES EntityStatus(EntityStatusID),
	PRIMARY KEY(ReceiptID)
);
CREATE TABLE Patient
(
	PatientID INT,
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
	PatientStatus NVARCHAR(32) DEFAULT (00),
	PatientNationalID INT

		--FOREIGN KEY(PatientStatus) REFERENCES EntityStatus(EntityStatusID),
		PRIMARY KEY (PatientID),

);


CREATE TABLE MedicalRecord
(
	MedicalRecordID INT IDENTITY,
	RespSQN NVARCHAR(64) UNIQUE,
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
	MRStatus NVARCHAR(32) DEFAULT (00),

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	--FOREIGN KEY (MRStatus) REFERENCES EntityStatus(EntityStatusID),
	PRIMARY KEY (MedicalRecordID),
);


CREATE TABLE PatientLocations
(
	PatientID INT,
	LocationID INT,

	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
	PRIMARY KEY (PatientID,LocationID)

);


CREATE TABLE Reports
(
	ReportID INT,
	ReportTitle VARCHAR(64) NOT NULL,
	ReportIssueTime DATETIME DEFAULT(GETDATE()),
	PatientID INT,
	ReportDestination NVARCHAR(64),
	--ReportStatus NVARCHAR(32) DEFAULT (1),

	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	--FOREIGN KEY(ReportStatus) REFERENCES EntityStatus(EntityStatusID),
	PRIMARY KEY (ReportID)
);


------------------------------------------------------------------------
-- Creating Indecies --
-- (1) Medicine BarCode Unique Index -- 
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_Medicine_Name
ON Medicine(BarCode)
-- End of Indecies -- 
------------------------------------------------------------------------