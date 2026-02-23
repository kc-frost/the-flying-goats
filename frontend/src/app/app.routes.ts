import { Routes } from '@angular/router';

import { Home } from './home/home';
import { Login } from './user-auth/login/login';
import { Register } from './user-auth/register/register';

// SOME ROUTER BASICS:
// Will send you to a component based on the 
// "route" (website url, ex. "localhost:4200/register") that is "active"

// A router-outlet can only have ONE component active (or shown) at a time
// They cannot coexist at the same time. When one is on, the other(s) HAVE to be off.
// Sounds more complicated than it has to be, but just think of it like this: when we go to a Register page, we shouldn't also be seeing our Login page.

// In order to circumvent the above (wanting more than one component rendered on screen at the same time), use a secondary named outlet. Basically, it tells Angular that this component will only be rendered on an outlet with name = ['nameOfOutlet']
// (This is what we use for Login/Register)

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    
    // this autoloads login, but now '' is always gonna be redirected
    // to 'login'.
    // eventually, turn dropdown into a clickable dropdown
    {
        path: '',
        outlet: 'dropdown',
        redirectTo: 'login',
        pathMatch: 'full',
    },
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
    
    
];

export default routes;
