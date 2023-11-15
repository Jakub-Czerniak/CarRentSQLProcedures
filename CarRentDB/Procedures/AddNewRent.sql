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
