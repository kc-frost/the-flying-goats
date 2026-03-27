  import { Component, output, inject, input, signal } from '@angular/core';
  import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { FlightService } from '../utils/flight-service/flight-service';

  @Component({
    selector: 'app-seat-selector-modal',
    imports: [ReactiveFormsModule],
    templateUrl: './seat-selector-modal.html',
    styleUrl: './seat-selector-modal.css',
  })
  export class SeatSelectorModal {
    private formBuider = inject(FormBuilder);
    private flightService = inject(FlightService)

    readonly leftSeats = ["A", "B"];
    readonly rightSeats = ["C", "D"];

    planeCapacity = input<number | null>(null);
    scheduleID = input<number | null>(null);
    currentActiveSeat = input<string | null>(null);

    capacity: number | null = null;
    schedule: number | null = null;
    rows: number[] = [];

    // this is a signal since its true value is obtained through an observable, compared to the others that can be directly derived by passing it as an input
    takenSeats = signal<string[]>([]);

    ngOnChanges() {
      this.mySeat.patchValue({
        seatID: this.currentActiveSeat(),
      });

      // allow seat capacity to dynamically change
      this.capacity = this.planeCapacity();
      this.rows = [];
      for (let a_row = 1; a_row <= (this.capacity!/4); a_row++) {
        this.rows.push(a_row)
      }

      // disable users from selecting booked flights, however this is just frontend
      // there are no backend protections yet
      this.getTakenSeats(this.scheduleID()!);
    }

    getTakenSeats(scheduleID: number) {
      this.flightService.getTakenSeats(scheduleID).subscribe({
        next: (res) => {
          this.takenSeats.set(res);
        }
      })
    }

    exitModal = output<boolean>();
    tellExit(): void {
      this.exitModal.emit(false);
    }

    seatID = output<string>();
    mySeat = this.formBuider.group({
      seatID: [''],
    });

    onSubmit() {
      this.seatID.emit(this.mySeat.get('seatID')?.value!);
    }

  }
