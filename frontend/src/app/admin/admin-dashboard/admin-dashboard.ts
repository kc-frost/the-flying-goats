import { Component, inject } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';
import { UserService } from '../../_shared/services/user-service';
import { AuthService } from '../../_shared/services/auth-service';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-admin-dashboard',
  imports: [RouterLink, RouterOutlet, AsyncPipe],
  templateUrl: './admin-dashboard.html',
  styleUrl: './admin-dashboard.css',
})
export class AdminDashboard {
  authService = inject(AuthService);
  userService = inject(UserService);
  isOutletActive = false;
}
