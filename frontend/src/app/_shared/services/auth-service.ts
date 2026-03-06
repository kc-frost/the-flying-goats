import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../_environments/environment';

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
  
  isAuthenticated() {
    return this.authenticated;
  }
 
  // Expected JSON response:
  // {"authenticated": true/false,
  //  "isAdmin": true/false,
  //  "username": current_user.username | "null"}
  getUserSummary() {
    return this.http.get(`${environment.api_url}/api/check-session`,
      {withCredentials: true}
    );
  }

  login(userProfile: any) {
    const _headers = {
      'Content-Type': 'application/json'
    };
    
    return this.http.post(`${environment.api_url}/api/login`,
      userProfile,
      { headers: _headers, observe: 'response'}
    );
  }
  
  register(newUserProfile: any) {
    const _headers = {
      'Content-Type': 'application/json'
    };

    return this.http.post(`${environment.api_url}/api/register`, newUserProfile,
      { headers: _headers, observe: 'response'}
    )
  }

  logout() {
    // can only do this here because login doesn't know whether it pushes through or not yet
    // here, we already know the user is logged in
    this.setAuthenticatedFalse()
    // this.setAdminFalse()
    return this.http.get(`${environment.api_url}/api/logout`,
      { observe: 'response'}
    )
  }

  setAuthenticatedTrue() { this.authenticated = true;}

  setAuthenticatedFalse() { this.authenticated = false;}
}
