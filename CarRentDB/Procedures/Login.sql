CREATE PROCEDURE Login 
(
  Email IN NVARCHAR2,
  Password IN VARCHAR,
  WorkerId OUT NUMBER,
  Name OUT NVARCHAR2,
  Surname OUT NVARCHAR2,
  Email OUT NVARCHAR2,
  RentalId OUT NUMBER,
  Localisation OUT NVARCHAR2,
  Position OUT NVARCHAR2
) 
AS
BEGIN
  SELECT Worker.Id AS WorkerId, Worker.Name, Worker.Surname, Worker.Email, Rental.Localisation, Position.Position 
  FROM Worker WHERE Worker.Email = @Email AND Worker.Password = @Password
  INNER JOIN Position ON Worker.PositionId = Position.Id
  INNER JOIN Rental ON Worker.RentalId = Rental.Id
END Login;
