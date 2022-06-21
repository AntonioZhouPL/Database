CREATE database PsychotherapistDatabase;
go


use PsychotherapistDatabase;
go


-- create tables

-- secontion 1



-- Create Table PaymentMethods
CREATE TABLE PaymentMethods 
(
    PaymentMethodsID VARCHAR(10),
    PaymentMethodsName varchar(100)
    
     CONSTRAINT "PK_PaymentMethods"  PRIMARY KEY
   (
       PaymentMethodsID
   ),

);



-- Create table Patients
CREATE TABLE Patients
(
    FirstName VARCHAR(10) Null,
    LastName VARCHAR(10) Null,
    PatientID INT,
    PaymentMethodsID VARCHAR(10),
    PESEL INT,
    
     CONSTRAINT "PK_Patients"  PRIMARY KEY
   (
       PatientID
   ),
   CONSTRAINT "FK_Patients"  FOREIGN KEY
   (
        PaymentMethodsID
   )
   REFERENCES PaymentMethods
   (
       PaymentMethodsID
   )
);


-- Create table AppointmentType
CREATE TABLE Appointment
(
     AppointmentTypeID INT,
     PatientID INT,
     AppointmentTypeName VARCHAR(100),

    CONSTRAINT "PK_Appointment"  PRIMARY KEY
   (
       AppointmentTypeID
   ),

      CONSTRAINT "FK_Appointment"  FOREIGN KEY
   (
      PatientID
   )
   REFERENCES Patients
   (
       PatientID
   )

);




-- Insert value into Table PaymentMethods
INSERT INTO PaymentMethods(PaymentMethodsID, PaymentMethodsName)VALUES('A','Stripe');
INSERT INTO PaymentMethods(PaymentMethodsID, PaymentMethodsName)VALUES('B','Online');
INSERT INTO PaymentMethods(PaymentMethodsID, PaymentMethodsName)VALUES('C','In The office');

-- Insert value into Table Patients
INSERT INTO Patients(FirstName, LastName, PatientID,PaymentMethodsID, PESEL)VALUES('Gena', 'Bukin', '1', 'A','7668967');
INSERT INTO Patients(FirstName, LastName, PatientID,PaymentMethodsID, PESEL)VALUES('James', 'Bond', '2', 'B','7668963');
INSERT INTO Patients(FirstName, LastName, PatientID,PaymentMethodsID, PESEL)VALUES('Harry', 'Kayne', '3', 'C','7668964');


-- Insert value into Table Appointment
INSERT INTO Appointment(AppointmentTypeID, PatientID, AppointmentTypeName)VALUES('1','3','FreeConsultation');
INSERT INTO Appointment(AppointmentTypeID, PatientID, AppointmentTypeName)VALUES('2','1','paid one-time consultations');
INSERT INTO Appointment(AppointmentTypeID, PatientID, AppointmentTypeName)VALUES('3','2','paid courses');