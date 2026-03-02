import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-profile-dropdown',
  imports: [],
  templateUrl: './profile-dropdown.html',
  styleUrl: './profile-dropdown.css',
})
export class ProfileDropdown {
  private router = inject(Router);

  staticProfileImage = "/profile/static-profile-image.svg";

  goToProfilePage() {
    this.router.navigate(['/profile']
    );
  }
}
