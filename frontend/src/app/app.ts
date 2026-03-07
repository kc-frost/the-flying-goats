import { Component, signal, inject, ChangeDetectorRef } from '@angular/core';
import { RouterOutlet, RouterLink, Router } from '@angular/router';
import { AuthService } from './_shared/services/auth-service';
import { Inventory } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';
import { UserService } from './_shared/services/user-service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, Inventory, BookFlight],
  templateUrl: './app.html',
  styleUrl: './app.css',
})

export class App {
  protected readonly title = signal('tfg');
  private router = inject(Router);
  private authService = inject(AuthService);
  private userService = inject(UserService);
  private cdr = inject(ChangeDetectorRef);

  // check on instantiation of App if user is logged in
  // to let angular know even when the page is refreshed
  constructor() {
    this.authService.getUserSummary().subscribe({
      next: (res) => {
        // this basically obtains username and email
        // fix after sprint 3
        const savedEmail = localStorage.getItem('email');
        var savedUsername = localStorage.getItem('username');

        // update 'username' if it's either nonexistent or doesn't match (a different user is logged in)
        var newUsername = JSON.parse(JSON.stringify(res))['username']
        if (savedUsername == null || savedUsername != newUsername) {
          localStorage.setItem('username', newUsername)
        }

        if (savedEmail) {
          this.userService.setEmail(savedEmail);
          this.cdr.detectChanges();
        }

        this.authService.setAuthenticatedTrue();
        console.log(res);
      },
      error: (err) => {
        console.log("App constructor:", err);
        this.authService.setAuthenticatedFalse();
      }
    })
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
    if (this.authService.isAuthenticated()) {
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
