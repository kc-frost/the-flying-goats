import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth-service';
import { map } from 'rxjs';

export const userAuthGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  
  return authService.authenticated$.pipe(
    map(isAuth => {
      if (!isAuth) {
        alert("This route is protected. Requires a logged-in user.");
        return false;
      }

      return true;
    })
  )
};
