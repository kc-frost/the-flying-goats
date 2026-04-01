drop database TFG;
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
create table deletedUsers(
userID int primary key auto_increment,
phoneNumber char(10) not null,
fname varchar(255) not null,
lname varchar(255) not null,
username varchar(255) not null,
email varchar(255) not null,
password varchar(255) not null,
isStaff boolean default false,
bio text,
registeredDate datetime
);

create table positionenums (
positionID int primary key auto_increment, 
position enum("Flight Attendent", "Pilot", "Co-Pilot", "Security", "Unassigned") default "Unassigned"
);

create table staff(
staffID int primary key,
email varchar(255) references users(email),
positionID int default 5 references positionenums(positionID)
);

create table plane(
ICAO varchar(4) primary key
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

create table flight(
    IATA varchar(7) primary key,
    ICAO varchar(4),
    planeName varchar(255),
    gate varchar(2),
    origin int,
    destination int,
    capacity int,
    assignedPilot int,
    unique(IATA, origin, destination),
    constraint chk_capacity
        check (capacity <= 36 and capacity >= 0 and capacity % 4 = 0),
    constraint fk_staffID
        foreign key (assignedPilot) references staff(staffID),
    constraint fk_planeICAO
        foreign key (ICAO) references plane(ICAO),
    constraint fk_flight_origin
        foreign key (origin) references airports(airportID),
    constraint fk_flight_destination
        foreign key (destination) references airports(airportID)
);
-- On time: 1 hour before take off
-- Boarding: 30 minutes before take off
-- Airborne: Duration of flight
-- Landing: 10 minutes after "end" of flight
-- Grounded: 30 minutes after "end" of flight
create table schedule(
    scheduleID int primary key auto_increment,
    flightID varchar(7),
    liftOff time,
    landing time,
    status enum('On Time', 'Delayed', 'Boarding', 'Taxiing', 'Airborne', 'Landing', 'Grounded'),
    constraint fk_schedule_flight foreign key (flightID) references flight(IATA)
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
    bookingDate datetime,
    userID int,
    departSeat varchar(3),
    returnSeat varchar(3),
    departDate date,
    departSchedule int not null,
    returnDate date,
    returnSchedule int not null,
    constraint fk_booking_user
        foreign key (userID) references users(userID),
    constraint fk_depart_schedule
        foreign key (departSchedule) references schedule(scheduleID),
    constraint fk_return_schedule
        foreign key (returnSchedule) references schedule(scheduleID),
    constraint fk_departDetails
        foreign key (departSeat, departSchedule)
        references planeseat(seatNumber, scheduleID),
    constraint fk_returnDetails
        foreign key (returnSeat, returnSchedule)
        references planeseat(seatNumber, scheduleID)
);

create table bookingHistory(
bookingNumber int primary key,
userID int,
flightID varchar(7),
seat varchar(3),
bookingDate datetime,
bookingStatus enum("Cancelled", "Completed"),
assignedPilot int
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
b.departDate as departDate, b.returnDate as returnDate,
-- ScheduleIDs for both depart and return
b.departSchedule as departScheduleID, b.returnSchedule as returnScheduleID,
-- usersD
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
left join schedule ds on ds.scheduleID = b.departSchedule
-- get the origin flightID
left join flight df on df.IATA = ds.flightID
-- Duplicate joins for the names of the airports on both destination and origin
left join airports dfAO on dfAO.airportID = df.origin
left join airports dfAD on dfAD.airportID = df.destination
-- joining for the return schedule, connecting through return this time
left join schedule rs on rs.scheduleID = b.returnSchedule
-- actually getting the return flight
left join flight rf on rf.IATA = rs.flightID
-- duplicate joisn for the names of the airports on for the rturn destination and origin
left join airports rfAO on rfAO.airportID = rf.origin
left join airports rfAD on rfAD.airportID = rf.destination;


-- view for view all users 
create view userreservationsummary as
select
u.userID, u.email, u.username,
datediff(curdate(), date(u.registeredDate)) as registerLengthDays, count(b.bookingNumber) as totalReservations,
sum(case when ds.liftOff < now() and (rs.liftOff is null or rs.liftOff < now()) then 1 else 0 end) as totalPastReservations,
sum(case when ds.liftOff >= now() or (rs.liftOff is not null and rs.liftOff >= now()) then 1 else 0 end) as totalFutureReservations
from users u
left join booking b on u.userID = b.userID
left join schedule ds on b.departSchedule = ds.scheduleID
left join schedule rs on b.returnSchedule = rs.scheduleID
group by u.userID, u.email, u.username, u.registeredDate;

-- Grabs the ICAO and plane status from hanger as long as it exists in the plane table
-- This way, we can get planes that are available for use without grabbing from the memory table directly
create view planeStatus as
select h.ICAO, h.planeStatus
from hanger h
where h.ICAO in (select * from plane);

create view pilotScheduleInfo as
select
-- User joins
    u.fname, u.lname,
-- Staff joins
    s.staffID,
-- flight joins
    f.IATA as flight,
-- schedule joins
    sc.liftOff, sc.landing, sc.status
from staff s
join users u on u.userID = s.staffID
join flight f on f.assignedPilot = s.staffID
join schedule sc on sc.flightID = f.IATA;

create or replace view available_flights as
select
s.scheduleID,
ao.IATA as origin_IATA, 
ad.IATA as destination_IATA, 
f.IATA, f.capacity,
TIME_FORMAT(s.liftOff, "%H:%i") as liftOff, 
TIME_FORMAT(s.landing, "%H:%i") as landing, 
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
    update hanger
    join flight f on hanger.ICAO = f.ICAO
    join schedule s on s.flightID = f.IATA
    set hanger.planeStatus = 'Available'
    where schedule.landing is not null
      and now() >= schedule.landing;

    update flight f
    join schedule s on s.flightID = f.IATA
    set f.assignedPilot = null
    where schedule.landing is not null
      and now() >= schedule.landing;
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

create trigger rememberDeletedUser
before delete on users
for each row
begin
insert into deletedUsers values(old.userID, old.phoneNumber, old.fname, old.lname, old.username, old.email, old.password, old.isStaff, old.bio, old.registeredDate);
end//

create trigger validReservationChange
before update on booking
for each row 
begin
	if new.bookingDate > CURDATE()
		then
			signal sqlstate '45000'
			set message_text = "Updated reservation isn't valid";
	end if;
    if exists (
    select 1
    from booking b
    where b.bookingNumber <> old.bookingNumber
    and ((b.departSchedule = new.departSchedule and b.departSeat = new.departSeat)
    or (b.returnSchedule = new.returnSchedule and b.returnSeat = new.returnSeat))
    )
		then
			signal sqlstate '45000'
            set message_text = "This seat is already taken";
	end if;
end//

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

-- This will remember old bookings after the procedure call, remembering the plane and the pilot assigned aswell.
create trigger rememberBookingsBeforeClearProcedureCall
before update on flight
for each row
begin
    if old.assignedPilot is not null
       and new.assignedPilot is null
       and not exists (
            select 1
            from bookingHistory
            where flightID = old.IATA
       )
    then
        insert into bookingHistory (
            bookingNumber,
            userID,
            flightID,
            seat,
            bookingDate,
            assignedPilot,
            bookingStatus
        )
        select
            b.bookingNumber, b.userID,
            ds.flightID,
            b.departSeat,
            b.bookingDate,
            old.assignedPilot,
            if(ds.landing is not null and now() >= ds.landing,
               'Completed',
               'Cancelled')
        from booking b
        join schedule ds
            on ds.scheduleID = b.departSchedule
        where ds.flightID = old.IATA;
    end if;
end//

delimiter ;
