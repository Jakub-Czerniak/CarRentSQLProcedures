CREATE PROCEDURE CustomerRents
(
  CustomerId in NUMBER
  Result OUT SYS_REFCURSOR
) 
AS
BEGIN
  OPEN Result FOR
  SELECT Customer.Name, Customer.Surname, CarRent.RentDate, CarRent.ExpectedReturnDate, CarRent.CarId
    FROM Customer
    INNER JOIN CarRent ON Customer.id = CarRent.CustomerId
END CustomerRents;
