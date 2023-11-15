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
