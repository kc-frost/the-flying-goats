import { Component, inject } from '@angular/core';
import { OverrideService } from './utils/override-service';
import { BehaviorSubject } from 'rxjs';
import { AsyncPipe } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-reservation-override',
  imports: [AsyncPipe, ReactiveFormsModule],
  templateUrl: './reservation-override.html',
  styleUrl: './reservation-override.css',
})
export class ReservationOverride {
  private override = inject(OverrideService);
  private formBuilder = inject(FormBuilder);

  // template of what fields we need
  // these are the same for both staff and admin, the only difference is that staff only needs their "appointments" ofc

  // i think it's easier if we just do a "get all reservations" if the user is an admin (backend), and do another query for getting all that staff's specific appointments, so we can reuse this entire component with little change to this code

  // my favorite behaviorsubject
  private userReservations = new BehaviorSubject<{ username: string, origin: string, destination: string, liftOffDate: string, landingDate: string, bookingNumber: number }[]>([]);
  userReservations$ = this.userReservations.asObservable();

  cancellationForm = this.formBuilder.group({
    bookingNumber: ['', Validators.required],
    reason: ['', Validators.required]
  })

  ngOnInit() {
    this.getCancelleableReservations();
  }

  getCancelleableReservations() {
    this.override.getCancelleableReservations().subscribe({
      next: (res) => {
        console.log(res);
        this.userReservations.next(
          res.map(r => ({
          username: r.username,
          origin: r.origin,
          destination: r.destination,
          liftOffDate: r.liftOff,
          landingDate: r.landing,
          bookingNumber: r.bookingNumber
        })));
      }
    });
  }

  deleteReservation() {
    this.override.deleteReservation(this.cancellationForm).subscribe({
      next: (res) => {
        this.getCancelleableReservations();
        this.cancellationForm.reset();
      }
    });
  }
  
  // to erase the 'GMT'
  formatDate(date: string): string {
    return date.replace(' GMT', '');
  }
}
