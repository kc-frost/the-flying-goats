import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink } from '@angular/router';
import { Login } from "./login/login";
import { Inventory } from './inventory/inventory';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, Login, Inventory],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('tfg');
}
