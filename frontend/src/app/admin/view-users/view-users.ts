import { CommonModule } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { Component, OnInit, inject } from "@angular/core";
import { environment } from "../../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { RouterLink } from "@angular/router";

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
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: "./view-users.html",
  styleUrls: ["./view-users.css"],
})
export class ViewUsers implements OnInit {
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef);

  users: UserInfo[] = [];
  searchTerm: string = "";

  ngOnInit(): void {
    this.getUsers();
  }

  getUsers(search: string = ""): void {
    const trimmedSearch = search.trim();
    const url = trimmedSearch
      ? // Chekcs if the search is empty after the trim, if yeah it'll just fetch all users, if not it'll search by whatevers in the search bar
        `${environment.api_url}/admin/search-users?search=${encodeURIComponent(
          trimmedSearch
        )}`
      : `${environment.api_url}/admin/users`;
    // For some reason (from my experience) you have to press enter twice for the search to work, no idea why but it still works, will look into later.
    this.http.get<UserInfo[]>(url).subscribe({
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

  onSearch(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.searchTerm = value;
    this.getUsers(this.searchTerm);
  }

  clearSearch(): void {
    this.searchTerm = "";
    this.getUsers();
  }

  deleteUser(user: UserInfo): void {
    const confirmed = window.confirm(`Delete user ${user.email}?`);
    if (!confirmed) {
      return;
    }

    this.http
      .post(`${environment.api_url}/admin/users/delete`, {
        userID: user.userID,
      })
      .subscribe({
        next: () => {
          this.getUsers(this.searchTerm);
        },
        error: (err) => {
          console.error("error deleting user:", err);
          let message = "YOU messed up somehow.";
          if (err.error && err.error.message) {
            message = err.error.message;
          }
          alert(message);
        },
      });
  }
}
