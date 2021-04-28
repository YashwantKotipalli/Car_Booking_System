

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

create or replace PROCEDURE CreateNewUser
( 
p_UserName varchar2,
p_Password varchar2,
p_FirstName varchar2,
p_LastName varchar2,
p_Street varchar2,
p_Region varchar2,
p_City varchar2,
p_State varchar2,
p_Country varchar2,
p_PhoneNumber varchar2,
p_EmailID varchar2,
p_Type varchar2
)
AS
 v_ApprovedByAdmin varchar2(10);
 v_uid varchar2(11);
 BEGIN
	v_ApprovedByAdmin := AdminApprovals(p_State);
	INSERT INTO UserProfile (ApprovedByAdmin,Username,Passwords,FirstName,LastName,Street,Region,City,States,Country,PhoneNumber,EmailID,Type_User,OverAllRating)
		VALUES (v_ApprovedByAdmin, p_UserName, p_Password, p_FirstName, p_LastName, 
				p_Street, p_Region, p_City, p_State, p_Country, p_PhoneNumber, p_EmailID, p_Type, 0);
	
 	SELECT UserID INTO v_uid FROM UserProfile WHERE UserName = p_UserName;
	IF p_Type = 'Rider'
		THEN
			INSERT INTO Rider (UserID, AmountDue)
						VALUES (v_uid, 0.0);
		END IF;
	IF p_Type = 'CarOwner'
		THEN
			INSERT INTO CarOwner(UserID, CompanyName, ContractType, TotalEarnings, ContractDuration)
						VALUES (v_uid, NULL, NULL, 0, 0);
			DBMS_OUTPUT.PUT_LINE('PLEASE PROVIDE CONTRACT DETAILS');
		END IF;
	IF p_Type = 'Driver'
		THEN
			INSERT INTO Driver (UserID, LicenseNo, Gender, TotalEarnings)
						VALUES (v_uid, NULL, NULL, 0);
			DBMS_OUTPUT.PUT_LINE('PLEASE PROVIDE LICENSE NUMBER AND GENDER');
		END IF;
END;

--------------------------------------- 3. STORED PROCEDURE TO UPDATE AN EXISTING DRIVER PROFILE FOR ENTERING THE LICENSE DETAILS ---------------------------------------------------------------

create or replace procedure DRIVERAPPROVAL(USERNAME varchar, LICENSENO varchar, GENDER char)
is
begin
    MERGE INTO DRIVER D
    USING      USERPROFILE U
    ON         (D.USERID = U.USERID)
    WHEN MATCHED THEN
        UPDATE SET D.LICENSENO = LICENSENO, D.GENDER = GENDER
        WHERE      U.USERNAME = USERNAME;
end DRIVERAPPROVAL;