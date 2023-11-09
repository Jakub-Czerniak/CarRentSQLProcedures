CREATE PROCEDURE AddCar 
(
Price IN NUMBER(6,2),
RegistrationNumber IN NUMBER,
Make IN NVARCHAR(255),
Model IN NVARCHAR(255),
Localisation IN NVARCHAR(255)
) 
AS
  varMakeId NUMBER;
  varRentalId
  localisation_missing EXCEPTION;

BEGIN
  IF EXISTS(SELECT Id, Make, Model FROM Make WHERE Make = @Make AND Model = @Model)
    THEN 
      varMakeId = Id
    ELSE
      INSERT INTO Make (Make, Model) VALUES (@Make, @Model) RETURNING Id INTO varMakeId
  END IF;

  SELECT Id INTO varRentalId FROM Rental WHERE Localisation = @Localisation;

  IF varRentalId IS NULL THEN RAISE localisation_missing;
  END IF;

  INSERT INTO Car (Price, RegistrationNumber, MakeId, RentalId) VALUES (@Price, @RegistrationNumber, varMakeId, varRentalId)

  NULL;

  WHEN localisation_missing THEN
    dbms_output.put_line('Localisation does not correspond to any rental.');

END AddCar;
