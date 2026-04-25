drop database if exists tfg;
create database tfg;
use tfg;

create table users(
    userID int primary key auto_increment,
    phoneNumber char(10) not null,
    fname varchar(255) not null,
    lname varchar(255) not null,
    username varchar(255) not null,
    email varchar(255) not null unique,
    password varchar(255) not null,
    isStaff boolean default false,
    profilePicture text,
    bio text,
    registeredDate datetime
);

-- create trigger for this
create table userhistory(
userID int primary key,
phoneNumber char(10) not null,
fname varchar(255) not null,
lname varchar(255) not null,
username varchar(255) not null,
email varchar(255) not null,
password varchar(255) not null,
isStaff boolean default false,
bio text,
registeredDate datetime,
-- TODO: Edit trigger for this, shouldn't be automatic
deletionDate datetime default null,
-- update existing view below, whatever tf I named it, to change enum status to one of these
accountStatus enum("Deleted", "Registered") default "Registered"
);

create table positionenums (
positionID int primary key auto_increment, 
position enum("Flight Attendent", "Pilot", "Co-Pilot", "Security", "Unassigned", "Admin") default "Unassigned"
);

create table staff(
staffID int primary key,
email varchar(255) references users(email) ,
positionID int default 5 references positionenums(positionID)
);

create table staffhistory(
staffID int primary key,
email varchar(255) not null,
positionID int not null,
deletionDate datetime default null,
accountStatus enum ("Deleted", "Registered")
);

-- Honestly why did I not add planeName to plane in the first place
create table plane(
ICAO varchar(4) primary key,
planeName varchar(255)
);

create table hanger(
hangerID int primary key auto_increment,
ICAO varchar(4) references plane(ICAO) on delete cascade on update cascade,
planeStatus enum ("In use", "Available") not null default ("Available")
);

create table regions(
    regionID int primary key,
    region varchar(255)
);

create table airports(
    airportID int primary key auto_increment,
    regionID int,
    place varchar(255),
    name varchar(255),
    IATA varchar(3),
    constraint fk_airports_region
        foreign key (regionID) references regions(regionID)
);

-- Cleaned up constraints, no longer has a composite primary key, constraint on capacity now on attribute, not allowing an empty plane.
create table flight(
    IATA varchar(7) primary key,
    ICAO varchar(4),
    gate varchar(2),
    origin int,
    destination int,
    capacity int check (capacity <= 36 and capacity > 0),
    assignedPilot int,
    constraint ensure_pilot_exists foreign key (assignedPilot) references staff(staffID),
    constraint ensure_plane_exists foreign key (ICAO) references plane(ICAO), 
    constraint ensure_flight_origin_exists foreign key (origin) references airports(airportID),
    constraint ensure_flight_destination_exists foreign key (destination) references airports(airportID)
);
-- On time: 1 hour before take off
-- Boarding: 30 minutes before take off
-- Airborne: Duration of flight
-- Landing: 10 minutes after "end" of flight
-- Grounded: 30 minutes after "end" of flight
create table schedule(
    scheduleID int primary key auto_increment,
    flightID varchar(7) not null,
    liftOff datetime not null,
    landing datetime not null,
    status enum('On Time', 'Delayed', 'Boarding', 'Taxiing', 'Airborne', 'Landing', 'Grounded'),
    constraint ensure_flight_exists foreign key (flightID) references flight(IATA),
    -- Don't know why I didn't add this earlier, but a quick constraint to prevent liftOff being before landing
    -- Honestly with how we have frontend built, this shouldn't really do anything, but it's nice to just have
    constraint ensure_schedule_times check (landing > liftoff)
);

create table flightclass(
classID int auto_increment primary key,
className varchar(255) not null,
price double
);

create table planeseat(
    seatNumber varchar(3),
    scheduleID int,
    classID int,
    constraint fk_planeseat_schedule
        foreign key (scheduleID) references schedule(scheduleID),
    constraint fk_class_id
        foreign key (classID) references flightclass(classID),
    primary key(seatNumber, scheduleID)
);

-- A table with all the info in one for the view appointment part and cause it's cleaner
create table booking(
    bookingNumber int primary key auto_increment,
    -- Found out this was a thing, going to delete the trigger doing this later
    bookingDate datetime default current_timestamp,
    userID int not null,
    departSeat varchar(3) not null,
    returnSeat varchar(3) not null,
    departScheduleID int not null,
    returnScheduleID int not null,
    constraint ensure_booking_user_exists foreign key (userID) references users(userID),
    constraint ensure_depart_schedule_exists foreign key (departScheduleID) references schedule(scheduleID),
    constraint ensure_return_schedule_exists foreign key (returnScheduleID) references schedule(scheduleID),
    constraint ensure_depart_seat_exists foreign key (departSeat, departScheduleID) references planeseat(seatNumber, scheduleID),
    constraint ensure_return_seat_exists foreign key (returnSeat, returnScheduleID) references planeseat(seatNumber, scheduleID)
);

-- python will change cancelledBy,
create table bookinghistory(
    bookingNumber int primary key,
    bookingDate datetime,
    userID int not null,
    departSeat varchar(3) not null,
    returnSeat varchar(3) not null,
    departScheduleID int not null,
    returnScheduleID int not null,
    departLiftOff datetime not null,
    departLanding datetime not null,
    returnLiftOff datetime not null,
    returnLanding datetime not null,
    bookingStatus enum("Cancelled", "Completed", "In Progress") not null default "In Progress",
    -- possibly needed for archiving, displaying old completed flights and when they were made
	archiveDate datetime default current_timestamp,
    -- TODO: create a trigger for this so we can track dates
    cancellationDate datetime default null,
    -- This is the userID/staffID of WHOM cancelled the ID. Mostly likely, this is going to be an update on the python side. Gunna think about logistics later, but can't exactly be trigger. Mostly likely going to default to "Null", and updated on python side
    cancelledBy int default null,
    reason text
);

create table reviews(
ratingID int primary key auto_increment,
bookingID int,
userID int,
rating int,
review text, 
creationDate datetime default current_timestamp,
deletionDate datetime default null
);

create table item (
itemID int primary key auto_increment,
itemName varchar(255) not null,
itemDescription text,
type enum("equipment","transportation", "misc") not null
);

