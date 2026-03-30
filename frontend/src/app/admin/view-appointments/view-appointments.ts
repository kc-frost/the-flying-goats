import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { ChangeDetectorRef, Component, OnInit, inject } from "@angular/core";
import { environment } from "../../../_environments/environment";
import { DatePipe } from "@angular/common";

type ReservationRow = {
  bookingNumber: number;
  userID: number;
  username: string;
  departSeat: string;
  returnSeat: string;
  seatNumber: number;
  departClass: string;
  returnClass: string;
  bookingDate: string;
  departIATA: string;
  returnIATA: string;
  departLift: string;
  returnLift: string;
  departOrigin: string;
  returnOrigin: string;
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