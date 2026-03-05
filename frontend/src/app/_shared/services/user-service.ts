import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient) {}

  private username: string = ""

  loadUserDetails(user: any) {
    this.setUsername(user.username);
  }

  setUsername(username: string) {
    this.username = username;
  }

  getUsername() {
    return this.username;
  }

}
