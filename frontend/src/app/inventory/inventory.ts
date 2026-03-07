import { HttpClient } from "@angular/common/http";
import { Component, inject } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { Router, CanMatchFn } from "@angular/router";
import { CommonModule } from "@angular/common";
import { BASE_URL } from "../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";
import { OnInit } from "@angular/core";

type InventoryRow = {
  itemID: number;
  quantity: number;
  isAvailable: boolean;
  itemName: string;
  type: "equipment" | "transportation" | "misc";
  itemDescription: string;
};

@Component({
  selector: "app-inventory",
  standalone: true,
  imports: [ReactiveFormsModule, FormsModule, CommonModule],
  templateUrl: "./inventory.html",
  styleUrls: ["./inventory.css"],
})
export class Inventory implements OnInit {
  private http = inject(HttpClient);
  private router = inject(Router);
  // This forces immediate change detection after we send a get request (later when getInventory is claled)
  private cdr = inject(ChangeDetectorRef);

  // Row that inventory items get added to that we cycle through in html with ngFor
  items: InventoryRow[] = [];

  // Object that gets sent to backend when additem is called
  newItem: {
    itemID: number | null;
    itemName: string;
    quantity: number | null;
    type: "equipment" | "transportation" | "misc";
    itemDescription: string;
  } = {
    // default values for newItem, these get reset whenever add modal is closed/displayed when opened freshly
    itemID: null,
    itemName: "",
    quantity: null,
    type: "equipment",
    itemDescription: ""
  };

  // When the component is initialized, get inventory from backend and populate items with it
  ngOnInit() {
    this.getInventory();
  }

  // Literally read the name
  getInventory() {
    // get request to backend API ENDPOINTTTTT
    this.http
      .get<InventoryRow[]>(`${BASE_URL}/api/inventory`)
      .subscribe((rows) => {
        this.items = rows;
        // What I was talking about before on updating inventory, needed cause I had a weird bug appear and never go away for some reason
        this.cdr.detectChanges();
      });
  }

  // lil boolean to get toggled to show/hide add item modal
  showAddModal = false;

  addModalShowButton() {
    this.showAddModal = true;
  }

  // This is the part that resets add modal parameters back to default ones
  closeAddModal() {
    this.showAddModal = false;

    this.newItem = {
      itemID: null,
      itemName: "",
      quantity: null,
      type: "equipment",
      itemDescription: ""
    };
  }

  addItem() {
    // if itemID or no quantity is there, don't send shit back
    if (this.newItem.itemID == null || this.newItem.quantity == null) {
      return;
    }
    // post request to backend
    this.http
      .post(`${BASE_URL}/api/inventory/add`, {
        itemID: this.newItem.itemID,
        quantity: this.newItem.quantity,
        type: this.newItem.type,
        itemName: this.newItem.itemName,
        itemDescription: this.newItem.itemDescription
      })
      .subscribe(() => {
        this.getInventory();
        this.closeAddModal();
      });
  }

  deleteItem(itemID: number) {
    // post request to APIIIIIII
    this.http
      .post(`${BASE_URL}/api/inventory/delete`, {
        itemID: itemID,
      })
      .subscribe(() => {
        this.getInventory();
      });
  }

  closeModal() {
    this.router.navigate([{ outlets: { modal: null } }]);
  }

  isReadOnly = true;
  enableEditing(itemID: number) {
    this.http.post(`${BASE_URL}/api/inventory/edit`, {
       itemID: itemID 
      }).subscribe(() => {
        this.isReadOnly = !this.isReadOnly;
    })
  }
}

// redirect function for inventory modal
export const inventoryModalRedirect: CanMatchFn = () => {
  const router = inject(Router);
  return router.createUrlTree([{ outlets: { modal: ["Inventory"] } }]);
};