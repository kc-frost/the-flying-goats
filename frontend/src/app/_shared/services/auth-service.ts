import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(private http: HttpClient) {}
  
  authenticated: boolean = false

  isAuthenticated() {
    return this.authenticated;
  }
  // returns blueprint for the request
  // does not actually send it yet
  checkSession() {
    return this.http.get(`${environment.api_url}/api/check-session`,
      {observe: 'response', withCredentials: true}
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
    return this.http.get(`${environment.api_url}/api/logout`,
      { observe: 'response'}
    )
  }

  setAuthenticatedTrue() {
    this.authenticated = true;
  }

  setAuthenticatedFalse() {
    this.authenticated = false;
  }
}
