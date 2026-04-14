create database TFG;
use TFG;

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
create table userHistory(
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

create table staffHistory(
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
create table cancellationNotifs(
userID int primary key,
bookingID int, -- This is the ID of what was cancelled. A trigger, after deletion, will insert ALL userIDs related the bookingID EXCLUDING the ID of the one who cancelled it.
primary key(userID, bookingID),
constraint ensure_user_exists foreign key (userID) references users(userID)
);

-- no idea how I'ma do this
create table planeArrivalNotifs(
userID int,
scheduleID int,
primary key(userID, scheduleID),
constraint ensure_flight_exists foreign key (scheduleID) references schedule(scheduleID)
);

create table pilotAssignmentNotifs(
userID int,
flightID varchar(7),
primary key(userID, flightID),
constraint ensure_pilot_exists foreign key (userID) references flight(assignedPilot),
constraint ensure_flight_exists foreign key (flightID) references flight(IATA)
);



-- create table payment

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
create or replace view planeStatus as
select h.ICAO, h.planeStatus
from hanger h
where h.ICAO in (select ICAO from plane);

create or replace view pilotScheduleInfo as
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
CONCAT(TIMESTAMPDIFF(hour, liftOff, landing), "h ", MOD(TIMESTAMPDIFF(minute, liftOff, landing), 60), 'm') as duration
from flight f
join airports ao on f.origin = ao.airportID
join airports ad on f.destination = ad.airportID
join schedule s on f.IATA = s.flightID;

select * from available_flights;

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

select * from pilotScheduleInfo;

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
insert into staffHistory(staffID, email, positionID, accountStatus) values (new.staffID, new.email, new.positionID, "Registered");

create trigger deletedStaff
after delete on staff
for each row
update staffHistory set accountStatus = "Deleted", deletionDate = curdate() where old.staffID = staffID;

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
	update bookingHistory set bookingStatus = "Cancelled", cancellationDate = now() where bookingNumber = old.bookingNumber;
    
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
        insert into pilotAssignmentNotifs(userID, flightID)
        values(new.assignedPilot, new.IATA);
    end if;
end//

delimiter ;

