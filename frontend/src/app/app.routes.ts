import { Routes } from '@angular/router';

import { Home } from './home/home';
import { Login } from './login/login';
import { Register } from './register/register';
import { Inventory, inventoryModalRedirect } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
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
    {
        path: 'inventory',
        outlet: 'modal',
        component: Inventory,
    },
    {
        path: 'book-flight',
        component: BookFlight,
    },
];

export default routes;
