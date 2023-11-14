-- Procedure definition

CREATE PROCEDURE AvaibleCarList 
(
  RentalId IN NUMBER,
  Id OUT NUMBER,
  Price OUT NUMBER(6,2),
  RegistrationNumber OUT NVARCHAR2(5),
  Make OUT NVARCHAR2(50),
  Model OUT NVARCHAR2(100)
) 
AS
BEGIN
SELECT Car.Id, Car.Price, Car.RegistrationNumber, Make.Make, Make.Model FROM Car 
  WHERE CarRent.ReturnDate IS NOT NULL
  INNER JOIN CarRent ON CarRent.CarId = Car.Id
  INNER JOIN Model ON Model.Id = Car.ModelId

END AvaibleCarList;
