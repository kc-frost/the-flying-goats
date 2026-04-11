import { Component } from '@angular/core';

@Component({
  selector: 'app-analytics',
  imports: [],
  templateUrl: './analytics.html',
  styleUrl: './analytics.css',
})
export class Analytics {
  // return this format in the api

  top3Users = [
    {user: 'me', amt: 123},
    {user: 'you', amt: 21},
    {user: 'someone', amt: 12},
  ];

  longestRegisteredUsers = [
    {user: 'me', days: 123},
    {user: 'you', days: 23},
    {user: 'someone', days: 9},
  ];

  reservationsThisYear = [
    {month: 'Jan', amt: 12},
    {month: 'Feb', amt: 12},
    {month: 'Mar', amt: 12},
    {month: 'Apr', amt: 12},
    {month: 'May', amt: 12},
    {month: 'Jun', amt: 12},
    {month: 'July', amt: 12},
    {month: 'Aug', amt: 12},
    {month: 'Sep', amt: 12},
    {month: 'Oct', amt: 12},
    {month: 'Nov', amt: 12},
    {month: 'Dec', amt: 12},
  ];
}
