-- Views

--1. To view the Nearby cars while requesting for a ride.

create or replace view REQUESTRIDE
as
select CARMODEL, CARREGISTRATIONNUMBER, CARCOLOR, CATEGORY, CAPACITY, LOCATIONID
from CARS;
select *
from REQUESTRIDE;


--2. Admin can view all pending requests

create or replace view USERPENDINGREQUEST
as
(
  (
    select U.USERID, U.USERNAME, U.FIRSTNAME, U.LASTNAME, U.TYPE_USER, U.STREET, U.REGION, U.CITY, U.STATES, U.COUNTRY, U.PHONENUMBER, U.EMAILID, U.APPROVEDBYADMIN
    from USERPROFILE U
    where TYPE_USER <> 'Rider'
  )
  minus (
    select U.USERID, U.USERNAME, U.FIRSTNAME, U.LASTNAME, U.TYPE_USER, U.STREET, U.REGION, U.CITY, U.STATES, U.COUNTRY, U.PHONENUMBER, U.EMAILID, U.APPROVEDBYADMIN
    from USERPROFILE U
      full outer join CAROWNER O
        on U.USERID = O.USERID
    where O.CONTRACTDURATION <> 0
  )
)
minus (
  select U.USERID, U.USERNAME, U.FIRSTNAME, U.LASTNAME, U.TYPE_USER, U.STREET, U.REGION, U.CITY, U.STATES, U.COUNTRY, U.PHONENUMBER, U.EMAILID, U.APPROVEDBYADMIN
  from USERPROFILE U
    full outer join DRIVER D
      on U.USERID = D.USERID
  where D.LICENSENO is not null
);
select *
from USERPENDINGREQUEST;


--3. To view all the trips till date

create or replace view RIDERTRIP
as
select R.RIDERID, R.CARID, R.SOURCELOCATIONID, R.DESTINATIONLOCATIONID, T.DISTANCE, R.ESTIMATIONAMOUNT, R.PROMOCODE
from REQUEST R
  join TRIP T
    on R.REQUESTID = T.REQUESTID;
select *
from RIDERTRIP;


--4. To view poplarity of methods of payments (ERROR - Not working)

create or replace view vw_MOP
AS 
(
  SELECT p.MethodOfPayment, ((COUNT(p.RiderID)*100)/
    (SELECT COUNT (*) FROM PaymentGateway)) PROMOCODEUSAGE
  FROM PaymentGateway p
  GROUP BY MethodOfPayment
);

SELECT * FROM vw_MOP;


--5. (Created) To view poplarity of promo codes

create or replace view VW_PROMOCODES
as
select
  PROMOCODE,
  ((count(REQUESTID) * 100.0) / (
    select count(REQUESTID)
    from REQUEST
    where PROMOCODE is not null
  )) PROMOCODEUSAGE
from REQUEST
where PROMOCODE is not null
group by PROMOCODE;
select *
from VW_PROMOCODES;


--6. To view supply and demand

create or replace view SUPPLY
as
select count(USERID) NUMBEROFDRIVERS, States, Type_user
from USERPROFILE
group by States, Type_User
having Type_User = 'Driver';

select States, NUMBEROFDRIVERS from SUPPLY;

create or replace view DEMAND
as
select count(REQUESTID) NUMBEROFRIDES, States, Status
from REQUEST
group by States, Status
having Status = 'Approved';

select States, NUMBEROFRIDES
from DEMAND;


--7. To calculate total revenue and total earnings of drivers

create or replace view TOTALREVENUE
as
select T1.REVENUE, T2.TOTALDRIVEREARNING, T3.TOTALCAROWNEREARNING
from
  (
    select sum(PRICE) REVENUE
    from INVOICE
  ) T1,
  (
    select sum(TOTALEARNINGS) TOTALDRIVEREARNING
    from DRIVER
  ) T2,
  (
    select sum(TOTALEARNINGS) TOTALCAROWNEREARNING
    from CAROWNER
  ) T3
;
select *
from TOTALREVENUE;


--8. To view top 3 states with positive customer feedback 

create or replace view STATEWISECUSTOMERSTATISFACTION
as
select
  RANK() over (order by avg(OVERALLRATING) desc) RANKING,
  avg(OVERALLRATING) AVGOVERALLRATING, States, Type_User
from USERPROFILE
where Type_User = 'Driver'
group by States, Type_User;

select States, AVGOVERALLRATING
from STATEWISECUSTOMERSTATISFACTION
where RANKING between 1 and 3;


--9. To view top 3 states with negative customer feedback

create or replace view STATEWISENEGATIVEFEEDBACK
as
select
  RANK() over (order by avg(OVERALLRATING)) RANKING,
  avg(OVERALLRATING) AVGOVERALLRATING,
  States,
  Type_User
from USERPROFILE
where Type_User = 'Driver'
group by States, Type_User;

select States, AVGOVERALLRATING
from STATEWISENEGATIVEFEEDBACK
where RANKING between 1 and 3;


--10. To view reasons for request cancellation

create or replace view VW_REASONFORCANCELLATIONS
as
select
  REASONFORCANCELLATION,
  ((count(REQUESTID) * 100.0) / (
    select count(REQUESTID)
    from REQUEST
    where REASONFORCANCELLATION is not null
  )) REASONPERCENTAGE
from REQUEST
where REASONFORCANCELLATION is not null
group by REASONFORCANCELLATION;

select *
from VW_REASONFORCANCELLATIONS;




