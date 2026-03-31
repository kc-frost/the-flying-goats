import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../_environments/environment';
import { MatSnackBar } from '@angular/material/snack-bar';


@Injectable({
  providedIn: 'root',
})
export class AppNotifService {
  private http = inject(HttpClient);
  private snackbar = inject(MatSnackBar);
  private alertedFlights = new Set<string>();

  startAlerts() {
    this.checkUpcomingFlights();
    setInterval(() => this.checkUpcomingFlights(), 120 * 1000 );
  }

  private checkUpcomingFlights() {
    this.http.get<any[]>(`${environment.api_url}/api/upcoming-flights`)
    .subscribe({
      next: (flights) => {
        const now = new Date();

        flights.forEach(flight => {
          const depart = new Date(flight.liftOff);
          const diff = (depart.getTime() - now.getTime()) / 60000; // in minutes

          const time = depart.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
          // 30 min alert 
          if (diff <= 30 && diff > 10 && !this.alertedFlights.has(`${flight.bookingNumber}-${flight.leg}-30`)) {
            this.showToast(`Your ${flight.leg} flight to ${flight.origin} departs at ${time} in less than 30 minutes!`);
            this.alertedFlights.add(`${flight.bookingNumber}-${flight.leg}-30`);
          }

          // 10 min alert
          if (diff <= 10 && !this.alertedFlights.has(`${flight.bookingNumber}-${flight.leg}-10`)) {
            this.showToast(`Your ${flight.leg} flight to ${flight.origin} departs at ${time} in less than 10 minutes!`);
            this.alertedFlights.add(`${flight.bookingNumber}-${flight.leg}-10`);
          }
          });
        }}
      )
  }

  private showToast(message: string) {
    this.snackbar.open(message, 'Dismiss', {
      verticalPosition: 'top',
      horizontalPosition: 'center',
    });
  }
}
