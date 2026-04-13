import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class OverrideService {
  private http = inject(HttpClient);

  // ADMIN gets these fields
  // flight IATA
  // bookers username
  // liftOff of both departing and return flights
  // landing of both departing and return flights
  // origin airport IATA of ""
  // destination airport IATA of "" 

  // PILOT gets these fields
  // staffID of pilot
  // email of pilot
  // ...the rest of the admin fields
  getCancelleableReservations() {
    return this.http.get<{
      IATA: string,
      username: string,
      liftOff: string,
      landing: string,
      origin: string,
      destination: string,
      bookingNumber: number,
      staffID?: number,     // optional
      pilotEmail?: string   // optional
    }[]>(`${environment.api_url}/admin/cancelleable-reservations`);
  }
}