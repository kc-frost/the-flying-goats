import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  // Holds current value and notifies anyone who .subscribes() to it if its value changes
  // Defaults to ""
  private currentEmail = new BehaviorSubject<string>("");
  private currentUsername = new BehaviorSubject<string>("");
  private currentProfilePicture = new BehaviorSubject<string>('');
  private currentRole = new BehaviorSubject<string>('');
  
  // Exposes the 'current' values of currentEmail and currentUsername
  // Subscribe to these (in a component) to automatically react when the value changes via async pipe
  currentEmail$ = this.currentEmail.asObservable();
  currentUsername$ = this.currentUsername.asObservable();
  currentProfilePicture$ = this.currentProfilePicture.asObservable()
  currentRole$ = this.currentRole.asObservable();

  setEmail(email: string): void {
    this.currentEmail.next(email);
  }

  // Use for one-time synchronous reads
  getEmail(): string {
    return this.currentEmail.getValue();
  }

  setUsername(username: string): void {
    this.currentUsername.next(username);
  }

  // Use for one-time synchronous reads
  getUsername(): string {
    return this.currentUsername.getValue();
  }

  set profilePicture(url: string) {
    this.currentProfilePicture.next(url);
  }

  get profilePicture() {
    return this.currentProfilePicture.getValue() == null ? '' : this.currentProfilePicture.getValue();
  }

  set role(role_value: string) {
    this.currentRole.next(role_value);
  }

  get role() {
    return this.currentRole.getValue();
  }
}
