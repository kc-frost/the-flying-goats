import { Component, inject } from '@angular/core';
import { UserService } from '../../_shared/services/user-service';

@Component({
  selector: 'app-profile-page',
  imports: [],
  templateUrl: './profile-page.html',
  styleUrl: './profile-page.css',
})
export class ProfilePage {
  userService = inject(UserService);
  staticProfileImage = "/profile/static-profile-image.svg";
}