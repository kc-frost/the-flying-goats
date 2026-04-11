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

  // Gets all the reservations made within the current month
  getReservationsThisMonth() {
    return this.http.get<{monthly_reservations: number}>(`${environment.api_url}/admin/reservations-this-month`);
  }

  // Gets all the reservations made within the current year, binned into the month they were booked
  getPerMonthReservations() {
    return this.http.get<{month: number, monthly_reservations: number}[]>(`${environment.api_url}/admin/per-month-reservations`)
  }
}
