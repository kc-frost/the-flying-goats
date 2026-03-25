import { Component, inject, ChangeDetectionStrategy} from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { provideNativeDateAdapter } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { invalidDateValidator } from './utils/invalid-date-validator';
import { environment } from '../../_environments/environment';
import { HttpClient } from '@angular/common/http';
import { SeatSelectorModal } from './seat-selector-modal/seat-selector-modal';
import { UserService } from '../_shared/services/user-service';
import { FlightService } from './utils/flight-service/flight-service';
import { BehaviorSubject, debounceTime } from 'rxjs';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-book-flight',
  templateUrl: './book-flight.html',
  styleUrl: './book-flight.css',
  imports: [ReactiveFormsModule, SeatSelectorModal, MatDatepickerModule, MatFormFieldModule, AsyncPipe],
  providers: [provideNativeDateAdapter()],
  changeDetection: ChangeDetectionStrategy.OnPush,
})

// This file is gonna be separated into commented categories because even after reorganizing everything it's still so fucking long
export class BookFlight {
  private formBuilder = inject(FormBuilder);
  private http = inject(HttpClient);
  private userService = inject(UserService);
  flightService = inject(FlightService);

  // === ON INIT ===
  ngOnInit() {
    this.currentDate = new Date();
    this.currentUser = this.userService.getUsername();

    this.newFlightDetails.get('origin')?.valueChanges.pipe(
      // Wait for 400ms of inactivity before subscribing
      debounceTime(400)
    )
    .subscribe({
      next: (search_term) => {
        this.searchAirports(search_term!, "origin");
      }
    }
    );

    this.newFlightDetails.get('destination')?.valueChanges.pipe(
      // Wait for 400ms of inactivity before subscribing
      debounceTime(400)
    )
    .subscribe({
      next: (search_term) => {
        this.searchAirports(search_term!, "destination");
      }
    }
    );

    this.newFlightDetails.get("reservationDate")?.setValue(this.currentDate.toDateString());
    this.newFlightDetails.get("username")?.setValue(this.currentUser);
  }

  // === FIELDS AND PROPERTIES ===

  readonly MIN_DATE = new Date();
  readonly MAX_DATE = new Date(
    this.MIN_DATE.getFullYear(),
    this.MIN_DATE.getMonth() + 3,
    this.MIN_DATE.getDate()
  )

  private originAirports = new BehaviorSubject<any[]>([]);
  private destinationAirports = new BehaviorSubject<any[]>([]);
  private availableFlights = new BehaviorSubject<any[]>([]);

  originAirports$ = this.originAirports.asObservable();
  destinationAirports$ = this.destinationAirports.asObservable();
  availableFlights$ = this.availableFlights.asObservable();
  currentDate!: Date
  currentUser!: string
  seatID: string | undefined | null; 
  
  originFocused: boolean = false;
  destFocused: boolean = false;

  activeFlight: number | null = null;

  // === FORM ===
  // Username, ReservationDate, and SeatClass are filled in automatically
  // SeatClass is automatic (FOR NOW)
  newFlightDetails = this.formBuilder.group({
    reservationDate: [''],
    flightID: ['',
      [Validators.required]
    ],
    username: [''
    ],
    origin: ['',
      [Validators.required]
    ],
    destination: ['',
      [Validators.required]
    ],
    departureDate: ['',
      [Validators.required]
    ],
    arrivalDate: ['',
      [Validators.required]
    ],
    seatNumber: ['',
      [Validators.required]
    ],
    seatClass: ['Economy'],
  },
  { validators: invalidDateValidator}
);
  
  // == ON SUBMIT ==
  onSubmit() {
    this.http.post(
    `${environment.api_url}/api/book-flight`, 
    this.newFlightDetails.value,
    { withCredentials: true }
  ).subscribe({
    next: () => {
      alert("Booking received!")
    },
    error: (err) => {
      console.log("BOOKING NOT RECEIVED:", err);
    }
  });
}

// === HELPER FUNCTIONS ===
  searchAirports(search_term: string, leg: string) {
    this.flightService.getAirports(search_term).subscribe({
      next: (res) => {
        console.log("AIRPORTS FOUND");
        if (leg == "origin") {
          this.originAirports.next(res);
        } else if (leg == "destination") {
          this.destinationAirports.next(res);
        }
      }
    })
  }

  searchFlights() {
    // due to the api call, flights takes a little longer to load
    // this delays the button from turning grey so that it "syncs up" with flights loading in 
    // this is more for visual purposes
    setTimeout(() => {
      this.activeFlight = null;
    }, 150);

    const origin = this.newFlightDetails.get('origin')?.value!;
    const destination = this.newFlightDetails.get('destination')?.value!;

    this.flightService.getFlights(origin, destination).subscribe({
      next: (res) => {
        console.log(res);
        this.availableFlights.next(res);
      }
    })
  }

  setOrigin(airport: any) {
    this.newFlightDetails.get('origin')?.setValue(airport.IATA)!
  }

  setDestination(airport: any) {
    this.newFlightDetails.get('destination')?.setValue(airport.IATA)!
  }

  setSeatID(seatID: string) {
    this.seatID = seatID;
    this.newFlightDetails.get("seatNumber")?.setValue(this.seatID);
    console.log(this.seatID);
  }

  setActiveFlight(flight: number) {
    this.activeFlight = flight;
    console.log(this.activeFlight);
  }

  getActiveFlight(): number | null {
    return this.activeFlight;
  }

};
