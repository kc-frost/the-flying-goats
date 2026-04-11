import { Component, inject } from '@angular/core';
import { AnalyticsService } from './utils/analytics-service';
import { AsyncPipe } from '@angular/common';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'app-analytics',
  imports: [AsyncPipe],
  templateUrl: './analytics.html',
  styleUrl: './analytics.css',
})
export class Analytics {
  private analytics = inject(AnalyticsService);

  // analytics structures
  private top3Users = new BehaviorSubject<{ user: string, amount: number }[]>([]);
  top3Users$ = this.top3Users.asObservable();

  ngOnInit() {
    this.getMostActiveUsers();

  }

  getMostActiveUsers() {
    this.analytics.getMostActiveUsers().subscribe({
      next: (res) => {
        this.top3Users.next(
          res.map(booking => ({
            user: booking.username,
            amount: booking.bookingAmount
          }))
        );
      }
    });
  }

  longestRegisteredUsers = [
    {user: 'me', days: 123},
    {user: 'you', days: 23},
    {user: 'someone', days: 9},
  ];

  reservationsThisYear = [
    {month: 'Jan', amt: 12},
    {month: 'Feb', amt: 12},
    {month: 'Mar', amt: 12},
    {month: 'Apr', amt: 12},
    {month: 'May', amt: 12},
    {month: 'Jun', amt: 12},
    {month: 'July', amt: 12},
    {month: 'Aug', amt: 12},
    {month: 'Sep', amt: 12},
    {month: 'Oct', amt: 12},
    {month: 'Nov', amt: 12},
    {month: 'Dec', amt: 12},
  ];
}