create table equipment(
itemID int primary key,
equipmentName varchar(255),
equipmentDescription text,
constraint fk_equipment_item foreign key (itemID) references item(itemID) on delete cascade
);

create table transportation(
itemID int primary key,
transportName varchar(255),
transportDescription text,
constraint fk_transportation_item foreign key (itemID) references item(itemID) on delete cascade
);

create table miscellaneousitem(
itemID int primary key,
itemName varchar(255),
itemDescription text,
constraint fk_miscellaneous_item foreign key (itemID) references item(itemID) on delete cascade
);

create table parkinglot(
lot char(1) primary key,
lotSpace int 
);

create table inventory(
itemID int primary key,
quantity int check (quantity >= 0),
constraint fk_inventory_item foreign key (itemID) references item(itemID) on delete cascade
);

-- After deletion/cancellation of an appointment
create table cancellationnotifs(
userID int,
bookingID int, -- This is the ID of what was cancelled. A trigger, after deletion, will insert ALL userIDs related the bookingID EXCLUDING the ID of the one who cancelled it.
primary key(userID, bookingID),
constraint ensure_user_exists foreign key (userID) references users(userID)
);

-- no idea how I'ma do this
create table planearrivalnotifs(
userID int,
scheduleID int,
primary key(userID, scheduleID),
constraint ensure_flight_exists_two foreign key (scheduleID) references schedule(scheduleID)
);

create table pilotassignmentnotifs(
userID int,
flightID varchar(7),
primary key(userID, flightID),
constraint ensure_pilot_exists_two foreign key (userID) references staff(staffID),
constraint ensure_flight_exists_three foreign key (flightID) references flight(IATA)
);

-- triggers
delimiter //

create trigger transportandequipmentinsert
after insert on item
for each row
begin
	if (new.type = "equipment")
		then
			insert into equipment(itemID, equipmentName, equipmentDescription) values 
            (new.itemID, new.itemName, new.itemDescription);
	elseif (new.type = "transportation")
		then 
			insert into transportation(itemID, transportName, transportDescription) values
            (new.itemID, new.itemName, new.itemDescription);
	elseif (new.type="misc")
		then
			insert into miscellaneousitem(itemID, itemName, itemDescription) values
            (new.itemID, new.itemName, new.itemDescription);
	end if;
end//

create trigger createstaff
after insert on users
for each row
begin
    if new.isStaff = true
		then
			insert into staff(staffID, email) values
            (new.userID, new.email);
    end if;
end//

create trigger createstaffAfterUpdate
after update on users
for each row
begin
    if new.isStaff = true 
		then
			insert into staff(staffID, email) values
            (new.userID, new.email);
    end if;
end//

-- WORK ON THIS
create trigger rememberStaff
after insert on staff
for each row 
insert into staffhistory(staffID, email, positionID, accountStatus) values (new.staffID, new.email, new.positionID, "Registered");

create trigger deletedStaff
after delete on staff
for each row
update staffhistory set accountStatus = "Deleted", deletionDate = curdate() where old.staffID = staffID;

create trigger enforceAvailablePilot
before insert on flight
for each row
begin
	if new.assignedPilot is null
		then
			signal sqlstate '45000'
            set message_text = "A flight must have an assigned pilot";
	end if;

    if not exists (
        select 1
        from staff s
        join positionenums p on p.positionID = s.positionID
        where s.staffID = new.assignedPilot
          and p.position = "Pilot"
    )
		then 
			signal sqlstate '45000'
            set message_text = "The staff attempting to take control of the plane is NOT a pilot";
	end if;
end//

-- This checks if, upon insertion, a pilot is being used in a flight insertion where the new liftOff Date is newer/before the old landing date
-- Essentially, prevent inserts into flight if a pilot exists, and the new liftOff date is before old landing date
create trigger validFlightInsertPrevention
before insert on schedule
for each row
begin
	if exists (
        select 1
        from flight f
        join schedule s on f.IATA = s.flightID
        where f.assignedPilot = (
            select assignedPilot
            from flight f
            where IATA = new.flightID
        )
        and f.IATA <> new.flightID
        and new.liftOff < s.landing
        and new.landing > s.liftOff
    ) then
        signal sqlstate '45000'
        set message_text = 'Pilot is already assigned to another active flight during that time.';
    end if;	
end//

-- Same thing as previous trigger, but preventing bad updates
create trigger validFlightUpdatePrevention
before update on schedule
for each row
begin
    if exists (
        select 1
        from flight f
        join schedule s on f.IATA = s.flightID
        where f.assignedPilot = (
            select assignedPilot
            from flight f
            where IATA = new.flightID
        )
        and f.IATA <> old.flightID
        and new.liftOff < s.landing
        and new.landing > s.liftOff
    ) then
        signal sqlstate '45000'
        set message_text = 'Pilot is already assigned to another active flight during that time.';
    end if;
end//

create trigger rememberUser
after insert on users
for each row
-- FIX THIS
insert into userhistory(userID, phoneNumber, fname, lname, username, email, password, isStaff, bio, registeredDate)
values(new.userID, new.phoneNumber, new.fname, new.lname, new.username, new.email, new.password, new.isStaff, new.bio, new.registeredDate);

create trigger deletedUserAndStaff
after delete on users
for each row
begin
	if old.isStaff = true
		then
			delete from staff where old.userID = staffID;
	end if;
    update userhistory set accountStatus = "Deleted", deletionDate = curdate() where userID = old.userID;
    
end//


-- got rid of validReservationChange cause it got deprecated in my DB changes, this comments gunna get removed in later commits next sprint

create trigger storePlaneInHanger
after insert on plane
for each row
insert into hanger(ICAO, planestatus) values (new.ICAO, "Available")//

create trigger updatePlaneAvailability
after insert on flight
for each row
update hanger h set planeStatus = "In use" where new.ICAO = h.ICAO//

create trigger editingPlaneInUse
before update on plane
for each row
begin
	if old.ICAO <> new.ICAO then
		if exists (
			select 1
			from flight f
			where f.ICAO = old.ICAO
		) then
			signal sqlstate '45000'
			set message_text = 'This plane is in use, editing the name is probably not the right call right now.';
		end if;

		if exists (
			select 1
			from plane p
			where p.ICAO = new.ICAO
		) then
			signal sqlstate '45000'
			set message_text = 'That ICAO already exists in the system.';
		end if;
	end if;
