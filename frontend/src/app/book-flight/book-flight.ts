import {Component, inject} from '@angular/core';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { UserService } from '../_shared/services/user-service';
import { AuthService } from '../_shared/services/auth-service';

interface Flights {
  id: string,
  code: string
}

@Component({
  selector: 'app-book-flight',
  templateUrl: './book-flight.html',
  styleUrl: './book-flight.css',
  imports: [ReactiveFormsModule],
})
export class BookFlight {
  private formBuilder = inject(FormBuilder);
  private authService = inject(AuthService);

  newFlightDetails = this.formBuilder.group({
    reservationDate: [''],
    flightID: [''],
    username: [''],
    origin: [''],
    destination: [''],
    departureDate: [''],
    arrivalDate: [''],
    seatNumber: [''],
    seatClass: ['Economy'],
  })


  onSubmit() {
  }

  printResults() {
    var deptDate = this.newFlightDetails.get('departureDate')?.value
    console.log(this.newFlightDetails.value);
  }
  availableFlights!: Flights[]
  currentDate: Date
  currentUser!: string
  
  constructor() {
    this.availableFlights = []
    this.currentDate = new Date();
    this.currentUser = localStorage.getItem('username')!
    
    this.newFlightDetails.valueChanges.subscribe({
      next: (changes) => {
        this.updateFlights(changes.departureDate!, changes.destination!);
      }
    })
  
    this.newFlightDetails.get("reservationDate")?.setValue(this.currentDate.toDateString());
    this.newFlightDetails.get("username")?.setValue(this.currentUser);
  }

  // get destination and time of departure date
  updateFlights(time: string, destination: string) {
    var deptHours = new Date(time).getHours()
    var destination = destination
    var timeSlot = ""
    if (deptHours >= 0 && deptHours < 12) timeSlot = "morning";
    else if (deptHours >= 12 && deptHours < 18 ) timeSlot = "afternoon";
    else if (deptHours >= 18 && deptHours <=23) timeSlot = "evening";
  
  
    this.availableFlights = this.flightsByTimeAndDest[timeSlot][destination];
  }

  // hardcoded flights
  flightsByTimeAndDest: any = {
    morning: {
    Paris: [
      { id: 'morning-paris-1', code: 'PRS123' },
      { id: 'morning-paris-2', code: 'PRS345' },
      { id: 'morning-paris-3', code: 'PRS678' },
    ],
    Japan: [
      { id: 'morning-japan-1', code: 'JPN123' },
      { id: 'morning-japan-2', code: 'JPN345' },
      { id: 'morning-japan-3', code: 'JPN678' },
    ]
  },
  afternoon: {
    Paris: [
      { id: 'afternoon-paris-1', code: 'PRS231' },
      { id: 'afternoon-paris-2', code: 'PRS453' },
      { id: 'afternoon-paris-3', code: 'PRS786' },
    ],
    Japan: [
      { id: 'afternoon-japan-1', code: 'JPN231' },
      { id: 'afternoon-japan-2', code: 'JPN453' },
      { id: 'afternoon-japan-3', code: 'JPN786' },
    ]
  },
  evening: {
    Paris: [
      { id: 'evening-paris-1', code: 'PRS321' },
      { id: 'evening-paris-2', code: 'PRS654' },
      { id: 'evening-paris-3', code: 'PRS987' },
    ],
    Japan: [
      { id: 'evening-japan-1', code: 'JPN321' },
      { id: 'evening-japan-2', code: 'JPN654' },
      { id: 'evening-japan-3', code: 'JPN987' },
    ]
  }
};

}
