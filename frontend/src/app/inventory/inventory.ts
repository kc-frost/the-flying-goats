import { Component, inject } from '@angular/core';
import {FormControl, FormGroup, ReactiveFormsModule} from '@angular/forms';
import {CanMatchFn, Router} from "@angular/router";
import {CommonModule} from '@angular/common';

@Component({
  selector: 'app-inventory',
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './inventory.html',
  styleUrl: './inventory.css',
})
// For forms/entering info
export class Inventory {
  // Grouping the items into an array to paste in more cards
  // I wanna catch the data into objects OR arrays, depends on how I feel later
  // Either way, this is test data and should look like this when adding data later
  // Only a test data
  items = [
  {
    id: 1,
    name: 'test',
    total: 100,
    reserved: 30,
    available: 70
  },
  {
    id: 2,
    name: 'TA agents',
    total: 50,
    reserved: 10,
    available: 40
  },
    {
    id: 3,
    name: 'Planes',
    total: 10,
    reserved: 10,
    available: 5
  }
];

// temp delete item logic until I get the db connected
// just for showcasing, will def change when I get data later
deleteItem(index: number) {
  this.items.splice(index, 1);
}

addItem() {
  const newItem = {
    id: this.items.length + 1,
    name: 'New Item',
    total: 0,
    reserved: 0,
    available: 0
  };

  this.items.push(newItem);
}

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

