import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AnalyticsService {
  private http = inject(HttpClient);

  // Gets the most active users according to how many reservations they've made (currently does not distinguish between valid, past, and cancelled reservations)
  getMostActiveUsers() {
    return this.http.get<{bookingAmount: number, userID: number, username: string}[]>(`${environment.api_url}/admin/most-active-users`);
  }

  // Get the top 10 users who are registered the longest in days
  getLongestRegisteredUsers() {
    return this.http.get<{registerLengthDays: number, userID: number, user_rank: number, username: string}[]>(`${environment.api_url}/admin/longest-registered-users`)
  }

  getActiveUsersThisMonth() {
    return this.http.get<{distinct_reservations_this_month: number}>(`${environment.api_url}/admin/active-users-this-month`)
  }

  // Gets all the reservations made within the current month
  getReservationsThisMonth() {
    return this.http.get<{monthly_reservations: number}>(`${environment.api_url}/admin/reservations-this-month`);
  }

  // Gets all the reservations made within the current year, binned into the month they were booked
  getPerMonthReservations() {
    return this.http.get<{month: number, monthly_reservations: number}[]>(`${environment.api_url}/admin/per-month-reservations`)
  }
}