end//

-- Automatically changes the status of the flight depending on the current time in relation to these constraints that we made up a couple days ago:
-- On time: 1 hour before take off
-- Boarding: 30 minutes before take off
-- Airborne: Duration of flight
-- Landing: 10 minutes after "end" of flight
-- Grounded: 30 minutes after "end" of flight
create trigger setScheduleStatusBeforeInsert
before insert on schedule
for each row
begin
    if now() < date_sub(new.liftOff, interval 1 hour) then
        set new.status = 'Grounded';
    elseif now() >= date_sub(new.liftOff, interval 1 hour)
       and now() < date_sub(new.liftOff, interval 30 minute) then
        set new.status = 'On Time';
    elseif now() >= date_sub(new.liftOff, interval 30 minute)
       and now() < new.liftOff then
        set new.status = 'Boarding';
    elseif now() >= new.liftOff
       and now() < new.landing then
        set new.status = 'Airborne';
    elseif now() >= new.landing
       and now() < date_add(new.landing, interval 10 minute) then
        set new.status = 'Landing';
    elseif now() >= date_add(new.landing, interval 10 minute)
       and now() < date_add(new.landing, interval 30 minute) then
        set new.status = 'Grounded';
    else
        set new.status = 'Grounded';
    end if;
end//

create trigger setScheduleStatusBeforeUpdate
before update on schedule
for each row
begin
    if now() < date_sub(new.liftOff, interval 1 hour) then
        set new.status = 'Grounded';
    elseif now() >= date_sub(new.liftOff, interval 1 hour)
       and now() < date_sub(new.liftOff, interval 30 minute) then
        set new.status = 'On Time';
    elseif now() >= date_sub(new.liftOff, interval 30 minute)
       and now() < new.liftOff then
        set new.status = 'Boarding';
    elseif now() >= new.liftOff
       and now() < new.landing then
        set new.status = 'Airborne';
    elseif now() >= new.landing
       and now() < date_add(new.landing, interval 10 minute) then
        set new.status = 'Landing';
    elseif now() >= date_add(new.landing, interval 10 minute)
       and now() < date_add(new.landing, interval 30 minute) then
        set new.status = 'Grounded';
    else
        set new.status = 'Grounded';
    end if;
end//

-- To remember ALL bookings
-- new.departLiftOff, new.departLanding, new.returnLiftOff, new.returnLanding,
create trigger RememberBookings
after insert on booking
for each row
	insert into bookinghistory(bookingNumber, bookingDate, userID, departSeat, returnSeat, departScheduleID, returnScheduleID, departLiftOff, departLanding, returnLiftOff, returnLanding)
    select new.bookingNumber, new.bookingDate, new.userID, new.departSeat, new.returnSeat, new.departScheduleID, new.returnScheduleID, ds.liftOff, ds.landing, rs.liftOff, rs.landing
    from schedule ds
    join schedule rs on rs.scheduleID = new.returnScheduleID where ds.scheduleID = new.departScheduleID;


create trigger updateBookingHistoryAfterBookingCancellation
after delete on booking
for each row
	update bookinghistory set bookingStatus = "Cancelled", cancellationDate = curdate() where bookingNumber = old.bookingNumber;
    
create trigger createCancellationNotif
after delete on booking
for each row
begin
    insert into cancellationnotifs(userID, bookingID)
    values(old.userID, old.bookingNumber);
end//

create trigger createPilotAssignmentNotifAfterInsert
after insert on flight
for each row
begin
    if new.assignedPilot is not null then
        insert into pilotassignmentnotifs(userID, flightID)
        values(new.assignedPilot, new.IATA);
    end if;
end//

delimiter ;

delimiter //

-- procedures
-- Resets a pilots and planes availability after a schedule is done
create procedure clearpilotandflightavailability()
begin
    update hanger h
    join flight f on h.ICAO = f.ICAO
    join schedule s on s.flightID = f.IATA
    set h.planeStatus = 'Available'
    where s.landing is not null
    -- Found out why this wasn't working, s was instead schedule for some reason
      and now() >= s.landing;

    update flight f
    join schedule s on s.flightID = f.IATA
    set f.assignedPilot = null
    where s.landing is not null
      and now() >= s.landing;
end//
delimiter ;

-- TFG Views --
-- view for staff count per position
create view staffcountperposition as select
pe.position, 
count(s.staffID) as positionCount
from positionenums pe
left join staff s using(positionID)
group by pe.positionID;

-- Creating a view so that I can display item names and stuff like that instead of just ids,
-- avoiding overflooding of the python file for no reason

create view inventorynames as
select
-- inventory
i.itemID, i.quantity,
(i.quantity > 0) as isAvailable,
-- item joins
it.type, it.itemName
from inventory i
join item it on it.itemID = i.itemID;

-- Reservation ticket view with all attributes needed for view reservations
create or replace view reservationticket as
select
-- booking b join for the basic booking info
b.bookingNumber as bookingNumber, b.userID as userID, b.bookingDate as reservationDate,
-- Still booking, but these are for the seat assignment for the depart and return
b.departSeat as departSeatNumber, b.returnSeat as returnSeatNumber,
-- return and depart travelling dates
-- users
u.username as username,

-- only the depart info
ds.liftOff as departLiftOffDate, ds.landing as departArrivingDate,
df.IATA as departFlight,
-- This is the name of the airports for the tickets, dFAO stands for depart flight airport origin, dfad stands for depart flight airport destination
dfAO.name as departOrigin, dfAD.name as departDestination,

-- return info
rs.liftOff as returnLiftOffDate, rs.landing as returnArrivingDate,
rf.IATA as returnFlight,
-- same naming scheme, again this is the name of the airports for the tickets.
rfAO.name as returnOrigin, rfAD.name as returnDestination
from booking b


-- joins
left join users u using(userID)
-- Joining for depart schedule, connecting through departSchedule (an id)
left join schedule ds on ds.scheduleID = b.departScheduleID
-- get the origin flightID
left join flight df on df.IATA = ds.flightID
-- Duplicate joins for the names of the airports on both destination and origin
left join airports dfAO on dfAO.airportID = df.origin
left join airports dfAD on dfAD.airportID = df.destination
-- joining for the return schedule, connecting through return this time
left join schedule rs on rs.scheduleID = b.returnScheduleID
-- actually getting the return flight
left join flight rf on rf.IATA = rs.flightID
-- duplicate joisn for the names of the airports on for the rturn destination and origin
left join airports rfAO on rfAO.airportID = rf.origin
left join airports rfAD on rfAD.airportID = rf.destination;


