import { Routes } from '@angular/router';

import { Home } from './home/home';
import { Login } from './auth-dropdown/login/login';
import { Register } from './auth-dropdown/register/register';
import { DropdownProfile } from './auth-dropdown/profile/profile';
import { ProfilePage } from './profile-page/profile-page';
import { Inventory } from './admin/inventory/inventory';
import { BookFlight } from './book-flight/book-flight';
import { userAuthGuard } from './_shared/guards/user-auth-guard';
import { adminAuthGuard } from './_shared/guards/admin-auth-guard';
import { ViewAppointments } from './admin/view-appointments/view-appointments';
import { ViewUsers } from './admin/view-users/view-users';

// SOME ROUTER BASICS:
// Will send you to a component based on the 
// "route" (website url, ex. "localhost:4200/register") that is "active"

// A router-outlet can only have ONE component active (or shown) at a time
// They cannot coexist at the same time. When one is on, the other(s) HAVE to be off.
// Sounds more complicated than it has to be, but just think of it like this: when we go to a Register page, we shouldn't also be seeing our Login page.

// In order to circumvent the above (wanting more than one component rendered on screen at the same time), use a secondary named outlet. Basically, it tells Angular that this component will only be rendered on an outlet with name = ['nameOfOutlet']
// (This is what we use for Login/Register)

export const routes: Routes = [
    // main router
    {
        path: '',
        component: Home,
    },
    // logged in views
    {
        path: 'book-flight',
        component: BookFlight,
        canActivate: [userAuthGuard]
    },
    {
        path: 'profile',
        component: ProfilePage,
        canActivate: [userAuthGuard],
    },
    {
        path: 'view-appointments',
        component: ViewAppointments,
        canActivate: [userAuthGuard, adminAuthGuard],
    },
    {
        path: 'view-users',
        component: ViewUsers,
        canActivate: [userAuthGuard, adminAuthGuard],
    },
    // dropdown outlet
    {
        path: 'login',
        outlet: 'dropdown',
        component: Login,    
    },
    {
        path: 'register',
        outlet: 'dropdown',
        component: Register,
    },
    {
        path: 'profile-page',
        outlet: 'dropdown',
        component: DropdownProfile
    },
    
    // modal outlet
    {
        path: 'inventory',
        outlet: 'modal',
        component: Inventory,
        canActivate: [userAuthGuard, adminAuthGuard],
    },    
];

export default routes;
