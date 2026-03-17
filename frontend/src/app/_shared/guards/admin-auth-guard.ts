import { CanActivateFn } from '@angular/router';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth-service';
import { map } from 'rxjs';

export const adminAuthGuard: CanActivateFn = (childRoute, state) => {
  const authService = inject(AuthService);

  return authService.adminStatus$.pipe(
    map(isAdmin => {
      if (!isAdmin) {
        alert("This route is protected. Admin permissions required");
        return false;
      }

      return true;
    })
  )
};
