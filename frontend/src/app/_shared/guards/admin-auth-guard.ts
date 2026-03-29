import { CanActivateFn } from '@angular/router';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth-service';
import { take, switchMap, map } from 'rxjs';

export const adminAuthGuard: CanActivateFn = (childRoute, state) => {
  const authService = inject(AuthService);
  
  return authService.authReady$.pipe(
    // Wait for the check-session call to complete before evaluating
    take(1),

    // On completion, switch to the Observable that verifies adminStatus
    switchMap(() => authService.adminStatus$.pipe(
      map(isAdmin => {
        if (!isAdmin) {
          alert("This route is protected. Admin permissions required.");
          return false;
        }

        return true;
      })
    ))
  )
  
};
