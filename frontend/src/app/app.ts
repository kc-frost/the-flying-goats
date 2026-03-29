import { Component, signal, inject } from '@angular/core';
import { RouterOutlet, RouterLink, Router } from '@angular/router';
import { AuthService } from './_shared/services/auth-service';
import { UserService } from './_shared/services/user-service';
import { OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink],
  templateUrl: './app.html',
  styleUrl: './app.css',
})

export class App implements OnInit {
  protected readonly title = signal('tfg');
  private router = inject(Router);
  authService = inject(AuthService);
  userService = inject(UserService);

  ngOnInit() {
    this.authService.setCurrentAfterRefresh().subscribe({
      error: (err) => {
        console.log("CHECK-SESSION FAILED:", err);
      }
    });
  }

  defaultImg = "/header/profile-dropdown/profile-dropdown.svg";
  clickedImg = "/header/profile-dropdown/profile-dropdown-hover.svg";
  
  isExpanded: boolean = false;
  toggleExpanded() {
    this.isExpanded = !this.isExpanded;
    return this.isExpanded;
  }

  // If a session exists, clicking on the profile picture should also show ProfileDropdown
  // Otherwise (including errors), show Login
  handleProfileClick() {
    if (this.authService.getAuthenticated()) {
      this.navigateToProfile()
    } else {
      this.navigateToLogin();
    }
  }

  navigateToLogin() {
    this.router.navigate([{ outlets: 
      { dropdown: ['login']}}],
      {
        skipLocationChange: true
      }
    )
  }

  navigateToProfile() {
    this.router.navigate([{ outlets: 
      { dropdown: ['profile-page'] } }], 
    {
      skipLocationChange: true
    });
  }
}
