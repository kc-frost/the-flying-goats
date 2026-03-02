import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../_environments/environment';
import { ReactiveFormsModule } from '@angular/forms';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(private http: HttpClient) {}
  
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

  // TODO
  logout() {

  }
}
