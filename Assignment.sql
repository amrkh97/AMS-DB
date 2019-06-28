Use KAN_AMO;


CREATE TABLE Assignment
(
    VehicleVIN   INT,
	YelloPadID   NVARCHAR(16),
	DriverSSN    INT,
	ParamedicSSN INT,
	AssignmentStatue NVARCHAR(32) DEFAULT(00)
    
	FOREIGN KEY (VehicleVIN)   REFERENCES    AmbulanceVehicle (VIN),
	FOREIGN KEY (YelloPadID)   REFERENCES    Yellopad (YelloPadID),
	FOREIGN KEY (DriverSSN)    REFERENCES    Employee(EID),
	FOREIGN KEY (ParamedicSSN) REFERENCES    Employee(EID),
	PRIMARY key (VehicleVIN)
);
