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

  // --- HOW THIS WORKS --- (thanks claude)
  // BehaviorSubject is like a variable that can be "watched" for changes.
  // When you call .next(value), it updates the value and notifies anyone watching.
  //
  // Each field here follows the same pattern:
  //   1. A private BehaviorSubject — this is what we write to (via .next())
  //   2. A public $ observable — this is what the HTML reads from
  //
  // If you're familiar with ChangeDetectorRef, think of BehaviorSubject + async pipe
  // as a more automatic version. Instead of manually calling detectChanges() to tell
  // Angular to re-render, the async pipe handles that for you — whenever .next() is
  // called with a new value, Angular knows to update the UI on its own.
  //
  // (kai) Tho in this case, since the page isn't updated until refresh() is called, technically we can swap it out 
  // for cdr. Using BehaviorSubject however allows us to pivot to a "live" analytics page if we wanted to. I just 
  // decided to not make it live since functionally they do the same thing. Time is short, why bother lol. Though 
  // it's nice to have the option to, I'm gonna be honest
  // Admittedly, it is more typing this way, but 🤷
  // 
  // (kai) Either implementation is fine, but if you do decide to go with cdr, make sure the rest don't break in the 
  // process since I have never experimented with using both at the same time 🙏
  // 
  // The refresh() method simply re-calls all the fetch methods, which call
  // .next() again with fresh data — the HTML updates automatically because
  // it's already watching the observables via async pipe.
  // ----------------------

  // analytics fields
  // USER STATS
  private top3Users = new BehaviorSubject<{ user: string, amount: number }[]>([]);
  top3Users$ = this.top3Users.asObservable();

  private longestRegisteredUsers = new BehaviorSubject<{ user: string, days: number }[]>([]);
  longestRegisteredUsers$ = this.longestRegisteredUsers.asObservable();

  private activeUsersThisMonth = new BehaviorSubject<number>(0);
  activeUsersThisMonth$ = this.activeUsersThisMonth.asObservable();

  // RESERVATION STATS
  private reservationsThisMonth = new BehaviorSubject<number>(0);
  reservationsThisMonth$ = this.reservationsThisMonth.asObservable(); 

  private perMonthReservations = new BehaviorSubject<{ month: string, monthlyReservations: number}[]>([]);
  perMonthReservations$ = this.perMonthReservations.asObservable();

  ngOnInit() {
    this.getMostActiveUsers();
    this.getReservationsThisMonth();
    this.getPerMonthReservations();
    this.getLongestRegisteredUsers();
    this.getActiveUsersThisMonth();
    this.getTopStaffThisMonth();
    this.getTotalCancellations();
    this.getTotalCancellationsThisMonth();
    this.getCancellationsThisMonthByCategory();
    this.getTotalReservationsThisYear();
  }

  refresh() {
    this.getMostActiveUsers();
    this.getReservationsThisMonth();
    this.getPerMonthReservations();
    this.getLongestRegisteredUsers();
    this.getActiveUsersThisMonth();
    this.getTopStaffThisMonth();
    this.getTotalCancellations();
    this.getTotalCancellationsThisMonth();
    this.getCancellationsThisMonthByCategory();
    this.getTotalReservationsThisYear();
  }

  // USER STATS
  // Get top 3 users with the most bookings
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

  // Get top 10 users who have been registered the longest
  getLongestRegisteredUsers() {
    this.analytics.getLongestRegisteredUsers().subscribe({
      next: (res) => {
        // console.log(res);
        this.longestRegisteredUsers.next(
          res.map(r => ({
            user: r.username,
            days: r.registerLengthDays
          }))
        );
      }
    });
  }

  // Get how many unique users made a reservation in the current month
  getActiveUsersThisMonth() {
    this.analytics.getActiveUsersThisMonth().subscribe({
      next: (res) => {
        // console.log(res);
        this.activeUsersThisMonth.next(res.distinct_reservations_this_month);
      }
    })
  }

  // RESERVATION STATS
  // Get how many reservations were booked in the current month
  getReservationsThisMonth() {
    this.analytics.getReservationsThisMonth().subscribe({
      next: (res) => {
        // console.log(res);
        this.reservationsThisMonth.next(res.monthly_reservations);
      }
    })
  }

  // Get how many reservations per month were made in the current year
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

  // STAFF STATS
  private topStaffThisMonth = new BehaviorSubject<{ staff: string, amount: number }[]>([]);
  topStaffThisMonth$ = this.topStaffThisMonth.asObservable();

  // CANCELLATION STATS
  private totalCancellations = new BehaviorSubject<number>(0);
  totalCancellations$ = this.totalCancellations.asObservable();

  private totalCancellationsThisMonth = new BehaviorSubject<number>(0);
  totalCancellationsThisMonth$ = this.totalCancellationsThisMonth.asObservable();

  private cancellationsThisMonthByCategory = new BehaviorSubject<{ category: string, amount: number }[]>([]);
  cancellationsThisMonthByCategory$ = this.cancellationsThisMonthByCategory.asObservable();

  private totalReservationsThisYear = new BehaviorSubject<number>(0);
  totalReservationsThisYear$ = this.totalReservationsThisYear.asObservable();

  getTopStaffThisMonth() {
    this.analytics.getTopStaffThisMonth().subscribe({
      next: (res) => {
        this.topStaffThisMonth.next(
          res.map(staff => ({
            staff: `${staff.fname} ${staff.lname}`,
            amount: staff.bookingCount
          }))
        );
      }
    })
  }

  getTotalCancellations() {
    this.analytics.getTotalCancellations().subscribe({
      next: (res) => {
        this.totalCancellations.next(res.total_cancellations);
      }
    })
  }

  getTotalCancellationsThisMonth() {
    this.analytics.getTotalCancellationsThisMonth().subscribe({
      next: (res) => {
        this.totalCancellationsThisMonth.next(res.total_cancellations);
      }
    })
  }

  getCancellationsThisMonthByCategory() {
    this.analytics.getCancellationsThisMonthByCategory().subscribe({
      next: (res) => {
        this.cancellationsThisMonthByCategory.next(
          res.map(category => ({
            category: category.cancellationCategory,
            amount: category.total_cancellations
          }))
        );
      }
    })
  }

  getTotalReservationsThisYear() {
    this.analytics.getTotalReservationsThisYear().subscribe({
      next: (res) => {
        this.totalReservationsThisYear.next(res.yearly_reservations);
      }
    })
  }
}
