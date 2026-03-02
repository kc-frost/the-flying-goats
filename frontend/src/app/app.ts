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
  host: {
    'document:click': 'onClick()'
  },
})

export class App {
  protected readonly title = signal('tfg');
  private router = inject(Router);
  isLoggedIn = inject(AuthService);

  defaultImg = "/header/profile-dropdown/profile-dropdown.svg";
  clickedImg = "/header/profile-dropdown/profile-dropdown-hover.svg";
  
  isExpanded: boolean = false;
  toggleExpanded() {
    this.isExpanded = !this.isExpanded;
    return this.isExpanded;
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
