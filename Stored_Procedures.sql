

-------------------------------------- STORED PROCEDURES -----------------------------------------------------------------------


--------------------------------------- 1. UPDATING THE CAR OWNER PROFILE FOR ENTERING THE CONTRACT DETAILS ---------------------------------------------------------------


create or replace procedure CAROWNERAPPROVAL(USERNAME varchar, COMPANYNAME varchar, CONTRACTTYPE varchar, CONTRACTDURATION integer)
as
  EARNINGS decimal(10, 2);
BEGIN
  EARNINGS := (250 * CONTRACTDURATION);

  MERGE INTO CAROWNER C
    USING      USERPROFILE U
    ON         (C.USERID = U.USERID)
    WHEN MATCHED THEN
        UPDATE SET C.COMPANYNAME = COMPANYNAME, C.CONTRACTTYPE = CONTRACTTYPE, 
                    C.TOTALEARNINGS = EARNINGS, C.CONTRACTDURATION = CONTRACTDURATION
        WHERE U.USERNAME = USERNAME;
end CAROWNERAPPROVAL;



--------------------------------------- 2. REGISTRATION OF A NEW USER USING STORED PROCEDURES ---------------------------------------------------------------


















--------------------------------------- 3. STORED PROCEDURE TO UPDATE AN EXISTING DRIVER PROFILE FOR ENTERING THE LICENSE DETAILS ---------------------------------------------------------------