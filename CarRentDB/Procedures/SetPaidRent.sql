CREATE PROCEDURE SetPaidRent 
(
  CarRentId IN NUMBER
)
AS
BEGIN
  UPDATE CarRent SET IsPaid = "Y" WHERE id = SetPaidRent.CarRentId;
END SetPaidRent;
