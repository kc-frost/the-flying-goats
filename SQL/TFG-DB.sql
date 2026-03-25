drop database TFG;
create database TFG;
use TFG;

create table users(
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
-- maybe add passport or some sorta identification?
);

create table positionenums (
positionID int primary key auto_increment, 
position enum("Flight Attendent", "Pilot", "Co-Pilot", "Security", "Unassigned") default "Unassigned"
);

create table staff(
staffID int primary key,
email varchar(255) references users(email),
positionID int default 5 references positionEnums(positionID) 
);

create table flight(
IATA varchar(7) primary key, -- Don't include dashes or space (I.E: TP6767)
planeName varchar(255),
gate varchar(2),
origin int references airports(airportID),
destination int references airports(airportID),
capacity int,
assignedPilot int,
constraint chk_capacity check (capacity >= 0),
constraint fk_staffID foreign key (assignedPilot) references staff(staffID) -- A flight MUST have a pilot now (staffID)
-- A trigger will make sure that staffID both belongs to a pilot and is available
);

create table regions(
regionID int primary key,
region varchar(255)
);

create table airports(
airportID int primary key auto_increment,
regionID int references regions(regionID), 
place varchar(255),
name varchar(255),
IATA varchar(3)
);

create table schedule(
scheduleID int primary key auto_increment,
flight varchar(7) references flight(IATA),
liftOff datetime,
landing datetime
);

create table planestatusenums(
psEnumID int primary key,
status enum("On Time", "Delayed", "Boarding", "Taxiing", "Airborne", "Landing", "Grounded"),
ICAO varchar(4)
);

create table plane(
ICAO varchar(4) primary key, 
statusID int references planeStatusEnums(psEnumID)
);

create table flightclass(
classID int auto_increment primary key,
className varchar(255) not null,
price double
);

create table planeseat(
seatNumber varchar(3),
flightID varchar(7) references flight(IATA),
classID int,
constraint fk_class_id foreign key (classID) references flightclass(classID),
primary key(seatNumber, flightID)
);

-- A table with all the info in one for the view appointment part and cause it's cleaner
create table booking(
bookingNumber int primary key auto_increment,
userID int references users(userID),
flightID varchar(7) references flight(IATA),
seat varchar(3) references planeSeat(seatNumber),
bookingDate datetime
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
from positionEnums pe
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
create view reservationticket as
select
-- booking
b.bookingNumber as bookingNumber, b.userID as userID, b.flightID as flightID, b.seat as seatNumber, b.bookingDate as reservationDate,
-- planeseat
ps.classID as classID,
-- flightclass
fc.className as seatClass, 
-- users
u.username as username,
-- schedule
s.liftOff as liftOffDate, s.landing as arrivingDate,
-- flight
f.origin as origin, f.destination as destination
from booking b
left join planeseat ps on (ps.seatNumber = b.seat)
inner join flightclass fc on (fc.classID = ps.classID)
left join users u using(userID)
left join schedule s on (s.flight = b.flightID)
left join flight f on (f.IATA = s.flight);

-- view for view all users 
create view userreservationsummary as
select
-- user table
u.userID, u.email,
-- for getting register date in numbers
datediff(curdate(), date(u.registeredDate)) as registerLengthDays, count(b.bookingNumber) as totalReservations,
sum(case when s.liftOff < now() then 1 else 0 end) as totalPastReservations,
sum(case when s.liftOff >= now() then 1 else 0 end) as totalFutureReservations
from users u
left join booking b on u.userID = b.userID
left join schedule s on b.flightID = s.flight
group by u.userID, u.email, u.registeredDate;

-- organizes staffID, position, and amount of people in that position with a window func
create view positionAndStaffIDCounted as
select s.staffID, p.position, count(p.positionID) over (partition by p.positionID order by position desc) as positionsCounted
from staff s
left join positionenums p using (positionID)
where staffID not in (select assignedPilot from flight);

<<<<<<< HEAD
-- Shows available flights (typically queried through origin and destination
-- Time is shown in 24H (don't sue me, i dont wanna deal with the extra spacing 12hr will make)
create view available_flights as
select 
ao.IATA as origin_IATA, 
ad.IATA as destination_IATA, 
f.IATA, 
TIME_FORMAT(s.liftOff, "%H:%i") as liftOff, 
TIME_FORMAT(s.landing, "%H:%i") as landing, 
CONCAT(TIMESTAMPDIFF(hour, liftOff, landing), "h ", MOD(TIMESTAMPDIFF(minute, liftOff, landing), 60), 'm') as duration
from flight f
join airports ao on f.origin = ao.airportID
join airports ad on f.destination = ad.airportID
join schedule s on f.IATA = s.flight;

select * from available_flights;

=======
>>>>>>> main

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
			insert into miscellaneousItem(itemID, itemName, itemDescription) values
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

	declare pilotsQuantity int;
    
    select positionsCounted into pilotsQuantity from positionsAndStaffIDCounted where positionID = 2;
    
    if new.assignedPilot != 2
		then 
			signal sqlstate '45000'
            set message_text = "The staff attempting to take control of the plane is NOT a pilot";
	end if;
    if @pilotsQuantity = 0
		then
			signal sqlstate '45000'
            set message_text = "No available pilots at the moment";
	end if;
end//
<<<<<<< HEAD
delimiter ;
=======
delimiter ;
>>>>>>> main
