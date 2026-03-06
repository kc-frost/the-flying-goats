import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../_shared/services/auth-service';
import { UserService } from '../../_shared/services/user-service';

@Component({
  selector: 'app-profile-dropdown',
  imports: [],
  templateUrl: './profile-dropdown.html',
  styleUrl: './profile-dropdown.css',
})
export class ProfileDropdown {
  private router = inject(Router);
  private authService = inject(AuthService);
  userService = inject(UserService);

  staticProfileImage = "/profile/static-profile-image.svg";

  goToProfilePage() {
    this.router.navigate(['/profile']);
  }

  backToLogin() {
    this.authService.logout().subscribe();
    localStorage.clear()
    this.router.navigate([{ outlets: {
      dropdown: ['login']
    }}], { skipLocationChange: true});
  }
}
