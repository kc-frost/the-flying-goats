import { Component, inject, ChangeDetectionStrategy} from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { provideNativeDateAdapter } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
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
  private userService = inject(UserService);
  private flightService = inject(FlightService);

  // === ON INIT ===
  ngOnInit() {
    this.searchTerms.get('origin')?.valueChanges.pipe(
      // Wait for 400ms of inactivity before subscribing
      debounceTime(400)
    )
    .subscribe({
      next: (search_term) => {
        this.searchAirports(search_term!, "origin");
      }
    }
    );

    this.searchTerms.get('destination')?.valueChanges.pipe(
      // Wait for 400ms of inactivity before subscribing
      debounceTime(400)
    )
    .subscribe({
      next: (search_term) => {
        this.searchAirports(search_term!, "destination");
      }
    }
    );
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

  // === FORMS ===
  // searches for flights
  searchTerms: FormGroup = this.formBuilder.group({
    origin: ['', [Validators.required]],
    destination: ['', [Validators.required]],
    departureDate: ['', [Validators.required]],
    arrivalDate: ['', [Validators.required]],
  })

  // round-trip flight forms to create a booking from
  outboundFlight = this.createFlightForm();
  inboundFlight = this.createFlightForm();

  // === ON SUBMIT ===
  onSubmit() {
    this.flightService.bookFlight(this.outboundFlight, this.inboundFlight).subscribe({
      next: () => {
        alert("Booking created! Safe travels :)");
      },
      error: (err) => {
        console.log("BOOKING NOT RECEIVED:", err);
      }
    });
}

// === HELPER FUNCTIONS ===
  createFlightForm() {
    return this.formBuilder.group({
      reservationDate: [new Date(), [Validators.required]],
      username: [this.userService.getUsername(), [Validators.required]],
      origin: ['', [Validators.required]],
      destination: ['', [Validators.required]],
      departureDate: ['', [Validators.required]],
      arrivalDate: ['', [Validators.required]],
      seatNumber: ['', [Validators.required]],
      seatClass: ['Economy', [Validators.required]],
    })
  }

  searchAirports(search_term: string, leg: string) {
    this.flightService.getAirports(search_term).subscribe({
      next: (res) => {
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

    const origin = this.searchTerms.get('origin')?.value!;
    const destination = this.searchTerms.get('destination')?.value!;

    this.flightService.getFlights(origin, destination).subscribe({
      next: (res) => {
        this.availableFlights.next(res);
      }
    })
  }

  // Replaces text in input element
  setOrigin(airport: any) {
    this.searchTerms.get('origin')?.setValue(airport.IATA)!;
  }

  // Replaces text in input element
  setDestination(airport: any) {
    this.searchTerms.get('destination')?.setValue(airport.IATA)!;
  }

  // separated function since seatID is determined from the child component
  setSeatID(seatID: string) {
    // persists selected seat while even if the seat selector modal is closed
    // for as long as the associated flight remains selected
    this.seatID = seatID;

    this.outboundFlight.patchValue({
      seatNumber: seatID
    });
  }

  selectFlight(flightIndex: number, flight: any, leg: string) {
    // important for knowing what flight was selected
    this.activeFlight = flightIndex;

    const dateKey = (leg == 'outbound') ? "departureDate" : "arrivalDate";

    // extract date out of the calendar
    var tripDate = new Date(`${this.searchTerms.get(`${dateKey}`)!.value}`).toLocaleDateString();

    var liftOff = flight.liftOff;
    var landing = flight.landing;

    var newDeptDate = new Date(`${tripDate} ${liftOff}`).toLocaleString();
    var newArrDate = new Date(`${tripDate} ${landing}`).toLocaleString();

    this.outboundFlight.patchValue({
      origin: this.searchTerms.get('origin')!.value.toUpperCase(),
      destination: this.searchTerms.get('destination')!.value.toUpperCase(),
      departureDate: newDeptDate,
      arrivalDate: newArrDate
    });
  }

  getActiveFlight(): number | null {
    return this.activeFlight;
  }

  // TESTING FUNCTIONS
  printOutbound() {
    console.log(this.outboundFlight.value);
  }

  printInBound() {
    console.log(this.inboundFlight.value);
  }

};
