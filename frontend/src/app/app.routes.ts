import { Routes } from '@angular/router';

import { SignInUp } from './sign-in-up/sign-in-up';
import { Home } from './home/home';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    {
        path: 'auth',
        component: SignInUp,
    },
];

export default routes;
