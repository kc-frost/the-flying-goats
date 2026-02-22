import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  private formBuilder = inject(FormBuilder);

  // This is a quicker way to instantiate a FormGroup
  // Each item in the Group is a FormControl (look at login.html and notice the 'formControlName' property)
  userProfile = this.formBuilder.group({
    email: ['',
      Validators.required,
      Validators.email],
    password: ['',
      Validators.required,
      Validators.minLength(8),
    ]
  });
}
