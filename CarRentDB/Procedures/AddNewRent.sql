CREATE PROCEDURE AddNewRent 
(
  CarId IN NUMBER,
  WorkerId IN NUMBER,
  CustomerDocumentId IN NVARCHAR2(255),
  RentalId IN NUMBER,
  RentTime IN NUMBER,
  CustomerName IN NVARCHAR2(255),
  CustomerSurname IN NVARCHAR2(255)
) 
AS
  varCustomerId NUMBER
  documentid_name_not_matched EXCEPTION;

BEGIN
  IF EXISTS (SELECT Id FROM Customer INTO varCustomerId WHERE DocumentId = @CustomDocumentId)
    IF EXISTS (SELECT * FROM Customer WHERE varCustomerId = Id AND Name = @CustomerName AND Surname = @CustomerSurname)
    ELSE RAISE documentid_name_not_matched
    END IF;
  ELSE 
    INSERT INTO Customer (Name, Surname, DocumentId, RentalId) VALUES (@CustomerName, @CustomerSurname, @DocumentId, @RentalId) RETURNING Id INTO varCustomerId
  END IF;

  INSERT INTO CarRent(CustomerId, WorkerId, CarId, RentDate, ExpectedReturnDate, IsPaid)
    VALUES(varCustomerId, @WorkerId, @CarId, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + NUMTODSINTERVAL(RentTime,'day'), 'N')

  NULL;

  WHEN documentid_name_not_matched THEN
    dbms_output.put_line('DocumentId previously used for different Name or Surname');

END AddNewRent;
