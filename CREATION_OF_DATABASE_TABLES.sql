------------- ADMIN TABLE ----------------------------

CREATE TABLE Admin (
  AdminID varchar2(11) NOT NULL PRIMARY KEY,
  Passwords varchar2(250) NOT NULL,
  StationNo varchar2(5) NOT NULL,
  FirstName varchar2(40) NOT NULL,
  LastName varchar2(40) NOT NULL
);

 drop table Admin;

------------- USERPROFILE TABLE ----------------------------

CREATE TABLE UserProfile (
ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
UserID varchar2(11) not null primary key,
ApprovedByAdmin varchar2(11) REFERENCES Admin(AdminID),
  UserName varchar2(50) NOT NULL UNIQUE,
  Passwords varchar2(250) NOT NULL,
  FirstName varchar2(50) NOT NULL,
  LastName varchar2(50) NOT NULL,
  Street varchar2(50) NOT NULL,
  Region varchar2(50) NOT NULL,
  City varchar2(50) NOT NULL,
  States varchar2(50) NOT NULL,
  Country varchar2(50) NOT NULL,
  PhoneNumber varchar2(10) NOT NULL,
  EmailID varchar2(50) NOT NULL,
  Type_User varchar2(30) NOT NULL,
  OverAllRating decimal(2,1) default 0 not null 
);

 drop table UserProfile;

------------- RIDER TABLE ----------------------------

CREATE TABLE Rider (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  RiderID varchar2(11) not null primary key,
  UserID varchar2(11) NOT NULL REFERENCES UserProfile(UserID),
  AmountDue decimal(10,2) DEFAULT 0 NOT NULL 
  );
  
 drop table Rider;