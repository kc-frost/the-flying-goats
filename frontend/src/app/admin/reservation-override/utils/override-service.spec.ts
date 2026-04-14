import { TestBed } from '@angular/core/testing';

import { OverrideService } from '../override-service';

describe('OverrideService', () => {
  let service: OverrideService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(OverrideService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
