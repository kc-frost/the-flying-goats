import { HttpClient } from "@angular/common/http";
import { Component, inject } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { Router, CanMatchFn } from "@angular/router";
import { CommonModule } from "@angular/common";
import { BASE_URL } from "../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";

type InventoryRow = {
  itemID: number;
  quantity: number;
  isAvailable: boolean;
  equipmentName: string;
  type: "equipment" | "transportation" | "Misc";
  equipmentID: number | null;
  transportationID: number | null;
  transportName?: string | null;
};

@Component({
  selector: "app-inventory",
  imports: [ReactiveFormsModule, FormsModule, CommonModule],
  templateUrl: "./inventory.html",
  styleUrls: ["./inventory.css"],
})
export class Inventory {
  private http = inject(HttpClient);
  private router = inject(Router);
  // This forces immediate change detection after we send a get request (later when getInventory is claled)
  private cdr = inject(ChangeDetectorRef);

  // Row that inventory items get added to that we cycle through in html with ngFor
  items: InventoryRow[] = [];

  // Object that gets sent to backend when additem is called
  newItem: {
    itemID: number | null;
    equipmentName: string;
    quantity: number | null;
    type: "equipment" | "transportation";
    equipmentID: number | null;
    transportationID: number | null;
  } = {
    // default values for newItem, these get reset whenever add modal is closed/displayed when opened freshly
    itemID: null,
    equipmentName: "",
    quantity: null,
    type: "equipment",
    equipmentID: null,
    transportationID: null,
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
      equipmentName: "",
      quantity: null,
      type: "equipment",
      equipmentID: null,
      transportationID: null,
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
        equipmentID: this.newItem.equipmentID,
        transportationID: this.newItem.transportationID,
        equipmentName: this.newItem.equipmentName,
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
}

// redirect function for inventory modal
export const inventoryModalRedirect: CanMatchFn = () => {
  const router = inject(Router);
  return router.createUrlTree([{ outlets: { modal: ["Inventory"] } }]);
};
