DROP TABLE CarRent;
DROP TABLE Car;
DROP TABLE Worker;
DROP TABLE Customer;
DROP TABLE Rental;
DROP TABLE Make;
DROP TABLE Position;

CREATE TABLE Rental
(
	Id NUMBER GENERATED ALWAYS AS IDENTITY,
	Localisation NVARCHAR2(255) NOT NULL UNIQUE,
	PRIMARY KEY(Id)
);

INSERT INTO Rental(Localisation) VALUES ('Wroc³aw');
INSERT INTO Rental(Localisation) VALUES ('Kraków');


CREATE TABLE Make
(
  Id NUMBER GENERATED ALWAYS AS IDENTITY,
  Make NVARCHAR2(100) NOT NULL,
  Model NVARCHAR2(100) NOT NULL UNIQUE,
  PRIMARY KEY(Id)
);

CREATE TABLE Car
(
	Id NUMBER GENERATED ALWAYS AS IDENTITY,
	Price NUMBER (6,2) NOT NULL,
	RegistrationNumber NVARCHAR2(100) NOT NULL UNIQUE,
	MakeId NUMBER NOT NULL,
	RentalId NUMBER NOT NULL,
	PRIMARY KEY(Id),
	FOREIGN KEY(MakeId) REFERENCES Make(Id),
	FOREIGN KEY(RentalId) REFERENCES Rental(Id)
);

CREATE TABLE Position
(
	Id NUMBER GENERATED ALWAYS AS IDENTITY,
	Position NVARCHAR2(255) NOT NULL UNIQUE,
	PRIMARY KEY(Id)
);

INSERT INTO Position (Position) VALUES ('Customer service');
INSERT INTO Position (Position) VALUES ('Manager');


CREATE TABLE Worker
(
  Id NUMBER GENERATED ALWAYS AS IDENTITY,
  Name NVARCHAR2(255) NOT NULL,
  Surname NVARCHAR2(255) NOT NULL,
  Password CHAR(128) NOT NULL,
  Email NVARCHAR2(255) NOT NULL UNIQUE,
  PositionId NUMBER NOT NULL,
  RentalId NUMBER NOT NULL,
  FOREIGN KEY(PositionId) REFERENCES Position(Id),
  FOREIGN KEY(RentalId) REFERENCES Rental(Id),
  PRIMARY KEY(Id)
);

INSERT INTO Worker(Name, Surname, Password, Email, PositionId, RentalId) VALUES('Marian', 'Kowalski', '5f4dcc3b5aa765d61d8327deb882cf99', 'marian.kowalski@mail.pl', '1', '1');
INSERT INTO Worker(Name, Surname, Password, Email, PositionId, RentalId) VALUES('Marianna', 'Kowalska', '5f4dcc3b5aa765d61d8327deb882cf99', 'marianna.kowalska@mail.pl', '2', '1');
INSERT INTO Worker(Name, Surname, Password, Email, PositionId, RentalId) VALUES('Marcin', 'Nowak', '5f4dcc3b5aa765d61d8327deb882cf99', 'marcin.nowak@mail.pl', '2', '2');
INSERT INTO Worker(Name, Surname, Password, Email, PositionId, RentalId) VALUES('Janina', 'Nowak', '5f4dcc3b5aa765d61d8327deb882cf99', 'janina.nowak@mail.pl', '1', '2');

CREATE TABLE Customer
(
	Id NUMBER GENERATED ALWAYS AS IDENTITY,
	Name NVARCHAR2(255) NOT NULL,
	Surname NVARCHAR2(255) NOT NULL,
	DocumentId NVARCHAR2(255) NOT NULL UNIQUE,
	RentalId NUMBER NOT NULL,
	PRIMARY KEY(Id),
	FOREIGN KEY(RentalId) REFERENCES Rental(Id)
);

CREATE TABLE CarRent
(
  Id NUMBER GENERATED ALWAYS AS IDENTITY,
  CustomerId NUMBER NOT NULL,
  WorkerId NUMBER NOT NULL,
  CarId NUMBER NOT NULL,
  RentDate TIMESTAMP NOT NULL,
  ExpectedReturnDate TIMESTAMP NOT NULL,
  ReturnDate TIMESTAMP,
  IsPaid CHAR(1 CHAR) NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(CustomerId) REFERENCES Customer(Id),
  FOREIGN KEY(WorkerId) REFERENCES Worker(Id),
  FOREIGN KEY(CarId) REFERENCES Car(Id)
);

CREATE OR REPLACE PROCEDURE AddCar 
(
Price IN NUMBER,
RegistrationNumber IN NVARCHAR2,
Make IN NVARCHAR2,
Model IN NVARCHAR2,
Localisation IN NVARCHAR2
) 
AS
  varCountId NUMBER;
  varMakeId NUMBER;
  varRentalId NUMBER;

