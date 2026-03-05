import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private email: string = "none_set"

  // loadUserDetails(data: any) {
  //   var userData = JSON.parse(JSON.stringify(data));
  //   this.setUsername(userData['username']);
  // }

  setEmail(email: string) {
    this.email = email;
  }

  getEmail() {
    return this.email;
  }

}
