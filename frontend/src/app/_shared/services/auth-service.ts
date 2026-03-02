import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private isLoggedIn: boolean = false;

  getLoggedIn(): boolean {
    return this.isLoggedIn;
  }

  // This is to make it more predictable instead of toggling
  setTrue(): void {
    this.isLoggedIn = true;
  }

  setFalse(): void {
    this.isLoggedIn = false;
  }
}
