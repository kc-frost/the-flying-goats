import { HttpClient } from '@angular/common/http';
import { Injectable, NgZone, inject } from '@angular/core';
import { environment } from '../../../_environments/environment';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AuthService } from './auth-service';
import { UserService } from './user-service';


@Injectable({
  providedIn: 'root',
})
export class AppNotifService {
  private http = inject(HttpClient);
  private snackbar = inject(MatSnackBar);
  private ngZone = inject(NgZone);
  private authService = inject(AuthService);
  private userService = inject(UserService);
  private alertedFlights = new Set<string>();
  private lastChecked = new Date();

  startAlerts() {
    this.ngZone.runOutsideAngular(() => {
      this.checkNewPilotAssignments(this.lastChecked);
      setInterval(() => {
        this.ngZone.run(() => {
          if (this.authService.getAuthenticated()) {
            this.checkUpcomingFlights();
            this.checkNewPilotAssignments(this.lastChecked);
            console.log(this.userService.role);
          }
          // check if a user is a pilot
          });
        }, 10 * 1000);
      });
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

  private checkNewPilotAssignments(lastChecked: Date) {
    // update lastChecked
    this.lastChecked = new Date();
    const pad = (n: number) => n.toString().padStart(2, '0');
    const d = lastChecked;
    const mysqlFormat = `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;

    this.http.get<{amount: number}>(`${environment.api_url}/api/new-assignments-amount`,
      { params: {
        since: mysqlFormat
      }}
    )
    .subscribe({
      next: (res) => {
        this.showToast(`You have ${res.amount} new assignments!`, "View here");
      }
    })
  }

  private showToast(message: string, action: string = "Dismiss") {
    this.snackbar.open(message, action, {
      verticalPosition: 'top',
      horizontalPosition: 'center',
    });
  }
}
