import { Component, output } from '@angular/core';

@Component({
  selector: 'app-seat-selector-modal',
  imports: [],
  templateUrl: './seat-selector-modal.html',
  styleUrl: './seat-selector-modal.css',
})
export class SeatSelectorModal {
  exitModal = output<boolean>();

  tellExit(): void {
    this.exitModal.emit(false);
  }

  // HARCODED SEAT IDs
  rows = [1, 2, 3, 4];
  leftSeats = ["A", "B"];
  rightSeats = ["C", "D"];
  seats = ["A", "B", "C", "D"];
}
