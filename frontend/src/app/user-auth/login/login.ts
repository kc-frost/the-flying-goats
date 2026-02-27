import { HttpClient } from '@angular/common/http';
import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { BASE_URL } from '../../../_environments/environment.dev';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule],
  templateUrl: './login.html',
  styleUrls: ['../user-auth.css','./login.css'],
})
export class Login {
  private formBuilder = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);

  // This is a quicker way to instantiate a FormGroup
  // Each item in the Group is a FormControl (look at login.html and notice the 'formControlName' property)
  // VALIDATORS GO IN ARRAYS
  userProfile = this.formBuilder.group({
    email: ['', 
      [Validators.required, Validators.email]],
    password: ['', 
      [Validators.required, Validators.minLength(8)],
    ]
  });

  // Sends a POST request with the body being the value of the form userProfile 
  onSubmit() {
    this.http.post(`${BASE_URL}/api/login`,
      this.userProfile.value).subscribe((response) => {
      console.log(response);
    })
  };

  // When the Register button is pressed (see: login.html), 
  // programatically navigate to Register. Note the syntax.
  goToRegister() {
    this.router.navigate([{ outlets: 
      { dropdown: ['register'] } }]);
  }
}
