import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../_shared/services/auth-service';
import { UserService } from '../../_shared/services/user-service';

@Component({
  selector: 'app-dropdown-profile',
  imports: [],
  templateUrl: './profile.html',
  styleUrl: './profile.css',
})
export class DropdownProfile {
  private router = inject(Router);
  private authService = inject(AuthService);
  userService = inject(UserService);

  staticProfileImage = "/profile/static-profile-image.svg";

  goToProfilePage() {
    this.router.navigate(['/profile']);
  }

  backToLogin() {
    this.authService.logout().subscribe({
      next: () => {
        localStorage.clear()
        this.router.navigate(['']);

        // commented but not deleted
        // for preservation of database, i'd rather we have a little jank to our dropdown
        // than prioritize visuals
        // ideally, will fix it

        // this.router.navigate([{ outlets: {
        //   dropdown: ['login']
        // }}], { skipLocationChange: true});
      }
    });
  }
}
