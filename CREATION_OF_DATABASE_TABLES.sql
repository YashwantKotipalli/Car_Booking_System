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
 
 
 
 ------------- DRIVER TABLE ----------------------------

CREATE TABLE Driver (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  DriverID varchar2(11) not null primary key,
  UserID varchar2(11) NOT NULL REFERENCES UserProfile(UserID),
  LicenseNo varchar2(20),
  Gender char,
  TotalEarnings decimal(10,2) DEFAULT 0 NOT NULL 
  );
  
 drop table Driver;
------------- CAR OWNER TABLE ----------------------------


CREATE TABLE CarOwner (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  OwnerID varchar2(11) not null primary key,
  UserID varchar2(11) NOT NULL REFERENCES UserProfile(UserID),
  CompanyName varchar2(30),
  ContractType varchar2(20),
  TotalEarnings decimal(10,2) DEFAULT 0 NOT NULL ,
  ContractDuration INTEGER DEFAULT 0 NOT NULL 
  );
  
   drop table CarOwner;
   
------------- FEEDBACK TABLE ----------------------------


CREATE TABLE FeedBacks (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  FeedBackID varchar2(11) not null primary key,
  UserID varchar2(11) NOT NULL REFERENCES UserProfile(UserID),
  Rating decimal(2,1) DEFAULT 0 NOT NULL ,
  Remarks varchar2(100)
  );

 drop table Feedbacks;

------------- PROMO CODE TABLE ----------------------------


CREATE TABLE PromoCode (
  PromoCode varchar2(50)  NOT NULL Primary Key,
  Offer varchar2(100) not null,
  DiscountAmount decimal(5,2) DEFAULT 0 NOT NULL
  );
  
  drop table PromoCode;


------------- LOCATIONS TABLE ----------------------------
  
  CREATE TABLE Locations(
    LocationID INTEGER NOT NULL PRIMARY KEY,
    Street varchar2(100) NOT NULL,
    Region varchar2(50) NOT NULL,
    City varchar2(50) NOT NULL,
    States varchar2(50) NOT NULL,
    Country varchar2(50) NOT NULL,
    Latitude decimal(10,6) NOT NULL,
    Longitude decimal(10,6) NOT NULL
  );
  
  drop table Locations;
  
  
  ------------- CARS TABLE ----------------------------
  
  
  CREATE TABLE Cars(
    ID INTEGER GENERATED AS IDENTITY (START WITH 1 INCREMENT BY 1),
    CarID varchar2(11) NOT NULL PRIMARY KEY,
    OwnerID varchar2(11) NOT NULL REFERENCES CAROWNER(OWNERID),
    DriverID varchar2(11) NOT NULL REFERENCES DRIVER(DRIVERID),
    CarModel varchar2(50) NOT NULL,
    CarRegistrationNumber varchar2(10) NOT NULL,
    CarColor varchar2(30) NOT NULL,
    LocationID INTEGER NOT NULL REFERENCES Locations(LocationID),
    Capacities INTEGER NOT NULL,
    Categories varchar2(25) NOT NULL
  );
  
  drop table Cars;
  
  ------------- TRIP CHARGES TABLE ----------------------------
  
  CREATE TABLE TripCharges(
    
    States varchar2(50) NOT NULL PRIMARY KEY,
    Tax decimal(5,3) DEFAULT 0 NOT NULL,
    ChargePerKilometer decimal(5,3) DEFAULT 0 NOT NULL 
  );
  
   drop table TripCharges;
  
  ------------- REQUEST TABLE ----------------------------
  
 CREATE TABLE Request(
 
    ID INTEGER GENERATED AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    RequestID varchar2(11) NOT NULL Primary Key,
    RiderID varchar2(11) NOT NULL REFERENCES Rider(RiderID),
    CarID varchar2(11) NOT NULL REFERENCES Cars(CarID),
    SourceLocationID INTEGER NOT NULL REFERENCES Locations(LocationID),
    DestinationLocationID INTEGER NOT NULL REFERENCES Locations(LocationID),
    Status varchar2(50) DEFAULT 'Pending Approval' NOT NULL ,
    States generated always as (RetrieveState(SourceLocationID)),
    PromoCode varchar2(50) DEFAULT NULL REFERENCES PromoCode(PromoCode) ,
    ReasonForCancellation varchar2(100),
    EstimationAmount generated always as(EstimateTripAmount(SourceLocationID, DestinationLocationID, PromoCode))
    
 );
 

 
  drop table Request;
 
------------- TRIP TABLE ----------------------------

CREATE TABLE Trip (
  RequestID varchar2(11) NOT NULL REFERENCES Request(RequestID),
  Distance decimal(5,3) NOT NULL,
  Status varchar2(50) DEFAULT 'On the Way' NOT NULL ,
  StartTimestamp Date DEFAULT SYSDATE NOT NULL ,
  DropTimestamp Date DEFAULT SYSDATE NOT NULL 
); 
 
 drop table Trip;


------------- INVOICE TABLE ----------------------------


CREATE TABLE Invoice (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  InvoiceID varchar2(11) not null primary key,
  RequestID varchar2(11) NOT NULL REFERENCES Request(RequestID),
  Distance decimal(5,2) NOT NULL,
  Price decimal(10,3) NOT NULL
  );

   drop table Invoice;

------------- PAYMENT GATEWAY TABLE ----------------------------


CREATE TABLE PaymentGateway (
  ID INTEGER GENERATED AS IDENTITY(Start with 1 increment by 1) NOT NULL,
  PaymentID varchar2(11) not null primary key,
  InvoiceID varchar2(11) NOT NULL REFERENCES Invoice(InvoiceID),
  RiderID varchar2(11) NOT NULL REFERENCES Rider(RiderID),
  MethodOfPayment varchar2(25) NOT NULL,
  Amount decimal(10,2) NOT NULL,
  Status varchar2(15) NOT NULL
  );

 drop table PaymentGateway;
