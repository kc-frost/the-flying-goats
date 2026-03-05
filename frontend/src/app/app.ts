import { Component, signal, inject } from '@angular/core';
import { RouterOutlet, RouterLink, Router } from '@angular/router';
import { AuthService } from './_shared/services/auth-service';
import { Inventory } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, Inventory, BookFlight],
  templateUrl: './app.html',
  styleUrl: './app.css',
})

export class App {
  protected readonly title = signal('tfg');
  private router = inject(Router);
  authService = inject(AuthService);

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
    this.authService.checkSession().subscribe({
      next: (res) => {
        if (res.ok) {
          this.navigateToProfile();
        } else {
          this.navigateToLogin();
        }
      },
      error: (res) => {
        console.log(res);
        this.navigateToLogin();
      }
    })
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
