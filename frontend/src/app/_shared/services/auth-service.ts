import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../_environments/environment';
import { BehaviorSubject, Observable, ReplaySubject, tap } from 'rxjs';
import { UserService } from './user-service';
import { FormGroup } from '@angular/forms';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(private http: HttpClient, private userService: UserService) {}
  
  // Holds current value and notifies anyone who .subscribes() to it if its value changes
  // Defaults to false for both
  private authenticated = new BehaviorSubject<boolean>(false);
  private adminStatus = new BehaviorSubject<boolean>(false);

  // Used by the guards to know when the user data has been loaded in
  private authReady = new ReplaySubject<boolean>(1);
  
  // Exposes the 'current' values of currentEmail and currentUsername
  // Subscribe to these (in a component) to automatically react when the value changes via async pipe
  authenticated$ = this.authenticated.asObservable();
  adminStatus$ = this.adminStatus.asObservable();
  authReady$ = this.authReady.asObservable();
  
  setCurrentAfterRefresh(): Observable<HttpResponse<any>> {
    return this.http.get(`${environment.api_url}/api/check-session`,
      { observe: 'response' }
    ).pipe(
      // tap is an rxjs that reacts (not transforms) to the received response from a successful api call
      tap((res) => {
        // Mark user as logged-in
        this.setAuthenticatedTrue();

        if (res.body.is_admin) {
          this.setAdminTrue()
        }

        // Save user details for app-wide use
        this.userService.setEmail(res.body.email);
        this.userService.setUsername(res.body.username);

        // Notify the rest of the app (guards) that the check-sesssion call completed
        this.authReady.next(true);
      })
    )
  }

  setAuthenticatedTrue(): void {
    this.authenticated.next(true);
  }

  // Use for one-time synchronous reads
  getAuthenticated(): boolean {
    return this.authenticated.getValue();
  }

  setAdminTrue(): void {
    this.adminStatus.next(true);
  }

  // Use for one-time synchronous reads
  getAdminStatus(): boolean {
    return this.adminStatus.getValue();
  }

  reset(): void {
    this.authenticated.next(false);
    this.adminStatus.next(false);
  }

  login(userProfile: FormGroup): Observable<HttpResponse<any>> {
    return this.http.post(`${environment.api_url}/api/login`, 
      userProfile.value, 
      { observe: 'response'}
    
      // Before being subscribed to (.subscribe()), set the currentUser's email
    ).pipe(
      tap((res: any) => {
        this.userService.setEmail(userProfile.get('email')!.value);
        this.userService.setUsername(res.body.username);
        this.userService.role = res.body.role;

        this.setAuthenticatedTrue();
        if (res.body.is_admin) {
          this.setAdminTrue()
        }

        // Notify the rest of the app (guards) that the check-sesssion call completed
        this.authReady.next(true);
      })
    )
  }
  
  register(newUserProfile: FormGroup): Observable<HttpResponse<any>> {
    const _headers = {
      'Content-Type': 'application/json'
    };

    return this.http.post(`${environment.api_url}/api/register`, newUserProfile.value,
      { headers: _headers, observe: 'response'}
    )
  }

  logout(): Observable<HttpResponse<any>> {
    this.reset();

    return this.http.get(`${environment.api_url}/api/logout`,
      { observe: 'response'}
    )
  }

  // Heard on the "can only do this here"
  isPilot() {
  return this.http.get(`${environment.api_url}/api/check-pilot`, {
    withCredentials: true
  });
}
}
