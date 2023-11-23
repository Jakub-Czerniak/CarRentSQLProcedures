CREATE PROCEDURE ReturnCar 
(
  CarRentId IN NUMBER
) 
AS
BEGIN
  DELETE FROM CarRent WHERE id = ReturnCar.CarRentId
END ReturnCar;