BEGIN
  SELECT COUNT(Id) INTO varCountId FROM Make WHERE Make = AddCar.Make AND Model = AddCar.Model;
  IF (varCountId = 1)
    THEN 
      SELECT Id INTO varMakeId FROM Make WHERE Make = AddCar.Make AND Model = AddCar.Model;
    ELSE
      INSERT INTO Make (Make, Model) VALUES (AddCar.Make, AddCar.Model) RETURNING Id INTO varMakeId;
  END IF;

  SELECT Id INTO varRentalId FROM Rental WHERE Localisation = AddCar.Localisation;

  INSERT INTO Car (Price, RegistrationNumber, MakeId, RentalId) VALUES (AddCar.Price, AddCar.RegistrationNumber, varMakeId, varRentalId);

END AddCar;
/
CREATE OR REPLACE PROCEDURE AddNewRent 
(
  CarId IN NUMBER,
  WorkerId IN NUMBER,
  CustomerDocumentId IN NVARCHAR2,
  RentalId IN NUMBER,
  RentTime IN NUMBER,
  CustomerName IN NVARCHAR2,
  CustomerSurname IN NVARCHAR2
) 
AS
  varCustomerId NUMBER;
  varCountCustomer NUMBER;
BEGIN
  SELECT COUNT(Id) INTO varCountCustomer FROM Customer WHERE DocumentId = AddNewRent.CustomerDocumentId;
  IF (varCountCustomer > 0)
  THEN
    SELECT Id INTO varCustomerId FROM Customer WHERE Name = AddNewRent.CustomerName AND Surname = AddNewRent.CustomerSurname AND DocumentId = AddNewRent.CustomerDocumentId;
  ELSE 
    INSERT INTO Customer (Name, Surname, DocumentId, RentalId) VALUES (AddNewRent.CustomerName, AddNewRent.CustomerSurname, AddNewRent.CustomerDocumentId, AddNewRent.RentalId) RETURNING Id INTO varCustomerId;
  END IF;
  
  INSERT INTO CarRent(CustomerId, WorkerId, CarId, RentDate, ExpectedReturnDate, IsPaid)
    VALUES(varCustomerId, AddNewRent.WorkerId, AddNewRent.CarId, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + NUMTODSINTERVAL(RentTime,'day'), 'N');
END AddNewRent;
/
CREATE OR REPLACE PROCEDURE AvaibleCarList 
(
  RentalId IN NUMBER,
  Result OUT SYS_REFCURSOR
) 
AS
BEGIN
OPEN Result FOR
SELECT Car.Id, Car.Price, Car.RegistrationNumber, Make.Make, Make.Model 
  FROM Car 
  INNER JOIN Make ON Make.Id = Car.MakeId
  LEFT JOIN CarRent ON CarRent.CarId = Car.Id 
  WHERE CarRent.CarId IS NULL AND Car.RentalId = AvaibleCarList.RentalId
  UNION
  SELECT Car.Id, Car.Price, Car.RegistrationNumber, Make.Make, Make.Model 
  FROM Car 
  INNER JOIN CarRent ON CarRent.ReturnDate IS NOT NULL AND CarRent.CarId = Car.Id
  INNER JOIN Make ON Make.Id = Car.MakeId
  WHERE Car.RentalId = AvaibleCarList.RentalId;
END AvaibleCarList;
/

CREATE OR REPLACE PROCEDURE Login 
(
  Email IN NVARCHAR2,
  Password IN VARCHAR,
  WorkerId OUT NUMBER,
  Name OUT NVARCHAR2,
  Surname OUT NVARCHAR2,
  RentalId OUT NUMBER,
  Localisation OUT NVARCHAR2,
  Position OUT NVARCHAR2
) 
AS
BEGIN
  BEGIN
    SELECT Worker.Id, Worker.Name, Worker.Surname, Rental.Id, Rental.Localisation, Position.Position 
    INTO Login.WorkerId, Login.Name, Login.Surname, Login.RentalId, Login.Localisation, Login.Position
    FROM Worker 
    INNER JOIN Position ON Worker.PositionId = Position.Id
    INNER JOIN Rental ON Worker.RentalId = Rental.Id
    WHERE Worker.Email = Login.Email AND Worker.Password = Login.Password;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      Login.WorkerId :=NULL; Login.Name:=NULL; Login.Surname:=NULL; Login.RentalId:=NULL; Login.Localisation:=NULL; Login.Position:=NULL;
  END;
END Login;
/
EXECUTE AddCar('50.99', 'DW808S', 'Audi', 'TT', 'Wroc³aw');
EXECUTE AddCar('75.00', 'DW5FD4D', 'Audi', 'A4', 'Wroc³aw');
EXECUTE AddCar('59.99', 'KR608S', 'BMW', 'X7', 'Kraków');
EXECUTE AddCar('59.99', 'KKY508S', 'BMW', 'X7', 'Kraków');

EXECUTE AddNewRent('1', '1','YTT686820','1','7','Agata','Agat');
EXECUTE AddNewRent('2', '2','YTT686820','1','2','Agata','Agat');

variable rc refcursor;
EXECUTE AvaibleCarList('1',:rc);
print rc;
EXECUTE AvaibleCarList('2',:rc);
print rc;