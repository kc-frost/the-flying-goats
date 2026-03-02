import { TestBed } from '@angular/core/testing';

import { AuthState } from './authstate.service';

describe('Authstate', () => {
  let service: AuthState;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AuthState);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
