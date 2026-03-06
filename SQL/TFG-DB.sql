drop database TFG;
create database TFG;
use TFG;

create table flight(
IATA varchar(7) primary key, -- Don't include dashes or space (I.E: TP6767)
planeName varchar(255),
gate varchar(2),
origin varchar(255),
destination varchar(255)
);

create table schedule(
flight varchar(7) primary key references flight(IATA),
liftOff datetime,
landing datetime
);

create table planeStatusEnums(
psEnumID int primary key,
status enum("On Time", "Delayed", "Boarding", "Taxiing", "Airborne", "Landing", "Grounded"),
ICAO varchar(4)
);

create table plane(
ICAO varchar(4) primary key, 
statusID int references planeStatusEnums(psEnumID)
);

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

create table positionEnums (
positionID int primary key auto_increment, 
position enum("Flight Attendent", "Pilot", "Co-Pilot", "Security", "Unassigned") default "Unassigned"
);

create table staff(
staffID int primary key,
email varchar(255) references users(email),
positionID int default 5 references positionEnums(positionID) 
);

create table flightClass(
classID int auto_increment primary key,
className varchar(255) not null,
price double
);

create table planeSeat(
seatNumber int,
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
seat int references planeSeat(seatNumber),
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

create table miscellaneousItem(
itemID int primary key,
itemName varchar(255),
itemDescription text,
constraint fk_miscellaneous_item foreign key (itemID) references item(itemID) on delete cascade
);

create table parkingLot(
lot char(1) primary key,
lotSpace int 
);

create table inventory(
itemID int primary key,
quantity int check (quantity >= 0),
constraint fk_inventory_item foreign key (itemID) references item(itemID) on delete cascade
);

-- create table payment





-- triggers
delimiter //
create trigger transportAndEquipmentInsert
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

create trigger createStaff
after insert on users
for each row
begin
    if new.isStaff = true 
		then
			insert into staff(staffID, email) values
            (new.userID, new.email);
    end if;
end//
delimiter ;


-- TFG Views --
-- view for staff count per position
create view staffCountPerPosition as select
pe.position, 
count(s.staffID) as positionCount
from positionEnums pe
left join staff s using(positionID)
group by pe.positionID;

-- Creating a view so that I can display item names and stuff like that instead of just ids,
-- avoiding overflooding of the python file for no reason

create view inventoryNames as
select
-- inventory
i.itemID, i.quantity,
(i.quantity > 0) as isAvailable,
-- item joins
it.type, it.itemName
from inventory i
join item it on it.itemID = i.itemID;

