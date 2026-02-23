import { Routes } from '@angular/router';

import { Home } from './home/home';
import { Login } from './login/login';
import { Register } from './register/register';
import { Inventory } from './inventory/inventory';
import { BookFlight } from './book-flight/book-flight';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    {
        path: 'login',
        component: Login,
    },
    {
        path: 'register',
        component: Register,
    },
    {
        path: 'inventory',
        component: Inventory,
    },
    {
        path: 'book-flight',
        component: BookFlight,
    },
];

export default routes;
