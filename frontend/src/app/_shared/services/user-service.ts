import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../_environments/environment';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient) {}

  private username: string = ""
  private email: string = ""

  loadUserDetails() {
    return this.http.get(`${environment.api_url}/api/get-active-user`, { observe: 'response' })
  }

  setUsername(username: string) {
    this.username = username;
  }

  setEmail(email: string) {
    this.email = email;
  }
  
  getUsername() {
    return this.username;
  }
  
  getEmail() {
    return this.email;
  }

}
