import { Component, inject } from '@angular/core';
import { FormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-register',
  imports: [ReactiveFormsModule],
  templateUrl: './register.html',
  styleUrls: ['../user-auth.css', './register.css'],
})
export class Register {
  private formBuilder = inject(FormBuilder);
  private router = inject(Router);

  newUserProfile = this.formBuilder.group({
    firstName: ['',
      [Validators.required]
    ],
    lastName: ['',
      [Validators.required]
    ],
    username: ['',
      [Validators.required]
    ],
    email: ['',
      [Validators.required, Validators.email]
    ],
    password: ['',
      [Validators.required, Validators.minLength(8)]
    ],
  })

  onSubmit() {

  }

  goToLogin() {
    this.router.navigate([{ outlets: 
      { dropdown: ['login']}}])
  }
}
