CREATE OR REPLACE PROCEDURE Login 
(
  Email IN NVARCHAR2,
  Password IN VARCHAR,
  WorkerId OUT NUMBER,
  Name OUT NVARCHAR2,
  Surname OUT NVARCHAR2,
  RentalId OUT NUMBER,
  Localisation OUT NVARCHAR2,
  Position OUT NVARCHAR2
) 
AS
BEGIN
  BEGIN
    SELECT Worker.Id, Worker.Name, Worker.Surname, Rental.Id, Rental.Localisation, Position.Position 
    INTO Login.WorkerId, Login.Name, Login.Surname, Login.RentalId, Login.Localisation, Login.Position
    FROM Worker 
    INNER JOIN Position ON Worker.PositionId = Position.Id
    INNER JOIN Rental ON Worker.RentalId = Rental.Id
    WHERE Worker.Email = Login.Email AND Worker.Password = Login.Password;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      Login.WorkerId :=NULL; Login.Name:=NULL; Login.Surname:=NULL; Login.RentalId:=NULL; Login.Localisation:=NULL; Login.Position:=NULL;
  END;
END Login;
