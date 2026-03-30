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
  imports: [ReactiveFormsModule, SeatSelectorModal, MatDatepickerModule, MatFormFieldModule, AsyncPipe,],
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
  originAirports$ = this.originAirports.asObservable();
  destinationAirports$ = this.destinationAirports.asObservable();

  private departingFlights = new BehaviorSubject<any[]>([]);
  private returningFlights = new BehaviorSubject<any[]>([]);
  departingFlights$ = this.departingFlights.asObservable();
  returningFlights$ = this.returningFlights.asObservable();

  currentDate!: Date
  currentUser!: string
  
  originFocused: boolean = false;
  destFocused: boolean = false;

  hasSelectedDeparture = false;
  activeTab: "depart" | "return" = "depart";

  activeOutboundFlight: number | null = null;
  activeOutboundSeat: string | null = null;
  
  activeInboundFlight: number | null = null;
  activeInboundSeat: string | null = null;

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
    // set timezone offset
    const now = new Date();
    const local = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
    
    return this.formBuilder.group({
      // match mysql datetime format
      reservationDate: [local.toISOString().slice(0, 19).replace("T", " "), [Validators.required]],
      username: [this.userService.getUsername(), [Validators.required]],
      email: [this.userService.getEmail(), [Validators.required]],
      flightID: ['', [Validators.required]], // this field is to make queries easier when POSTed
      origin: ['', [Validators.required]],
      destination: ['', [Validators.required]],
      departureDate: ['', [Validators.required]],
      arrivalDate: ['', [Validators.required]],
      seatNumber: ['', [Validators.required]],
      seatClass: ['1', [Validators.required]],
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
    // if the user has a selected flight from a previous search, and queries new flights based on another search
    // delay the select seat button from turning gray until the api call returns
    // (150 isnt exactly how long it takes, but this is more for visual purposes anyway)
    setTimeout(() => {
      this.activeOutboundFlight = null;
      this.activeInboundFlight = null;
    }, 150);

    this.hasSelectedDeparture = false;

    const origin = this.searchTerms.get('origin')?.value!;
    const destination = this.searchTerms.get('destination')?.value!;

    this.flightService.getFlights(origin, destination).subscribe({
      next: (res: any) => {
        this.departingFlights.next(res.depart);
        this.returningFlights.next(res.return);
      }
    });
  }

  // Replaces text in input element
  setOrigin(airport: any) {
    this.searchTerms.get('origin')?.setValue(airport.IATA)!;
  }

  onOriginFocused() {
    if (!this.searchTerms.get("origin")?.value) {
      this.searchAirports(" ", "origin");
    }
    this.originFocused = true;
  }
  
  onDestFocused() {
    if (!this.searchTerms.get("destination")?.value) {
      this.searchAirports(" ", "destination");
    }
    this.destFocused = true;

  }

  // Replaces text in input element
  setDestination(airport: any) {
    this.searchTerms.get('destination')?.setValue(airport.IATA)!;
  }

  // separated function since seatID is determined from the child component
  setSeatID(seatID: string, leg: string) {
    var isOutbound = (leg === "outbound");
    var flightForm = isOutbound ? this.outboundFlight : this.inboundFlight;

    if (isOutbound) {
      this.activeOutboundSeat = seatID;
    } else {
      this.activeInboundSeat = seatID;
    }

    flightForm.patchValue({
      seatNumber: seatID
    });
  }

  selectFlight(flightIndex: number, flight: any, leg: string) {
    var isOutbound = (leg === "outbound");
    
    if (isOutbound) {
      this.activeOutboundFlight = flightIndex;

      // when a user selects a new flight, reset their seat choices
      this.activeOutboundSeat = null;
      
      // let user select return flight
      this.hasSelectedDeparture = true;
    } else {
      this.activeInboundFlight = flightIndex;
      this.activeInboundSeat = null;
    }

    const dateKey = isOutbound ? "departureDate" : "arrivalDate";
    const origin = isOutbound ? "origin" : "destination";
    const destination = isOutbound ? "destination" : "origin";
    const flightForm = isOutbound ? this.outboundFlight : this.inboundFlight;

    // extract date out of the calendar
    var tripDate = new Date(`${this.searchTerms.get(`${dateKey}`)!.value}`).toLocaleDateString();

    // set timezone offset
    const toLocal = (d: Date) => new Date(d.getTime() - d.getTimezoneOffset() * 60000)
    .toISOString().slice(0, 19).replace("T", " ");
    
    // match mysql datetime format
    var newDeptDate = toLocal(new Date(`${tripDate} ${flight.liftOff}`));
    var newArrDate = toLocal(new Date(`${tripDate} ${flight.landing}`));

    // update form values
    flightForm.patchValue({
      origin: this.searchTerms.get(`${origin}`)!.value.toUpperCase(),
      destination: this.searchTerms.get(`${destination}`)!.value.toUpperCase(),
      flightID: flight.IATA,
      departureDate: newDeptDate,
      arrivalDate: newArrDate
    })

  }

  // TESTING FUNCTIONS
  printOutbound() {
    console.log(this.outboundFlight.value);
  }

  printInBound() {
    console.log(this.inboundFlight.value);
  }

  printAllFlights() {
    this.printOutbound();
    this.printInBound();
  }

};
