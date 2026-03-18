import { HttpClient } from "@angular/common/http";
import { Component, inject, OnInit } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { Router, CanMatchFn } from "@angular/router";
import { CommonModule } from "@angular/common";
import { environment } from "../../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";

type InventoryRow = {
  itemID: number;
  quantity: number;
  isAvailable: boolean;
  itemName: string;
  type: "equipment" | "transportation" | "misc";
  itemDescription: string;
  isReadOnly: boolean;
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
  private cdr = inject(ChangeDetectorRef);

  items: InventoryRow[] = [];

  newItem: {
    itemID: number | null;
    itemName: string;
    quantity: number | null;
    type: "equipment" | "transportation" | "misc";
    itemDescription: string;
  } = {
    itemID: null,
    itemName: "",
    quantity: null,
    type: "equipment",
    itemDescription: ""
  };

  showAddModal = false;

  ngOnInit(): void {
    this.getInventory();
  }

  getInventory(): void {
    this.http
      .get<Omit<InventoryRow, "isReadOnly">[]>(`${environment.api_url}/admin/inventory`)
      .subscribe({
        next: (rows) => {
          this.items = rows.map((row) => ({
            ...row,
            isReadOnly: true
          }));
          this.cdr.detectChanges();
        },
        error: () => {
          alert("Error loading inventory.");
        }
      });
  }

  addModalShowButton(): void {
    this.showAddModal = true;
  }

  closeAddModal(): void {
    this.showAddModal = false;

    this.newItem = {
      itemID: null,
      itemName: "",
      quantity: null,
      type: "equipment",
      itemDescription: ""
    };
  }

  addItem(): void {
    if (this.newItem.itemID == null || this.newItem.quantity == null) {
      return;
    }

    this.http
      .post(`${environment.api_url}/admin/inventory/add`, {
        itemID: this.newItem.itemID,
        quantity: this.newItem.quantity,
        type: this.newItem.type,
        itemName: this.newItem.itemName,
        itemDescription: this.newItem.itemDescription
      })
      .subscribe({
        next: () => {
          this.getInventory();
          this.closeAddModal();
        },
        error: () => {
          alert("Error adding inventory item.");
        }
      });
  }

  deleteItem(itemID: number): void {
    this.http
      .post(`${environment.api_url}/admin/inventory/delete`, {
        itemID: itemID,
      })
      .subscribe({
        next: () => {
          this.getInventory();
        },
        error: () => {
          alert("Error deleting inventory item.");
        }
      });
  }

  closeModal(): void {
    this.router.navigate([{ outlets: { modal: null } }]);
  }

  enableEditing(item: InventoryRow): void {
    item.isReadOnly = false;
    this.cdr.detectChanges();
  }

  saveChanges(item: InventoryRow): void {
    this.http
      .post(`${environment.api_url}/admin/inventory/edit`, {
        itemID: item.itemID,
        quantity: item.quantity,
        type: item.type,
        itemName: item.itemName,
        itemDescription: item.itemDescription
      })
      .subscribe({
        next: () => {
          item.isReadOnly = true;
          this.cdr.detectChanges();
        },
        error: () => {
          alert("Error updating inventory item. Please try again.");
        }
      });
  }
}

export const inventoryModalRedirect: CanMatchFn = () => {
  const router = inject(Router);
  return router.createUrlTree([{ outlets: { modal: ["Inventory"] } }]);
};