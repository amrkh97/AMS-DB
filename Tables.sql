CREATE DATABASE KAN_EMS;
GO
USE KAN_EMS;

GO
CREATE TABLE EntityStatus
(
	StatusName NVARCHAR(32),
	StatusNote NVARCHAR(256)

	PRIMARY KEY (StatusName)
)
INSERT INTO EntityStatus (StatusName)
VALUES ('Undefined'),('Verified'),('Updated'),('Deleted')

CREATE TABLE IncidentTypes
(
	TypeName NVARCHAR(32),
	TypeNote NVARCHAR(256)

	PRIMARY KEY (TypeName)
)

CREATE TABLE Priorities
(
	PriorityName NVARCHAR(32),
	PriorityNote NVARCHAR(256)

	PRIMARY KEY (PriorityName)
)

CREATE TABLE AlarmLevels
(
	AlarmLevelName NVARCHAR(32),
	AlarmLevelote NVARCHAR(256)

	PRIMARY KEY (AlarmLevelName)
)

CREATE TABLE Jobs
(
	Title NVARCHAR(32),
	Note NVARCHAR(64),
	JobDescription NVARCHAR(256),

	PRIMARY KEY (Title)
)


CREATE TABLE Medicine
(
	BarCode NVARCHAR(64) NOT NULL UNIQUE,
	MedicineName NVARCHAR(64), 
    CountInStock INT,
    Price MONEY,
    Implications NVARCHAR(MAX),
    MedicineUsage NVARCHAR(MAX),
    SideEffects NVARCHAR(MAX),
    ActiveComponent NVARCHAR(MAX),
	MedicineStatus nvarchar(32) DEFAULT('Undefined')

    PRIMARY KEY(MedicineName),
	FOREIGN KEY(MedicineStatus) REFERENCES EntityStatus(StatusName), 
	CHECK (Price > 0)

);

CREATE TABLE PharmaCompany
(
    CompanyName NVARCHAR(64),
    ContactPerson NVARCHAR(32),
    CompanyAddress NVARCHAR(128),
    CompanyPhone NVARCHAR(32),
    CompanyStatus nvarchar(32) DEFAULT('Undefined')

	PRIMARY key (CompanyName)
	FOREIGN KEY (CompanyStatus) REFERENCES EntityStatus(StatusName), 
);

