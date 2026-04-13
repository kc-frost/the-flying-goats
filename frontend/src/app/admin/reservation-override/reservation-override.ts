import { Component } from '@angular/core';

@Component({
  selector: 'app-reservation-override',
  imports: [],
  templateUrl: './reservation-override.html',
  styleUrl: './reservation-override.css',
})
export class ReservationOverride {

  // template of what fields we need
  // these are the same for both staff and admin, the only difference is that staff only needs their "appointments" ofc

  // i think it's easier if we just do a "get all reservations" if the user is an admin (backend), and do another query for getting all that staff's specific appointments, so we can reuse this entire component with little change to this code

  userReservations: {username: string, origin: string, destination: string, liftOffDate: string, landingDate: string}[] = [
    {
      username: "kcfrost",
      origin: "AUS",
      destination: "JFK",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    },  
    {
      username: "kcfrost",
      origin: "JFK",
      destination: "AUS",
      liftOffDate: "2026-04-15 12:00",
      landingDate: "2026-04-15 01:30"
    },  
    {
      username: "sceptre",
      origin: "EZE",
      destination: "SFO",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    },
    {
      username: "jbl",
      origin: "HND",
      destination: "MNL",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    },
    {
      username: "jbl",
      origin: "HND",
      destination: "MNL",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    },
    {
      username: "jbl",
      origin: "HND",
      destination: "MNL",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    },
    {
      username: "jbl",
      origin: "HND",
      destination: "MNL",
      liftOffDate: "2026-04-12 14:30",
      landingDate: "2026-04-12 18:45"
    }
  ];
}
