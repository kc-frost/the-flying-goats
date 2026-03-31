import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth-service';
import { map, catchError, of } from 'rxjs';

export const pilotAuthGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);

  if (!authService.isAuthenticated()) {
    alert("Route requires authentication. Please login first.");
    return false;
  }

  return authService.isPilot().pipe(
    map(() => true),
    catchError(() => {
      alert("Only pilots can access this page.");
      return of(false);
    })
  );
};