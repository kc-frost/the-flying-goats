import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth-service';
import { map, take, switchMap } from 'rxjs';

export const userAuthGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);

  return authService.authReady$.pipe(
    // Wait for the check-session call to complete before evaluating
    take(1),

    // On completion, switch to the Observable that verifies user authentication
    switchMap(() => authService.authenticated$.pipe(
      map(isAuth => {
        if (!isAuth) {
          alert("This route is protected. Please login to access this route.")
          return false;
        }

        return true;
      })
    ))
  )
};
