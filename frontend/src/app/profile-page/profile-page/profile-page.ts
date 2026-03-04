import { Component, inject } from '@angular/core';
import { UserService } from '../../_shared/services/user-service';

@Component({
  selector: 'app-profile-page',
  imports: [],
  templateUrl: './profile-page.html',
  styleUrl: './profile-page.css',
})
export class ProfilePage {
  private userService = inject(UserService);
  staticProfileImage = "/profile/static-profile-image.svg";
  username: string = "randomusernameasdasdasasd"
  email: string = "testEmail"


  // loadUser() {
  //   this.userService.loadUserDetails().subscribe({
  //     next: (res) => {
  //       var data = JSON.parse(JSON.stringify(res.body))

  //       this.userService.setUsername(data['username'])
  //       this.userService.setEmail(data['email'])

  //       this.username = this.userService.getUsername();
  //       this.email = this.userService.getEmail();
  //     }
  //   })
  // }

}