-- view for view all users 
create or replace view userreservationsummary as
select
u.userID, u.email, u.username,
datediff(curdate(), date(u.registeredDate)) as registerLengthDays, count(b.bookingNumber) as totalReservations,
sum(case when ds.landing < now() and (rs.landing is null or rs.landing < now()) then 1 else 0 end) as totalPastReservations,
sum(case when ds.liftOff >= now() or (rs.landing is not null and rs.landing >= now()) then 1 else 0 end) as totalFutureReservations
from users u
left join booking b on u.userID = b.userID
left join schedule ds on b.departScheduleID = ds.scheduleID
left join schedule rs on b.returnScheduleID = rs.scheduleID
group by u.userID, u.email, u.username, u.registeredDate;

-- Grabs the ICAO and plane status from hanger as long as it exists in the plane table
-- This way, we can get planes that are available for use without grabbing from the memory table directly
create or replace view planestatus as
select h.ICAO, h.planeStatus
from hanger h
where h.ICAO in (select ICAO from plane);

create or replace view pilotscheduleinfo as
select	
-- User joins
    u.fname, u.lname,
-- Staff joins
    s.staffID,
-- flight joins
    f.IATA as flight,
    f.origin,
    f.destination,
-- plane (via hanger)
    h.ICAO as plane,
-- schedule joins
    sc.liftOff, sc.landing, sc.status
from staff s
join users u on u.userID = s.staffID
join flight f on f.assignedPilot = s.staffID
join schedule sc on sc.flightID = f.IATA
left join hanger h on h.ICAO = f.ICAO;

-- changed from time format to date format, remember to include in commit later
create or replace view available_flights as
select
s.scheduleID,
ao.IATA as origin_IATA, 
ad.IATA as destination_IATA, 
f.IATA, f.capacity,
DATE_FORMAT(s.liftOff, "%Y-%m-%d %H:%i") as liftOff, 
DATE_FORMAT(s.landing, "%Y-%m-%d %H:%i") as landing, 
CONCAT(TIMESTAMPDIFF(hour, s.liftOff, s.landing), "h ", MOD(TIMESTAMPDIFF(minute, s.liftOff, s.landing), 60), 'm') as duration
from flight f
join airports ao on f.origin = ao.airportID
join airports ad on f.destination = ad.airportID
join schedule s on f.IATA = s.flightID;

create or replace view bhcancellationmonthlycounts as
select
year(cancellationDate) as deletionyear,
month(cancellationDate) as deletionmonth,
count(*) as total_cancellations
from bookinghistory
where bookingStatus = "Cancelled"
group by year(cancellationDate), month(cancellationDate);

create or replace view bhcancellationsbywhodoneit as
select
year(bh.cancellationDate) as deletionyear,
month(bh.cancellationDate) as deletionmonth,
case
    when u.username = "admin" then "admin"
    when u.isStaff = 1 then "staff"
    else "user"
end as cancellationcategory,
count(*) as total_cancellations
from bookinghistory bh
join users u on u.userID = bh.cancelledBy
where bh.bookingStatus = "Cancelled"
group by
    year(bh.cancellationDate),
    month(bh.cancellationDate),
    case
        when u.username = "admin" then "admin"
        when u.isStaff = 1 then "staff"
        else "user"
    end;

create or replace view psinfomonthlycounts as
select
fname, lname, staffID as staffid,
year(liftOff) as departyear,
month(liftOff) as departmonth,
count(*) as bookingcount
from pilotscheduleinfo
group by fname, lname, staffID, year(liftOff), month(liftOff);

create or replace view rtmonthlycounts as
select
year(reservationDate) as reservationyear,
month(reservationDate) as reservationmonth,
count(*) as monthly_reservations,
count(distinct userID) as distinct_reservations_this_month
from reservationticket
group by year(reservationDate), month(reservationDate);

create or replace view rtusercounts as
select
count(bookingNumber) as bookingamount,
userID as userid,
username
from reservationticket
group by userID, username;


insert into positionenums (positionID, position) values
(1, "Flight Attendent"),
(2, "Pilot"),
(3, "Co-Pilot"),
(4, "Security"),
(5, "Unassigned"),
(6, "Admin");

