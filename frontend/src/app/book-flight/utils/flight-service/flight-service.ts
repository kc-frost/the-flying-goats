import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { environment } from '../../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})

export class FlightService {
  private http = inject(HttpClient);

  bookFlight(outboundFlight: FormGroup, inboundFlight: FormGroup) {
    return this.http.post(`${environment.api_url}/api/book-flight`, {
      outbound: outboundFlight.value,
      inbound: inboundFlight.value
    }
    );
  }

  getAirports(search_tm: string) {
    return this.http.get<any[]>(`${environment.api_url}/api/airports`,
      { params: {
        search_term: search_tm
      }}
    );
  }

  getFilteredAirports(regionID: string) {
    return this.http.get<any[]>(`${environment.api_url}/api/filter-airports`,
      { params: {
        regionID: regionID
      }}
    )
  }

  getFlights(origin: string, destination: string, departureDate: string, arrivalDate: string) {
    // FUCK MYSQL AND IT'S NEEDY BULLSHIT
    const formatDate = (date: any) => {
    const d = new Date(date);
    return d.toISOString().split('T')[0];
  };
    return this.http.get<any[]>(`${environment.api_url}/api/available-flights`,
      { params: {
        user_origin: origin,
        user_destination: destination,
        departure_date: formatDate(departureDate),
        arrival_date: formatDate(arrivalDate)
      }}
    );
  }

  getTakenSeats(scheduleID: number) {
    return this.http.get<any[]>(`${environment.api_url}/api/taken-seats`,
      { params: {
        scheduleID: scheduleID
      }}
    );
  }
  
}
