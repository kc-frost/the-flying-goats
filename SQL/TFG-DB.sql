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
flightID int primary key auto_increment,
IATA varchar(7), -- Don't include dashes or space (I.E: TP6767)
planeName varchar(255),
gate varchar(2),
origin int references airports(airportID),
destination int references airports(airportID),
capacity int,
assignedPilot int,
unique(IATA, origin, destination), -- A flight (IATA) and its route (origin, destination) cannot be entered twice
constraint chk_capacity check (capacity <= 36 and capacity >= 0 and capacity % 4 = 0),
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
flightID varchar(7) references flight(IATA),
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
scheduleID int references schedule(scheduleID),
classID int,
constraint fk_class_id foreign key (classID) references flightclass(classID),
primary key(seatNumber, scheduleID)
);

-- A table with all the info in one for the view appointment part and cause it's cleaner
create table booking(
bookingNumber int primary key auto_increment,
userID int references users(userID),
departSeat varchar(3),
returnSeat varchar(3),
departSchedule int not null references schedule(scheduleID),
returnSchedule int not null references schedule(scheduleID),
bookingDate datetime,

-- associate each seat with its proper flight
constraint fk_departDetails foreign key (departSeat, departSchedule) references planeseat(seatNumber, scheduleID),
constraint fk_returnDetails foreign key (returnSeat, returnSchedule) references planeseat(seatNumber, scheduleID)
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
b.bookingNumber as bookingNumber, b.userID as userID, b.departSeat as departSeat, b.returnSeat as returnSeat, b.bookingDate as reservationDate,
-- flight IDS
f_depart.IATA as departFlightID, f_return.IATA as returnFlightID,
-- planeseat
ps.classID as classID,
-- flightclass
fc.className as seatClass, 
-- users
u.username as username,
-- schedule
s_depart.liftOff as liftOffDate, s_return.landing as arrivingDate,
-- flight
a_origin.place as origin, a_dest.place as destination
from booking b
left join planeseat ps on (ps.seatNumber = b.departSeat and ps.scheduleID = b.departSchedule)
inner join flightclass fc on (fc.classID = ps.classID)
left join users u using(userID)
left join schedule s_depart on b.departSchedule = s_depart.scheduleID
left join schedule s_return on b.returnSchedule = s_return.scheduleID
left join flight f_depart on (f_depart.flightID = s_depart.flightID)
left join flight f_return on (f_return.flightID = s_return.flightID)
left join airports a_origin on (a_origin.airportID = f_depart.origin)
left join airports a_dest on (a_dest.airportID = f_depart.destination);


select * from reservationticket;
-- view for view all users 
create view userreservationsummary as
select
-- user table
u.userID, u.email,
-- for getting register date in numbers
datediff(curdate(), date(u.registeredDate)) as registerLengthDays, count(b.bookingNumber) as totalReservations,
sum(case when s_depart.liftOff < now() then 1 else 0 end) as totalPastReservations,
sum(case when s_depart.liftOff >= now() then 1 else 0 end) as totalFutureReservations
from users u
left join booking b on u.userID = b.userID
left join schedule s_depart on b.departSchedule = s_depart.scheduleID
left join schedule s_return on b.returnSchedule = s_return.scheduleID
-- left join schedule s on b.flightID = s.flight 
group by u.userID, u.email, u.registeredDate;

-- organizes staffID, position, and amount of people in that position with a window func
create view positionAndStaffIDCounted as
select s.staffID, p.position, count(p.positionID) over (partition by p.positionID order by position desc) as positionsCounted
from staff s
left join positionenums p using (positionID)
where staffID not in (select assignedPilot from flight);

-- Shows available flights (typically queried through origin and destination
-- Time is shown in 24H (don't sue me, i dont wanna deal with the extra spacing 12hr will make)
create view available_flights as
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
join schedule s on f.flightID = s.flightID;

select * from available_flights;

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
delimiter ;