insert into users (userID, phoneNumber, fname, lname, username, email, password, isStaff, profilePicture, bio, registeredDate) values
(1, "5127997308", "Alan", "Gascon", "McTails", "alangascon@gmail.com", "3d45597256050bb1e93bd9c10aee4c8716f8774f5a48c995bf0cf860", 0, null, null, "2026-03-01 09:00:00"),
(2, "5123005252", "Maria", "Valentine", "ValesMom", "mariavalentine@gmail.com", "8e012a7c9d83ad6d0a8c4623bccf2f208985d847cf8de8257111037e", 1, null, null, "2026-03-01 09:15:00"),
(3, "5125550101", "Kai", "Cairo", "kcfrost", "kaicairo@gmail.com", "e04c3fcc21706ccaf4dac43d0e2530de2b5075963b50d6fc71b75306", 1, null, null, "2026-03-01 09:30:00"),
(4, "5125550102", "Richard", "Walker", "rich93147", "richardwalker@gmail.com", "b9b3bbe5850b2e006260ce9e7575af2135381fc2387d141adbae4ed9", 1, null, null, "2026-03-01 09:45:00"),
(5, "5125550103", "Erin", "Choi", "ErinCo", "erinchoi@gmail.com", "6c09ee70bba90aa92e604850300911d13ec0f793f142f1d751436a28", 1, null, null, "2026-03-01 10:00:00"),
(6, "5125550104", "Omar", "Singh", "OmarSec", "omarsingh@gmail.com", "9da84c9b32f7ed60b153942887bee79fd607c02761697cf3da75c467", 0, null, null, "2026-03-01 10:15:00"),
(7, "5125550105", "Tess", "Nguyen", "TessFA", "tessnguyen@gmail.com", "abf520e115e79883efd11fc1c2ecb835f84aedebbcae9243a59a51de", 0, null, null, "2026-03-01 10:30:00"),
(8, "5125550106", "Luis", "Martinez", "LuisOps", "luismartinez@gmail.com", "37cd094b9932c2b6145a891f070fc3d0529643c7fd0945e80290c7db", 0, null, null, "2026-03-01 10:45:00"),
(9, "5125550201", "Bongo", "Gigglefart", "bongojet", "bongogigglefart@gmail.com", "e3264e3441f7771da59005bc31b21e28976df50536942aae6780c9e1", 1, null, null, "2026-03-01 11:00:00"),
(10, "5125550202", "Crunch", "Giggler", "crunchpilot", "crunchgiggler@gmail.com", "1113d702884878bbbc5f4102973be7e8fca7a73643a653f1c0094aa9", 1, null, null, "2026-03-01 11:15:00"),
(11, "5125550203", "Toaster", "Giggleblast", "toastgob", "toastergiggleblast@gmail.com", "89b1a7ff725054065f3f0b17c6bbe0d1021ef36ae9561add61241064", 1, null, null, "2026-03-01 11:30:00"),
(12, "5125550204", "Toe", "Gigglesnort", "toeLiker", "toegigglesnort@gmail.com", "5d85e39972dda93ad56a7c4697c25e52c481667d42ec3da1831a8323", 1, null, null, "2026-03-01 11:45:00"),
(13, "5125550205", "Soggy", "Gigglenoodle", "sogwaff", "soggygigglenoodle@gmail.com", "1ea30687f3f2b94bbb7ec553c4b9d6fd0c0c0accffda7e6ce70d0ae4", 0, null, null, "2026-03-01 12:00:00"),
(14, "5125550206", "Grease", "Gigglechunk", "greasemc", "greasegigglechunk@gmail.com", "eb4b19792f4aeb780bc5a0f98d31e510b3479d7c0e566a330d4fec49", 0, null, null, "2026-03-01 12:15:00"),
(15, "5125550207", "Wiggles", "Gigglepants", "wigglefunk", "wigglesgigglepants@gmail.com", "f6890f6e78029659e9f65d1c41faccba06b96c8818e2553e0fa7f425", 0, null, null, "2026-03-01 12:30:00"),
(16, "5125550208", "Cheddar", "Gigglecheese", "chedblast", "cheddargigglecheese@gmail.com", "6c95d9fba357468220b1305a5593e78da8eabecbf5039fb9214b06aa", 0, null, null, "2026-03-01 12:45:00"),
(17, "5125551000", "Rex", "Gigglefart", "rexhar", "rexgigglefart@gmail.com", "915ff5a2d51fe69d6c948bb6b2a77835b29c30dc00aad8e2c8a372e9", 1, null, null, "2026-03-15 08:00:00"),
(18, "5125551001", "Nadia", "Giggler", "nadiavos", "nadiagiggler@gmail.com", "2045d6530c48dadf94cf7ffc785cede6b680b602f376ac483e402253", 1, null, null, "2026-03-15 08:00:00"),
(19, "5125551002", "Colt", "Giggleblast", "coltbla", "coltgiggleblast@gmail.com", "adac97622b6281379ce628e0f4d4c31c482a1c4074c5ac1b2c413c7e", 1, null, null, "2026-03-15 08:00:00"),
(20, "5125551003", "Inez", "Gigglesnort", "inezfer", "inezgigglesnort@gmail.com", "93d83c88cd84efbebf28f15f185ab4c909e75bf52560740bf3f8423d", 1, null, null, "2026-03-15 08:00:00"),
(22, "123", "admin", "admin", "iamanadmin", "admin@admin.com", "641bde2781319a338d8b5970db8bd1950cc952a79420597b0c241c72", 0, null, null, "2026-04-01 15:10:39"),
(23, "123213", "staff", "staff", "SATFF!!", "staff1@staff.com", "7c68303949eb4127f8c36bf8247c3951c3a19dd04c5419c3d4aae500", 1, null, null, "2026-04-01 15:12:38"),
(24, "3434", "AAAAA", "AAAAA", "Meoww123?", "Meoww123?@gmail.com", "86cdbca762d6e4f8260aa7a078a4c9fabd68c26cb3e7bd1289ee7e28", 0, null, null, "2026-04-01 15:14:27"),
(25, "1231231234", "asdf", "asdf", "testAdmin@admin.com", "testAdmin@admin.com", "830f851001f6618afccfeae6412db325350f233f730a3063ebefbf50", 0, null, null, "2026-04-14 08:32:42"),
(26, "1231231234", "example", "user5", "insertuser5", "insertuser5@gmail.com", "8e8ff798bd1d948c046922a325102436e3d021f109dd1c3567cb0098", 0, null, null, "2026-04-14 17:32:51"),
(27, "4564564567", "exampleuser", "two", "somethingsomething", "exampleuser2@gmail.com", "9cb476f31b070b7146bed94269a89581d137c0db8642a53a152ea50a", 0, null, null, "2026-04-14 17:33:44"),
(28, "7897987894", "pilot", "user", "ImAPilot", "PilotUser@gmail.com", "fe62b4bbbfbc9e2dba09f7f23e8970ae38c2750e8b585f4a85d61b32", 1, null, null, "2026-04-14 17:34:31"),
(29, "4564564561", "ILikeFlying", "Alot", "ILikeFlying", "flyer@gmail.com", "e8384f29d3cc00277ee43136a6e4f5220d6373096a397cbf51c85d00", 0, "data:image/jpeg;base64,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", "uhoh", "2026-04-14 17:37:24"),
(30, "1231231234", "ajksldf", "asdfjkl", "jklasdjfl", "TestAdminTwo@admin.com", "9688c49a256f4466ee55ebd32897d4ff1dfba5f76f5801c5d3227691", 0, null, null, "2026-04-14 17:47:03"),
(39, "6546546541", "Admin", "AdminAdmin", "AdminAdminAdmin", "Admin67@admin.com", "3bcc7dd326cd797ca5c0dcc98a1429ac5e57ebb8dcb0373ed385ccd6", 0, null, null, "2026-04-16 17:31:41");

