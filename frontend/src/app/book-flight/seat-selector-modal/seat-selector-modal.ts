import { Component, output, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-seat-selector-modal',
  imports: [ReactiveFormsModule],
  templateUrl: './seat-selector-modal.html',
  styleUrl: './seat-selector-modal.css',
})
export class SeatSelectorModal {
  private formBuider = inject(FormBuilder);

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

  // HARCODED SEAT IDs
  rows = [1, 2, 3, 4, 5, 6, 7];
  leftSeats = ["A", "B"];
  rightSeats = ["C", "D"];
  seats = ["A", "B", "C", "D"];
}
