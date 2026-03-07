import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BASE_URL } from '../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  // ! == asserts that this property cannot be not null or undefined
  // (because it won't be, this will be instantiated in app.ts, but it doesn't know that)
  private authenticated!: boolean
  private admin: boolean = false

  constructor(private http: HttpClient) {}

  setAdminTrue() { localStorage.setItem('isAdmin', 'true'); }
  setAdminFalse() { localStorage.setItem('isAdmin', 'false')};
  isAdmin() { return localStorage.getItem('isAdmin') === 'true'; }

  setAuthenticatedTrue() { localStorage.setItem('authenticated', 'true'); }
  setAuthenticatedFalse() { localStorage.setItem('authenticated', 'false'); }
  isAuthenticated() { return localStorage.getItem('authenticated') === 'true'; }
 
  // Expected JSON response:
  // {"authenticated": true/false,
  //  "isAdmin": true/false,
  //  "username": current_user.username | "null"}
  getUserSummary() {
    return this.http.get(`${BASE_URL}/api/check-session`,
      {withCredentials: true}
    );
  }

  login(userProfile: any) {
    const _headers = {
      'Content-Type': 'application/json'
    };
    
    return this.http.post(`${BASE_URL}/api/login`,
      userProfile,
      { headers: _headers, observe: 'response'}
    );
  }
  
  register(newUserProfile: any) {
    const _headers = {
      'Content-Type': 'application/json'
    };

    return this.http.post(`${BASE_URL}/api/register`, newUserProfile,
      { headers: _headers, observe: 'response'}
    )
  }

  logout() {
    // can only do this here because login doesn't know whether it pushes through or not yet
    // here, we already know the user is logged in
    this.setAuthenticatedFalse()
    // this.setAdminFalse()
    return this.http.get(`${BASE_URL}/api/logout`,
      { observe: 'response'}
    )
  }
}
