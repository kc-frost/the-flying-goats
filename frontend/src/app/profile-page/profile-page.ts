import { ChangeDetectorRef, Component, inject } from '@angular/core';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { AsyncPipe } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { UserService } from '../_shared/services/user-service';
import { environment } from '../../_environments/environment';
import { BehaviorSubject } from 'rxjs';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-profile-page',
  // AsyncPipe subscribes to an Observable/Promise and emits the latest value emitted, and then is marked to be checked for changes
  imports: [ReactiveFormsModule, AsyncPipe, DatePipe],
  templateUrl: './profile-page.html',
  styleUrl: './profile-page.css',
})
export class ProfilePage {
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef)
  private userReservations = new BehaviorSubject<any[]>([]);
  private userBio = new BehaviorSubject<string>("");
  private isEditing = new BehaviorSubject<boolean>(false);

  userService = inject(UserService);
  selectedTab: 'past' | 'upcoming' = 'upcoming'
  staticProfileImage = "/profile/static-profile-image.svg";
  
  isEditing$ = this.isEditing.asObservable();
  userBio$ = this.userBio.asObservable();
  userBioForm = new FormControl('');

  ngOnInit() {
    this.loadReservations();
    this.loadBio();
  }

  loadReservations() {
    this.http.get<any[]>(`${environment.api_url}/api/user-reservations`).subscribe({
      next: (data) => {
        this.userReservations.next(data);
        
        // load reservations automatically
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.log("LOADING RESERVATIONS ERROR:", err);
      }
    })
  }

  get filteredReservations() {
    // change this to sort by the full date of the initial liftOff of the trip

    const pastCutoff = new Date();

    // currently, if the creation of a booking is at least 3 days ago
    pastCutoff.setDate(pastCutoff.getDate() - 2);
    const allReservations = this.userReservations.value;

    // past: descending (most recent first)
    if (this.selectedTab == 'past') {
      return allReservations.filter((reservation) => new Date(reservation.reservationDate) < pastCutoff)
      .sort((a,b) => 
        new Date(b.reservationDate).getTime() - new Date(a.reservationDate).getTime()
      )
    } 

    // upcoming: ascending (soonest first)
    else {
      return allReservations.filter((reservation) => new Date(reservation.reservationDate) >= pastCutoff)
      .sort((a,b) => 
        new Date(a.reservationDate).getTime() - new Date(b.reservationDate).getTime()
      )
    }
  }

  loadBio() {
    this.http.get<{bio: string}>(`${environment.api_url}/api/get-bio`,)
    .subscribe({
      next: (data) => {
        this.userBio.next(data.bio);

        this.cdr.detectChanges();
      },
      error: (err) => console.log(err)
    });
  }

  saveBio() {
    this.http.post(
      `${environment.api_url}/api/save-bio`, 
      { bio: this.userBioForm.value }, 
    ).subscribe({
      next: () => {
        this.isEditing.next(false);
        this.userBio.next(this.userBioForm.value!);
      },
      error: (err) => console.log("SAVE BIO ERROR:", err)
    });
  }

  updateBio() { 
    this.isEditing.next(true);
  }

}