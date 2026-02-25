import { Component } from '@angular/core';
import {FormControl, FormGroup, ReactiveFormsModule} from '@angular/forms';

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
}
