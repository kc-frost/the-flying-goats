import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { environment } from '../../../_environments/environment';
environment

@Injectable({
  providedIn: 'root',
})
export class DestinationCache {
  private http = inject(HttpClient);
  private ls = localStorage;
}
