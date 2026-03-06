import { Component, inject } from '@angular/core';
import { UserService } from '../../_shared/services/user-service';
import { form } from '@angular/forms/signals';

interface Reservation {
  id: number;
  reservationDate: string;
  flightID: string;
  departureDate: string;
  arrivalDate: string;
  username: string;
  seatNumber: string;
  seatClass: string;
  origin: string;
  destination: string;


}

@Component({
  selector: 'app-profile-page',
  imports: [],
  templateUrl: './profile-page.html',
  styleUrl: './profile-page.css',
})
export class ProfilePage {
  userService = inject(UserService);
  staticProfileImage = "/profile/static-profile-image.svg";

  formatDate(date: string): string {
    var enteredDate = new Date(date);
    var formattedDate = new Intl.DateTimeFormat("en-GB", 
      {
        weekday: "short",
        day: "2-digit",
        month: "short",
        year: "numeric",
      }).format(enteredDate);

      return formattedDate;
  }

  formatTime(date: string) {
    var enteredDate = new Date(date);
    var hour12Time = new Intl.DateTimeFormat("en-GB",
      {
        hour12: true,
        hour: "2-digit",
        minute: "numeric"
      }
    ).format(enteredDate)
    hour12Time = hour12Time.replace(" ", "");
    
    var hour24Time = new Intl.DateTimeFormat("en-GB",
      {
        hour12: false,
        hour: "2-digit",
        minute: "numeric"
      }
    ).format(enteredDate)

    return hour12Time.concat(" / " + hour24Time);
  }
  
  testReservation: Reservation = {
    id: 1,
    arrivalDate: "2026-03-07T20:25",
    departureDate: "2026-03-06T20:25",
    destination: "Paris",
    flightID: "PRS321",
    origin: "Austin",
    reservationDate: "Thu Mar 05 2026",
    seatClass: "Economy", 
    seatNumber: "",
    username: "admin"
  }

  arrayOfReservations: Reservation[] = [
    {
      id: 1,
      arrivalDate: "2026-03-07T20:25",
      departureDate: "2026-03-06T20:25",
      destination: "Paris",
      flightID: "PRS321",
      origin: "Austin",
      reservationDate: "Thu Mar 05 2026",
      seatClass: "Economy", 
      seatNumber: "",
      username: "admin"
    },
    {
      id: 2,
      arrivalDate: "2026-03-27T00:02",
      departureDate: "2026-03-23T20:58",
      destination: "Japan",
      flightID: "JPN987",
      origin: "Austin",
      reservationDate: "Thu Mar 05 2026",
      seatClass: "Economy",
      seatNumber: "",
      username: "admin"
    }
  ];
}