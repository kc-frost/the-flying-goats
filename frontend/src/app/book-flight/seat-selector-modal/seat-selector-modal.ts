  import { Component, output, inject, input } from '@angular/core';
  import { FormBuilder, ReactiveFormsModule } from '@angular/forms';

  @Component({
    selector: 'app-seat-selector-modal',
    imports: [ReactiveFormsModule],
    templateUrl: './seat-selector-modal.html',
    styleUrl: './seat-selector-modal.css',
  })
  export class SeatSelectorModal {
    private formBuider = inject(FormBuilder);

    readonly leftSeats = ["A", "B"];
    readonly rightSeats = ["C", "D"];

    planeCapacity = input<number | null>(null);
    currentActiveSeat = input<string | null>(null);

    capacity: number | null = null;
    rows: number[] = [];

    ngOnChanges() {
      this.mySeat.patchValue({
        seatID: this.currentActiveSeat(),
      });

      // allow seat capacity to dynamically change
      this.capacity = this.planeCapacity();
      this.rows = [];
      for (let a_row = 1; a_row <= (this.capacity!/2); a_row++) {
        this.rows.push(a_row)
      }

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
