import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AnalyticsService {
  private http = inject(HttpClient);

  getMostActiveUsers() {
    return this.http.get<{bookingAmount: number, userID: number, username: string}[]>(`${environment.api_url}/admin/most-active-users`);
  }

}
