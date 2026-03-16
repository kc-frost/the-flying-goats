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
}
