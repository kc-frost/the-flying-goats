import { Component, inject } from '@angular/core';
import { FormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { BASE_URL } from '../../../_environments/environment.dev';

@Component({
  selector: 'app-register',
  imports: [ReactiveFormsModule],
  templateUrl: './register.html',
  styleUrls: ['../user-auth.css', './register.css'],
})
export class Register {
  private formBuilder = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);

  newUserProfile = this.formBuilder.group({
    firstName: ['',
      [Validators.required]
    ],
    lastName: ['',
      [Validators.required]
    ],
    phoneNum: ['',
      [Validators.required,
        Validators.minLength(10),
        Validators.maxLength(10)
      ]
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
    this.http.post(`${BASE_URL}/api/register`, this.newUserProfile.value).subscribe((response) => {
      console.log(response);
    })
  }

  goToLogin() {
    this.router.navigate([{ outlets: 
      { dropdown: ['login']}}])
  }
}
