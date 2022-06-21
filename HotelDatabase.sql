/*
------------------------------------------------------------
Name: BankDatabase
version: 2.0
*/


CREATE database HotelDatabase;
go


use HotelDatabase;
go


-- create tables

-- secontion 1

CREATE TABLE Hotels
(
    HotelCode INT,
    HotelName VARCHAR(10),
    City varchar(100),
    Descriptions TEXT NULL,
    
     CONSTRAINT "PK_Hotels"  PRIMARY KEY
   (
       HotelCode
   ),

);



CREATE TABLE HotelRooms
(
    RoomCode INT,
    HotelCode INT,
    NumberOfGuests INT,
    CostOfANight MONEY,
   CONSTRAINT "PK_HotelRooms"  PRIMARY KEY
   (
       RoomCode
   ),
   CONSTRAINT "FK_HotelRooms"  FOREIGN KEY
   (
       HotelCode
   )
   REFERENCES Hotels
   (
       HotelCode
   )
);



CREATE TABLE Reservation
(
    ReservationCode INT,
    RoomCode INT,
    DateFrom DATE,
    DateTo DATE,
    TotalCost MONEY NULL,
   CONSTRAINT "PK_Reservation"  PRIMARY KEY
   (
       ReservationCode
   ),
   CONSTRAINT "FK_Reservation"  FOREIGN KEY
   (
       RoomCode
   )
   REFERENCES HotelRooms
   (
       RoomCode
   )
);

-- section 2

ALTER TABLE HotelRooms
ADD IsReserved BIT NOT NULL 
CONSTRAINT IsAvailable_A DEFAULT 0;

-- section 3

ALTER TABLE Hotels
ALTER COLUMN HotelName
varchar(100);

-- section 4

-- Hotels
INSERT INTO Hotels(HotelCode,HotelName,City,Descriptions)VALUES('1','Hilton','London','');
INSERT INTO Hotels(HotelCode,HotelName,City,Descriptions)VALUES('2','Bliss','Paris','');

-- HotelsRooms
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('701','1','2','1099',1);
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('303','2','1','599',1);
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('1701','1','4','1599',1);
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('808','2','2','899',1);
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('918','2','3','999',0);
INSERT INTO HotelRooms(RoomCode,HotelCode,NumberOfGuests,CostOfANight,IsReserved)VALUES('1303','1','1','699',0);


-- Reservations
INSERT INTO Reservation(ReservationCode,RoomCode,DateFrom,DateTo,TotalCost)VALUES('1','303','2022-06-15','2022-06-16','599');
INSERT INTO Reservation(ReservationCode,RoomCode,DateFrom,DateTo,TotalCost)VALUES('2','701','2022-06-16','2022-06-18','2198');
INSERT INTO Reservation(ReservationCode,RoomCode,DateFrom,DateTo,TotalCost)VALUES('3','808','2022-06-17','2022-06-18','899');
INSERT INTO Reservation(ReservationCode,RoomCode,DateFrom,DateTo,TotalCost)VALUES('4','1701','2022-06-18','2022-06-20','3198');
