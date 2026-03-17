import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AsyncPipe } from '@angular/common';
import { AuthService } from '../../_shared/services/auth-service';
import { UserService } from '../../_shared/services/user-service';

@Component({
  selector: 'app-dropdown-profile',
  // AsyncPipe subscribes to an Observable/Promise and emits the latest value emitted, and then is marked to be checked for changes
  imports: [AsyncPipe],
  templateUrl: './profile.html',
  styleUrl: './profile.css',
})
export class DropdownProfile {
  private router = inject(Router);
  private authService = inject(AuthService);
  userService = inject(UserService);

  staticProfileImage = "/profile/static-profile-image.svg";

  // TODO: Clear secondary outlet upon navigation
  goToProfilePage() {
    this.router.navigate(['/profile']);
  }

  backToLogin() {
    this.authService.logout().subscribe({
      next: () => {
        this.router.navigate(['']);
      }
    });
  }
}
