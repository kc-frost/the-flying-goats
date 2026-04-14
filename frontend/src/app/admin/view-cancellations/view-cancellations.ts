import { Component, inject } from '@angular/core';
import { AsyncPipe } from '@angular/common';
import { CancellationService } from './utils/cancellation-service';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'app-view-cancellations',
  imports: [AsyncPipe],
  templateUrl: './view-cancellations.html',
  styleUrl: './view-cancellations.css',
})
export class ViewCancellations {
  private cancellation = inject(CancellationService);

  // BEHAVIORSUBJEEEEECT
  private allCancellations = new BehaviorSubject<{ bookingNumber: number, bookingDate: string, cancellationDate: string, cancelledBy: string, destination: string, origin: string, reason: string, username: string }[]>([]);
  allCancellations$ = this.allCancellations.asObservable();

  ngOnInit() {
    this.getAllCancellations();
  }

  getAllCancellations() {
    this.cancellation.getAllCancellations().subscribe({
      next: (res) => {
        // console.log(res);
        this.allCancellations.next(res.map(
          r => ({
            bookingNumber: r.bookingNumber,
            bookingDate: r.bookingDate,
            cancellationDate: r.cancellationDate,
            cancelledBy: r.cancelledBy,
            destination: r.destination,
            origin: r.origin,
            reason: r.reason,
            username: r.username
          })
        ))
      }
    })
  }

  // to erase the 'GMT'
  formatDate(date: string): string {
    return date.replace(' GMT', '');
  }
}
