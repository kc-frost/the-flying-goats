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

  // Get all destinations that the user is going to
  loadUserDests() {
    return this.http.get<any>(`${environment.api_url}/api/get-user-dests`);
  }
  // Cache a sight that we know isn't cached yet
  cacheSight(city: string) {
    return this.http.get<any>(`${environment.api_url}/api/get-tourist-dests`, {
      params: { location: city }
    });
  }

  // Check how many user destinations are in the cache
  cacheCheck(userDests: any) {
    const now = Date.now();
    const sevenDays = 7 * 24 * 60 * 60 * 1000;

    for (let dest of userDests) {
      // Check if a timestamp exists for this destination
      const timestamp = localStorage.getItem(`${dest}_timestamp`);
      
      // Expired if no timestamp or older than 7 days
      const expired = !timestamp || (now - parseInt(timestamp)) > sevenDays;

      // Clear stale cache if expired
      if (expired) {
        localStorage.removeItem(dest);
      }

      // Fetch and cache if not present
      let present = this.ls.getItem(dest);
      // IMPORTANT
      // Ensures that we don't call it again if it's already cached
      if (!present) {
        this.cacheSight(dest).subscribe({
          next: (res) => {
            console.log(dest, "is now cached!");
            this.ls.setItem(dest, JSON.stringify(res));
            this.ls.setItem(`${dest}_timestamp`, now.toString());
          }
        })
      }
    }
  }
}