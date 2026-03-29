import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { ChangeDetectorRef, Component, OnInit, inject } from "@angular/core";
import { environment } from "../../../_environments/environment";

type ReservationRow = {
  bookingNumber: number;
  userID: number;
  username: string;
  departSeat: string;
  returnSeat: string;
  seatNumber: number;
  seatClass: string;
  reservationDate: string;
  departFlightID: string;
  returnFlightID: string;
  liftOffDate: string;
  arrivingDate: string;
  origin: string;
  destination: string;
};

@Component({
  selector: "app-view-appointments",
  standalone: true,
  imports: [CommonModule],
  templateUrl: "./view-appointments.html",
  styleUrls: ["./view-appointments.css"],
})
export class ViewAppointments implements OnInit {
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef);
  reservations: ReservationRow[] = [];
  
  ngOnInit(): void {
    this.getReservations();
  }
  getReservations(): void {
    this.http
      .get<ReservationRow[]>(`${environment.api_url}/admin/reservations`)
      .subscribe({
        next: (data) => {
          console.log("reservations received:", data);
          this.reservations = data;
          this.cdr.detectChanges();
        },
        error: (err) => {
          console.error("error loading reservations:", err);
        },
      });
  }
}