import { Component, inject } from '@angular/core';
import {FormControl, FormGroup, ReactiveFormsModule} from '@angular/forms';
import {Injectable} from "@angular/core";
import {CanMatchFn, Router} from "@angular/router";

@Component({
  selector: 'app-inventory',
  imports: [ReactiveFormsModule],
  templateUrl: './inventory.html',
  styleUrl: './inventory.css',
})
// For forms/entering info
export class Inventory {
  inventoryCount = new FormGroup({
    Item: new FormControl(''),
    ItemDescription: new FormControl('')
  });

// This, when clicked rerouts back to home.
// Basically the opposite/undoes the router that you have for login.
  constructor(private router: Router) {}

  closeModal() {
    this.router.navigate([{ outlets: { modal: null } }]);
  }
}

// This creates a sort of catcher/guard that makes any directs to inventory redirect to the modal I'ma make.
export const inventoryModalRedirect: CanMatchFn = () => {
  const router = inject(Router);
  // Redirects inventory to modal:inventory
  return router.createUrlTree([{outlets: {modal: ["Inventory"]}}])
}