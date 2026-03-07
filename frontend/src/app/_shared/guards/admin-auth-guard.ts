import { CanActivateFn } from '@angular/router';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth-service';

export const adminAuthGuard: CanActivateFn = (childRoute, state) => {
  const authService = inject(AuthService);
  if (!authService.isAdmin()) {
    alert("Route requires admin permissions.");
    return false;
  } else {
    return true;
  }
};
