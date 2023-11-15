CREATE OR REPLACE PROCEDURE AvaibleCarList 
(
  RentalId IN NUMBER,
  Id OUT NUMBER,
  Price OUT NUMBER,
  RegistrationNumber OUT NVARCHAR2,
  Make OUT NVARCHAR2,
  Model OUT NVARCHAR2
) 
AS
BEGIN
SELECT Car.Id, Car.Price, Car.RegistrationNumber, Make.Make, Make.Model 
  INTO AvaibleCarList.Id, AvaibleCarList.Price, AvaibleCarList.RegistrationNumber, AvaibleCarList.Make, AvaibleCarList.Model
  FROM Car 
  INNER JOIN Make ON Make.Id = Car.MakeId
  LEFT JOIN CarRent ON CarRent.CarId = Car.Id 
  WHERE CarRent.CarId IS NULL
  UNION
  SELECT Car.Id, Car.Price, Car.RegistrationNumber, Make.Make, Make.Model 
  FROM Car 
  INNER JOIN CarRent ON CarRent.ReturnDate IS NOT NULL AND CarRent.CarId = Car.Id
  INNER JOIN Make ON Make.Id = Car.MakeId;
END AvaibleCarList;
