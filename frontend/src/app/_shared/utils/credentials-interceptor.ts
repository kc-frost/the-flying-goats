import { HttpEvent, HttpHandlerFn, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs';

// Makes all outgoing Http requests send cookies
export function credentialsInterceptor(
  req: HttpRequest<unknown>,
  next: HttpHandlerFn,
): Observable<HttpEvent<unknown>> {
  const newReq = req.clone({
    withCredentials: true,
  })
  return next(newReq);
}
