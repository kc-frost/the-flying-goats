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