-- staff updates
update staff set positionID = 1 where staffID = 2;
update staff set positionID = 2 where staffID = 3;
update staff set positionID = 2 where staffID = 4;
update staff set positionID = 2 where staffID = 5;
update staff set positionID = 1 where staffID = 9;
update staff set positionID = 2 where staffID = 10;
update staff set positionID = 5 where staffID = 11;
update staff set positionID = 2 where staffID = 12;
update staff set positionID = 2 where staffID = 17;
update staff set positionID = 2 where staffID = 18;
update staff set positionID = 2 where staffID = 19;
update staff set positionID = 2 where staffID = 20;
update staff set positionID = 1 where staffID = 22;
update staff set positionID = 1 where staffID = 23;
update staff set positionID = 2 where staffID = 28;

insert into plane (ICAO, planeName) values
("A676", "Goated67Plane"),
("AA23", "AltitudePro"),
("AB24", "BlackKite"),
("AC25", "MercuryWing"),
("AD26", "CrimsonAce"),
("AE27", "BronzeArrow"),
("AF28", "DiamondAir"),
("AG29", "SapphireGlide"),
("AH30", "AmethystWing"),
("AI31", "OpalSky"),
("AJ32", "PeridotFlight"),
("AK33", "QuartzSprint"),
("AL34", "MarbleAce"),
("AM35", "SlateHawk"),
("AN36", "CanyonRunner"),
("AO37", "DeltaGlide"),
("AP38", "ZetaWing"),
("AQ39", "ThetaStar"),
("AR40", "KappaAir"),
("AS41", "MuWing"),
("AT42", "XiGlide"),
("AU43", "PiAce"),
("AV44", "SigmaFlight"),
("AW45", "UpsilonJet"),
("AX46", "ChiHawk"),
("AY47", "OmegaAce"),
("B212", "SkyRam900"),
("C909", "HornetJet11"),
("D404", "Nimbus220"),
("E777", "CrownCruiser"),
("F101", "AtlasSprint"),
("G303", "GoatedFlight"),
("H404", "GoatPlane"),
("I505", "StormRider"),
("J606", "NovaStar"),
("K707", "ArcticBreeze"),
("L808", "CoastalAce"),
("M909", "ApexGlider"),
("N010", "MidnightRun"),
("O111", "CloudPiercer"),
("P212", "EclipseJet"),
("Q313", "SwiftArrow"),
("R414", "CycloneX"),
("S515", "TwilightAce"),
("T616", "SkyLancer"),
("U717", "NorthStar"),
("V818", "TurboCondor"),
("W919", "HighRoller"),
("X020", "MachRacer"),
("Y121", "CobaltJet"),
("Z222", "HorizonX");


insert into regions (regionID, region) values
(1, "Texas"),
(2, "Colorado"),
(3, "Illinois"),
(4, "Arizona"),
(5, "Georgia");

insert into airports (airportID, regionID, place, name, IATA) values
(1, 1, "Austin, TX", "Austin-Bergstrom Intl", "AUS"),
(2, 1, "New York, NYC", "John F Kennedy Intl", "JFK"),
(3, 1, "San Francisco, CA", "San Francisco Intl", "SFO"),
(4, 2, "São Paulo, Brazil", "Guarulhos Intl", "GRU"),
(5, 2, "Buenos Aires, Argentina", "Ministro Pistarini Intl", "EZE"),
(6, 2, "Bogotá, Colombia", "El Dorado Intl", "BOG"),
(7, 3, "Tokyo, Japan", "Haneda Intl", "HND"),
(8, 3, "Dubai, UAE", "Dubai Intl", "DXB"),
(9, 3, "Singapore, Singapore", "Changi Intl", "SIN"),
(10, 4, "London, UK", "Heathrow Intl", "LHR"),
(11, 4, "Paris, France", "Charles de Gaulle Intl", "CDG"),
(12, 4, "Frankfurt, Germany", "Frankfurt am Main Intl", "FRA"),
(13, 5, "Johannesburg, South Africa", "O.R. Tambo Intl", "JNB"),
(14, 5, "Cairo, Egypt", "Cairo Intl", "CAI"),
(15, 5, "Nairobi, Kenya", "Jomo Kenyatta Intl", "NBO");

insert into flight (IATA, ICAO, gate, origin, destination, capacity, assignedPilot) values
("TP1001", "A676", "A1", 1, 2, 20, 5),
("TP1002", "B212", "A2", 1, 3, 24, 17),
("TP1003", "C909", "B1", 1, 4, 16, 18),
("TP1004", "D404", "B2", 1, 5, 20, 18),
("TP1005", "E777", "C1", 1, 6, 24, 5),
("TP1006", "F101", "C2", 1, 7, 28, 12),
("TP1007", "G303", "A1", 1, 2, 20, 4),
("TP1009", "H404", "D3", 1, 3, 24, 19),
("TP1011", "I505", "C3", 1, 4, 16, 3),
("TP1013", "J606", "A1", 2, 3, 4, 4),
("TP1015", "K707", "D1", 2, 1, 20, 12),
("TP1017", "L808", "B2", 2, 5, 8, 17),
("TP1019", "M909", "A3", 3, 1, 12, 3),
("TP1021", "N010", "B3", 3, 2, 28, 20),
("TP1023", "O111", "B2", 3, 4, 16, 10),
("TP1025", "P212", "B2", 4, 1, 28, 12),
("TP1027", "Q313", "A1", 4, 2, 28, 10),
("TP1029", "R414", "B3", 4, 5, 32, 3),
("TP1031", "S515", "C2", 5, 3, 32, 10),
("TP1033", "T616", "A2", 5, 1, 16, 19),
("TP1035", "U717", "C3", 5, 4, 16, 4),
("TP1037", "V818", "A1", 6, 3, 12, 10),
("TP1039", "W919", "B1", 6, 5, 32, 3),
("TP1041", "X020", "D3", 7, 4, 8, 19),
("TP1043", "Y121", "D2", 7, 8, 8, 28),
("TP1045", "Z222", "C1", 8, 9, 20, 4),
("TP1047", "AA23", "A3", 9, 1, 4, 19),
("TP1049", "AB24", "B1", 10, 3, 28, 10),
("TP1051", "AC25", "A1", 10, 2, 12, 18),
("TP1053", "AD26", "D3", 11, 3, 28, 5),
("TP1055", "AE27", "B3", 11, 1, 28, 4),
("TP1057", "AF28", "D2", 12, 4, 28, 17),
("TP1059", "AG29", "C2", 12, 5, 20, 18),
("TP1061", "AH30", "D1", 13, 4, 32, 4),
("TP1063", "AI31", "D3", 13, 1, 32, 5),
("TP1065", "AJ32", "C2", 14, 2, 8, 20),
("TP1067", "AK33", "B3", 14, 5, 32, 28),
("TP1069", "AL34", "B2", 15, 3, 32, 17),
("TP1071", "AM35", "D1", 15, 1, 32, 12),
("TP1073", "AN36", "B2", 1, 2, 32, 3),
("TP1075", "AO37", "A3", 2, 3, 24, 20),
("TP1077", "AP38", "B3", 3, 4, 28, 17),
("TP1079", "AQ39", "A1", 4, 1, 8, 3),
("TP1081", "AR40", "A2", 5, 9, 4, 4),
("TP1083", "AS41", "C3", 6, 3, 24, 12),
("TP1085", "AT42", "C2", 7, 1, 24, 10),
("TP1087", "AU43", "D3", 8, 2, 24, 18),
("TP1089", "AV44", "B2", 9, 4, 24, 12),
("TP1091", "AW45", "D2", 10, 1, 20, 17),
("TP1093", "AX46", "C3", 11, 2, 16, 5),
("TP1095", "AY47", "D1", 12, 3, 16, 3);

