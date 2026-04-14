import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class CancellationService {
  private http = inject(HttpClient);

  getAllCancellations() {
    return this.http.get<{ bookingNumber: number, cancellationDate: string, canceledBy: string, destination: string, origin: string, reason: string, username: string}[]>(`${environment.api_url}/admin/all-cancellations`)
  }
}
