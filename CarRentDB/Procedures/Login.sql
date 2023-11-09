-- Procedure definition

CREATE PROCEDURE PROCEDURE1 (
  PARAM1 IN NUMBER) IS

-- Declare constants and variables in this section.
-- Example: <Variable Identifier> <DATATYPE>
--          <Variable Identifier> CONSTANT <DATATYPE>
--          varEname  VARCHAR2(40);
--          varComm   REAL;
--          varSalary CONSTANT NUMBER:=1000;
--          comm_missing EXCEPTION;
  varSum NUMBER;

-- Executable part starts here
BEGIN

  -- Write PL/SQL and SQL statements to implement the processing logic
  -- of subprogram. Example:
  --     SELECT ENAME,
  --            COMM
  --     INTO   varEname,
  --            varComm
  --     FROM   EMP
  --     WHERE  EMPNO = 7369;
  --
  --     IF varComm IS NULL THEN
  --         RAISE comm_missing;
  --     END IF;

  NULL;

  -- EXCEPTION -- exception-handling part starts here
  -- WHEN comm_missing THEN
  --   dbms_output.put_line('Commision is NULL');

END PROCEDURE1;
