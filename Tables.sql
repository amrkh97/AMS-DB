
USE KAN_AMO;

GO
CREATE TABLE EntityStatus
(
	EntityStatusID INT,
	StatusName NVARCHAR(32),
	StatusNote NVARCHAR(256)

	PRIMARY KEY (EntityStatusID)
)
INSERT INTO EntityStatus (EntityStatusID,StatusName)
VALUES (1,'Undefined'),(2,'Updated'),(3,'Verified'),(99,'Deleted')

CREATE TABLE ResponseStatuses
(
	ResponseStatusID INT,
	StatusName NVARCHAR(64),
	StatusNote NVARCHAR(256)

	PRIMARY KEY (ResponseStatusID)
)

CREATE TABLE IncidentTypes
(
	IncidentTypeID INT,
	TypeName NVARCHAR(32),
	TypeNote NVARCHAR(256)

	PRIMARY KEY (IncidentTypeID)
)

CREATE TABLE Priorities
(
	PrioritYID INT,
	PriorityName NVARCHAR(32),
	PriorityNote NVARCHAR(256)

	PRIMARY KEY (PrioritYID)
)

CREATE TABLE AlarmLevels
(
	AlarmLevelID INT,
	AlarmLevelName NVARCHAR(32),
	AlarmLevelote NVARCHAR(256)

	PRIMARY KEY (AlarmLevelID)
)

CREATE TABLE Jobs
(
	JobID INT,
	Title NVARCHAR(32),
	Note NVARCHAR(64),
	JobDescription NVARCHAR(256),

	PRIMARY KEY (JobID)
)

CREATE TABLE PaymentMethods
(
	MethodName NVARCHAR(32),
	TreatmentImage VARBINARY(MAX),

	PRIMARY KEY (MethodName)
)

CREATE TABLE Medicine
(
	BarCode NVARCHAR(64),
	MedicineName NVARCHAR(64) NOT NULL UNIQUE, 
    CountInStock INT,
    Price MONEY,
    Implications NVARCHAR(MAX),
    MedicineUsage NVARCHAR(MAX),
    SideEffects NVARCHAR(MAX),
    ActiveComponent NVARCHAR(MAX),
	MedicineStatus INT DEFAULT(1)

    PRIMARY KEY(BarCode),
	FOREIGN KEY(MedicineStatus) REFERENCES EntityStatus(EntityStatusID), 
	CHECK (Price > 0)

);

CREATE TABLE PharmaCompany
(
	CompanyID INT IDENTITY,
    CompanyName NVARCHAR(64),
    ContactPerson NVARCHAR(32),
    CompanyAddress NVARCHAR(128),
    CompanyPhone NVARCHAR(32),
    CompanyStatus INT DEFAULT(1)

	PRIMARY key (CompanyID)
	FOREIGN KEY (CompanyStatus) REFERENCES EntityStatus(EntityStatusID), 
);

CREATE TABLE CompanyMedicineMap (
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
	Quantity INT,
	ExpiryDate DATE,
    OrderDate DATETIME DEFAULT getdate(),
	BatchStatus INT DEFAULT(1)
    PRIMARY KEY(BatchID),
	FOREIGN KEY (BatchMedBCode) REFERENCES Medicine(BarCode),
	FOREIGN KEY (BatchStatus) REFERENCES EntityStatus(EntityStatusID), 
	CONSTRAINT chk_Batch_QuantityPositive CHECK(Quantity > 0 )
);

CREATE TABLE AmbulanceVehicle
(
	VIN INT,
	Implication NVARCHAR(32),
	Make NVARCHAR(32) ,
	[Type] NVARCHAR(32) ,
	ProductionYear int ,
	RegYear int,
	LicencePlate NVARCHAR(32),
	OwnerName NVARCHAR(128),
	LicenceStateOrProvince NVARCHAR(32),
    ServiceStartDate DATE,
    EngineNumber NVARCHAR(32),
    Brand NVARCHAR(32),
    ChasiahNumber NVARCHAR(32),
    Model NVARCHAR(32),
    DriverPhoneNumber NVARCHAR(32),
    VehicleStatus INT DEFAULT(1)

    PRIMARY KEY ([VIN]),
	FOREIGN KEY (VehicleStatus) REFERENCES EntityStatus(EntityStatusID), 
);

CREATE TABLE BatchDistributionMap
(
	DistributedAmt INT,
	BID INT,
	AmbVIN INT

	PRIMARY KEY (BID,AmbVIN),
	FOREIGN KEY (BID) REFERENCES Batch(BatchID),
	FOREIGN KEY (AmbVIN) REFERENCES AmbulanceVehicle(VIN),
	CONSTRAINT chk_BatchDistributionMap_DistributedAmtPositive CHECK(DistributedAmt > 0 )
);

CREATE TABLE Locations  
 (
 	LocationID INT IDENTITY,
    FreeFormatAddress NVARCHAR(256) NOT NULL UNIQUE,
    City NVARCHAR(32),
    Longitude DECIMAL(9,6),
    Latitude DECIMAL(9,6),
    Street NVARCHAR(32),
    Apartement NVARCHAR(32),
    PostalCode NVARCHAR(20),
    FloorLevel NVARCHAR(20),
	HouseNumber NVARCHAR(12),
	PostalZipCode NVARCHAR(32),
	LocationStatus INT DEFAULT (1),

	FOREIGN KEY (LocationStatus) REFERENCES EntityStatus(EntityStatusID),
    PRIMARY KEY (LocationID)
);

