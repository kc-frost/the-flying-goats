import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../_shared/services/auth-service';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule],
  templateUrl: './login.html',
  styleUrls: ['../user-auth.css','./login.css'],
})
export class Login {
  private formBuilder = inject(FormBuilder);
  private router = inject(Router);
  private authService = inject(AuthService);

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
    this.authService.login(this.userProfile.value).subscribe({
      next: (res) => {
        console.log(res)
        this.showProfileDropdown()
      },
      error: (err) => {
        console.log(err)
      }
    })
  }

  // When the Register button is pressed (see: login.html), 
  // programatically navigate to Register. Note the syntax.
  goToRegister() {
    this.router.navigate([{ outlets: 
      { dropdown: ['register'] } }], 
    {
      skipLocationChange: true
    });
  }

  showProfileDropdown() {
    this.router.navigate([{ outlets: 
      { dropdown: ['profile-page'] } }], 
    {
      skipLocationChange: true
    });
  }
}
