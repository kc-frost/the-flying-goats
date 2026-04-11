use tfg;
-- top 3 users who book the most often
    -- track by userID, show username
select count(bookingNumber) bookingAmount, userID, username
from reservationticket
group by userID
order by bookingAmount desc
limit 3;

-- reservations this month (not last 30 days)
select count(*) as monthly_reservations
from reservationticket
where month(reservationDate) = month(curdate())
and year(reservationDate) = 2026;
-- RHS has to be 0x 

-- monthly reservations across the entire year
-- same question as monthly reservations
select month(reservationDate) as month, count(*) as monthly_reservations
from reservationticket
group by month
order by monthly_reservations desc;

-- monthly reservations
-- Should prolly ask thursday if he wants us to show absolutely all reservations, including cancelled ones, or just all valid ones
select count(*) as monthly_reservations
from reservationticket
-- Gunna be a param, look into how to implement later?
where month(reservationDate) = 04
and year(reservationDate) = 2026;

-- ALL reservations
-- Change this to booking history. Reservationticket only shows valid and completed reservations, not deleted ones.
select count(*) as all_reservations
from reservationticket;

-- longest registered users
-- kinda confused on this, ask after I'm done on my side
select userID, username, registerLengthDays, rank() over (order by registerLengthDays desc) as user_rank
from userreservationsummary;

-- how many DISTINCT users made a reservation THIS month?
-- Confused on this, shouldn't this be count? If not count then show usernames instead of ids no? Ask after I'm done
select distinct(userID) as distinct_reservations_this_month
from reservationticket
-- updated this also use month()
where month(reservationDate) = month(curdate()) and year(departDate) = year(curdate());

-- All time registerd Users. This will NOT work properly until AFTER a rerun of the database. We need to implement the new DB changes into the dump, namely new triggers, before recreating the dump, then this will work.
select count(*) as userCount from userHistory;

-- Top three staff
-- Good luck future me integrating this into general staff stat view :pray:
select fname, lname, staffID, bookingCount,
dense_rank() over (order by bookingCount desc) as staffRank
from (select fname, lname, staffId, bookingCount
	from(select fname, lname, staffID, bookingNumber, row_number() over (partition by staffID order by bookingNumber desc) as pilotRow, count(*) over(partition by staffID) as bookingCount 
		from pilotscheduleinfo where month(departDate) = month(curdate()) and year(departDate) = year(curdate())) innerThing
			where pilotRow = 1) rankInnerThing
					order by bookingcount desc limit 3;


-- cancellations
-- These (hopefully hypothetically) work, but we won't know until we edit the dump
-- Some won't run cause bookingHistory isn't update yet, will do later
-- Total cancellations
select count(*) from bookingHistory where bookingStatus = "Cancelled";

-- Total cancellations this month
select count(*) from bookingHistory where bookingStatus = "Cancelled" and month(deletionDate) = month(curdate()) and year(deletionDate) = year(curdate());

-- Cancellations this month by category(user, staff, admin)
-- Gunna be a big boy that I can't really do right now because "admin" isn't a roll, it's one user. Will do later, but I'm planning on using a window function where isStaff from user table is a factor

