import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { invalidDateValidator } from './utils/invalid-date-validator';
import { environment } from '../../_environments/environment';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { SeatSelectorModal } from './seat-selector-modal/seat-selector-modal';

interface Flights {
  id: string,
  code: string
}

@Component({
  selector: 'app-book-flight',
  templateUrl: './book-flight.html',
  styleUrl: './book-flight.css',
  imports: [ReactiveFormsModule, SeatSelectorModal],
})
export class BookFlight {
  private formBuilder = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);
  
  modalShown = false;
  // some fields don't have a validator because they are automatically filled in (for now)
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
    seatNumber: ['',],
    seatClass: ['Economy'],
  },
  { validators: invalidDateValidator}
);

  toggleModal() {
    this.modalShown = !this.modalShown;
    console.log(this.modalShown);
  }
  
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
      console.log(err);
    }
  });
}

  printResults() {
    var deptDate = this.newFlightDetails.get('departureDate')?.value
    console.log(this.newFlightDetails.value);
  }

  validateUserAccess() {
    this.http.get(`${environment.api_url}/api/check-authenticated`).subscribe({
      error: () => {
        this.router.navigate([''])
      }
    })
  }

  availableFlights!: Flights[]
  currentDate: Date
  currentUser!: string

  // temporarily hardcode everyone to have seat 1
  seatNumber = "110";
  
  constructor() {
    // this.validateUserAccess();
    
    this.availableFlights = []
    this.currentDate = new Date();
    this.currentUser = localStorage.getItem('username')!
    
    this.newFlightDetails.valueChanges.subscribe({
      next: (changes) => {
        this.updateFlights(changes.departureDate!, changes.arrivalDate!);
      }
    })
  
    this.newFlightDetails.get("reservationDate")?.setValue(this.currentDate.toDateString());
    this.newFlightDetails.get("username")?.setValue(this.currentUser);
    this.newFlightDetails.get("seatNumber")?.setValue(this.seatNumber);
  }

  updateFlights(departureDate: string, arrivalDate: string) {
  if (!departureDate || !arrivalDate) return;

  const dept = new Date(departureDate).toISOString().split('T')[0];
  const arr = new Date(arrivalDate).toISOString().split('T')[0];

  this.http.get<Flights[]>(
    `${environment.api_url}/api/available-flights`,
    { params: { departureDate: dept, arrivalDate: arr }, withCredentials: true }
  ).subscribe({
    next: (flights) => this.availableFlights = flights,
    error: (err) => console.log(err)
  });
}

  // // get destination and time of departure date
  // updateFlights(time: string, destination: string) {
  //   var deptHours = new Date(time).getHours()
  //   var destination = destination
  //   var timeSlot = ""
  //   if (deptHours >= 0 && deptHours < 12) timeSlot = "morning";
  //   else if (deptHours >= 12 && deptHours < 18 ) timeSlot = "afternoon";
  //   else if (deptHours >= 18 && deptHours <=23) timeSlot = "evening";
  
  
  //   this.availableFlights = this.flightsByTimeAndDest[timeSlot][destination];
  // }

  // hardcoded flights
  flightsByTimeAndDest: any = {
    morning: {
    Paris: [
      { id: 'morning-paris-1', code: 'TP1002' },
      { id: 'morning-paris-2', code: 'TP1003' },
      { id: 'morning-paris-3', code: 'TP1004' },
    ],
    Japan: [
      { id: 'morning-japan-1', code: 'TP1006' },
      { id: 'morning-japan-2', code: 'TP1005' },
      { id: 'morning-japan-3', code: 'TP1004' },
    ]
  },
  afternoon: {
    Paris: [
      { id: 'afternoon-paris-1', code: 'TP1007' },
      { id: 'afternoon-paris-2', code: 'TP1003' },
      { id: 'afternoon-paris-3', code: 'TP1002' },
    ],
    Japan: [
      { id: 'afternoon-japan-1', code: 'TP1007' },
      { id: 'afternoon-japan-2', code: 'TP1006' },
      { id: 'afternoon-japan-3', code: 'TP1005' },
    ]
  },
  evening: {
    Paris: [
      { id: 'evening-paris-1', code: 'TP1001' },
      { id: 'evening-paris-2', code: 'TP1004' },
      { id: 'evening-paris-3', code: 'TP1007' },
    ],
    Japan: [
      { id: 'evening-japan-1', code: 'TP1003' },
      { id: 'evening-japan-2', code: 'TP1001' },
      { id: 'evening-japan-3', code: 'TP1002' },
    ]
  }
};

}
