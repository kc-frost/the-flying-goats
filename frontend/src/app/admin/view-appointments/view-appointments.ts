import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { ChangeDetectorRef, Component, OnInit, inject } from "@angular/core";
import { environment } from "../../../_environments/environment";

// Changed cause, you guessed it, DB changes. New datatypes, general attributes, and new names
type ReservationRow = {
  bookingNumber: number;
  userID: number;
  username: string;
  departSeatNumber: string;
  returnSeatNumber: string;
  reservationDate: string;
  departFlight: string;
  returnFlight: string;
  departLiftOffDate: string;
  departArrivingDate: string;
  returnLiftOffDate: string;
  returnArrivingDate: string;
  departOrigin: string;
  departDestination: string;
  returnOrigin: string;
  returnDestination: string;
};

@Component({
  selector: "app-view-appointments",
  standalone: true,
  imports: [CommonModule,],
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
  const url = `${environment.api_url}/admin/reservations`;
  console.log("calling reservations url:", url);

  this.http.get(url).subscribe({
    next: (data: any) => {
      console.log("raw reservations response:", data);
      console.log("is array?", Array.isArray(data));
      console.log("reservations length:", Array.isArray(data) ? data.length : "not array");
      console.log("first reservation:", Array.isArray(data) && data.length > 0 ? data[0] : null);

      this.reservations = Array.isArray(data) ? data : [];
      this.cdr.detectChanges();
    },
    error: (err) => {
      console.error("error loading reservations:", err);
    },
  });
}
}