CREATE TABLE CompanyMedicineMap (
    CompName NVARCHAR(64),
    MedName NVARCHAR(64),
    PRIMARY key (CompName,MedName),
    FOREIGN KEY (CompName) REFERENCES PharmaCompany (CompanyName),
    FOREIGN KEY (MedName) REFERENCES Medicine (MedicineName)
);
CREATE TABLE Batch 
(
    BatchID INT,
	BatchMedName NVARCHAR(64) NOT NULL,
	Quantity INT,
	ExpiryDate DATE,
    OrderDate DATETIME DEFAULT getdate(),
	BatchStatus nvarchar(32) DEFAULT('Undefined')
    PRIMARY KEY(BatchID),
	FOREIGN KEY (BatchMedName) REFERENCES Medicine(MedicineName),
	FOREIGN KEY (BatchStatus) REFERENCES EntityStatus(StatusName), 
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
    VehicleStatus nvarchar(32) DEFAULT('Undefined')

    PRIMARY KEY ([VIN]),
	FOREIGN KEY (VehicleStatus) REFERENCES EntityStatus(StatusName), 
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

CREATE TABLE Receipt (
    ReceiptID INT,
    RespSQN NVARCHAR(64) NOT NULL,
    CasheirSSN INT,
    ReceiptCreationTime DATETIME DEFAULT (GETDATE()),
    FTPFileLocation NVARCHAR(128),
	ReceiptStatus NVARCHAR(32) DEFAULT ('Undefined'),

    PRIMARY KEY(ReceiptID)
);
CREATE TABLE Locaition  -- DONE
 (
    FreeFormatAddress NVARCHAR(256),
    City NVARCHAR(32),
    Longitude DECIMAL(9,6),
    Latitude DECIMAL(9,6),
    Street NVARCHAR(32),
    Apartement NVARCHAR(32),
    PostalCode NVARCHAR(20),
    FloorLevel NVARCHAR(20),
	HouseNumber NVARCHAR(12),
	PostalZipCode NVARCHAR(32),
	LocationStatus NVARCHAR(32) DEFAULT ('Undefined'),

    PRIMARY KEY (FreeFormatAddress)
);

CREATE TABLE MedicalRecord
 (
    MedicalRecordID INT,
    RespSQN nvarchar(32) UNIQUE,
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
    MRStatus NVARCHAR(32) DEFAULT ('Undefined'),

    PRIMARY KEY (MedicalRecordID),
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
    PatientLocation NVARCHAR(256),
    NextOfKenName NVARCHAR(32),
    NextOfKenPhone NVARCHAR(24),
    NextOfKenAddress NVARCHAR(256),
	PatientStatus NVARCHAR(32) DEFAULT ('Undefined'),

    PRIMARY KEY (PatientID),

); 

CREATE TABLE Reports 
(
    ReportID INT,
    ReportTitle VARCHAR(64) NOT NULL,
    ReportIssueTime DATETIME DEFAULT(GETDATE()),
    PatientID INT,
    ReportDestination NVARCHAR(64),
    ReportsStatus NVARCHAR(32) DEFAULT ('Undefined'),

    PRIMARY KEY (ReportID)
);

CREATE TABLE Employee
(
	Essn INT,
	Fname nvarchar(32),
	Lname nvarchar(32),
	BDate Date,
	Email nvarchar(32),
	HashPassword nvarchar(512),
	Gender nvarchar(1),
	ContactNumber nvarchar(64),
	Country nvarchar(32),
    City nvarchar(32),
    AddressState nvarchar(32),
    AddressStreet nvarchar(64),
    AddressPcode VARCHAR(20),
    SubscriptionDate DateTime DEFAULT (GETDATE()),
    PAN nvarchar(32),
    NaitonalID nvarchar(14),
    LogInTStamp DATETIME,
    LogInGPS nvarchar(20),
    EmpolyeeStatus nvarchar(32) DEFAULT ('Undefined'),
    SuperSSN INT,
	JobTitle nvarchar(32),
    Photo VARBINARY(MAX),
	Age as DATEDIFF(YEAR, BDate, GETDATE()),

	PRIMARY KEY (Essn)
	
)

CREATE TABLE Incident
(
	IncidentSequenceNumber nvarchar(64),
	CreationTime DATETIME DEFAULT (GETDATE()),
	IncidentType nvarchar(64),
	IncidentPriority nvarchar(32),
	[Location] nvarchar(256),
	AgencyName nvarchar(64) NULL,
	IncidentTime DATETIME DEFAULT (GETDATE()),
	PRIMARY KEY(IncidentSequenceNumber)
)

CREATE TABLE Rsponse
(
	SequenceNumber nvarchar(64) NOT NULL,
	AmbVehivleVIN INT NOT NULL,
	CreationTime DATE DEFAULT (getdate()),
	StartLocationLat DECIMAL(9,6),
	StartLocationLong DECIMAL(9,6),
	PickLocationLat DECIMAL(9,6),
	PickLocationLong DECIMAL(9,6),
	DropLocationLat DECIMAL(9,6),
	DropLocationLong DECIMAL(9,6),
	EndLocationLat DECIMAL(9,6),
	EndLocationLong DECIMAL(9,6),
	Cost MONEY,
	DriverSSN INT,
	ParamedicSSN INT,
	RespStatus INT,
	IncidentSQN nvarchar(64) NOT NULL,
	PrimaryResponseSQN nvarchar(64),
	RespAlarmLevel nvarchar(32),
	PersonCount INT,
	PRIMARY KEY (SequenceNumber)
)

------------------------------------------------------------------------
-- Creating Indecies --
-- (1) Medicine BarCode Unique Index -- 
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_Medicine_Name
ON Medicine(BarCode)
-- End of Indecies -- 
------------------------------------------------------------------------