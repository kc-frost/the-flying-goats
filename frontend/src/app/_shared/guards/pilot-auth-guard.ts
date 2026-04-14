import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth-service';
import { map, catchError, of } from 'rxjs';

export const pilotAuthGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);

  if (!authService.getAuthenticated()) {
    alert("Route requires authentication. Please login first.");
    return false;
  }

  return authService.isPilot().pipe(
    map((res: any) => {
      if (res.isPilot) {
        return true;
      }
      alert("Only pilots can access this page.");
      return false;
    }),
    catchError(() => {
      alert("Only pilots can access this page.");
      return of(false);
    })
  );
};
