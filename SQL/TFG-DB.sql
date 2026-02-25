create database TFG;
use TFG;

create table flight(
IATA varchar(7) primary key, -- Don't include dashes or space (I.E: TP6767)
planeName varchar(255),
gate varchar(255),
status enum("On Time", "Delayed", "Boarding", "Taxiing", "Airborne", "Landing", "Grounded"),
destination varchar(255)
);

create table schedule(
flight varchar(7) primary key references flight(IATA),
liftOff datetime,
landing datetime
);

create table plane(
ICAO varchar(4) primary key
);

create table users(
userID int primary key,
phoneNumber int not null,
fname varchar(255) not null,
phoneNumber int not null,
lname varchar(255) not null,
username varchar(255) not null,
email varchar(255) not null,
password varchar(255) not null,
isStaff boolean default false
-- maybe add passport or some sorta identification?
);

create table staff(
staffID int primary key,
position enum("Flight Attendent", "Pilot", "Co-Pilot", "Security") not null,
email varchar(255) references users(email)
);

create table flightClass(
classID int auto_increment primary key,
className varchar(255) not null,
price double
);

create table planeSeat(
seatNumber int primary key,
flightID int references flight(IATA),
class varchar(255) references flightClass(className)
);

-- A table with all the info in one for the view appointment part and cause it's cleaner
create table booking(
bookingNumber int primary key,
userID int references users(userID),
flightID int references flight(IATA),
seat int references planeSeat(seatNumber)
);

create table equipment(
equipmentID int primary key auto_increment,
equipmentName varchar(255),
equipmentDescription text
);

create table transporation(
transportationID int primary key auto_increment
);

create table parkingLot(
lot char(1) primary key,
lotSpace int 
);

create table inventory(
itemID int primary key,
planeID int references plane(ICAO),
staffID int references staff(staffID),
equipmentID int references equipment(equipmentID),
transportationID int references transportation(transportationID),
quantity int check (quantity > 0),
isAvailable boolean default true
);


-- create table payment;