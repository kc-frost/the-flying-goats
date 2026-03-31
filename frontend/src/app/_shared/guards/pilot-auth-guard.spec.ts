import { TestBed } from '@angular/core/testing';

import { pilotAuthGuard} from '../services/pilot-auth-guard';

describe('pilotAuthGuard', () => {
  let service: typeof pilotAuthGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(pilotAuthGuard);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
