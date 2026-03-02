import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private isLoggedIn: boolean = false;
  http = inject(HttpClient);
  
  // returns blueprint for the request
  // does not actually send it yet
  checkSession() {
    return this.http.get(`${environment.api_url}/api/check-session`,
      {observe: 'response', withCredentials: true}
    );
  }

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
