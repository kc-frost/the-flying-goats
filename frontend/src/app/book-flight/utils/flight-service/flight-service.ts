import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class FlightService {
  private http = inject(HttpClient);

  getAirports(search_tm: string) {
    return this.http.get<any[]>(`${environment.api_url}/api/airports`,
      { params: {
      search_term: search_tm
    }}
    );
  }

  getFlights(origin: string, destination: string) {
    return this.http.get<any[]>(`${environment.api_url}/api/available-flights`,
      { params: {
        user_origin: origin,
        user_destination: destination
      }}
    );
  }
  
}