insert into schedule (scheduleID, flightID, liftOff, landing, status) values
(1, "TP1001", "2026-04-01 10:06:07", "2026-04-01 12:00:00", "Grounded"),
(2, "TP1002", "2026-04-01 13:30:00", "2026-04-01 15:05:00", "Grounded"),
(3, "TP1003", "2026-04-01 09:15:00", "2026-04-01 10:25:00", "Grounded"),
(4, "TP1004", "2026-04-01 16:40:00", "2026-04-01 18:10:00", "Grounded"),
(5, "TP1005", "2026-04-01 07:00:00", "2026-04-01 09:55:00", "Grounded"),
(6, "TP1006", "2026-04-01 19:20:00", "2026-04-01 22:35:00", "Airborne"),
(7, "TP1007", "2026-04-01 08:00:00", "2026-04-01 10:10:00", "Grounded"),
(8, "TP1009", "2026-04-01 11:15:00", "2026-04-01 13:05:00", "Grounded"),
(9, "TP1011", "2026-04-01 14:20:00", "2026-04-01 16:00:00", "Grounded"),
(10, "TP1013", "2026-04-01 06:45:00", "2026-04-01 08:00:00", "Grounded"),
(11, "TP1015", "2026-04-02 17:30:00", "2026-04-02 19:10:00", "Grounded"),
(12, "TP1017", "2026-04-01 12:10:00", "2026-04-01 13:30:00", "Grounded"),
(13, "TP1019", "2026-04-01 09:50:00", "2026-04-01 11:20:00", "Grounded"),
(14, "TP1021", "2026-04-01 15:00:00", "2026-04-01 17:40:00", "Grounded"),
(15, "TP1023", "2026-04-01 18:10:00", "2026-04-01 19:45:00", "Grounded"),
(16, "TP1025", "2026-04-01 07:30:00", "2026-04-01 10:00:00", "Grounded"),
(17, "TP1027", "2026-04-01 13:00:00", "2026-04-01 15:20:00", "Grounded"),
(18, "TP1029", "2026-04-01 16:00:00", "2026-04-01 18:30:00", "Grounded"),
(19, "TP1031", "2026-04-01 10:30:00", "2026-04-01 13:00:00", "Grounded"),
(20, "TP1033", "2026-04-01 08:20:00", "2026-04-01 10:00:00", "Grounded"),
(21, "TP1035", "2026-04-01 19:00:00", "2026-04-01 20:30:00", "Grounded"),
(22, "TP1037", "2026-04-01 06:30:00", "2026-04-01 08:00:00", "Grounded"),
(23, "TP1039", "2026-04-01 11:40:00", "2026-04-01 14:20:00", "Grounded"),
(24, "TP1041", "2026-04-01 14:10:00", "2026-04-01 15:20:00", "Grounded"),
(25, "TP1043", "2026-04-01 09:00:00", "2026-04-01 10:30:00", "Grounded"),
(26, "TP1045", "2026-04-01 20:30:00", "2026-04-01 22:50:00", "Grounded"),
(27, "TP1047", "2026-04-01 17:10:00", "2026-04-01 18:00:00", "Grounded"),
(28, "TP1049", "2026-04-01 15:30:00", "2026-04-01 18:10:00", "Grounded"),
(29, "TP1051", "2026-04-01 07:50:00", "2026-04-01 09:10:00", "Grounded"),
(30, "TP1053", "2026-04-01 13:40:00", "2026-04-01 16:20:00", "Grounded"),
(31, "TP1055", "2026-04-01 10:10:00", "2026-04-01 12:40:00", "Grounded"),
(32, "TP1057", "2026-04-01 18:20:00", "2026-04-01 20:50:00", "Grounded"),
(33, "TP1059", "2026-04-01 11:00:00", "2026-04-01 13:10:00", "Grounded"),
(34, "TP1061", "2026-04-01 14:50:00", "2026-04-01 17:30:00", "Grounded"),
(35, "TP1063", "2026-04-01 16:30:00", "2026-04-01 19:10:00", "Grounded"),
(36, "TP1065", "2026-04-01 08:40:00", "2026-04-01 10:00:00", "Grounded"),
(37, "TP1067", "2026-04-01 12:20:00", "2026-04-01 15:00:00", "Grounded"),
(38, "TP1069", "2026-04-01 09:30:00", "2026-04-01 12:10:00", "Grounded"),
(39, "TP1071", "2026-04-01 13:10:00", "2026-04-01 15:50:00", "Grounded"),
(40, "TP1073", "2026-04-01 07:10:00", "2026-04-01 09:40:00", "Grounded"),
(41, "TP1075", "2026-04-01 11:50:00", "2026-04-01 14:00:00", "Grounded"),
(42, "TP1077", "2026-04-01 15:20:00", "2026-04-01 18:00:00", "Grounded"),
(43, "TP1079", "2026-04-01 06:00:00", "2026-04-01 07:10:00", "Grounded"),
(44, "TP1081", "2026-04-01 17:50:00", "2026-04-01 18:40:00", "Grounded"),
(45, "TP1083", "2026-04-01 10:50:00", "2026-04-01 13:10:00", "Grounded"),
(46, "TP1085", "2026-04-01 08:10:00", "2026-04-01 10:30:00", "Grounded"),
(47, "TP1087", "2026-04-01 14:00:00", "2026-04-01 16:20:00", "Grounded"),
(48, "TP1089", "2026-04-01 16:10:00", "2026-04-01 18:30:00", "Grounded"),
(49, "TP1091", "2026-04-01 07:40:00", "2026-04-01 09:30:00", "Grounded"),
(50, "TP1093", "2026-04-01 12:00:00", "2026-04-01 13:40:00", "Grounded"),
(51, "TP1095", "2026-04-01 18:40:00", "2026-04-01 20:10:00", "Grounded"),
(52, "TP1073", "2026-04-14 07:10:00", "2026-04-14 09:40:00", "Grounded"),
(53, "TP1015", "2026-04-15 17:30:00", "2026-04-15 19:10:00", "Grounded"),
(54, "TP1009", "2026-04-15 11:15:00", "2026-04-15 13:05:00", "Grounded"),
(55, "TP1019", "2026-04-17 09:50:00", "2026-04-17 11:20:00", "Grounded"),
(56, "TP1073", "2026-04-16 07:10:00", "2026-04-16 09:40:00", "Grounded"),
(57, "TP1015", "2026-04-17 17:30:00", "2026-04-17 19:10:00", "Grounded"),
(58, "TP1073", "2026-04-19 07:10:00", "2026-04-19 09:40:00", "Grounded"),
(59, "TP1015", "2026-04-21 17:30:00", "2026-04-21 19:10:00", "Grounded"),
(60, "TP1073", "2026-04-22 07:10:00", "2026-04-22 09:40:00", "Grounded"),
(61, "TP1015", "2026-04-30 17:30:00", "2026-04-30 19:10:00", "Grounded");