CREATE TABLE Employee
(
	EID INT IDENTITY,
	Fname nvarchar(32),
	Lname nvarchar(32),
	BDate Date,
	Email nvarchar(128) NOT NULL UNIQUE,
	HashPassword nvarchar(128) NOT NULL,
	Gender nvarchar(1),
	ContactNumber nvarchar(64),
	Country nvarchar(32),
    City nvarchar(32),
    AddressState nvarchar(32),
    AddressStreet nvarchar(64),
    AddressPcode VARCHAR(20),
    SubscriptionDate DateTime DEFAULT (GETDATE()),
    PAN nvarchar(20),
    NaitonalID nvarchar(14),
    LogInTStamp DATETIME,
    LogInGPS nvarchar(20),
    EmpolyeeStatus INT DEFAULT (1),
    SuperSSN INT,
	JobID INT,
    Photo VARBINARY(MAX),
	Age as DATEDIFF(YEAR, BDate, GETDATE()),
	
	FOREIGN KEY (SuperSSN) REFERENCES Employee(EID),
	FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
	FOREIGN KEY(EmpolyeeStatus) REFERENCES EntityStatus(EntityStatusID), 
	PRIMARY KEY (EID)
	
)

CREATE TABLE Incident
(
	IncidentSequenceNumber nvarchar(64),
	CreationTime DATETIME DEFAULT (GETDATE()),
	IncidentType INT,
	IncidentPriority INT,
	IncidentLocationID INT,
	IncidentTime DATETIME DEFAULT (GETDATE()),
	FOREIGN KEY (IncidentType) REFERENCES IncidentTypes(IncidentTypeID),
	FOREIGN KEY (IncidentPriority) REFERENCES Priorities(PrioritYID),
	FOREIGN KEY (IncidentLocationID) REFERENCES Locations(LocationID),
	PRIMARY KEY(IncidentSequenceNumber)
)

CREATE TABLE Responses
(
	SequenceNumber nvarchar(64) NOT NULL,
	AssociatedVehivleVIN INT NOT NULL,
	CreationTime DATE DEFAULT (getdate()),
	StartLocationID INT,
	PickLocationID INT,
	DropLocationID INT,
	DestinationLocationID INT,
	DriverSSN INT,
	ParamedicSSN INT,
	RespStatus INT,
	IncidentSQN nvarchar(64) NOT NULL,
	PrimaryResponseSQN nvarchar(64),
	RespAlarmLevel INT,
	PersonCount INT,

	FOREIGN KEY (AssociatedVehivleVIN) REFERENCES AmbulanceVehicle(VIN),
	FOREIGN KEY (StartLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (PickLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DropLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DestinationLocationID) REFERENCES Locations(LocationID),
	FOREIGN KEY (DriverSSN) REFERENCES Employee(EID),
	FOREIGN KEY (ParamedicSSN) REFERENCES Employee(EID),
	FOREIGN KEY (RespStatus) REFERENCES ResponseStatuses(ResponseStatusID),
	FOREIGN KEY (IncidentSQN) REFERENCES Incident(IncidentSequenceNumber),
	FOREIGN KEY (RespAlarmLevel) REFERENCES AlarmLevels(AlarmLevelID),
	PRIMARY KEY (SequenceNumber)
)


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
	CONSTRAINT chk_MedicineUsedPerResponse_UsedAmtPositive CHECK(UsedAmt > 0 )
);

CREATE TABLE Receipt (
    ReceiptID INT,
    RespSQN NVARCHAR(64) NOT NULL,
    CasheirSSN INT,
    ReceiptCreationTime DATETIME DEFAULT (GETDATE()),
    FTPFileLocation NVARCHAR(128),
	ReceiptStatus INT DEFAULT (1),
	Cost Money,
	PaymentMethod NVARCHAR(32),

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (CasheirSSN) REFERENCES Employee(EID),
	FOREIGN KEY (PaymentMethod) REFERENCES PaymentMethods(MethodName),
	FOREIGN KEY (ReceiptStatus) REFERENCES EntityStatus(EntityStatusID),
    PRIMARY KEY(ReceiptID)
);
CREATE TABLE Patient 
(
    PatientID INT,
    PatientFName VARCHAR(32),
    PatientLName VARCHAR(32),
    Gender NVARCHAR(1),
    Age INT,
    Phone NVARCHAR(24),
    LastBenifitedTime DATETIME DEFAULT(GETDATE()),
    FirstBenifitedTime DATETIME DEFAULT(GETDATE()),
    NextOfKenName NVARCHAR(32),
    NextOfKenPhone NVARCHAR(24),
    NextOfKenAddress NVARCHAR(256),
	PatientStatus INT DEFAULT (1),

	FOREIGN KEY(PatientStatus) REFERENCES EntityStatus(EntityStatusID), 
    PRIMARY KEY (PatientID),

); 


CREATE TABLE MedicalRecord
 (
    MedicalRecordID INT,
    RespSQN nvarchar(64) UNIQUE,
	PatientID INT,
    BloodPressure NVARCHAR(12),
    Temperature NVARCHAR(33),
    BloodType NVARCHAR(12),
    BloodSugar NVARCHAR(12),
    CBC NVARCHAR(64),
    EMG NVARCHAR(MAX),
    ECG NVARCHAR(MAX),
    Hepatitis NVARCHAR(1),
    PhysicalExaminationImage VARBINARY(MAX),
    MedicineApplied NVARCHAR(128),
    ProcedureDoneInCar NVARCHAR(MAX),
    RecommendedProcedure NVARCHAR(MAX),
    MRStatus INT DEFAULT (1),

	FOREIGN KEY (RespSQN) REFERENCES Responses(SequenceNumber),
	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	FOREIGN KEY (MRStatus) REFERENCES EntityStatus(EntityStatusID),
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
    ReportStatus INT DEFAULT (1),

	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	FOREIGN KEY(ReportStatus) REFERENCES EntityStatus(EntityStatusID), 
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