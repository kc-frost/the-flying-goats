import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink } from '@angular/router';
import { Login } from "./login/login";
import { Inventory } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, Login, Inventory, BookFlight],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('tfg');
}
