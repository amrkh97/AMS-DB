Use KAN_AMO;
--Comment: Entity Status was removed bacuse it caused
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
	IncidentTypeID INT,
	TypeName NVARCHAR(32),
	TypeNote NVARCHAR(256)

		PRIMARY KEY (IncidentTypeID)
);

CREATE TABLE Priorities
(
	PrioritYID INT,
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
	CountInStock NVARCHAR(64),
	Price NVARCHAR(32),
	Implications NVARCHAR(MAX),
	MedicineUsage NVARCHAR(MAX),
	SideEffects NVARCHAR(MAX),
	ActiveComponent NVARCHAR(MAX),
	MedicineStatus NVARCHAR(32) DEFAULT(00),
	BatchNo NVARCHAR(32) DEFAULT('-1'),

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
	PRIMARY key (CompID,MedBCode),
	FOREIGN KEY (CompID) REFERENCES PharmaCompany (CompanyID),
	FOREIGN KEY (MedBCode) REFERENCES Medicine (BarCode)
);
CREATE TABLE Batch
(
	BatchID INT,
	BatchMedBCode NVARCHAR(64) NOT NULL,
	Quantity NVARCHAR(64),
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
	BatchID INT,
	MedicineBCode NVARCHAR(64),
	Quantity NVARCHAR(64),
	FOREIGN KEY(BatchID) REFERENCES Batch(BatchID),
	FOREIGN KEY(MedicineBCode) REFERENCES Medicine(BarCode)
	);

CREATE TABLE Yellopad
(
	YelloPadID NVARCHAR(16) NOT NULL,
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
	AssignedYPID NVARCHAR(16) NOT NULL UNIQUE,
	VehicleStatus NVARCHAR(32) DEFAULT(00),
	AmbulanceVehiclePicture NVARCHAR(500),

	PRIMARY KEY (VIN),
	--FOREIGN KEY (VehicleStatus) REFERENCES EntityStatus (EntityStatusID),
	FOREIGN KEY (AssignedYPID) REFERENCES Yellopad (YelloPadID)
);

CREATE TABLE BatchDistributionMap
(
	DistributedAmt INT,
	BID INT,
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
	PAN NVARCHAR(20) UNIQUE,
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

CREATE TABLE Incident
(
	IncidentSequenceNumber NVARCHAR(64),
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
	SequenceNumber NVARCHAR(64) NOT NULL,
	AssociatedVehicleVIN INT NOT NULL,
	CreationTime DATETIME DEFAULT (getdate()),
	StartLocationID INT,
	PickLocationID INT,
	DropLocationID INT,
	DestinationLocationID INT,
	RespStatus NVARCHAR(32),
	IncidentSQN NVARCHAR(64) NOT NULL,
	PrimaryResponseSQN NVARCHAR(64),
	RespAlarmLevel INT,
	PersonCount NVARCHAR(32),

	FOREIGN KEY (AssociatedVehicleVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (StartLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (PickLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DropLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DestinationLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (RespStatus) REFERENCES ResponseStatuses(ResponseStatusID),
	FOREIGN KEY (IncidentSQN) REFERENCES Incident(IncidentSequenceNumber),
	FOREIGN KEY (RespAlarmLevel) REFERENCES AlarmLevels(AlarmLevelID),
	PRIMARY KEY (SequenceNumber)
);


CREATE TABLE MedicineUsedPerResponse
(
	RespSQN NVARCHAR(64) NOT NULL,
	UsedAmt INT,
	BID INT,
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
	RespSQN NVARCHAR(64) NOT NULL,
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
	MedicalRecordID INT,
	RespSQN NVARCHAR(64) UNIQUE,
	PatientID INT,
	BloodPressure NVARCHAR(12),
	Temperature NVARCHAR(33),
	BloodType NVARCHAR(12),
	BloodSugar NVARCHAR(12),
	CBC NVARCHAR(64),
	EMG NVARCHAR(MAX),
	ECG NVARCHAR(MAX),
	Hepatitis NVARCHAR(1),
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