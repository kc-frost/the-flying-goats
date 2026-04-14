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

type PlaneRow = {
  ICAO: string;
  planeStatus: string;
  isReadOnly: boolean;
  oldICAO?: string;
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
  planes: PlaneRow[] = [];

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

  newPlane: {
    ICAO: string;
    planeStatus: string;
    } = {
      ICAO: "",
      planeStatus: ""
    };

  showAddModal = false;
  showPlaneModal = false;

  ngOnInit(): void {
    this.getInventory();
    this.getPlanes();
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

getPlanes(): void {
  this.http
    .get<Omit<PlaneRow, "isReadOnly">[]>(`${environment.api_url}/admin/planes`)
    .subscribe({
      next: (rows) => {
        this.planes = rows.map((row) => ({
          ...row,
          isReadOnly: true
        }));
        this.cdr.detectChanges();
      },
      error: () => {
        alert("Error loading planes.");
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

  togglePlaneModal(): void {
  this.showPlaneModal = !this.showPlaneModal;
}

closePlaneModal(): void {
  this.showPlaneModal = false;
  this.showCreatePlaneForm = false;
  this.newPlane = {
    ICAO: "",
    planeStatus: ""
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

  addPlane(): void {
    if (!this.newPlane.ICAO) {
      return;
    }

    this.http
      .post(`${environment.api_url}/admin/planes/add`, {
        ICAO: this.newPlane.ICAO
      })
      .subscribe({
        next: () => {
          this.getPlanes();
          this.closePlaneModal();
        },
        error: () => {
          alert("Error adding plane.");
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

  deletePlane(ICAO: string): void {
    this.http
      .post(`${environment.api_url}/admin/planes/delete`, {
        ICAO: ICAO
      })
      .subscribe({
        next: () => {
          this.getPlanes();
        },
        error: () => {
          alert("Error deleting plane.");
        }
      });
  }

  updatePlaneICAO(ICAO: string, newICAO: string): void {
    this.http
      .post(`${environment.api_url}/admin/planes/update-ICAO`, {
        ICAO: newICAO,
        old_ICAO: ICAO
      })
      .subscribe({
        next: () => {
          this.getPlanes();
        },
        error: () => {
          alert("Error updating plane ICAO.");
        }
      });
  }


  closeModal(): void {
    this.router.navigate(['dashboard', { outlets: { modal: null } }]);
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

  showCreatePlaneForm = false;
  openCreatePlaneForm(): void {
    this.showCreatePlaneForm = true;
  }

  closeCreatePlaneForm(): void {
    this.showCreatePlaneForm = false;
    this.newPlane = {
      ICAO: "",
      planeStatus: ""
    };
  }

  enablePlaneEditing(plane: PlaneRow): void {
  plane.isReadOnly = false;
  plane.oldICAO = plane.ICAO;
  this.cdr.detectChanges();
}

savePlaneChanges(plane: PlaneRow): void {
  this.http
    .post(`${environment.api_url}/admin/planes/update-ICAO`, {
      ICAO: plane.ICAO,
      old_ICAO: plane.oldICAO
    })
    .subscribe({
      next: () => {
        plane.isReadOnly = true;
        plane.oldICAO = undefined;
        this.getPlanes();
        this.cdr.detectChanges();
      },
      error: () => {
        plane.ICAO = plane.oldICAO ?? plane.ICAO;
        plane.isReadOnly = true;
        this.cdr.detectChanges();
        alert("Error updating plane ICAO.");
      }
    });
}

}

export const inventoryModalRedirect: CanMatchFn = () => {
  const router = inject(Router);
  return router.createUrlTree([{ outlets: { modal: ["Inventory"] } }]);
};
