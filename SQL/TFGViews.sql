use TFG;

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

select * from inventoryNames;

-- Reservation ticket view with all attributes needed for view reservations
create view reservationTicket as
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

select * from reservationTicket;