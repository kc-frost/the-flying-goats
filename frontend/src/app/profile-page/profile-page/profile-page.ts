import { ChangeDetectorRef, Component, inject } from '@angular/core';
import { UserService } from '../../_shared/services/user-service';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../_environments/environment';

interface Reservation {
  bookingNumber: number;
  reservationDate: string;
  flightID: string;
  liftOffDate: string;
  arrivingDate: string;
  username: string;
  seatNumber: string;
  seatClass: string;
  origin: string;
  destination: string;
}

@Component({
  selector: 'app-profile-page',
  imports: [ReactiveFormsModule],
  templateUrl: './profile-page.html',
  styleUrl: './profile-page.css',
})
export class ProfilePage {
  private cdr = inject(ChangeDetectorRef);
  userService = inject(UserService);
  staticProfileImage = "/profile/static-profile-image.svg";

  today = new Date();
  selectedTab: 'past' | 'current' | 'future' = 'past'
  userReservations: Reservation[] = [];

  // sorts RESERVATION DATE in descending order
  constructor(private http: HttpClient) {
    this.loadReservations();
    this.loadBio();

  }

  loadReservations() {
    this.http.get<Reservation[]>(`${environment.api_url}/api/get-user-reservations`, {withCredentials: true})
    .subscribe({
      next: (data) => {
        this.userReservations = data;
        this.userReservations.sort((a, b) =>
          new Date(b.reservationDate).getTime() - new Date(a.reservationDate).getTime()
        );
      },
      error: (err) => {
        console.log(err);
      }
    })
  }

  // assumption: all returned reservations from the database will automatically be made by the current logged in user
  // main function to return reservations
  getReservations() {
    if (this.selectedTab === 'past') return this.getPastReservations();
    if (this.selectedTab === 'current') return this.getCurrentReservations();
    return this.getFutureReservations();
  }

  // the three succeeding functions get reservations based on time relative to today 

  getPastReservations() {
    return this.userReservations
    .filter(r => new Date(r.liftOffDate) < this.today)
    .sort((a, b) => new Date(a.liftOffDate).getTime() - new Date(b.liftOffDate).getTime());
  }
  
  getCurrentReservations() {
    return this.userReservations
    .filter(r => {
      const dep = new Date(r.liftOffDate);
      const arr = new Date(r.arrivingDate);
      return dep <= this.today && arr >= this.today;
    })
    .sort((a, b) => new Date(a.liftOffDate).getTime() - new Date(b.liftOffDate).getTime());
  }
  
  getFutureReservations() {
    return this.userReservations
    .filter(r => new Date(r.liftOffDate) > this.today)
    .sort((a, b) => new Date(a.liftOffDate).getTime() - new Date(b.liftOffDate).getTime());
  }

  // formatting of dates and time
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

  // bio logic
  isEditing = false;
  userBio = new FormControl('');

loadBio() {
  this.http.get<{bio: string}>(`${environment.api_url}/api/get-bio`, { withCredentials: true })
  .subscribe({
    next: (data) => {
      // console.log('bio response:', data);
      this.userBio.setValue(data.bio ?? '');
      this.cdr.detectChanges();
    },
    error: (err) => console.log(err)
  });
}

saveBio() {
  this.http.post(
    `${environment.api_url}/api/save-bio`, 
    { bio: this.userBio.value }, 
    { withCredentials: true }
  ).subscribe({
    next: () => this.isEditing = false,
    error: (err) => console.log(err)
  });
}

updateBio() {
  this.isEditing = true;
}

  // saveBio() {
  //   this.userBio.setValue(this.userBio.value);
  //   this.isEditing = false;
  // }

  // updateBio() {
  //   this.isEditing = true;
  // }
}