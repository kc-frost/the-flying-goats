import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { Component, OnInit, inject } from "@angular/core";
import { environment } from "../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";

type UserInfo = {
  userID: number;
  email: string;
  registerLengthDays: number;
  totalReservations: number;
  totalPastReservations: number;
  totalFutureReservations: number;
};

@Component({
  selector: "app-view-users",
  standalone: true,
  imports: [CommonModule],
  templateUrl: "./view-users.html",
  styleUrls: ["./view-users.css"],
})
export class ViewUsers implements OnInit {
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef);

  users: UserInfo[] = [];

  ngOnInit(): void {
    this.getUsers();
  }

  getUsers(): void {
    this.http
          .get<UserInfo[]>(`${environment.api_url}/api/users`)
          .subscribe({
            next: (data) => {
              console.log("users received:", data);
              this.users = data;
              this.cdr.detectChanges();
            },
            error: (err) => {
              console.error("error loading users:", err);
            },
          });
      }
  }