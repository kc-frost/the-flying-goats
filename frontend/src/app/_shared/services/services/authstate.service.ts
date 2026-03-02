import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class AuthState {
  private isLoggedIn: boolean = false;

  toggleLoggedIn(): void {
    this.isLoggedIn = !this.isLoggedIn;
  }
}
