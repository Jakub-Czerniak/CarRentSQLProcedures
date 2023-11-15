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