insert into flightclass (classID, className, price) values
(1, "Economy", 100),
(2, "First Class", 200),
(3, "Goat Class", 10000);

insert into planeseat (seatNumber, scheduleID, classID) values
("1A", 1, 1),
("1A", 52, 1),
("1A", 53, 1),
("1A", 56, 1),
("1B", 1, 1),
("1B", 11, 1),
("1B", 52, 1),
("1B", 53, 1),
("1C", 54, 1),
("1C", 60, 1),
("2A", 11, 1),
("2A", 61, 1),
("2C", 57, 1),
("3C", 55, 1);

insert into booking (bookingNumber, bookingDate, userID, departSeat, returnSeat, departScheduleID, returnScheduleID) values
(7, "2026-04-14 17:38:20", 29, "1B", "1A", 52, 53),
(8, "2026-04-14 17:38:25", 29, "1B", "1A", 52, 53),
(9, "2026-04-14 17:39:07", 29, "1C", "3C", 54, 55),
(10, "2026-04-14 17:39:09", 29, "1C", "3C", 54, 55),
(11, "2026-04-14 17:39:11", 29, "1C", "3C", 54, 55),
(12, "2026-04-16 17:30:32", 1, "1A", "2C", 56, 57),
(13, "2026-04-16 17:40:38", 1, "1C", "2A", 60, 61);

insert into bookinghistory (bookingNumber, bookingDate, userID, departSeat, returnSeat, departScheduleID, returnScheduleID, departLiftOff, departLanding, returnLiftOff, returnLanding, bookingStatus, archiveDate, cancellationDate, cancelledBy, reason) values
(2, "2026-04-02 01:13:29", 3, "1B", "2A", 1, 11, "2026-04-01 10:06:07", "2026-04-01 12:00:00", "2026-04-02 17:30:00", "2026-04-02 19:10:00", "Cancelled", "2026-04-02 01:13:29", "2026-04-14 00:00:00", 25, "test removal"),
(3, "2026-04-14 17:37:56", 29, "1A", "1B", 52, 53, "2026-04-14 07:10:00", "2026-04-14 09:40:00", "2026-04-15 17:30:00", "2026-04-15 19:10:00", "Cancelled", "2026-04-14 17:37:56", "2026-04-14 00:00:00", 30, "hhkjl"),
(4, "2026-04-14 17:38:08", 29, "1B", "1A", 52, 53, "2026-04-14 07:10:00", "2026-04-14 09:40:00", "2026-04-15 17:30:00", "2026-04-15 19:10:00", "Cancelled", "2026-04-14 17:38:08", "2026-04-14 00:00:00", 30, "cvbnjmk"),
(5, "2026-04-14 17:38:12", 29, "1B", "1A", 52, 53, "2026-04-14 07:10:00", "2026-04-14 09:40:00", "2026-04-15 17:30:00", "2026-04-15 19:10:00", "Cancelled", "2026-04-14 17:38:12", "2026-04-16 00:00:00", 25, "I HATE YOU"),
(6, "2026-04-14 17:38:14", 29, "1B", "1A", 52, 53, "2026-04-14 07:10:00", "2026-04-14 09:40:00", "2026-04-15 17:30:00", "2026-04-15 19:10:00", "Cancelled", "2026-04-14 17:38:14", "2026-04-16 00:00:00", 22, "kjhfjkashajksdf");


insert into item (itemID, itemName, itemDescription, type) values
(1, "Metal Detector", "Primary security screening device used at entry checkpoints.", "equipment"),
(2, "First Aid Kit", "Emergency medical kit stored for handling minor injuries and health incidents.", "equipment"),
(4, "Baggage Tug", "Vehicle used to transport luggage carts between terminals and aircraft.", "transportation"),
(5, "Passenger Shuttle", "Ground shuttle used to move passengers between terminals and gates.", "transportation"),
(6, "Lost & Found Bin", "Storage container used for temporarily holding lost passenger items.", "misc"),
(7, "Cleaning Supplies", "General cleaning materials used by maintenance staff throughout the airport.", "misc");


insert into parkinglot (lot, lotSpace) values
("A", 100),
("B", 120),
("C", 80),
("D", 60),
("E", 150),
("F", 90);

insert into inventory (itemID, quantity) values
(1, 10),
(2, 25),
(4, 2),
(5, 1),
(6, 18),
(7, 12);


insert into cancellationnotifs (userID, bookingID) values
(3, 2),
(29, 3),
(29, 4),
(29, 5),
(29, 6);

