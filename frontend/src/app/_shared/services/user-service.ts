import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private email: string = "default@.gmail.com"
  private username: string = "default"
  
  setEmail(email: string) {
    this.email = email;
  }

  getEmail() {
    return this.email;
  }

  setUsername(username: string) {
    this.username = username;
  }

  getUsername() {
    return this.username;
  }
}
