import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink } from '@angular/router';
import { Login } from "./login/login";
import { Inventory } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, Login, Inventory, BookFlight],
  templateUrl: './app.html',
  styleUrl: './app.css',
  host: {
    'document:click': 'onClick()'
  },
})

export class App {
  protected readonly title = signal('tfg');

  defaultImg = "/header/profile-dropdown/profile-dropdown.svg";
  clickedImg = "/header/profile-dropdown/profile-dropdown-hover.svg";
  
  isExpanded: boolean = false;
  toggleExpanded() {
    this.isExpanded = !this.isExpanded;
    return this.isExpanded;
  }

  onClick() {
    console.log("The window was clicked");
  }
}
