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

  // analytics fields
  // USER STATS
  private top3Users = new BehaviorSubject<{ user: string, amount: number }[]>([]);
  top3Users$ = this.top3Users.asObservable();

  private allTimeRegisteredUsers = new BehaviorSubject<{ user: string, days: number }[]>([]);
  allTimeRegisteredUsers$ = this.allTimeRegisteredUsers.asObservable();

  // RESERVATION STATS
  private reservationsThisMonth = new BehaviorSubject<number>(0);
  reservationsThisMonth$ = this.reservationsThisMonth.asObservable(); 

  private perMonthReservations = new BehaviorSubject<{ month: string, monthlyReservations: number}[]>([]);
  perMonthReservations$ = this.perMonthReservations.asObservable();

  ngOnInit() {
    this.getMostActiveUsers();
    this.getReservationsThisMonth();
    this.getPerMonthReservations();
    this.getAllTimeRegisteredUsers();
  }

  // TODO: Add refresh button

  // USER STATS
  getMostActiveUsers() {
    this.analytics.getMostActiveUsers().subscribe({
      next: (res) => {
        // console.log(res);
        this.top3Users.next(
          res.map(booking => ({
            user: booking.username,
            amount: booking.bookingAmount
          }))
        );
      }
    });
  }

  getAllTimeRegisteredUsers() {
    this.analytics.getAllTimeRegisteredUsers().subscribe({
      next: (res) => {
        console.log(res);
        this.allTimeRegisteredUsers.next(
          res.map(r => ({
            user: r.username,
            days: r.registerLengthDays
          }))
        );
      }
    });
  }

  // RESERVATION STATS
  getReservationsThisMonth() {
    this.analytics.getReservationsThisMonth().subscribe({
      next: (res) => {
        // console.log(res);
        this.reservationsThisMonth.next(res.monthly_reservations);
      }
    })
  }

  getPerMonthReservations() {
    this.analytics.getPerMonthReservations().subscribe({
      next: (res) => {
        // console.log(res);
        const monthlyReservations: { month: string, monthlyReservations: number }[] = [];

        for (let month = 1; month < 13; month++) {
          const found = res.find((r) => r.month === month)
          monthlyReservations.push({
            month: new Date(2000, month - 1).toLocaleString('default', { month: 'short' }),
            monthlyReservations: found ? found.monthly_reservations : 0
          });
        }

        this.perMonthReservations.next(monthlyReservations);
      }
    })
  }

  longestRegisteredUsers = [
    {user: 'me', days: 123},
    {user: 'you', days: 23},
    {user: 'someone', days: 9},
  ];
}
