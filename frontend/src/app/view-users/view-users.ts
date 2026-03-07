import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { Component, OnInit, inject } from "@angular/core";
import { BASE_URL } from "../../_environments/environment";

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

  users: UserInfo[] = [];

  ngOnInit(): void {
    this.getUsers();
  }

  getUsers(): void {
    this.http.get<UserInfo[]>(`${BASE_URL}/api/users`).subscribe({
      next: (data) => {
}